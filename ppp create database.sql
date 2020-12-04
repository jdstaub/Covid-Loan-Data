-- PPP and EIDL analysis

-- Importing data from csv files downloaded from the SBA website
-- https://sba.app.box.com/s/5myd1nxutoq8wxecx2562baruz774si6/folder/127200074608
DROP DATABASE IF EXISTS covid_loans;
CREATE DATABASE covid_loans;
SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

-- make table with column names and data types to import data into
CREATE TABLE covid_loans.ppp (
	loan_amount DECIMAL(10,2) DEFAULT NULL,
    business_name VARCHAR(60) DEFAULT NULL,
    address VARCHAR(100) DEFAULT NULL,
    city VARCHAR(40) DEFAULT NULL,
    state VARCHAR(2) DEFAULT NULL,
    zip VARCHAR(5) DEFAULT NULL,
    naics_code VARCHAR(6) DEFAULT NULL,
    business_type VARCHAR(40) DEFAULT NULL,
    race_ethnicity VARCHAR(40) DEFAULT NULL,
    gender VARCHAR(20) DEFAULT NULL,
    veteran VARCHAR(20) DEFAULT NULL,
    non_profit VARCHAR(1) DEFAULT NULL,
    jobs_reported VARCHAR(4) DEFAULT NULL,
    date_approved VARCHAR(10) DEFAULT NULL,
    lender VARCHAR(80) DEFAULT NULL,
    congressional_district VARCHAR(5) DEFAULT NULL);

-- bulk import files

ALTER TABLE covid_loans.ppp DISABLE KEYS;
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET autocommit=0;

-- file 01
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/01 PPP sub 150k through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
COMMIT;

-- file 02
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/02 PPP sub 150k through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
COMMIT;

-- file 03
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/03 PPP sub 150k through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
COMMIT;

-- file 04
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/04 PPP sub 150k through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
COMMIT;

-- file 05
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/05 PPP sub 150k through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
COMMIT;

-- file 06 (loans > 150k)
LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/150k plus PPP through 112420.csv'
INTO TABLE covid_loans.ppp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
SET autocommit=1;


-- create table to match NAICS codes to name of industry
-- data from https://apifriends.com/api-streaming/json-csv-files-naics-codes/
CREATE TABLE naics_codes (
	naics_code VARCHAR(6) DEFAULT NULL,
    naics_name VARCHAR(150) DEFAULT NULL);

LOAD DATA INFILE 
	'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/naics-codes.csv'
INTO TABLE covid_loans.naics_codes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

INSERT INTO naics_codes
	VALUES (NULL,NULL);