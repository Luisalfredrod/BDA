-- Script for creating tables, creates two schemas:
--  1. For filling them with all data.
--  2. For inserting fragmented data.
-- Author: Eduardo Vaca.


-- Creation of FULL TABLES (to be destroyed after fragmentation).

-- Creates the table for all Continents.
CREATE TABLE ContinentFull
(
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_ContinentFull PRIMARY KEY (id_continent)
);

-- Creates the table for all Countries.
CREATE TABLE CountryFull
(
    id_country number(10) NOT NULL,
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_CountryFull PRIMARY KEY (id_country),
    -- Adds foreign key constraint with ContinentFull table.
    CONSTRAINT fk_CountryContinentFull FOREIGN KEY (id_continent) REFERENCES ContinentFull(id_continent)
);

-- Creates the table for all Cities.
CREATE TABLE CityFull
(
    id_city number(10) NOT NULL,
    id_country number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_CityFull PRIMARY KEY(id_city),
    -- Adds foreign key constraint with CountryFull table.
    CONSTRAINT fk_CityCountryFull FOREIGN KEY (id_country) REFERENCES CountryFull(id_country)
);

-- Creates the table for all Airports.
CREATE TABLE AirportFull
(
    id_airport number(10) NOT NULL,
    id_city number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_AirportFull PRIMARY KEY(id_airport),
    -- Adds foreign key constraint with CityFull table.
    CONSTRAINT fk_AirportCityFull FOREIGN KEY (id_city) REFERENCES CityFull(id_city)     
);

-- Creates the table for all Routes.
CREATE TABLE RouteFull
(
    id_route number(10) NOT NULL,
    id_airport_departure number(10) NOT NULL,
    id_airport_arrival number(10) NOT NULL,
    route_duration number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_RouteFull PRIMARY KEY(id_route),
    -- Adds foreign key constraint with AirportFull table.
    CONSTRAINT fk_RouteAirportDepartureFull FOREIGN KEY (id_airport_departure) REFERENCES AirportFull(id_airport),
    -- Adds foreign key constraint with AirportFull table.
    CONSTRAINT fk_RouteAirportArrivalFull FOREIGN KEY (id_airport_arrival) REFERENCES AirportFull(id_airport)
);

-- Creates the table for all Schedules.
CREATE TABLE ScheduleTimeFull (
    id_schedule number(10) NOT NULL,
    schedule_time varchar2(15) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_ScheduleTimeFull PRIMARY KEY (id_schedule)
);

-- Creates the table for all Airplanes.
CREATE TABLE AirplaneFull (
    id_plane number(10) NOT NULL,
    name varchar2(30) NOT NULL,
    capacity number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_AirplaneFull PRIMARY KEY (id_plane)
);

-- Creates the table for all Flights.
CREATE TABLE FlightFull (
    id_flight number(10) NOT NULL,
    id_route number(10) NOT NULL,
    id_schedule number(10) NOT NULL,
    id_plane number(10) NOT NULL,
    price number(10) NOT NULL,
    flight_date date NOT NULL,
    on_time number(1) NOT NULL,
    delay_time number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_FlightFull PRIMARY KEY (id_flight),
    -- Adds foreign key constraint with RouteFull table.
    CONSTRAINT fk_FlightRouteFull FOREIGN KEY (id_route) REFERENCES RouteFull(id_route),
    -- Adds foreign key constraint with ScheduleTimeFull table.
    CONSTRAINT fk_FlightScheduleTimeFull FOREIGN KEY (id_schedule) REFERENCES ScheduleTimeFull(id_schedule),    
    -- Adds foreign key constraint with AirplaneFull table.
    CONSTRAINT fk_FlightAirplaneFull FOREIGN KEY (id_plane) REFERENCES AirplaneFull(id_plane)
);

-- Creates the table for all Passangers.
CREATE TABLE PassengerFull (
    id_passenger number(10) NOT NULL,
    first_name varchar2(50) NOT NULL,
    last_name varchar2(50) NOT NULL,
    email varchar2(50) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_PassengerFull PRIMARY KEY (id_passenger)
);

-- Creates the table for all Tickets.
CREATE TABLE TicketFull (
    id_flight number(10) NOT NULL,
    id_passenger number(10) NOT NULL,
    seat number(10) NOT NULL,
    date_purchase date NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_TicketFull PRIMARY KEY (id_flight,id_passenger,seat),
    -- Adds foreign key constraint with FlightFull table.
    CONSTRAINT fk_TicketFlightFull FOREIGN KEY (id_flight) REFERENCES FlightFull(id_flight),
    -- Adds foreign key constraint with PassengerFull table.
    CONSTRAINT fk_TicketPassengerFull FOREIGN KEY (id_passenger) REFERENCES PassengerFull(id_passenger)
);

-- FRAGMENTED TABLES. (to be kept after fragmentation).

-- Creates table for fragmentation of ContinentFull.
CREATE TABLE Continent
(
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Continent PRIMARY KEY (id_continent)
);

-- Creates table for fragmentation of CountryFull.
CREATE TABLE Country
(
    id_country number(10) NOT NULL,
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_Country PRIMARY KEY (id_country),
    -- Adds foreign key constraint with Continent table.
    CONSTRAINT fk_CountryContinent FOREIGN KEY (id_continent) REFERENCES Continent(id_continent)
);

-- Creates table for fragmentation of CityFull.
CREATE TABLE City
(
    id_city number(10) NOT NULL,
    id_country number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_City PRIMARY KEY(id_city),
    -- Adds foreign key constraint with Country table.
    CONSTRAINT fk_CityCountry FOREIGN KEY (id_country) REFERENCES Country(id_country)
);

-- Creates table for fragmentation of AirportFull.
CREATE TABLE Airport
(
    id_airport number(10) NOT NULL,
    id_city number(10) NOT NULL,
    name varchar2(50) NOT NULL,    
    -- Adds primary key constraint.
    CONSTRAINT pk_Airport PRIMARY KEY(id_airport),
    -- Adds foreign key constraint with City table.
    CONSTRAINT fk_AirportCity FOREIGN KEY (id_city) REFERENCES City(id_city)     
);

-- Creates table for fragmentation of RouteFull.
CREATE TABLE Route
(
    id_route number(10) NOT NULL,
    id_airport_departure number(10) NOT NULL,
    id_airport_arrival number(10) NOT NULL,
    route_duration number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Route PRIMARY KEY(id_route),
    -- Adds foreign key constraint with Airport table.
    CONSTRAINT fk_RouteAirportDeparture FOREIGN KEY (id_airport_departure) REFERENCES Airport(id_airport),
    -- Adds foreign key constraint with Airport table.
    CONSTRAINT fk_RouteAirportArrival FOREIGN KEY (id_airport_arrival) REFERENCES Airport(id_airport)
);

-- Creates table for fragmentation of ScheduleTimeFull.
CREATE TABLE ScheduleTime (
    id_schedule number(10) NOT NULL,
    schedule_time varchar2(15) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_ScheduleTime PRIMARY KEY (id_schedule)
    
);

-- Creates table for fragmentation of AirplaneFull.
CREATE TABLE Airplane (
    id_plane number(10) NOT NULL,
    name varchar2(30) NOT NULL,
    capacity number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Airplane PRIMARY KEY (id_plane)
);

-- Creates table for fragmentation of FlightFull.
CREATE TABLE Flight (
    id_flight number(10) NOT NULL,
    id_route number(10) NOT NULL,
    id_schedule number(10) NOT NULL,
    id_plane number(10) NOT NULL,
    price number(10) NOT NULL,
    flight_date date NOT NULL,
    on_time number(1) NOT NULL,
    delay_time number(10) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Flight PRIMARY KEY (id_flight),
    -- Adds foreign key constraint with Route table.
    CONSTRAINT fk_FlightRoute FOREIGN KEY (id_route) REFERENCES Route(id_route),
    -- Adds foreign key constraint with ScheduleTime table.
    CONSTRAINT fk_FlightScheduleTime FOREIGN KEY (id_schedule) REFERENCES ScheduleTime(id_schedule),    
    -- Adds foreign key constraint with Airplane table.
    CONSTRAINT fk_FlightAirplane FOREIGN KEY (id_plane) REFERENCES Airplane(id_plane)
);

-- Creates table for fragmentation of PassengerFull.
CREATE TABLE Passenger (
    id_passenger number(10) NOT NULL,
    first_name varchar2(50) NOT NULL,
    last_name varchar2(50) NOT NULL,
    email varchar2(50) NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Passenger PRIMARY KEY (id_passenger)
);

-- Creates table for fragmentation of PassengerFull.
CREATE TABLE Ticket (
    id_flight number(10) NOT NULL,
    id_passenger number(10) NOT NULL,
    seat number(10) NOT NULL,
    date_purchase date NOT NULL,
    -- Adds primary key constraint.
    CONSTRAINT pk_Ticket PRIMARY KEY (id_flight,id_passenger,seat),
    -- Adds foreign key constraint with Flight table.
    CONSTRAINT fk_TicketFlight FOREIGN KEY (id_flight) REFERENCES Flight(id_flight),
    -- Adds foreign key constraint with Passenger table.
    CONSTRAINT fk_TicketPassenger FOREIGN KEY (id_passenger) REFERENCES Passenger(id_passenger)
);

