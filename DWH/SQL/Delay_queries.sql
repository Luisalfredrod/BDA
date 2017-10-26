
-- ¿Cuántos retrazos tuvo un avion en el año?
SELECT D_A.name, SUM(delays_count) as TimesLate
FROM D_AIRPLANE D_A, DELAYS, D_TIME
WHERE D_A.id_plane = 1
    AND DELAYS.id_time = D_TIME.id_time
    AND DELAYS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'JUNIO%' AND DATE_YEAR = '2017')
GROUP BY D_A.name;
-- ¿Cuál fue el avion con la mayor cantidad de retrasos? 
SELECT D_A.name, SUM(delays_count) as TimesLate
FROM D_AIRPLANE D_A, DELAYS
WHERE D_A.id_plane = DELAYS.id_plane
GROUP BY D_A.name
ORDER BY SUM(delays_count) DESC;
-- ¿Cuantos retrasos hubieron durante el mes? 
SELECT SUM(delays_count) as TimesLate
FROM DELAYS, D_TIME
WHERE DELAYS.id_time = D_TIME.id_time
    AND DELAYS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'JUNIO%' AND DATE_YEAR = '2017');
-- ¿Cuál fue el ciudad con mayor número de retrasos por año?
SELECT city_name, SUM(delays_count) as TimesLate
FROM D_DESTINY, DELAYS
WHERE D_DESTINY.id_destiny = DELAYS.id_destiny
GROUP BY city_name
ORDER BY SUM(delays_count) DESC;
-- ¿Cuál fue el tiempo total de retrazo de los aviones en el mes? 
SELECT D_A.name, SUM(total_delays_time) as Total_Time
FROM D_AIRPLANE D_A, DELAYS, D_TIME
WHERE D_A.id_plane = DELAYS.id_plane
    AND DELAYS.id_time = D_TIME.id_time
    AND DELAYS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'JUNIO%' AND DATE_YEAR = '2017')
GROUP BY D_A.name
ORDER BY SUM(total_delays_time) DESC;