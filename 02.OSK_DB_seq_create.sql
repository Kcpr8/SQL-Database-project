CREATE SEQUENCE seq_id_ankiety INCREMENT BY 1 START WITH 1 MAXVALUE 99999 MINVALUE 1 CACHE 20 ORDER NOCYCLE;

ALTER TABLE ankieta MODIFY
    id_ankiety DEFAULT seq_id_ankiety.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_dokumentu INCREMENT BY 1 START WITH 2001 MAXVALUE 99999 MINVALUE 2001 CACHE 20 ORDER NOCYCLE;

ALTER TABLE dokument MODIFY
    id_dokumentu DEFAULT seq_id_dokumentu.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_egzaminu INCREMENT BY 1 START WITH 40100 MAXVALUE 99999 MINVALUE 40100 CACHE 20 ORDER NOCYCLE;

ALTER TABLE egzamin MODIFY
    id_egzaminu DEFAULT seq_id_egzaminu.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_instruktora INCREMENT BY 1 START WITH 10 MAXVALUE 99999 MINVALUE 10 CACHE 20 ORDER NOCYCLE;

ALTER TABLE instruktor MODIFY
    id_instruktora DEFAULT seq_id_instruktora.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_kursu INCREMENT BY 100 START WITH 10100 MAXVALUE 99999 MINVALUE 10100 CACHE 20 ORDER NOCYCLE;

ALTER TABLE kurs MODIFY
    id_kursu DEFAULT seq_id_kursu.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_kursanta INCREMENT BY 1 START WITH 1000 MAXVALUE 99999 MINVALUE 1000 CACHE 20 ORDER NOCYCLE;

ALTER TABLE kursant MODIFY
    id_kursanta DEFAULT seq_id_kursanta.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_naprawy INCREMENT BY 1 START WITH 9001 MAXVALUE 99999 MINVALUE 9001 CACHE 20 ORDER NOCYCLE;

ALTER TABLE naprawa MODIFY
    id_naprawy DEFAULT seq_id_naprawy.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_oplaty INCREMENT BY 1 START WITH 8201 MAXVALUE 99999 MINVALUE 8201 CACHE 20 ORDER NOCYCLE;

ALTER TABLE oplata MODIFY
    id_oplaty DEFAULT seq_id_oplaty.NEXTVAL;

------------------------------------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_id_pojazdu INCREMENT BY 1 START WITH 401 MAXVALUE 99999 MINVALUE 401 CACHE 20 ORDER NOCYCLE;

ALTER TABLE pojazd MODIFY
    id_pojazdu DEFAULT seq_id_pojazdu.NEXTVAL;

COMMIT;