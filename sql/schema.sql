create table kategorija
(
    kategorija_id    serial
        constraint kategorija_pk
            primary key,
    naziv_kategorije varchar(20) not null,
    opis             varchar(50)
);

alter table kategorija
    owner to marino_barnjak;

create table proizvod
(
    proizvod_id     serial
        constraint proizvod_pk
            primary key,
    naziv_proizvoda varchar(20)      not null,
    opis            varchar(50),
    cijena          double precision not null,
    pakiranje       varchar(20)      not null,
    kategorija_id   integer          not null
        constraint proizvod_kategorija_kategorija_id_fk
            references kategorija
            on update cascade
);

alter table proizvod
    owner to marino_barnjak;

create table kupac
(
    kupac_id    serial
        constraint kupac_pk
            primary key,
    ime_prezime varchar(30) not null,
    email       varchar(50) not null,
    telefon     varchar(20) not null,
    grad        varchar(20) not null,
    adresa      varchar(50) not null
);

alter table kupac
    owner to marino_barnjak;

create table zaposlenik
(
    zaposlenik_id serial
        constraint zaposlenik_pk
            primary key,
    ime_prezime   varchar(30) not null,
    uloga         varchar(20) not null,
    telefon       varchar(20) not null,
    email         varchar(50) not null,
    nadredeni_id  integer
        constraint zaposlenik_zaposlenik_zaposlenik_id_fk
            references zaposlenik
            on update cascade on delete set null
);

alter table zaposlenik
    owner to marino_barnjak;

create table skladiste
(
    skladiste_id    serial
        constraint skladiste_pk
            primary key,
    naziv_skladista varchar(20) not null,
    lokacija        varchar(20) not null,
    zaposlenik_id   integer     not null
        constraint skladiste_zaposlenik_zaposlenik_id_fk
            references zaposlenik
            on update cascade on delete set null
);

alter table skladiste
    owner to marino_barnjak;

create table stanje_skladista
(
    skladiste_id integer not null
        constraint stanje_skladista_skladiste_skladiste_id_fk
            references skladiste
            on update cascade on delete cascade,
    proizvod_id  integer not null
        constraint stanje_skladista_proizvod_proizvod_id_fk
            references proizvod
            on update cascade on delete cascade,
    kolicina     integer,
    constraint stanje_skladista_pk
        primary key (proizvod_id, skladiste_id)
);

alter table stanje_skladista
    owner to marino_barnjak;

create table narudzba
(
    narudzba_id    serial
        constraint narudzba_pk
            primary key,
    datum_narudzbe date             not null,
    status         varchar(20)      not null,
    iznos_narudzbe double precision not null,
    kupac_id       integer          not null
        constraint narudzba_kupac_kupac_id_fk
            references kupac
            on update cascade on delete set null,
    zaposlenik_id  integer          not null
        constraint narudzba_zaposlenik_zaposlenik_id_fk
            references zaposlenik
            on update cascade on delete set null
);

alter table narudzba
    owner to marino_barnjak;

create trigger kreiraj_racun
    after update
        of status
    on narudzba
    for each row
execute procedure kreiraj_racun();

create table stavka_narudzbe
(
    proizvod_id integer not null
        constraint stavka_narudzbe_proizvod_proizvod_id_fk
            references proizvod
            on update cascade on delete cascade,
    narudzba_id integer not null
        constraint stavka_narudzbe_narudzba_narudzba_id_fk
            references narudzba
            on update cascade on delete cascade,
    kolicina    integer not null,
    constraint stavka_narudzbe_pk
        primary key (narudzba_id, proizvod_id)
);

alter table stavka_narudzbe
    owner to marino_barnjak;

create trigger smanji_skladiste
    after insert
    on stavka_narudzbe
    for each row
execute procedure smanji_stanje_skladista();

create table racun
(
    racun_id        serial
        constraint racun_pk
            primary key,
    datum_izdavanja date             not null,
    nacin_placanja  varchar(20)      not null,
    iznos           double precision not null,
    narudzba_id     integer
        constraint racun_narudzba_narudzba_id_fk
            references narudzba
            on update cascade on delete cascade,
    zaposlenik_id   integer          not null
        constraint racun_zaposlenik_zaposlenik_id_fk
            references zaposlenik
            on update cascade
);

alter table racun
    owner to marino_barnjak;

create table dostavljac
(
    dostavljac_id serial
        constraint dostavljac_pk
            primary key,
    ime_prezime   varchar(30) not null,
    vozilo        varchar(20) not null,
    telefon       varchar(20) not null,
    pouzece       varchar(30) not null
);

alter table dostavljac
    owner to marino_barnjak;

create table dostava
(
    dostava_id     serial
        constraint dostava_pk
            primary key,
    datum_dostave  date             not null,
    cijena_dostave double precision not null,
    status_dostave varchar(20)      not null,
    narudzba_id    integer
        constraint dostava_pk_2
            unique
        constraint dostava_narudzba_narudzba_id_fk
            references narudzba
            on update cascade on delete cascade,
    dostavljac_id  integer          not null
        constraint dostava_dostavljac_dostavljac_id_fk
            references dostavljac
            on update cascade on delete set null
);

alter table dostava
    owner to marino_barnjak;

create trigger postavi_datum_dostave
    before update
    on dostava
    for each row
execute procedure postavi_datum_dostave();

