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


----------------------------------- EXECUTION --------------------------------------

-- Execute procedure to load D_Time table
EXECUTE PD_LOAD_D_TIME(TO_DATE('2016/01/01', 'yyyy/mm/dd'), TO_DATE('2017/12/31', 'yyyy/mm/dd'));

-- Execute procedure to load D_Destiny table
EXECUTE UPDATE_D_DESTINY;

-- Execute procedure to load D_Ticket table
EXECUTE UPDATE_DESTINY_TICKETS(TO_DATE('2016/01/01', 'yyyy/mm/dd'), TO_DATE('2017/12/31', 'yyyy/mm/dd'));

