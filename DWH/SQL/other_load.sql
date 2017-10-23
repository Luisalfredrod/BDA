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