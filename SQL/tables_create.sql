CREATE TABLE Continent
(
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,

    CONSTRAINT pk_Continent PRIMARY KEY (id_continent)
);

CREATE TABLE Country
(
    id_country number(10) NOT NULL,
    id_continent number(10) NOT NULL,
    name varchar2(50) NOT NULL,    

    CONSTRAINT pk_Country PRIMARY KEY (id_country),
    CONSTRAINT fk_CountryContinent FOREIGN KEY (id_continent) REFERENCES Continent(id_continent)
);

CREATE TABLE City
(
    id_city number(10) NOT NULL,
    id_country number(10) NOT NULL,
    name varchar2(50) NOT NULL,    

    CONSTRAINT pk_City PRIMARY KEY(id_city),
    CONSTRAINT fk_CityCountry FOREIGN KEY (id_country) REFERENCES Country(id_country)
);

CREATE TABLE Airport
(
    id_airport number(10) NOT NULL,
    id_city number(10) NOT NULL,
    name varchar2(50) NOT NULL,    

    CONSTRAINT pk_Airport PRIMARY KEY(id_airport),
    CONSTRAINT fk_AirportCity FOREIGN KEY (id_city) REFERENCES City(id_city)     
);

CREATE TABLE Route
(
    id_route number(10) NOT NULL,
    id_airport_departure number(10) NOT NULL,
    id_airport_arrival number(10) NOT NULL,
    route_duration number(10) NOT NULL,

    CONSTRAINT pk_Route PRIMARY KEY(id_route),
    CONSTRAINT fk_RouteAirportDeparture FOREIGN KEY (id_airport_departure) REFERENCES Airport(id_airport),
    CONSTRAINT fk_RouteAirportArrival FOREIGN KEY (id_airport_arrival) REFERENCES Airport(id_airport)
);

CREATE TABLE ScheduleTime (
    id_schedule number(10) NOT NULL,
    schedule_time varchar2(15) NOT NULL,
    
    CONSTRAINT pk_ScheduleTime PRIMARY KEY (id_schedule)
    
);

CREATE TABLE Airplane (
    id_plane number(10) NOT NULL,
    name varchar2(30) NOT NULL,
    capacity number(10) NOT NULL,
    
    CONSTRAINT pk_Airplane PRIMARY KEY (id_plane)
);

CREATE TABLE Flight (
    id_flight number(10) NOT NULL,
    id_route number(10) NOT NULL,
    id_schedule number(10) NOT NULL,
    id_plane number(10) NOT NULL,
    price number(10) NOT NULL,
    flight_date date NOT NULL,
    on_time number(1) NOT NULL,
    
    CONSTRAINT pk_Flight PRIMARY KEY (id_flight),
    CONSTRAINT fk_FlightRoute FOREIGN KEY (id_route) REFERENCES Route(id_route),
    CONSTRAINT fk_FlightScheduleTime FOREIGN KEY (id_schedule) REFERENCES ScheduleTime(id_schedule),    
    CONSTRAINT fk_FlightAirplane FOREIGN KEY (id_plane) REFERENCES Airplane(id_plane)
);

CREATE TABLE Passenger (
    id_passenger number(10) NOT NULL,
    first_name varchar2(50) NOT NULL,
    last_name varchar2(50) NOT NULL,
    email varchar2(50) NOT NULL,
    
    CONSTRAINT pk_Passenger PRIMARY KEY (id_passenger)
);

CREATE TABLE Ticket (
    id_flight number(10) NOT NULL,
    id_passenger number(10) NOT NULL,
    seat number(10) NOT NULL,
    date_purchase date NOT NULL,
    
    CONSTRAINT pk_Ticket PRIMARY KEY (id_flight,id_passenger,seat),
    CONSTRAINT fk_TicketFlight FOREIGN KEY (id_flight) REFERENCES Flight(id_flight),
    CONSTRAINT fk_TicketPassenger FOREIGN KEY (id_passenger) REFERENCES Passenger(id_passenger)
);

