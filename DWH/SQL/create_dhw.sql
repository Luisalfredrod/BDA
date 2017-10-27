/* Script that creates the DWH.
 *
 */

------------------------------ DESTRUCTION ---------------------------

/*
 * Destruction of DHW tables.
 */
DROP TABLE DESTINY_TICKETS;
DROP TABLE DELAYS;
DROP TABLE AIRPLANE_FLIGHTS;
DROP TABLE PASSENGER_FLIGHTS;
DROP TABLE D_DESTINY;
DROP TABLE D_TIME;
DROP TABLE D_AIRPLANE;
DROP TABLE D_PASSENGER;

/*
 * Destruction of DHW sequences.
 */
DROP SEQUENCE SEQ_D_DESTINY;
DROP SEQUENCE SEQ_D_TIME;
DROP SEQUENCE SEQ_DESTINY_TICKETS;
DROP SEQUENCE SEQ_DELAYS;
DROP SEQUENCE SEQ_AIRPLANE_FLIGHTS;
DROP SEQUENCE SEQ_PASSENGER_FLIGHTS;
DROP SEQUENCE SEQ_D_AIRPLANE;
DROP SEQUENCE SEQ_D_PASSENGER;

/*
 * Destruction of materialized views.
 */
DROP MATERIALIZED VIEW MV_AIRPORT;
DROP MATERIALIZED VIEW MV_AIRPLANE;
DROP MATERIALIZED VIEW MV_PASSENGER;
DROP MATERIALIZED VIEW MV_CITY;
DROP MATERIALIZED VIEW MV_COUNTRY;
DROP MATERIALIZED VIEW MV_CONTINENT;
DROP MATERIALIZED VIEW MV_TICKET;
DROP MATERIALIZED VIEW MV_FLIGHT;
DROP MATERIALIZED VIEW MV_TICKET2;


------------------------------ CREATION ---------------------------

/*
 * Creation of Materialized views
 * NOTE: Materialized views only contain information needed to build cubes.
 */

-- Airport materialized view
CREATE MATERIALIZED VIEW MV_AIRPORT
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM AIRPORT@EUROPE;

-- Airplane materialized view
CREATE MATERIALIZED VIEW MV_AIRPLANE
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM AIRPLANE@EUROPE;

-- Passenger materialized view
CREATE MATERIALIZED VIEW MV_PASSENGER
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM PASSENGER@EUROPE;

-- City materialized view
CREATE MATERIALIZED VIEW MV_CITY
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM CITY@EUROPE;

-- Country materialized view
CREATE MATERIALIZED VIEW MV_COUNTRY
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM COUNTRY@EUROPE;

-- Continent materialized view
CREATE MATERIALIZED VIEW MV_CONTINENT
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM CONTINENT@EUROPE;

-- Ticket materialized view
CREATE MATERIALIZED VIEW MV_TICKET
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price as price, COUNT(1) as tickets_sold
FROM TICKET@EUROPE TICKET, FLIGHT@EUROPE FLIGHT, ROUTE@EUROPE ROUTE
WHERE TICKET.id_flight = FLIGHT.id_flight AND ROUTE.id_route = FLIGHT.id_route
GROUP BY TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price
UNION
SELECT TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price as price, COUNT(1) as tickets_sold
FROM TICKET@AMERICA TICKET, FLIGHT@AMERICA FLIGHT, ROUTE@AMERICA ROUTE
WHERE TICKET.id_flight = FLIGHT.id_flight AND ROUTE.id_route = FLIGHT.id_route
GROUP BY TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price
UNION
SELECT TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price as price, COUNT(1) as tickets_sold
FROM TICKET@ASIA TICKET, FLIGHT@ASIA FLIGHT, ROUTE@ASIA ROUTE
WHERE TICKET.id_flight = FLIGHT.id_flight AND ROUTE.id_route = FLIGHT.id_route
GROUP BY TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price
UNION
SELECT TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price as price, COUNT(1) as tickets_sold
FROM TICKET@OCEANIA TICKET, FLIGHT@OCEANIA FLIGHT, ROUTE@OCEANIA ROUTE
WHERE TICKET.id_flight = FLIGHT.id_flight AND ROUTE.id_route = FLIGHT.id_route
GROUP BY TICKET.date_purchase, TICKET.id_passenger, ROUTE.id_airport_arrival, FLIGHT.price;

-- Flight materialized view
CREATE MATERIALIZED VIEW MV_FLIGHT
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT F.id_flight, F.price, R.id_airport_arrival,F.on_time, F.delay_time, F.flight_date, F.id_plane
FROM FLIGHT@EUROPE F, ROUTE@EUROPE R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival,F.on_time, F.delay_time, F.flight_date, F.id_plane
FROM FLIGHT@AMERICA F, ROUTE@AMERICA R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival,F.on_time, F.delay_time, F.flight_date, F.id_plane
FROM FLIGHT@ASIA F, ROUTE@ASIA R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival,F.on_time, F.delay_time, F.flight_date, F.id_plane
FROM FLIGHT@OCEANIA F, ROUTE@OCEANIA R
WHERE F.id_route = R.id_route;

-- Ticket 2 materialized view
--Se que la vista no es necesaria y solo se necesita agregar el id_flight y flight_date a la otra vista de ticket,
--pero el profe me recomendó ya no moverle a la vista y ya después lo mejoramos.
CREATE MATERIALIZED VIEW MV_TICKET2
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT F.id_flight,FLIGHT_DATE, T.id_passenger
FROM FLIGHT@EUROPE F, TICKET@EUROPE T
WHERE F.id_flight = T.id_flight
UNION
SELECT F.id_flight,FLIGHT_DATE, T.id_passenger
FROM FLIGHT@AMERICA F, TICKET@AMERICA T
WHERE F.id_flight = T.id_flight
UNION
SELECT F.id_flight,FLIGHT_DATE, T.id_passenger
FROM FLIGHT@ASIA F, TICKET@ASIA T
WHERE F.id_flight = T.id_flight
UNION
SELECT F.id_flight,FLIGHT_DATE, T.id_passenger
FROM FLIGHT@OCEANIA F, TICKET@OCEANIA T
WHERE F.id_flight = T.id_flight;





/*
 * Creation of DHW tables.
 */

-- Dimension: Destiny table.
CREATE TABLE D_DESTINY
(
    id_destiny NUMBER(10) NOT NULL,
    code_airport NUMBER(10) NOT NULL,
    code_city NUMBER(10) NOT NULL,
    code_country NUMBER(10) NOT NULL,
    code_contintent NUMBER(10) NOT NULL,
    airport_name VARCHAR2(50) NOT NULL,
    city_name VARCHAR2(50) NOT NULL,
    country_name VARCHAR2(50) NOT NULL,
    continent_name VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_D_Destiny PRIMARY KEY (id_destiny)
);

-- Dimension: Time table.
CREATE TABLE D_TIME
(
    id_time NUMBER(10) NOT NULL,
    date_complete DATE NOT NULL,
    date_year VARCHAR2(4) NOT NULL,
    date_month VARCHAR2(10) NOT NULL,
    date_day NUMBER NOT NULL,
    date_day_name VARCHAR2(10),

    CONSTRAINT pk_D_Time PRIMARY KEY (id_time)
);

-- Fact: DESTINY_TICKETS
CREATE TABLE DESTINY_TICKETS
(
    id_destiny_tickets NUMBER(10) NOT NULL,
    id_destiny NUMBER(10) NOT NULL,
    id_time NUMBER(10) NOT NULL,
    tickets_sold NUMBER(10) NOT NULL,
    income NUMBER(10) NOT NULL,

    CONSTRAINT pk_TicketSells PRIMARY KEY (id_destiny_tickets),
    CONSTRAINT fk_TicketSellsDestiny FOREIGN KEY (id_destiny) REFERENCES D_DESTINY(id_destiny),
    CONSTRAINT fk_TicketSellsTime FOREIGN KEY (id_time) REFERENCES D_TIME(id_time)
);

-- Dimension: Airplane table.
CREATE TABLE D_AIRPLANE
(
  id_plane NUMBER(10) NOT NULL,
  code_plane NUMBER(10) NOT NULL,
  name VARCHAR2(100) NOT NULL,
  capacity VARCHAR2(100) NOT NULL,

  CONSTRAINT pk_D_Airplane PRIMARY KEY (id_plane)
);
-- Dimension: Passenger table.
CREATE TABLE D_PASSENGER
(
  id_passenger NUMBER(10) NOT NULL,
  code_passenger NUMBER(10) NOT NULL,
  first_name VARCHAR2(50) NOT NULL,
  last_name VARCHAR2(50) NOT NULL,
  email VARCHAR2(50) NOT NULL,

  CONSTRAINT pk_D_Passenger PRIMARY KEY (id_passenger)
);

--Fact: AIRPLANE_FLIGHTS
CREATE TABLE AIRPLANE_FLIGHTS
(
id_airplane_flights NUMBER(10) NOT NULL,
id_plane NUMBER(10) NOT NULL,
id_time NUMBER(10) NOT NULL,
flights_made_count NUMBER(10) NOT NULL,

CONSTRAINT pk_AirplaneFlights PRIMARY KEY (id_airplane_flights),
CONSTRAINT fk_AirplaneFlightsAirplane FOREIGN KEY (id_plane) REFERENCES D_AIRPLANE(id_plane),
CONSTRAINT fk_AirplaneFlightsTime FOREIGN KEY (id_time) REFERENCES D_TIME(id_time)
);

--Fact: PASSENGER_FLIGHTS
CREATE TABLE PASSENGER_FLIGHTS
(
  id_passenger_flights NUMBER(10) NOT NULL,
  id_passenger NUMBER(10) NOT NULL,
  id_time NUMBER(10) NOT NULL,
  count_flights_passenger NUMBER(10) NOT NULL,

  CONSTRAINT pk_PassengerFlights PRIMARY KEY (id_passenger_flights),
  CONSTRAINT fk_PassengerFlightsPassenger FOREIGN KEY (id_passenger) REFERENCES D_PASSENGER(id_passenger),
  CONSTRAINT fk_PassengerFlightsTime FOREIGN KEY (id_time) REFERENCES D_TIME(id_time)

);

-- Fact: Delays table.
CREATE TABLE DELAYS(
    id_delays NUMBER(10) NOT NULL,
    id_destiny NUMBER(10) NOT NULL,
    id_plane NUMBER(10) NOT NULL,
    id_time NUMBER(10) NOT NULL,
    code_flight NUMBER(10) NOT NULL,
    delays_count NUMBER(10) NOT NULL,
    total_delays_time NUMBER(10) NOT NULL,

    CONSTRAINT pk_Delays PRIMARY KEY (id_delays),
    CONSTRAINT fk_DelaysDestiny FOREIGN KEY (id_destiny) REFERENCES D_DESTINY(id_destiny),
    CONSTRAINT fk_DelaysPlane FOREIGN KEY (id_plane) REFERENCES D_AIRPLANE(id_plane),
    CONSTRAINT fk_DelaysTime FOREIGN KEY (id_time) REFERENCES D_TIME(id_time)
);
/*
 * Create Sequences for primary keys.
 */

-- Destiny dimension sequence
CREATE SEQUENCE SEQ_D_DESTINY;
-- Time dimension sequence
CREATE SEQUENCE SEQ_D_TIME;
-- TicketSells sequence
CREATE SEQUENCE SEQ_DESTINY_TICKETS;
-- Airplane dimension sequence
CREATE SEQUENCE SEQ_D_AIRPLANE;
--Passenger dimension sequence
CREATE SEQUENCE SEQ_D_PASSENGER;
-- AirplaneFlights sequence
CREATE SEQUENCE SEQ_AIRPLANE_FLIGHTS;
--PassengerFlights sequence
CREATE SEQUENCE SEQ_PASSENGER_FLIGHTS;
-- Delays sequence
CREATE SEQUENCE SEQ_DELAYS;
