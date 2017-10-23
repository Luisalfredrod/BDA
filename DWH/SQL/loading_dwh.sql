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
