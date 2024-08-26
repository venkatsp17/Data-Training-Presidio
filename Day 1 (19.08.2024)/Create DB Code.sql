CREATE DATABASE MynewDB;
GO

USE MynewDB;
GO

CREATE TABLE Employee_SOURCE (
    ID INT,
    EMPLOYEE_NAME VARCHAR(50)
);

CREATE TABLE Employee_TARGET (
    ID INT,
    EMPLOYEE_NAME VARCHAR(50),
    IS_DELETED BIT,
    TIMESTAMP_CREATED TIMESTAMP
);


INSERT INTO Employee_SOURCE (ID, EMPLOYEE_NAME) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Michael Johnson'),
(4, 'Emily Davis'),
(5, 'David Brown');


INSERT INTO Employee_SOURCE (ID, EMPLOYEE_NAME) VALUES
(6, 'John Doee1');


Update Employee_SOURCE set EMPLOYEE_NAME = 'Default' where ID = 5;

Delete from Employee_SOURCE where ID = 6;

EXEC TABLE_SYNC @DEBUG_FLAG = 1;