SET ECHO ON;
--
SPOOL "C:\Users\Sergio\Documents\SchoolWork\COMP 2714\Asgnmnts\Asssn1_GITRepo\Asn1_LowensteinL_VillegasS.txt";
--
-- ---------------------------------------------------------
--  COMP 2714
--  SET 2D
--  Assignment Asn01
--  Villegas, Sergio    A00935797
--  Lowenstein, Luli    A00946133
--  email: jvillegas4@my.bcit.ca
--  email: llowenstein@my.bcit.ca
-- ---------------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';
--
--  Q1. Dropping all tables
DROP TABLE Booking;
DROP TABLE Guest;
DROP TABLE Room;
DROP TABLE Hotel;
DROP TABLE OldBooking;
--  Q2. Creating Hotel table.
CREATE TABLE Hotel
(hotelNo      CHAR(10)    NOT NULL
,hotelName    VARCHAR(30) NOT NULL
,city         VARCHAR(15) NOT NULL
,CONSTRAINT PKHotel PRIMARY KEY (hotelNo)
);
--  Q2. Creating Room table.
CREATE TABLE Room
(roomNo      CHAR(10)       NOT NULL
,hotelNo     CHAR(10)       NOT NULL
,type        VARCHAR(15)    NOT NULL
,price       DECIMAL(10)    NOT NULL
,CONSTRAINT chk_Type
            CHECK (type IN ('Single', 'Double', 'Family'))
,CONSTRAINT chk_Price
            CHECK (price BETWEEN 10 AND 100)
,CONSTRAINT chk_RoomNo
            CHECK (roomNo BETWEEN 1 AND 100)
,CONSTRAINT PKRoom PRIMARY KEY (roomNo, hotelNo)
,CONSTRAINT FKHotelNo FOREIGN KEY (hotelNo)
                      REFERENCES Hotel (hotelNo)
);
--  Q3. Creating Guest table.
CREATE TABLE Guest
(guestNo      CHAR(10)    NOT NULL
,guestName    VARCHAR(30) NOT NULL
,guestAddress VARCHAR(30) NOT NULL
,CONSTRAINT PKGuest PRIMARY KEY (guestNo)
);
--  Q3. Creating Booking table.
CREATE TABLE Booking
(hotelNo    CHAR(10)    NOT NULL
,guestNo    CHAR(10)    NOT NULL
,dateFrom   DATE        NOT NULL
,dateTo     VARCHAR(10) NOT NULL
,roomNo     CHAR(10)    NOT NULL
,CONSTRAINT PKBooking PRIMARY KEY (hotelNo, guestNo, dateFrom)
,CONSTRAINT FKBHotelNo FOREIGN KEY (hotelNo, roomNo)
                      REFERENCES Room (hotelNo, roomNo)
,CONSTRAINT FKGuestNo FOREIGN KEY (guestNo)
                      REFERENCES Guest (guestNo)
);
--  Q4. Inserting sample data into the Hotel table.
INSERT INTO Hotel
  VALUES ('H0001', 'The Villegas Inn', 'Bermuda');
INSERT INTO Hotel
  VALUES ('H0002', 'The Lowenstein Inn', 'Caracas');
INSERT INTO Hotel
  VALUES ('H0003', 'The Lam Motel', 'Bangkok');
INSERT INTO Hotel
  VALUES ('H0004', 'The NesvaderaHu Joint Hotel', 'Surrey');
--  Q4. Inserting sample data into the Room table.
INSERT INTO Room
  VALUES ('001', 'H0001', 'Single', 50);
INSERT INTO Room
  VALUES ('056', 'H0003', 'Double', 75);
INSERT INTO Room
  VALUES ('100', 'H0004', 'Family', 66);
INSERT INTO Room
  VALUES ('075', 'H0002', 'Double', 20);
--  Q4. Inserting sample data into the Guest table.
INSERT INTO Guest
  VALUES ('G001', 'Wilson Hu', '123 Hampton Pl');
INSERT INTO Guest
  VALUES ('G002', 'Angus Lam', '9.75 Platform');
INSERT INTO Guest
  VALUES ('G003', 'Luli Lowenstein', '654 Columbia Road');
INSERT INTO Guest
  VALUES ('G004', 'Yashar Nesvaderani', '666 Fail St');
--  Q4. Inserting sample data into the Booking table.
INSERT INTO Booking
  VALUES ('H0003', 'G002', TO_DATE('2016-08-08'), TO_DATE('2016-09-08'), '056');
INSERT INTO Booking
  VALUES ('H0001', 'G004', TO_DATE('2016-10-05'), TO_DATE('2016-10-20'), '001');
INSERT INTO Booking
  VALUES ('H0002', 'G003', TO_DATE('2017-01-03'), TO_DATE('2017-01-06'), '075');
INSERT INTO Booking
  VALUES ('H0004', 'G001', TO_DATE('2016-08-08'), TO_DATE('2016-09-10'), '100');
--
--  Displaying the tables and their durrent data.
SELECT *
    FROM Hotel;
--
SELECT *
    FROM Room;
--
SELECT *
    FROM Guest;
--
SELECT *
    FROM Booking;
--  Q5a. Dropping the check constraint for Room table.
ALTER TABLE Room
DROP CONSTRAINT chk_type;
--  Q5a. Modifying the check constraint for Room so it accepts 'Deluxe'.
ALTER TABLE Room
ADD CONSTRAINT chk_Type
  CHECK (type IN ('Deluxe', 'Single', 'Double', 'Family'));
--  Q5b. Adding a new column called Discount. Default 0, and must be between 0 and 30.
ALTER TABLE Room
  ADD discount  DECIMAL(5)  DEFAULT 0 NOT NULL;
ALTER TABLE Room
  ADD CONSTRAINT chk_Discount
  CHECK (discount BETWEEN 0 AND 30);
--  Q6a. Increasing the price of 'Double' rooms in a hotel of our choice by 15%.
UPDATE Room
SET price = price * 1.15
WHERE hotelNo = 'H0002'
  AND type = 'Double';
--  Q6b. Modifying the booking for a guest that arrived early.
UPDATE Booking
SET dateFrom = TO_DATE('2016-07-28'), dateTo = TO_DATE('2016-10-05')
WHERE guestNo = 'G001';
--  Q7a. Creating archive table for Booking table.
CREATE TABLE OldBooking
(hotelNo    CHAR(10)    NOT NULL
,guestNo    CHAR(10)    NOT NULL
,dateFrom   VARCHAR(10) NOT NULL
,dateTo     VARCHAR(10) NOT NULL
,roomNo     CHAR(10)    NOT NULL
,CONSTRAINT PKOldBooking PRIMARY KEY (hotelNo, guestNo, dateFrom, roomNo)
);
--  Q7b. Copying rows in Booking table with dates before 2017-01-01 to OldBooking table.
INSERT INTO OldBooking
SELECT * 
FROM Booking
WHERE dateTo < TO_DATE('2017-01-01');
--  Q7c. Deleting rows in Booking table that have dates before 2017-01-01.
DELETE FROM Booking
WHERE dateTo <= TO_DATE('2017-01-01');
--
--  Display all tables after all changes are made
SELECT *
    FROM Hotel;
--
SELECT *
    FROM Room;
--
SELECT *
    FROM Guest;
--
SELECT *
    FROM Booking;
--
SELECT *
    FROM OldBooking;
--
SPOOL OFF;
