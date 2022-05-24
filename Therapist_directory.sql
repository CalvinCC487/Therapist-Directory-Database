/*create table therapist_directory*/
CREATE TABLE  therapist_directory(
	ther_id  NUMBER(38) not null,
	first_name VARCHAR2(30),
	last_name VARCHAR2(30),
	gender VARCHAR2(10),
	license VARCHAR(5) CHECK(license IN ('MFT', 'PhD', 'MD')),
	phone_no NUMBER(8),
	CONSTRAINT ther_id_pk PRIMARY KEY(ther_id)
);

/*create table specialties*/
CREATE TABLE  specialties(
	specialties_id NUMBER(38) not null,
	ther_id NUMBER(38) not null,
	spec_name VARCHAR(100),
	FOREIGN KEY(ther_id) REFERENCES therapist_directory(ther_id),
	CONSTRAINT specialties_id_pk PRIMARY KEY(specialties_id)
);

/*create table location_state*/
CREATE TABLE  location_state(
	location VARCHAR(20),
	status CHAR(3) CHECK(status IN ('on', 'off')),
	CONSTRAINT location_state_pk PRIMARY KEY(location)
);

/*create table locations*/
CREATE TABLE  locations(
    hospital_name VARCHAR2(50),
    hospital_id VARCHAR2(50) not null,   
    location VARCHAR2(50),   
	CONSTRAINT location_pk PRIMARY KEY(hospital_id),
	CONSTRAINT location_fk FOREIGN KEY(location) REFERENCES location_state(location)
);

/*create table therapist_locations*/
CREATE TABLE  therapist_locations(
	hospital_id VARCHAR2(50) not null,
	ther_id number(38) not null,
	CONSTRAINT therapist_locations_pk PRIMARY KEY(hospital_id, ther_id),
	CONSTRAINT therapist_locations_fk_1 FOREIGN KEY(hospital_id) REFERENCES locations(hospital_id),
	CONSTRAINT therapist_locations_fk_2 FOREIGN KEY(ther_id) REFERENCES  therapist_directory(ther_id)
);


/*insert value into therapist_directory*/
INSERT INTO	 therapist_directory(ther_id, first_name, last_name, gender,  license, phone_no) VALUES (0,'Vivi', ' Chan', 'female',   'PhD', 27890000);
INSERT INTO	 therapist_directory(ther_id, first_name, last_name, gender,  license, phone_no) VALUES	(1,'Peter', 'Chan', 'male',   'MD', 34670000);
INSERT INTO	 therapist_directory(ther_id, first_name, last_name, gender,  license, phone_no) VALUES	(2,'Peter' ,'Cheung', 'male',   'MD', 38001155);
INSERT INTO	 therapist_directory(ther_id, first_name, last_name, gender, license, phone_no) VALUES	(3,'Dickson', 'Lee', 'male',   'MFT', 37647788);
INSERT INTO	 therapist_directory(ther_id, first_name, last_name, gender,  license, phone_no) VALUES	(4,'Vivian', 'Chan', 'female',   'MFT', 34798964);

/*insert value into specialties*/
INSERT INTO	 specialties( specialties_id, ther_id,  spec_name) VALUES	( 0, 0, 'Anxiety');
INSERT INTO	 specialties( specialties_id, ther_id,  spec_name) VALUES	(1, 1, 'PTSD');
INSERT INTO	 specialties( specialties_id, ther_id,  spec_name) VALUES	(2, 2, 'Bipolar');
INSERT INTO	 specialties( specialties_id, ther_id,  spec_name) VALUES	( 3, 3, 'Depression');
INSERT INTO	 specialties( specialties_id, ther_id,  spec_name) VALUES	( 4, 4, 'Depression');


/*insert value into locations*/
INSERT INTO  locations(hospital_id, hospital_name) VALUES (0,'Caritas Medical Centre');
INSERT INTO  locations(hospital_id, hospital_name) VALUES (1,' Kowloon Tong');
INSERT INTO  locations(hospital_id, hospital_name) VALUES (2,'Princess Margaret Hospital');
INSERT INTO  locations(hospital_id, hospital_name) VALUES (3,'Queen Elizabeth Hospital');
INSERT INTO  locations(hospital_id, hospital_name) VALUES (4,'Yan Chai Hospital');
	

/*insert value into location_state*/
INSERT INTO  location_state(location,  status) VALUES	( 'Cheung Sha Wan','on');
INSERT INTO  location_state(location,  status) VALUES	( 'Kwai Chung','off');
INSERT INTO  location_state(location,  status) VALUES	( 'Kowloon Tong','off');
INSERT INTO  location_state(location,  status) VALUES	( 'Yau Ma Tei','on');
INSERT INTO  location_state(location,  status) VALUES	( 'Tsuen Wan','on');



/*query with all SELECT, FROM, WHERE, GROUP BY, HAVING AND ORDER BY clauses on a table*/
SELECT ther_id, first_name, last_name
FROM therapist_directory
WHERE gender = 'male'
GROUP BY ther_id, first_name, last_name
HAVING COUNT(ther_id) <= 3
ORDER BY first_name;  
    
/*query that joins two tables*/	
SELECT therapist_directory.first_name, therapist_directory.last_name, specialties.spec_name
FROM therapist_directory
INNER JOIN specialties
ON therapist_directory.ther_id=specialties.ther_id;

/*query that uses a subquery*/
SELECT ther_id, first_name, last_name 
FROM  therapist_directory 
WHERE  first_name = ( SELECT  first_name  FROM  therapist_directory WHERE ther_id=0);

/*create or replace the GetTherapist procedure*/
CREATE OR REPLACE PROCEDURE GetTherapist
AS
therapist_id therapist_directory.ther_id%TYPE;
first_name therapist_directory.first_name%TYPE;
last_name therapist_directory.last_name%TYPE;
BEGIN
SELECT  ther_id,first_name,last_name  INTO therapist_id, first_name, last_name FROM therapist_directory WHERE ther_id=0;
 dbms_output.put_line(  'Therapist ID: ' ||therapist_id  );
 dbms_output.put_line(  'Therapist NAME: ' || first_name || ' ' || last_name );
END;
/

/*create or replace the countPhD function*/
CREATE OR REPLACE FUNCTION countPhD 
RETURN number IS
therapist_id therapist_directory.ther_id%TYPE;
BEGIN
SELECT  Count(ther_id)  INTO therapist_id FROM therapist_directory WHERE license='PhD';
RETURN therapist_id;
END countPhD;
/

/*create or replace the no_st_name_provide trigger*/
CREATE OR REPLACE TRIGGER no_st_name_provide
BEFORE
INSERT ON therapist_directory 
FOR EACH ROW
DECLARE
gender therapist_directory.gender%TYPE;
first_name therapist_directory.first_name%TYPE;
last_name therapist_directory.last_name%TYPE;

BEGIN
first_name := :new.first_name;
last_name := :new.last_name;
gender := :new.gender;
IF (first_name is null AND gender = 'male')
THEN       
first_name := 'Mr.';
dbms_output.put_line( first_name ||' ' || last_name || '  is added to the table therapist_directory');
END IF;

IF (first_name is null AND gender = 'female')
THEN       
first_name := 'Mrs.';
dbms_output.put_line( first_name ||' ' || last_name || '  is added to the table therapist_directory');
END IF;

END;
/





