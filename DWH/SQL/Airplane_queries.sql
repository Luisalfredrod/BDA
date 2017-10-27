-- Vuelos Totales por Avion --
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS
WHERE AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane
GROUP BY name;

-- El avion con mayor numero de vuelos --
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS
WHERE AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane
GROUP BY name
ORDER BY SUM(flights_made_count) DESC;

-- El avion con menor numero de vuelos --
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS
WHERE AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane
GROUP BY name
ORDER BY SUM(flights_made_count);

-- Vuelos por avion en X mes--
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS, D_TIME
WHERE D_AIRPLANE.code_plane = 1
      AND AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane 
      AND AIRPLANE_FLIGHTS.id_time = D_TIME.id_time
      AND AIRPLANE_FLIGHTS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'ABRIL%' AND DATE_YEAR = '2017')
GROUP BY name;

-- Vuelos Especificos por avion en X mes
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS, D_TIME
WHERE D_AIRPLANE.code_plane = 1
      AND AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane 
      AND AIRPLANE_FLIGHTS.id_time = D_TIME.id_time
      AND AIRPLANE_FLIGHTS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'ABRIL%' AND DATE_YEAR = '2017')
GROUP BY name;

-- Vuelos de todos los aviones por mes
SELECT NAME, SUM(flights_made_count) as TotalFlights
FROM D_AIRPLANE, AIRPLANE_FLIGHTS, D_TIME
WHERE AIRPLANE_FLIGHTS.id_plane = D_AIRPLANE.id_plane 
      AND AIRPLANE_FLIGHTS.id_time = D_TIME.id_time
      AND AIRPLANE_FLIGHTS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_MONTH LIKE 'OCTUBRE%' AND DATE_YEAR = '2017')
GROUP BY name;
