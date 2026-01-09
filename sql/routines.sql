--Ovaj trigger automatski postavlja datum dostave na trenutni datum svaki put kada se status
--dostave promijeni u 'isporučeno', ako datum prethodno nije bio upisan.

CREATE OR REPLACE FUNCTION projekt.postavi_datum_dostave()
RETURNS trigger AS $$
BEGIN
    IF NEW.status_dostave IN ('isporučeno', 'isporučena')
       AND NEW.datum_dostave IS NULL THEN
        NEW.datum_dostave := CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER postavi_datum_dostave
BEFORE UPDATE ON projekt.dostava
FOR EACH ROW
EXECUTE FUNCTION projekt.postavi_datum_dostave();


--Ovaj trigger automatski umanjuje količinu proizvoda u skladištu svaki put kada se doda nova
--stavka narudžbe.

CREATE OR REPLACE FUNCTION projekt.smanji_stanje_skladista()
RETURNS trigger AS $$
BEGIN
    UPDATE projekt.stanje_skladista
    SET kolicina = kolicina - NEW.kolicina
    WHERE proizvod_id = NEW.proizvod_id
      AND skladiste_id = 1;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER smanji_skladiste
AFTER INSERT ON projekt.stavka_narudzbe
FOR EACH ROW
EXECUTE FUNCTION projekt.smanji_stanje_skladista();


--Ovaj trigger automatski kreira račun svaki put kada narudžba promijeni status u 'završena' ili
--'isporučena'.

CREATE OR REPLACE FUNCTION projekt.kreiraj_racun()
RETURNS trigger AS $$
BEGIN
    IF NEW.status IN ('završena', 'isporučena')
       AND (OLD.status IS DISTINCT FROM NEW.status) THEN

        IF NOT EXISTS (
            SELECT 1
            FROM projekt.racun
            WHERE narudzba_id = NEW.narudzba_id
        ) THEN
            INSERT INTO projekt.racun (
                narudzba_id,
                zaposlenik_id,
                iznos,
                nacin_placanja,
                datum_izdavanja
            )
            VALUES (
                NEW.narudzba_id,
                NEW.zaposlenik_id,
                NEW.iznos_narudzbe,
                'gotovina',
                CURRENT_DATE
            );
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER kreiraj_racun
AFTER UPDATE OF status ON projekt.narudzba
FOR EACH ROW
EXECUTE FUNCTION projekt.kreiraj_racun();
