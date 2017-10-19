/* Script that creates the DWH.
 *
 */

------------------------------ DESTRUCTION ---------------------------

/*
 * Destruction of DHW tables.
 */
DROP TABLE DESTINY_TICKETS;
DROP TABLE AIRPLANE_FLIGHTS;
DROP TABLE D_DESTINY;
DROP TABLE D_TIME;
DROP TABLE D_TICKET;
DROP TABLE D_AIRPLANE;

/*
 * Destruction of DHW sequences.
 */
DROP SEQUENCE SEQ_D_DESTINY;
DROP SEQUENCE SEQ_D_TICKET;
DROP SEQUENCE SEQ_D_TIME;
DROP SEQUENCE SEQ_DESTINY_TICKETS;
DROP SEQUENCE SEQ_AIRPLANE_FLIGHTS;
DROP SEQUENCE SEQ_D_AIRPLANE;

/*
 * Destruction of materialized views.
 */
DROP MATERIALIZED VIEW MV_AIRPORT;
DROP MATERIALIZED VIEW MV_CITY;
DROP MATERIALIZED VIEW MV_COUNTRY;
DROP MATERIALIZED VIEW MV_CONTINENT;
DROP MATERIALIZED VIEW MV_PASSENGER;
DROP MATERIALIZED VIEW MV_TICKET;
DROP MATERIALIZED VIEW MV_FLIGHT;


------------------------------ CREATION ---------------------------

/*
 * Creation of Materialized views
 * NOTE: Materialized views only contain information needed to build cubes.
 */

-- Airplane materialized view
CREATE MATERIALIZED VIEW MV_AIRPORT
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM AIRPORT@EUROPE;

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

-- Passenger materialized view
CREATE MATERIALIZED VIEW MV_PASSENGER
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
AS
SELECT * FROM PASSENGER@EUROPE;

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
SELECT F.id_flight, F.price, R.id_airport_arrival
FROM FLIGHT@EUROPE F, ROUTE@EUROPE R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival
FROM FLIGHT@AMERICA F, ROUTE@AMERICA R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival
FROM FLIGHT@ASIA F, ROUTE@ASIA R
WHERE F.id_route = R.id_route
UNION
SELECT F.id_flight, F.price, R.id_airport_arrival
FROM FLIGHT@OCEANIA F, ROUTE@OCEANIA R
WHERE F.id_route = R.id_route;

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
/*
 * Create Sequences for primary keys.
 */

-- Destiny dimension sequence
CREATE SEQUENCE SEQ_D_DESTINY;
-- Time dimension sequence
CREATE SEQUENCE SEQ_D_TIME;
-- Ticket dimension sequence
CREATE SEQUENCE SEQ_D_TICKET;
-- TicketSells sequence
CREATE SEQUENCE SEQ_DESTINY_TICKETS;
--Airplane dimension sequence
CREATE SEQUENCE SEQ_D_AIRPLANE;
--AirplaneFlights sequence
CREATE SEQUENCE SEQ_AIRPLANE_FLIGHTS;
