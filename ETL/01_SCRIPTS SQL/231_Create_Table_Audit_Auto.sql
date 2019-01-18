-- AUDIT_AUTO_TRACE
CREATE TABLE AUDIT_AUTO_TRACE(
NUM_TRANSFER NUMERIC(15) IDENTITY(1,1) NOT NULL,
START_TIME DATETIME,
END_TIME DATETIME,
PACKAGE_NAME VARCHAR(32),
MACHINE_NAME VARCHAR(32),
USER_NAME VARCHAR(32),
ERROR_CODE NUMERIC(1),
ROWS_TREATED NUMERIC(10),
ROWS_REJECTED NUMERIC(10)
);
ALTER TABLE AUDIT_AUTO_TRACE
ADD CONSTRAINT PK_AUDIT_AUTO_TRACE PRIMARY KEY (NUM_TRANSFER);

-- AUDIT_AUTO_ERRORS
CREATE TABLE AUDIT_AUTO_ERRORS
(
NUM_ERROR NUMERIC(10) NOT NULL IDENTITY(1,1)
,ERROR_CODE NUMERIC(10)
,ERROR_DESCRIPTION VARCHAR(255)
,PK_VALUE NUMERIC(10)
,TABLE_NAME VARCHAR(25)
,NUM_TRANSFER NUMERIC(15)
)
;
ALTER TABLE AUDIT_AUTO_ERRORS
ADD CONSTRAINT PK_AUDIT_AUTO_ERRORS PRIMARY KEY (NUM_ERROR);
ALTER TABLE AUDIT_AUTO_ERRORS
ADD CONSTRAINT FK_AUDIT_AUTO_ERRORS_NT
FOREIGN KEY (NUM_TRANSFER)
REFERENCES AUDIT_AUTO_TRACE(NUM_TRANSFER);