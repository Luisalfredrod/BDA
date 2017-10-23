-- Distributed transaction for changing user's email.
-- PARAMS:
--  - P_OD_EMAIL : email to be changed
--  - P_NEW_EMAIL : new email to be used instead
CREATE OR REPLACE PROCEDURE CHANGE_USER_EMAIL
(
    P_OLD_EMAIL IN VARCHAR2,
    P_NEW_EMAIL IN VARCHAR2
) AS
v_user_exists number;
BEGIN
    SELECT COUNT(1) INTO v_user_exists FROM PASSENGER WHERE EMAIL = P_OLD_EMAIL;
    if v_user_exists = 0 then
        RAISE_APPLICATION_ERROR(-20000, '{No user found}');
    else
        UPDATE PASSENGER SET email = P_NEW_EMAIL WHERE email = P_OLD_EMAIL;
        UPDATE PASSENGER@AMERICA SET email = P_NEW_EMAIL WHERE email = P_OLD_EMAIL;
        UPDATE PASSENGER@ASIA SET email = P_NEW_EMAIL WHERE email = P_OLD_EMAIL;
        UPDATE PASSENGER@OCEANIA SET email = P_NEW_EMAIL WHERE email = P_OLD_EMAIL;
        COMMIT;
    end if;
END CHANGE_USER_EMAIL;
/

-- Procedure to load/update dimension table D_DESTINY
CREATE OR REPLACE PROCEDURE UPDATEDESTINY ()
AS
BEGIN
    SELECT * FROM D_DESTINY;    
END UPDATEDESTINY;
/