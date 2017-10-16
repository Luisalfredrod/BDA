-- Script for fragmenting tables.
-- Param continent_id.
-- Author: Eduardo Vaca.

INSERT INTO CONTINENT
SELECT *
FROM CONTINENTFULL;

-- Vertical fragmentation of Country.
INSERT INTO COUNTRY
SELECT COUNTRYFULL.id_country, COUNTRYFULL.id_continent, COUNTRYFULL.name
FROM COUNTRYFULL;

-- Vertical fragmentation of City.
INSERT INTO CITY
SELECT CITYFULL.id_city, CITYFULL.id_country, CITYFULL.name
FROM CITYFULL;

-- Vertical fragmentation of Airport.
INSERT INTO AIRPORT
SELECT AIRPORTFULL.id_airport, AIRPORTFULL.id_city, AIRPORTFULL.name
FROM AIRPORTFULL;

-- Horizontal fragmentation of Route.
INSERT INTO ROUTE
SELECT ROUTEFULL.id_route, ROUTEFULL.id_airport_departure, ROUTEFULL.id_airport_arrival, ROUTEFULL.route_duration
FROM ROUTEFULL, AIRPORTFULL, CITYFULL, COUNTRYFULL, CONTINENTFULL
WHERE ROUTEFULL.id_airport_departure = AIRPORTFULL.id_airport 
    AND AIRPORTFULL.id_city = CITYFULL.id_city
    AND CITYFULL.id_country = COUNTRYFULL.id_country
    AND COUNTRYFULL.id_continent = CONTINENTFULL.id_continent
    AND CONTINENTFULL.id_continent = &1;

INSERT INTO SCHEDULETIME
SELECT *
FROM SCHEDULETIMEFULL;

INSERT INTO AIRPLANE
SELECT *
FROM AIRPLANEFULL;

INSERT INTO PASSENGER
SELECT *
FROM PASSENGERFULL;

-- Horizontal fragmentation of Flight.
INSERT INTO FLIGHT
SELECT FLIGHTFULL.id_flight, FLIGHTFULL.id_route, FLIGHTFULL.id_schedule, FLIGHTFULL.id_plane, FLIGHTFULL.price, FLIGHTFULL.flight_date, FLIGHTFULL.on_time, FLIGHTFULL.delay_time
FROM FLIGHTFULL, ROUTEFULL, AIRPORTFULL, CITYFULL, COUNTRYFULL, CONTINENTFULL
WHERE FLIGHTFULL.id_route = ROUTEFULL.id_route
    AND ROUTEFULL.id_airport_departure = AIRPORTFULL.id_airport
    AND AIRPORTFULL.id_city = CITYFULL.id_city
    AND CITYFULL.id_country = COUNTRYFULL.id_country
    AND COUNTRYFULL.id_continent = CONTINENTFULL.id_continent
    AND CONTINENTFULL.id_continent = &1;

-- Horizontal fragmentation of Ticket.
INSERT INTO TICKET
SELECT TICKETFULL.id_flight, TICKETFULL.id_passenger, TICKETFULL.seat, TICKETFULL.date_purchase
FROM TICKETFULL, FLIGHTFULL, ROUTEFULL, AIRPORTFULL, CITYFULL, COUNTRYFULL, CONTINENTFULL
WHERE TICKETFULL.id_flight = FLIGHTFULL.id_flight
    AND FLIGHTFULL.id_route = ROUTEFULL.id_route
    AND ROUTEFULL.id_airport_departure = AIRPORTFULL.id_airport
    AND AIRPORTFULL.id_city = CITYFULL.id_city
    AND CITYFULL.id_country = COUNTRYFULL.id_country
    AND COUNTRYFULL.id_continent = CONTINENTFULL.id_continent
    AND CONTINENTFULL.id_continent = &1;

-- Drop temporary tables that cointained all data.
DROP TABLE TicketFull;
DROP TABLE FlightFull;
DROP TABLE ScheduleTimeFull;
DROP TABLE RouteFull;
DROP TABLE AirportFull;
DROP TABLE CityFull;
DROP TABLE CountryFull;
DROP TABLE ContinentFull;
DROP TABLE PassengerFull;
DROP TABLE AirplaneFull;