--------------------------------------------------------------------------------
--perspektywa kursanta id=1015
SELECT *
FROM kursant1015;

--najblizsze 3 kursy
SELECT ROWNUM, id_kursu, data_rozpoczecia, typ_kategorii, cena, liczba_miejsc,
 CASE 
        WHEN data_rozpoczecia > sysdate THEN 'planowany' ELSE 'w trakcie'
    END 
    AS opis
FROM kurs
WHERE data_rozpoczecia > sysdate AND ROWNUM <4;

--najblizsze kursy i dostepne miejsca
SELECT ROWNUM, kurs.id_kursu, data_rozpoczecia, typ_kategorii, cena, liczba_miejsc, COALESCE(lk,0) AS liczba_kursantow,
                liczba_miejsc - COALESCE(lk, 0) AS dostepne_miejsca,
 CASE 
        WHEN data_rozpoczecia > sysdate THEN 'planowany' ELSE 'w trakcie'
    END 
    AS opis
FROM kurs
FULL OUTER JOIN(SELECT COUNT(relation_1.id_kursanta) AS lk, relation_1.id_kursu
    FROM relation_1
    GROUP BY id_kursu) nazwa ON kurs.id_kursu = nazwa.id_kursu
WHERE data_rozpoczecia > sysdate;

--------------------------------------------------------------------------------
--perspektywa pracownika recepcji
SELECT * 
FROM pracownik_recepcji;

--wszystkie kursy i dostepne miejsca
SELECT kurs.id_kursu, data_rozpoczecia, typ_kategorii, cena, liczba_miejsc, COALESCE(lk,0) AS liczba_kursantow,
        liczba_miejsc - COALESCE(lk, 0) AS dostepne_miejsca,
    CASE 
        WHEN data_rozpoczecia > sysdate THEN 'planowany' ELSE 'w trakcie'
    END 
    AS opis
FROM kurs
FULL OUTER JOIN(SELECT COUNT(relation_1.id_kursanta) AS lk, relation_1.id_kursu
    FROM relation_1
    GROUP BY id_kursu) nazwa ON kurs.id_kursu = nazwa.id_kursu;


-- liczba wszystkich zapisow online i offline
SELECT
liczba_zapisow_online,
liczba_zapisow_offline
FROM
    (SELECT COUNT(*) AS liczba_zapisow_online
        FROM (SELECT imie, nazwisko, typ_zapisu 
                FROM kursant, relation_1 WHERE typ_zapisu = 'online' AND kursant.id_kursanta = relation_1.id_kursanta
                )
        ),
    
    (SELECT COUNT(*) AS liczba_zapisow_offline
        FROM (SELECT imie, nazwisko, typ_zapisu 
                FROM kursant, relation_1 WHERE typ_zapisu = 'na miejscu' AND kursant.id_kursanta = relation_1.id_kursanta
                )
        );


--liczba instruktorow z uprawnieniami do danej kategorii
SELECT typ_kategorii, COUNT(id_instruktora) AS liczba_instruktorow_z_uprawnieniami
FROM relation_2
GROUP BY typ_kategorii;

--------------------------------------------------------------------------------
--perspektywa kierownika
SELECT * 
FROM kierownik_osrodka;

-- liczba kursantow ktorzy zdali za pierwszym razem wszystkie egzaminy
SELECT COUNT(*) AS liczba_kursantow_ktorzy_zdali_wszystkie_egzaminy_za_pierwszym_razem
FROM (
    SELECT id_kursanta, COUNT(id_egzaminu) AS liczba_egzaminow
    FROM egzamin
    GROUP BY id_kursanta
    HAVING COUNT(id_egzaminu) = '4');

-- statystki zwiazane z kursantami
SELECT liczba_wszystkich_kursantow, liczba_kursantow_ktorzy_zdali_praktyczny_egzamin_panstwowy,
        liczba_kurantow_ktorzy_wyplelnili_ankiete
FROM
    (SELECT COUNT (id_kursanta) AS liczba_wszystkich_kursantow
        FROM kursant),
    (SELECT COUNT(id_kursanta) AS liczba_kursantow_ktorzy_zdali_praktyczny_egzamin_panstwowy
        FROM egzamin
        WHERE typ = 'ZEWNETRZNY' AND rodzaj = 'PRAKTYKA' AND wynik = 'ZDANY'),
    (SELECT COUNT (id_kursanta) AS liczba_kurantow_ktorzy_wyplelnili_ankiete
        FROM ankieta);

--liczba oplat z danym statusem
SELECT status, COUNT(id_oplaty) AS liczba
FROM oplata
GROUP BY status;

--liczba oplat zrealizowanych
SELECT COUNT(id_oplaty) as liczba_oplat_zrealizowanych
FROM oplata
WHERE status = 'ZREALIZOWANA';

--liczba oplat niezrealizowanych
SELECT COUNT(id_oplaty) AS oplaty_niezrealizowane
FROM oplata
WHERE status <> 'ZREALIZOWANA';

--statystyki dochodow w poszczegolnych miesiacach
SELECT rok1 AS rok, miesiac1 AS miesiac, COALESCE(liczba_wplat,0) AS "liczba wplat", COALESCE(suma_wplat,0) AS "suma wplat",
        COALESCE(liczba_napraw,0) AS "liczba_napraw", COALESCE(suma_kosztow,0) AS "suma_kosztow",
        COALESCE(suma_wplat,0) - COALESCE(suma_kosztow,0) AS "bilans w miesiacu"
FROM
    (SELECT
        EXTRACT(YEAR FROM data_wplywu)AS rok1,
        EXTRACT(MONTH FROM data_wplywu)AS miesiac1,
        COUNT(id_oplaty) AS liczba_wplat,
        SUM(kwota) AS suma_wplat
    FROM oplata
    GROUP BY
        EXTRACT(YEAR FROM data_wplywu),
        EXTRACT(MONTH FROM data_wplywu)
    )
FULL OUTER JOIN
    (SELECT
        EXTRACT(YEAR FROM data_rozpczecia)AS rok2,
        EXTRACT(MONTH FROM data_rozpczecia)AS miesiac2,
        COUNT(id_naprawy) AS liczba_napraw,
        SUM(koszt) AS suma_kosztow
    FROM naprawa
    GROUP BY
        EXTRACT(YEAR FROM data_rozpczecia),
        EXTRACT(MONTH FROM data_rozpczecia)
    ) ON rok1 = rok2 AND miesiac1 = miesiac2
    ORDER BY rok ASC, miesiac ASC;

--dochod ogolem
SELECT
wplywy_ogolem,
kwota_wszystkich_napraw,
wplywy_ogolem - kwota_wszystkich_napraw AS zysk
FROM
    (SELECT SUM(kwota) AS wplywy_ogolem FROM oplata),
    (SELECT SUM(koszt) AS kwota_wszystkich_napraw FROM naprawa);

--statysyki z ankiet
SELECT
liczba_ankiet,
srednia_ocen,
liczba_sugestii,
liczba_pozytywnych_uwag,
liczba_negatywnych_uwag
FROM (SELECT COUNT(id_ankiety) AS liczba_ankiet, round(AVG(ocena_w_skali_1do5),1) AS srednia_ocen
        FROM ankieta),
    (SELECT COUNT(sugestie) AS liczba_sugestii
        FROM ankieta WHERE sugestie IS NOT NULL),
    (SELECT COUNT(pozytywy) AS liczba_pozytywnych_uwag
        FROM ankieta WHERE pozytywy IS NOT NULL),
    (SELECT COUNT(negatywy) AS liczba_negatywnych_uwag
        FROM ankieta WHERE negatywy IS NOT NULL);

--wszystkie niezdane praktyczne egzaminy panstwowe
SELECT id_kursanta, id_egzaminu, data_egzaminu, typ, rodzaj, wynik, powod_niezaliczenia
FROM egzamin
WHERE typ = 'ZEWNETRZNY' AND rodzaj = 'PRAKTYKA' AND powod_niezaliczenia IS NOT NULL;

--powody niezaliczenia praktycznych egzaminow panstowowych oraz liczba ich wystapien
SELECT powod_niezaliczenia AS powod_niezaliczenia_egzaminu_panstwowego, COUNT(*) AS liczba_wystapien
FROM egzamin
WHERE typ = 'ZEWNETRZNY' AND powod_niezaliczenia IS NOT NULL
GROUP BY powod_niezaliczenia;


--------------------------------------------------------------------------------
--perspektywa nadzorcy pojazdow
SELECT *
FROM nadzorca_pojazdow;       

-- dane pojazdow ktore byly naprawiane wiecej niz 2 razy oraz koszt wszystkich napraw i sredni koszt jednej naprawy danego pojazdu 
-- uporzadkowane malejaco wg kosztu wszystkich napraw
SELECT  pojazd.*, liczba_napraw, koszt_wszystkich_napraw_pojazdu, sredni_koszt_jednej_naprawy_pojazdu
FROM pojazd
INNER JOIN (SELECT id_pojazdu, COUNT(id_naprawy) AS liczba_napraw, SUM(koszt) AS koszt_wszystkich_napraw_pojazdu, 
            round(AVG(koszt),1) AS sredni_koszt_jednej_naprawy_pojazdu
                FROM naprawa
                GROUP BY id_pojazdu
                HAVING COUNT(id_naprawy) > 2) tabela1 ON pojazd.id_pojazdu = tabela1.id_pojazdu
ORDER BY koszt_wszystkich_napraw_pojazdu DESC;

--liczba pojazdow o danym statusie przegladu
SELECT status_przegladu, COUNT(*) AS liczba_pojazdow
FROM pojazd
GROUP BY status_przegladu;

--pojazdy do oddania na przeglad
SELECT id_pojazdu AS pojazdy_do_oddania_na_przeglad, status_przegladu, termin_nastepnego_przegladu
FROM pojazd 
WHERE status_przegladu = 'NIEAKTUALNY' OR (termin_nastepnego_przegladu >= sysdate AND termin_nastepnego_przegladu <= sysdate + 31)
ORDER BY termin_nastepnego_przegladu;

--pojazdy z nieaktualnym przegladem
SELECT id_pojazdu AS pojazdy_z_nieaktualnym_przegladem, status_przegladu, termin_nastepnego_przegladu
FROM pojazd 
WHERE status_przegladu = 'NIEAKTUALNY'
ORDER BY termin_nastepnego_przegladu;

-- pojazdy z bliskim terminem przegladu, tj. w najblizszym miesiacu
SELECT id_pojazdu AS pojazdy_ze_zblizajacym_sie_terminem_przegladu, status_przegladu, termin_nastepnego_przegladu
FROM pojazd 
WHERE termin_nastepnego_przegladu >= sysdate AND termin_nastepnego_przegladu <= sysdate + 31
ORDER BY termin_nastepnego_przegladu;

--pojazdy gotowe do odbioru z naprawy
SELECT id_pojazdu AS id_pojazdow_gotowych_do_odbioru_z_naprawy
FROM naprawa
WHERE status = 'DO ODBIORU'
GROUP BY id_pojazdu;

-- 3 najczesciej wystepujace naprawy
SELECT ROWNUM, opis_naprawy, ilosc_wystapien_naprawy
    FROM (
SELECT opis AS opis_naprawy, COUNT(*) AS ilosc_wystapien_naprawy
FROM naprawa
GROUP BY opis
ORDER BY ilosc_wystapien_naprawy DESC
        )
WHERE ROWNUM <4;

--statystyki napraw
SELECT
liczba_wszystkich_napraw,
koszt_wszystkich_napraw_ogolem,
sredni_koszt_jednej_naprawy,
sredni_koszt_wszystkich_napraw_jednego_pojazdu
FROM
    (SELECT COUNT(id_naprawy) AS liczba_wszystkich_napraw, SUM(koszt) AS koszt_wszystkich_napraw_ogolem,
        AVG(koszt) AS sredni_koszt_jednej_naprawy
        FROM naprawa),
    
    (SELECT AVG(suma_kosztow_na_pojazd) AS sredni_koszt_wszystkich_napraw_jednego_pojazdu
        FROM (SELECT id_pojazdu, SUM(koszt) AS suma_kosztow_na_pojazd
                FROM naprawa
                GROUP BY id_pojazdu
                )
    );

--statystyki napraw dla kazdego pojazdu
SELECT id_pojazdu, COUNT(*) AS liczba_napraw, SUM(koszt) AS suma_kosztow_na_pojazd,
        round(AVG(koszt), 1) AS sredni_koszt_jednej_naprawy_na_pojazd
FROM naprawa
GROUP BY id_pojazdu
ORDER BY suma_kosztow_na_pojazd DESC;



