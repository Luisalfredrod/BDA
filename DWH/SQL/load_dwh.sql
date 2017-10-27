/*
 * Script to load tables of DWH
 */

/*
 * Create procedures to load/update tables
 */

----------------------------------- CREATION --------------------------------------

-- Procedure to load dimension table D_TIME data
-- PARAMS:
--  - p_startDate : initial date to be filled in the Dimension time table
--  - v_endData : final date to be filled in the Dimension time table
CREATE OR REPLACE PROCEDURE PD_LOAD_D_TIME
(
    p_startDate in DATE,
    v_endDate in DATE
) AS
v_currentDay NUMBER;
v_currentMont NUMBER;
v_currentYear NUMBER;
v_do BOOLEAN := true;
v_startDate DATE := p_startDate;
v_anio VARCHAR2(4);
v_mes VARCHAR2(10);
v_dia NUMBER;
v_nombredia VARCHAR(10);
v_goalYear NUMBER;
v_goalMonth NUMBER;
v_goalDay NUMBER;
BEGIN
    SELECT EXTRACT(YEAR FROM v_endDate) INTO v_goalYear FROM DUAL;
    SELECT EXTRACT(MONTH FROM v_endDate) INTO v_goalMonth FROM DUAL;
    SELECT EXTRACT(DAY FROM v_endDate) INTO v_goalDay FROM DUAL;
    WHILE v_do
    LOOP
        select to_char(v_startDate, 'YYYY') into v_anio from dual;
        select to_char(v_startDate, 'MONTH') into v_mes from dual;
        select to_char(v_startDate, 'DAY') into v_nombredia from dual;
        select to_char(v_startDate, 'DAY') into v_nombredia from dual;
        SELECT EXTRACT(DAY FROM v_startDate) INTO v_dia FROM DUAL;
        INSERT INTO D_TIME VALUES(SEQ_D_TIME.NEXTVAL, v_startDate, v_anio, v_mes, v_dia, v_nombredia);
        COMMIT;
        v_startDate := v_startDate + 1;
        SELECT EXTRACT(YEAR FROM v_startDate) INTO v_currentYear FROM DUAL;
        SELECT EXTRACT(MONTH FROM v_startDate) INTO v_currentMont FROM DUAL;
        SELECT EXTRACT(DAY FROM v_startDate) INTO v_currentDay FROM DUAL;
        IF v_currentYear = v_goalYear AND v_currentMont = v_goalMonth AND v_currentDay = v_goalDay THEN
            v_do := false;
        END IF;
    END LOOP;
END PD_LOAD_D_TIME;
/

-- Procedure to load/update dimension table D_DESTINY
CREATE OR REPLACE PROCEDURE UPDATE_D_DESTINY AS
BEGIN
    INSERT INTO D_DESTINY
    SELECT SEQ_D_DESTINY.NEXTVAL,
        AIR.id_airport,
        CI.id_city,
        COU.id_country,
        CONT.id_continent,
        AIR.name,
        CI.name,
        COU.name,
        CONT.name
    FROM MV_AIRPORT AIR,
        MV_CITY CI,
        MV_COUNTRY COU,
        MV_CONTINENT CONT
    WHERE AIR.id_city = CI.id_city
        AND CI.id_country = COU.id_country
        AND COU.id_continent = CONT.id_continent
        AND AIR.id_airport NOT IN (SELECT code_airport FROM D_DESTINY);
    COMMIT;
END UPDATE_D_DESTINY;
/

-- Procedure to load/update destiny tickets
-- PARAMS:
--  - STARTDATE: initial date of records to be updated
--  - ENDDATE: final date of records to be updated
CREATE OR REPLACE PROCEDURE UPDATE_DESTINY_TICKETS
(
    STARTDATE IN DATE,
    ENDDATE IN DATE
) AS
vSTARTDATE DATE;
vENDDATE DATE;

-- Get ticket sell records to be deleted based on date
CURSOR c_time IS
SELECT id_destiny_tickets FROM DESTINY_TICKETS
WHERE id_time IN (SELECT id_time FROM D_TIME WHERE date_complete BETWEEN vSTARTDATE and vENDDATE);

-- Get records to be saved
CURSOR c_tickets IS
    SELECT D_DES.id_destiny as id_destiny,
        D_TIME.id_time as id_time,
        SUM(MV_TICKET.tickets_sold) as tickets_sold,
        SUM(MV_TICKET.tickets_sold*MV_TICKET.price) as income
    FROM D_DESTINY D_DES,
        D_TIME,
        MV_TICKET
    WHERE MV_TICKET.date_purchase BETWEEN vSTARTDATE AND vENDDATE
        AND D_DES.code_airport = MV_TICKET.id_airport_arrival
        AND TRUNC(D_TIME.date_complete) = TRUNC(MV_TICKET.date_purchase)
    GROUP BY D_DES.id_destiny, D_TIME.id_time;

BEGIN
    vSTARTDATE := STARTDATE;
    vENDDATE := ENDDATE;

    FOR i_time in c_time
    LOOP
        DELETE FROM DESTINY_TICKETS WHERE i_time.id_destiny_tickets = id_destiny_tickets;
        COMMIT;
    END LOOP;

    FOR i_ticket in c_tickets
    LOOP
        INSERT INTO DESTINY_TICKETS VALUES(SEQ_DESTINY_TICKETS.NEXTVAL, i_ticket.id_destiny, i_ticket.id_time, i_ticket.tickets_sold, i_ticket.income);
        COMMIT;
    END LOOP;
END UPDATE_DESTINY_TICKETS;
/

-- Procedure to load D_AIRPLANE table
CREATE OR REPLACE PROCEDURE UPDATE_D_AIRPLANE AS
BEGIN
    INSERT INTO D_AIRPLANE
    SELECT SEQ_D_AIRPLANE.NEXTVAL,
        MV_AIRPLANE.id_plane,
        MV_AIRPLANE.name,
        MV_AIRPLANE.capacity
    FROM MV_AIRPLANE
    WHERE MV_AIRPLANE.id_plane NOT IN (SELECT code_plane FROM D_AIRPLANE);
    COMMIT;
END UPDATE_D_AIRPLANE;
/

--Procedure to load D_PASSENGER table
CREATE OR REPLACE PROCEDURE UPDATE_D_PASSENGER AS
BEGIN
  INSERT INTO D_PASSENGER
  SELECT SEQ_D_PASSENGER.NEXTVAL,
      MV_PASSENGER.id_passenger,
      MV_PASSENGER.first_name,
      MV_PASSENGER.last_name,
      MV_PASSENGER.email
    FROM MV_PASSENGER
    WHERE MV_PASSENGER.id_passenger NOT IN (SELECT code_passenger FROM D_PASSENGER);
    COMMIT;
  END UPDATE_D_PASSENGER;
  /

-- Procedure to load/update delays
-- PARAMS:
--  - STARTDATE: initial date of records to be updated
--  - ENDDATE: final date of records to be updated
CREATE OR REPLACE PROCEDURE UPDATE_DELAYS
(
    STARTDATE IN DATE,
    ENDDATE IN DATE
) AS
vSTARTDATE DATE;
vENDDATE DATE;

CURSOR c_time IS
    SELECT id_delays FROM DELAYS
    WHERE id_time IN (SELECT id_time FROM D_TIME WHERE date_complete BETWEEN vSTARTDATE and vENDDATE);

CURSOR c_delays IS
    SELECT MV_FLIGHT.id_flight as code_flight,
            D_DES.id_destiny as id_destiny,
            D_TIME.id_time as id_time,
            D_AIRPLANE.code_plane as id_airplane,
            COUNT(4) as delay_count,
            SUM(MV_FLIGHT.delay_time) as total_delay_time
    FROM D_DESTINY D_DES,
            D_TIME,
            MV_FLIGHT,
            D_AIRPLANE
    WHERE MV_FLIGHT.on_time = 0
        AND MV_FLIGHT.id_plane = D_AIRPLANE.code_plane
        AND MV_FLIGHT.flight_date BETWEEN vSTARTDATE AND vENDDATE
        AND TRUNC(D_TIME.date_complete) = TRUNC(MV_FLIGHT.flight_date)
        AND D_DES.code_airport = MV_FLIGHT.id_airport_arrival
    GROUP BY MV_FLIGHT.id_flight, D_DES.id_destiny, D_TIME.id_time, D_AIRPLANE.code_plane;

BEGIN
    vSTARTDATE := STARTDATE;
    vENDDATE := ENDDATE;

    FOR i_time in c_time
    LOOP
        DELETE FROM DELAYS WHERE i_time.id_delays = id_delays;
        COMMIT;
    END LOOP;

    FOR i_delays in c_delays
    LOOP
        INSERT INTO DELAYS VALUES(SEQ_DELAYS.NEXTVAL, i_delays.id_destiny, i_delays.id_airplane, i_delays.id_time, i_delays.code_flight, i_delays.delay_count, i_delays.total_delay_time);
        COMMIT;
    END LOOP;
END UPDATE_DELAYS;
/

-- Procedure UPDATE Airplane Flights
CREATE OR REPLACE PROCEDURE UPDATE_AIRPLANE_FLIGHTS
(
  STARTDATE IN DATE,
  ENDDATE IN DATE
)AS
vSTARTDATE DATE;
VENDDATE DATE;

CURSOR c_time IS
SELECT id_airplane_flights FROM AIRPLANE_FLIGHTS
WHERE id_time IN (SELECT id_time FROM D_TIME WHERE date_complete BETWEEN vSTARTDATE and vENDDATE);

CURSOR c_airplane IS
SELECT D_AIRPLANE.id_plane AS id_plane,
    D_TIME.id_time AS id_time,
    COUNT(MV_FLIGHT.id_flight) AS flights_made_count
FROM D_AIRPLANE,
    D_TIME,
    MV_FLIGHT
WHERE MV_FLIGHT.flight_date BETWEEN TO_DATE('2017/01/01', 'yyyy/mm/dd') AND TO_DATE('2018/01/01', 'yyyy/mm/dd')
    AND TRUNC(D_TIME.date_complete) = TRUNC(MV_FLIGHT.flight_date)
    AND MV_FLIGHT.id_plane = D_AIRPLANE.code_plane
GROUP BY D_AIRPLANE.id_plane, D_TIME.id_time;

BEGIN 
  vSTARTDATE := STARTDATE;
  vENDDATE := ENDDATE;

    FOR i_time in c_time
    LOOP
        DELETE FROM AIRPLANE_FLIGHTS WHERE i_time.id_airplane_flights = id_airplane_flights;
        COMMIT;
    END LOOP;
    FOR i_airplane in c_airplane
    LOOP
        INSERT INTO AIRPLANE_FLIGHTS VALUES(SEQ_AIRPLANE_FLIGHTS.NEXTVAL, i_airplane.id_plane, i_airplane.id_time, i_airplane.flights_made_count);
        COMMIT;
    END LOOP;
END UPDATE_AIRPLANE_FLIGHTS;
/


-- Procedure UPDATE Passenger Flights
CREATE OR REPLACE PROCEDURE UPDATE_PASSENGER_FLIGHTS
(
  STARTDATE IN DATE,
  ENDDATE IN DATE
)AS
vSTARTDATE DATE;
VENDDATE DATE;

CURSOR c_time IS
SELECT id_passenger_flights FROM PASSENGER_FLIGHTS
WHERE id_time IN (SELECT id_time FROM D_TIME WHERE date_complete BETWEEN vSTARTDATE and vENDDATE);


CURSOR c_passenger IS
SELECT D_PASSENGER.id_passenger AS id_passenger,D_TIME.id_time AS id_time,
    COUNT(MV_TICKET2.id_passenger) AS count_flights_passenger
FROM D_PASSENGER,
    D_TIME,
    MV_TICKET2
    WHERE MV_TICKET2.flight_date BETWEEN TO_DATE('2017/01/01', 'yyyy/mm/dd') AND TO_DATE('2018/01/01', 'yyyy/mm/dd')
        AND TRUNC(D_TIME.date_complete) = TRUNC(MV_TICKET2.flight_date)
        AND MV_TICKET2.id_passenger = D_passenger.code_passenger
    GROUP BY D_PASSENGER.id_passenger, D_TIME.id_time;

BEGIN
  vSTARTDATE := STARTDATE;
  vENDDATE := ENDDATE;

    FOR i_time in c_time
    LOOP
        DELETE FROM PASSENGER_FLIGHTS WHERE i_time.id_passenger_flights = id_passenger_flights;
        COMMIT;
    END LOOP;
    FOR i_passenger in c_passenger
    LOOP
        INSERT INTO PASSENGER_FLIGHTS VALUES(SEQ_PASSENGER_FLIGHTS.NEXTVAL, i_passenger.id_passenger, i_passenger.id_time, i_passenger.count_flights_passenger);
        COMMIT;
    END LOOP;
END UPDATE_PASSENGER_FLIGHTS;
/

----------------------------------- EXECUTION --------------------------------------

-- Execute procedure to load D_Time table
EXECUTE PD_LOAD_D_TIME(TO_DATE('2016/01/01', 'yyyy/mm/dd'), TO_DATE('2017/12/31', 'yyyy/mm/dd'));

-- Execute procedure to load D_Destiny table
EXECUTE UPDATE_D_DESTINY;

-- Execute procedure to load D_AIRPLANE
EXECUTE UPDATE_D_AIRPLANE;

--Execute procedure to Loada D_PASSENGER
EXECUTE UPDATE_D_PASSENGER;

-- Execute procedure to load Destiny Tickets table.
EXECUTE UPDATE_DESTINY_TICKETS(TO_DATE('2016/01/01', 'yyyy/mm/dd'), TO_DATE('2017/12/31', 'yyyy/mm/dd'));

-- Execute procedure to load Delays table.
EXECUTE UPDATE_DELAYS(TO_DATE('2017/01/01', 'yyyy/mm/dd'), TO_DATE('2018/12/31', 'yyyy/mm/dd'));

-- Execute procedure to load Airplane Flights table.
EXECUTE UPDATE_AIRPLANE_FLIGHTS(TO_DATE('2017/01/01', 'yyyy/mm/dd'), TO_DATE('2018/12/31', 'yyyy/mm/dd'));

--Execute procedure to Load PASSENGER_FLIGHTS
EXECUTE UPDATE_PASSENGER_FLIGHTS(TO_DATE('2017/01/01', 'yyyy/mm/dd'), TO_DATE('2018/12/31', 'yyyy/mm/dd'));
