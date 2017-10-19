/*
 * Script to load tables of DWH
 */

/*
 * Create procedures to load/update tables
 */

----------------------------------- CREATION --------------------------------------

-- Procedure to load D_TIME data
CREATE OR REPLACE PROCEDURE PD_LOAD_D_TIME (p_startDate in
DATE, v_endDate in DATE) AS 
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

-- Procedure to load/update D_DESTINY
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
END UPDATE_D_DESTINY;

-- Procedure to load/update D_TICKET
CREATE OR REPLACE PROCEDURE UPDATE_D_TICKET AS
BEGIN
    INSERT INTO D_TICKET
    SELECT SEQ_D_TICKET.NEXTVAL,
        TO_CHAR(TIC.id_flight) || TO_CHAR(TIC.id_passenger) || TO_CHAR(TIC.seat),
        TIC.id_flight,
        PAS.id_passenger,
        TIC.date_purchase,
        PAS.first_name || ' ' || PAS.last_name,
        PAS.email
FROM MV_TICKET TIC, 
    MV_PASSENGER PAS
WHERE TIC.id_passenger = PAS.id_passenger
    AND TO_CHAR(TIC.id_flight) || TO_CHAR(TIC.id_passenger) || TO_CHAR(TIC.seat) NOT IN (SELECT code_ticket FROM D_TICKET);
END UPDATE_D_TICKET;


----------------------------------- EXECUTION --------------------------------------

-- Execute procedure to load D_Time table
EXECUTE PD_LOAD_D_TIME(TO_DATE('2016/01/01', 'yyyy/mm/dd'), TO_DATE('2017/12/31', 'yyyy/mm/dd'));

-- Execute procedure to load D_Destiny table
EXECUTE UPDATE_D_DESTINY;

-- Execute procedure to load D_Ticket table
EXECUTE UPDATE_D_TICKET;

