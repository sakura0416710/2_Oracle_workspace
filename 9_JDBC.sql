ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER JDBC IDENTIFIED BY JDBC;
GRANT CONNECT, RESOURCE TO JDBC;
ALTER USER JDBC DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;