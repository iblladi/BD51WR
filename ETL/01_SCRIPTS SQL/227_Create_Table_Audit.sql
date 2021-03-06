CREATE TABLE AUDIT_TRACE
(
NUM_TRANSFER NUMERIC(15) IDENTITY(1,1) NOT NULL
,"DATE" DATE
,START TIME
,"END" TIME
,ERROR_CODE NUMERIC(1)
)
;

CREATE TABLE AUDIT_DETAILS
(
NUM_DETAIL NUMERIC(10) NOT NULL IDENTITY(1,1)
,TABLE_NAME VARCHAR(25)
,ROWS_INSERTED NUMERIC(10)
,ROWS_UPDATED NUMERIC(10)
,ROWS_DELETED NUMERIC(10)
,ROWS_REJECTED NUMERIC(10)
,ROWS_TREATED NUMERIC(10)
,NUM_TRANSFER NUMERIC(15)
)
;

CREATE TABLE AUDIT_ERRORS
(
NUM_ERROR NUMERIC(10) NOT NULL IDENTITY(1,1)
,TABLE_NAME VARCHAR(25)
,PK_VALUE NUMERIC(10)
,SRC_PROBLEM VARCHAR(100)
,NUM_TRANSFER NUMERIC(15)
)
;


--PK & FK
ALTER TABLE AUDIT_TRACE
ADD CONSTRAINT PK_AUDIT_TRACE PRIMARY KEY (NUM_TRANSFER);

ALTER TABLE AUDIT_DETAILS
ADD CONSTRAINT PK_AUDIT_DETAILS PRIMARY KEY (NUM_DETAIL);

ALTER TABLE AUDIT_ERRORS
ADD CONSTRAINT PK_AUDIT_ERRORS PRIMARY KEY (NUM_ERROR);

ALTER TABLE AUDIT_DETAILS
ADD CONSTRAINT FK_AUDIT_DETAILS_NT
FOREIGN KEY (NUM_TRANSFER)
REFERENCES AUDIT_TRACE(NUM_TRANSFER);

ALTER TABLE AUDIT_ERRORS
ADD CONSTRAINT FK_AUDIT_ERRORS_NT
FOREIGN KEY (NUM_TRANSFER)
REFERENCES AUDIT_TRACE(NUM_TRANSFER);