/* Script that creates the DWH.
 *
 */

/*
 * Destruction of DHW tables.
 */
DROP TABLE TICKET_SELLS;
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
DROP SEQUENCE SEQ_TICKET_SELLS;
DROP SEQUENCE SEQ_AIRPLANE_FLIGHTS;
DROP SEQUENCE SEQ_D_AIRPLANE;

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

-- Dimension: Ticket table.
CREATE TABLE D_TICKET
(
    id_ticket NUMBER(10) NOT NULL,
    code_ticket NUMBER(10) NOT NULL,
    code_flight NUMBER(10) NOT NULL,
    code_passenger NUMBER(10) NOT NULL,
    date_purchase DATE NOT NULL,
    passenger_name VARCHAR2(100) NOT NULL,
    passenger_email VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_D_Ticket PRIMARY KEY (id_ticket)
);

-- Fact: TICKET_SELLS
CREATE TABLE TICKET_SELLS
(
    id_ticket_sells NUMBER(10) NOT NULL,
    id_destiny NUMBER(10) NOT NULL,
    id_time NUMBER(10) NOT NULL,
    id_ticket NUMBER(10) NOT NULL,
    tickets_count NUMBER(10) NOT NULL,
    income NUMBER(10) NOT NULL,

    CONSTRAINT pk_TicketSells PRIMARY KEY (id_ticket_sells),
    CONSTRAINT fk_TicketSellsDestiny FOREIGN KEY (id_destiny) REFERENCES D_DESTINY(id_destiny),
    CONSTRAINT fk_TicketSellsTime FOREIGN KEY (id_time) REFERENCES D_TIME(id_time),
    CONSTRAINT fk_TicketSellsTicket FOREIGN KEY (id_ticket) REFERENCES D_TICKET(id_ticket)
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
CREATE SEQUENCE SEQ_TICKET_SELLS;
--Airplane dimension sequence
CREATE SEQUENCE SEQ_D_AIRPLANE;
--AirplaneFlights sequence
CREATE SEQUENCE SEQ_AIRPLANE_FLIGHTS;