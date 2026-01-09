create sequence kategorija_kategorija_id_seq
    as integer;

alter sequence kategorija_kategorija_id_seq owner to marino_barnjak;

alter sequence kategorija_kategorija_id_seq owned by kategorija.kategorija_id;

create sequence proizvod_proizvod_id_seq
    as integer;

alter sequence proizvod_proizvod_id_seq owner to marino_barnjak;

alter sequence proizvod_proizvod_id_seq owned by proizvod.proizvod_id;

create sequence kupac_kupac_id_seq
    as integer;

alter sequence kupac_kupac_id_seq owner to marino_barnjak;

alter sequence kupac_kupac_id_seq owned by kupac.kupac_id;

create sequence zaposlenik_zaposlenik_id_seq
    as integer;

alter sequence zaposlenik_zaposlenik_id_seq owner to marino_barnjak;

alter sequence zaposlenik_zaposlenik_id_seq owned by zaposlenik.zaposlenik_id;

create sequence skladiste_skladiste_id_seq
    as integer;

alter sequence skladiste_skladiste_id_seq owner to marino_barnjak;

alter sequence skladiste_skladiste_id_seq owned by skladiste.skladiste_id;

create sequence narudzba_narudzba_id_seq
    as integer;

alter sequence narudzba_narudzba_id_seq owner to marino_barnjak;

alter sequence narudzba_narudzba_id_seq owned by narudzba.narudzba_id;

create sequence racun_racun_id_seq
    as integer;

alter sequence racun_racun_id_seq owner to marino_barnjak;

alter sequence racun_racun_id_seq owned by racun.racun_id;

create sequence dostavljac_dostavljac_id_seq
    as integer;

alter sequence dostavljac_dostavljac_id_seq owner to marino_barnjak;

alter sequence dostavljac_dostavljac_id_seq owned by dostavljac.dostavljac_id;

create sequence dostava_dostava_id_seq
    as integer;

alter sequence dostava_dostava_id_seq owner to marino_barnjak;

alter sequence dostava_dostava_id_seq owned by dostava.dostava_id;

