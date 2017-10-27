
-- Total de vuelos por pasajero --
SELECT first_name,last_name, SUM(count_flights_passenger) as Passenger_Total_Flights
FROM D_PASSENGER, PASSENGER_FLIGHTS
WHERE PASSENGER_FLIGHTS.id_passenger = D_PASSENGER.id_passenger
GROUP BY first_name,last_name
ORDER BY SUM(count_flights_passenger);

-- Vuelos de pasajero por año
SELECT first_name,last_name, SUM(count_flights_passenger) as TotalFlights
FROM D_PASSENGER, PASSENGER_FLIGHTS, D_TIME
WHERE PASSENGER_FLIGHTS.id_passenger = D_PASSENGER.id_passenger
      AND PASSENGER_FLIGHTS.id_time = D_TIME.id_time
      AND PASSENGER_FLIGHTS.id_time IN (SELECT id_time FROM D_TIME WHERE DATE_YEAR = '2017')
GROUP BY first_name,last_name;

-- Pasajero con mayor numero de boletos comprados --
SELECT first_name,last_name, SUM(count_flights_passenger) as Passenger_Total_Flights
FROM D_PASSENGER, PASSENGER_FLIGHTS
WHERE PASSENGER_FLIGHTS.id_passenger = D_PASSENGER.id_passenger
GROUP BY first_name, last_name
ORDER BY SUM(count_flights_passenger) DESC;

-- Pasajero con menor numero de vuelos --
SELECT first_name,last_name, SUM(count_flights_passenger) as Passenger_Total_Flights
FROM D_PASSENGER, PASSENGER_FLIGHTS
WHERE PASSENGER_FLIGHTS.id_passenger = D_PASSENGER.id_passenger
GROUP BY first_name, last_name
ORDER BY SUM(count_flights_passenger) ASC;

-- Promedio de vuelos por pasajero --
SELECT AVG(Passenger_Total_Flights) AS PROMEDIO FROM (SELECT first_name,last_name, SUM(count_flights_passenger) as Passenger_Total_Flights
FROM D_PASSENGER, PASSENGER_FLIGHTS
WHERE PASSENGER_FLIGHTS.id_passenger = D_PASSENGER.id_passenger
GROUP BY first_name,last_name
ORDER BY SUM(count_flights_passenger));
