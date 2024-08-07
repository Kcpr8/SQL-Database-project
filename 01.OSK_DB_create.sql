
CREATE TABLE ankieta (
    id_ankiety         NUMBER(5) NOT NULL,
    ocena_w_skali_1do5 NUMBER(1) NOT NULL,
    pozytywy           VARCHAR2(200),
    negatywy           VARCHAR2(200),
    sugestie           VARCHAR2(200),
    id_kursanta        NUMBER(5) NOT NULL
);

CREATE UNIQUE INDEX ankieta__idx ON
    ankieta (
        id_kursanta
    ASC );

ALTER TABLE ankieta ADD CONSTRAINT ankieta_pk PRIMARY KEY ( id_ankiety );

CREATE TABLE dokument (
    id_kursanta  NUMBER(5) NOT NULL,
    id_dokumentu NUMBER(5) NOT NULL,
    typ          VARCHAR2(30) NOT NULL,
    opis         VARCHAR2(200)
);

ALTER TABLE dokument ADD CONSTRAINT dokument_pk PRIMARY KEY ( id_dokumentu,
                                                              id_kursanta );

CREATE TABLE egzamin (
    id_kursanta         NUMBER(5) NOT NULL,
    id_egzaminu         NUMBER(5) NOT NULL,
    data_egzaminu       DATE NOT NULL,
    typ                 VARCHAR2(30) NOT NULL,
    rodzaj              VARCHAR2(30) NOT NULL,
    wynik               VARCHAR2(30) NOT NULL,
    powod_niezaliczenia VARCHAR2(200)
);

ALTER TABLE egzamin ADD CONSTRAINT egzamin_pk PRIMARY KEY ( id_egzaminu,
                                                            id_kursanta );

CREATE TABLE instruktor (
    id_instruktora          NUMBER(5) NOT NULL,
    imie                    VARCHAR2(30) NOT NULL,
    nazwisko                VARCHAR2(30) NOT NULL,
    preferowana_lokalizacja VARCHAR2(30)
);

ALTER TABLE instruktor ADD CONSTRAINT instruktor_pk PRIMARY KEY ( id_instruktora );

CREATE TABLE kategoria (
    typ_kategorii VARCHAR2(5) NOT NULL
);

ALTER TABLE kategoria ADD CONSTRAINT kategoria_pk PRIMARY KEY ( typ_kategorii );

CREATE TABLE kurs (
    id_kursu         NUMBER(5) NOT NULL,
    data_rozpoczecia DATE NOT NULL,
    liczba_miejsc    NUMBER(2) NOT NULL,
    cena             NUMBER(10, 2) NOT NULL,
    typ_kategorii    VARCHAR2(5) NOT NULL
);

ALTER TABLE kurs ADD CONSTRAINT kurs_pk PRIMARY KEY ( id_kursu );

CREATE TABLE kursant (
    id_kursanta             NUMBER(5) NOT NULL,
    imie                    VARCHAR2(30) NOT NULL,
    nazwisko                VARCHAR2(30) NOT NULL,
    adres_email             VARCHAR2(30),
    preferowana_lokalizacja VARCHAR2(30)
);

ALTER TABLE kursant ADD CONSTRAINT kursant_pk PRIMARY KEY ( id_kursanta );

CREATE TABLE naprawa (
    id_pojazdu       NUMBER(5) NOT NULL,
    id_naprawy       NUMBER(5) NOT NULL,
    opis             VARCHAR2(200) NOT NULL,
    koszt            NUMBER(10, 2) NOT NULL,
    status           VARCHAR2(30) NOT NULL,
    data_rozpczecia  DATE NOT NULL,
    data_zakonczenia DATE
);

ALTER TABLE naprawa ADD CONSTRAINT naprawa_pk PRIMARY KEY ( id_naprawy,
                                                            id_pojazdu );

CREATE TABLE oplata (
    id_kursanta   NUMBER(5) NOT NULL,
    id_oplaty     NUMBER(5) NOT NULL,
    status        VARCHAR2(30) NOT NULL,
    kwota         NUMBER(10, 2) NOT NULL,
    termin_wplaty DATE NOT NULL,
    data_wplywu   DATE
);

ALTER TABLE oplata ADD CONSTRAINT oplata_pk PRIMARY KEY ( id_oplaty,
                                                          id_kursanta );

CREATE TABLE pojazd (
    id_pojazdu                  NUMBER(5) NOT NULL,
    typ                         VARCHAR2(50) NOT NULL,
    marka                       VARCHAR2(30) NOT NULL,
    model                       VARCHAR2(30) NOT NULL,
    rok_produkcji               NUMBER(4) NOT NULL,
    status_przegladu            VARCHAR2(30) NOT NULL,
    termin_nastepnego_przegladu DATE NOT NULL,
    dane_przyczepy              VARCHAR2(200),
    typ_kategorii               VARCHAR2(5) NOT NULL
);

ALTER TABLE pojazd ADD CONSTRAINT pojazd_pk PRIMARY KEY ( id_pojazdu );

CREATE TABLE relation_1 (
    id_kursanta NUMBER(5) NOT NULL,
    id_kursu    NUMBER(5) NOT NULL,
    typ_zapisu  VARCHAR2(30) NOT NULL,
    data_zapisu DATE NOT NULL
);

ALTER TABLE relation_1 ADD CONSTRAINT relation_1_pk PRIMARY KEY ( id_kursanta,
                                                                  id_kursu );

CREATE TABLE relation_2 (
    id_instruktora NUMBER(5) NOT NULL,
    typ_kategorii  VARCHAR2(5) NOT NULL
);

ALTER TABLE relation_2 ADD CONSTRAINT relation_2_pk PRIMARY KEY ( id_instruktora,
                                                                  typ_kategorii );

ALTER TABLE ankieta
    ADD CONSTRAINT ankieta_kursant_fk FOREIGN KEY ( id_kursanta )
        REFERENCES kursant ( id_kursanta );

ALTER TABLE dokument
    ADD CONSTRAINT dokument_kursant_fk FOREIGN KEY ( id_kursanta )
        REFERENCES kursant ( id_kursanta );

ALTER TABLE egzamin
    ADD CONSTRAINT egzamin_kursant_fk FOREIGN KEY ( id_kursanta )
        REFERENCES kursant ( id_kursanta );

ALTER TABLE kurs
    ADD CONSTRAINT kurs_kategoria_fk FOREIGN KEY ( typ_kategorii )
        REFERENCES kategoria ( typ_kategorii );

ALTER TABLE naprawa
    ADD CONSTRAINT naprawa_pojazd_fk FOREIGN KEY ( id_pojazdu )
        REFERENCES pojazd ( id_pojazdu );

ALTER TABLE oplata
    ADD CONSTRAINT oplata_kursant_fk FOREIGN KEY ( id_kursanta )
        REFERENCES kursant ( id_kursanta );

ALTER TABLE pojazd
    ADD CONSTRAINT pojazd_kategoria_fk FOREIGN KEY ( typ_kategorii )
        REFERENCES kategoria ( typ_kategorii );

ALTER TABLE relation_1
    ADD CONSTRAINT relation_1_kurs_fk FOREIGN KEY ( id_kursu )
        REFERENCES kurs ( id_kursu );

ALTER TABLE relation_1
    ADD CONSTRAINT relation_1_kursant_fk FOREIGN KEY ( id_kursanta )
        REFERENCES kursant ( id_kursanta );

ALTER TABLE relation_2
    ADD CONSTRAINT relation_2_instruktor_fk FOREIGN KEY ( id_instruktora )
        REFERENCES instruktor ( id_instruktora );

ALTER TABLE relation_2
    ADD CONSTRAINT relation_2_kategoria_fk FOREIGN KEY ( typ_kategorii )
        REFERENCES kategoria ( typ_kategorii );


COMMIT;