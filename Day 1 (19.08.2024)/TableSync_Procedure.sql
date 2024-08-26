CREATE OR ALTER PROCEDURE TABLE_SYNC(
    @DEBUG_FLAG INT = 0
)
AS
BEGIN

    INSERT INTO Employee_TARGET (ID, EMPLOYEE_NAME, IS_DELETED)
    SELECT 
        s.ID, 
        s.EMPLOYEE_NAME, 
        0
    FROM 
        Employee_SOURCE s
    LEFT JOIN 
        Employee_TARGET t ON s.ID = t.ID
    WHERE 
        t.ID IS NULL;


    INSERT INTO Employee_TARGET (ID, EMPLOYEE_NAME, IS_DELETED)
    SELECT 
        s.ID, 
        s.EMPLOYEE_NAME, 
        0
    FROM 
        Employee_SOURCE s
    INNER JOIN 
        Employee_TARGET t ON s.ID = t.ID
    WHERE 
        t.IS_DELETED = 0 AND s.EMPLOYEE_NAME <> t.EMPLOYEE_NAME;


    UPDATE t
    SET 
        t.IS_DELETED = 1
    FROM 
        Employee_TARGET t
    LEFT JOIN 
        Employee_SOURCE s ON t.ID = s.ID
    WHERE 
        s.ID IS NULL 
        AND t.IS_DELETED = 0;

    IF @DEBUG_FLAG = 1
    BEGIN
        PRINT 'After Sync - Employee_SOURCE:';
        SELECT * FROM Employee_SOURCE;

        PRINT 'After Sync - Employee_TARGET (All Active Records):';
        SELECT * FROM Employee_TARGET WHERE IS_DELETED = 0;

        PRINT 'After Sync - Employee_TARGET (All Active Latest Records):';
        SELECT *
        FROM Employee_TARGET t1
        WHERE IS_DELETED = 0
        AND TIMESTAMP_CREATED = (
            SELECT MAX(TIMESTAMP_CREATED)
            FROM Employee_TARGET t2
            WHERE t1.ID = t2.ID
            AND t2.IS_DELETED = 0
        );

        PRINT 'After Sync - Employee_TARGET (Deleted Records):';
        SELECT * FROM Employee_TARGET WHERE IS_DELETED = 1;
    END
END;



EXEC TABLE_SYNC @DEBUG_FLAG = 1;
