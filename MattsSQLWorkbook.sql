/*Selects all records from the Employee table*/
SELECT * from Employee;

/*Selects all Employees with the last name of King */
SELECT * FROM Employee WHERE LASTNAME = 'King';

/*Selects all employees with the first name Andrew who don't report to anybody */
SELECT * FROM Employee WHERE FIRSTNAME = 'Andrew' AND REPORTSTO = NULL;

/*Selects all albums and places them in descending order based on title*/
SELECT * FROM Album ORDER BY Title DESC;

/*Displays the first name of customers ordered in ascending order by city */
SELECT FirstName FROM Customer  ORDER BY City;

/* Inserts two new genres*/
INSERT INTO Genre (GenreId, Name) VALUES (26, 'Power Violence');
INSERT INTO Genre (GenreId, Name) VALUES (27, 'Bluegrass');

/* Inserts two new employees*/
INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL) VALUES ('9', 'Adams', 'Morgan,', 'Nepotistic Hire', '1', '13-MAR-90', '15-AUG-05', '11120 Jasper Ave NW', 'NYC', 'NY', 'USA', '55555', '612-555-5555', '612-555-5551', 'BossesDaughter@gmail.com');
INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL) VALUES ('10', 'Castle', 'Frank,', 'The Punisher', '1', '1-FEB-74', '15-AUG-05', 'None of your business', 'NYC', 'NY', 'USA', '55555', '612-505-5555', '612-555-5552', 'IMissMyFamily@gmail.com' );

/* Inserts two new Customers*/
INSERT INTO Customer (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL, SUPPORTREPID) VALUES ('60', 'Bill', 'Billton', 'Walmart', '6969 Cool Street', 'Phoenix', 'AZ', 'USA', '67676', '321-321-3211', '312-258-3595', 'BillyB@gmail.com', '3');
INSERT INTO Customer (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL, SUPPORTREPID) VALUES ('61', 'Mandy', 'Billton', 'Walmart', '6969 Cool Street', 'Phoenix', 'AZ', 'USA', '67676', '321-321-3212', '312-258-3596', 'MandyB@gmail.com', '3');

/*updates Aaron Mitchell to Robert Walter*/
UPDATE Customer SET FIRSTNAME = 'Robert', LASTNAME = 'Walter' WHERE FIRSTNAME = 'Aaron' AND LASTNAME = 'Mitchell';

/*updates Creedence Clearwater Revival to CCR*/
UPDATE Artist SET NAME = 'CCR' WHERE NAME = 'Creedence Clearwater Revival';

/*Finds all addresses that start with the letter T*/
SELECT * FROM Invoice WHERE BillingAddress LIKE 'T%';

/*Returns all invoices with a total in between 15 and 50*/
SELECT * FROM Invoice WHERE Total BETWEEN '15' AND '50';

/*Returns all employees hired between the first of June 2003 and the first of March 2004*/
SELECT * FROM Employee WHERE HIREDATE BETWEEN '01-JUN-03' AND '01-MAR-04';

/*Deletes Robert Walter by first deleting the invoices and invoicelines tied to him*/
DELETE FROM Invoiceline WHERE INVOICEID = '50' OR INVOICEID = '61' OR INVOICEID = '116' OR INVOICEID = '245' OR INVOICEID = '268' OR INVOICEID = '290' OR INVOICEID = '342';
DELETE FROM Invoice WHERE CUSTOMERID = '32';
DELETE FROM Customer WHERE FIRSTNAME = 'Robert' AND LASTNAME = 'Walter';

/*Creates and runs a function to return the current time*/
CREATE OR REPLACE FUNCTION getTheTime 
RETURN VARCHAR2 AS z VARCHAR2(120);
BEGIN
    RETURN CURRENT_TIMESTAMP;
END;
/
DECLARE
    theTime VARCHAR2(120);
BEGIN
    theTime := getTheTime;
    DBMS_OUTPUT.PUT_LINE(theTime);
END;
/

/*Creates and executes a function that finds and returns the length of a mediatype*/
CREATE OR REPLACE FUNCTION getMediaLength(mediaTypeIdentity NUMBER)
RETURN NUMBER AS 
    holderLength NUMBER := '0'; 
    thisLength VARCHAR2(25);
BEGIN 
    SELECT NAME INTO thisLength FROM MediaType WHERE MEDIATYPEID = mediaTypeIdentity;
    SELECT LENGTH(thisLength) INTO holderLength FROM dual;
    RETURN holderLength;
END;
/

DECLARE 
myLength NUMBER;
BEGIN
    myLength := getMediaLength(1);
    DBMS_OUTPUT.PUT_LINE(myLength);
END;
/

/*Creates and executes a function that returns the average total of all invoices*/
CREATE OR REPLACE FUNCTION invoiceAverage
RETURN NUMBER AS
yourAverage NUMBER := 0;
BEGIN
SELECT AVG(TOTAL) INTO yourAverage FROM INVOICE;
RETURN yourAverage;
END;
/

DECLARE 
myAvg NUMBER;
BEGIN
    myAvg := invoiceAverage();
    DBMS_OUTPUT.PUT_LINE(myAvg);
END;
/

/*Creates and executes a function that returns the trackId of the most expensive track*/
CREATE OR REPLACE FUNCTION mostExpensiveTrax
RETURN NUMBER
AS
highestPrice NUMBER; 
currentPrice NUMBER;
outputtt NUMBER := 0;
counterr NUMBER := 1;
BEGIN
SELECT MAX(UNITPRICE) INTO highestPrice FROM TRACK;
LOOP
    EXIT WHEN(outputtt != 0);
    SELECT UNITPRICE INTO currentPrice FROM TRACK WHERE (TRACKID = counterr);
    IF (currentPrice = highestPrice) THEN
        outputtt := counterr;
    ELSE
        counterr := counterr + 1;
    END IF;
END LOOP;
RETURN outputtt;
END;
/
DECLARE 
theMostExpensiveTraxID NUMBER;
BEGIN
    theMostExpensiveTraxID := mostExpensiveTrax();
    DBMS_OUTPUT.PUT_LINE(theMostExpensiveTraxID);
END;
/

/*Creates and executes a function that returns the average price of invoiceline items*/
CREATE OR REPLACE FUNCTION invoiceLinePricesss
RETURN NUMBER
AS
theAverage NUMBER;
BEGIN
    SELECT AVG(UNITPRICE) INTO theAverage FROM INVOICELINE;
    RETURN theAverage;
END;
/

DECLARE 
thisAvg NUMBER;
BEGIN
    thisAvg := invoiceLinePricesss();
    DBMS_OUTPUT.PUT_LINE(thisAvg);
END;
/

/*Creates and executes a function that returns all employees born after 1968*/
CREATE OR REPLACE FUNCTION yungEmployeez
RETURN NUMBER
AS
BEGIN
   SELECT * FROM Employee WHERE BIRTHDATE BETWEEN '01-JAN-69' AND '20-DEC-17';
   RETURN 1;
END;
/
BEGIN
    yungEmployeez();
END;
/

/*Creates and executes a stored procedure that selects the first and last name of all employees*/
CREATE OR REPLACE PROCEDURE furstAndLast
AS 
BEGIN 
  SELECT FIRSTNAME, LASTNAME FROM EMPLOYEE; 
END furstAndLast; 
/
BEGIN 
   furstAndLast; 
END; 
/

/*7.1*/
SELECT CUSTOMER.FIRSTNAME, CUSTOMER.LASTNAME FROM CUSTOMER
INNER JOIN INVOICE ON CUSTOMER.CUSTOMERID = INVOICE.CUSTOMERID;

/*7.2*/
SELECT CUSTOMER.FIRSTNAME, CUSTOMER.LASTNAME, INVOICE.INVOICEID, INVOICE.TOTAL FROM CUSTOMER
LEFT JOIN INVOICE ON CUSTOMER.CUSTOMERID = INVOICE.CUSTOMERID;

/*7.3 */
SELECT ARTIST.NAME, ALBUM.TITLE FROM ALBUM
RIGHT JOIN ARTIST ON ALBUM.ARTISTID = ARTIST.ARTISTID;

/*7.4*/
SELECT * FROM ALBUM 
CROSS JOIN ARTIST ORDER BY ARTIST.NAME;

/*7.5*/
SELECT * FROM EMPLOYEE.REPORTSTO, EMPLOYEE.REPORTSTO;