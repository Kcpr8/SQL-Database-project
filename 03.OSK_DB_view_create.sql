--perspektywa kursanta id=1015
CREATE OR REPLACE VIEW kursant1015 AS
    SELECT kursant.id_kursanta AS "twoj identyfikator", kurs.typ_kategorii AS "kategoria", kurs.id_kursu "identyfikator kursu",
        kurs.data_rozpoczecia AS "data rozpoczecia kursu", oplata.kwota AS "do oplaty", oplata.termin_wplaty AS "termin na wplate"
    FROM kursant, relation_1, kurs, oplata
    WHERE kursant.id_kursanta = '1015'
        AND relation_1.id_kursanta = kursant.id_kursanta
        AND relation_1.id_kursu = kurs.id_kursu
        AND oplata.id_kursanta = kursant.id_kursanta;
        
        
--perspektywa pracownika recepcji
CREATE OR REPLACE VIEW pracownik_recepcji AS
    SELECT kursant.id_kursanta, oplata.status AS status_oplaty, kurs.typ_kategorii, kurs.id_kursu, relation_1.typ_zapisu, adres_email
    FROM kursant, oplata, relation_1, kurs
    WHERE oplata.id_kursanta = kursant.id_kursanta
        AND relation_1.id_kursanta = kursant.id_kursanta
        AND relation_1.id_kursu = kurs.id_kursu;
        
        
--perspektywa kierownika osrodka
CREATE OR REPLACE VIEW kierownik_osrodka AS
    SELECT kursant.id_kursanta, relation_1.id_kursu, typ_kategorii, ocena_w_skali_1do5, pozytywy, negatywy, sugestie
    FROM kursant
    FULL OUTER JOIN ankieta ON kursant.id_kursanta = ankieta.id_kursanta
    FULL OUTER JOIN relation_1 ON kursant.id_kursanta = relation_1.id_kursanta
    FULL OUTER JOIN kurs ON relation_1.id_kursu = kurs.id_kursu;
    
--perspektywa nadzorcy pojazdow
CREATE OR REPLACE VIEW nadzorca_pojazdow AS
    SELECT pojazd.id_pojazdu, pojazd.typ, pojazd.marka, pojazd.model, pojazd.rok_produkcji, pojazd.status_przegladu, pojazd.termin_nastepnego_przegladu, 
    pojazd.dane_przyczepy, kategoria.typ_kategorii, liczba_napraw, koszt_wszystkich_napraw_pojazdu, sredni_koszt_wszystkich_napraw_tego_pojazdu
    FROM pojazd
    LEFT JOIN kategoria ON pojazd.typ_kategorii = kategoria.typ_kategorii
    INNER JOIN (SELECT id_pojazdu, COUNT(id_naprawy) AS liczba_napraw, SUM(koszt) AS koszt_wszystkich_napraw_pojazdu, 
                round(AVG(koszt),1) AS sredni_koszt_wszystkich_napraw_tego_pojazdu
                    FROM naprawa
                    GROUP BY id_pojazdu) tabela1 ON pojazd.id_pojazdu = tabela1.id_pojazdu
    ORDER BY koszt_wszystkich_napraw_pojazdu DESC;

    
COMMIT;







