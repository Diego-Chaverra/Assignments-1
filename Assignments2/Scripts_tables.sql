
CREATE TABLE drivers (
    driver_id number not null,
    employee_number number(15) not null,
    fullname varchar(255) not null,
	CONSTRAINT drivers_pk PRIMARY KEY (driver_id)
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE drivers_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER drivers_tggr
BEFORE INSERT ON drivers
FOR EACH ROW
BEGIN
  SELECT drivers_seq.NEXTVAL 
  INTO :new.driver_id
  FROM dual;
END;

/

CREATE TABLE types_of_vehicles (
    type_of_vehicle_id number not null,
    description varchar(100) not null,
	special_qualification varchar(1) not null,
	CONSTRAINT types_of_vehicles_pk PRIMARY KEY (type_of_vehicle_id),
	CONSTRAINT special_qualification_ck CHECK (special_qualification in ('S', 'N'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE types_of_vehicles_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER types_of_vehicles_tggr
BEFORE INSERT ON types_of_vehicles
FOR EACH ROW
BEGIN
  SELECT types_of_vehicles_seq.NEXTVAL 
  INTO :new.type_of_vehicle_id
  FROM dual;
END;

/

CREATE TABLE vehicles (
    vehicle_id number not null,
    registration_number number(30) not null,
    plate varchar(6) not null,
	status varchar(30) not null,
	mileage number not null,
	model number not null,
	current_value number,
	replacement_value number,
	taxed_date date,
	bought_date date,
	actual_policy_number number,
	written_off varchar(1) not null,
	type_of_vehicle_id number not null,
	CONSTRAINT vehicles_pk PRIMARY KEY (vehicle_id),
	CONSTRAINT vehicle_type_fk FOREIGN KEY (type_of_vehicle_id) references types_of_vehicles(type_of_vehicle_id),
	CONSTRAINT status_vehicle_ck CHECK (status in ('Active', 'Inactive', 'Repairing', 'Sold')),
	CONSTRAINT written_off_ck CHECK (written_off in ('S', 'N'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE vehicles_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER vehicles_tggr
BEFORE INSERT ON vehicles
FOR EACH ROW
BEGIN
  SELECT vehicles_seq.NEXTVAL 
  INTO :new.vehicle_id
  FROM dual;
END;

/

CREATE TABLE vehicles_per_drivers (
    driver_id number not null,
    vehicle_id number not null,
	CONSTRAINT vehicles_per_drivers_pk PRIMARY KEY (driver_id, vehicle_id),
	CONSTRAINT veh_per_dri_driver_fk FOREIGN KEY (driver_id) references vehicles(vehicle_id),
	CONSTRAINT veh_per_dri_vehicle_fk FOREIGN KEY (vehicle_id) references drivers(driver_id)
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE TABLE drivers_qualifications (
    driver_id number not null,
    type_of_vehicle number not null,
	status varchar(30) not null,
	assignment_date date not null,
	CONSTRAINT drivers_qualifications_pk PRIMARY KEY (driver_id, type_of_vehicle),
	CONSTRAINT qualification_driver_fk FOREIGN KEY (driver_id) references drivers(driver_id),
	CONSTRAINT qualification_type_veh_fk FOREIGN KEY (type_of_vehicle) references types_of_vehicles(type_of_vehicle_id),
	CONSTRAINT status_qualification_ck CHECK (status in ('Active', 'Inactive', 'Expired', 'Disqualified'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE TABLE repair_costs (
    repair_id number not null,
    vehicle_id number not null,
	repair_date date not null,
	description varchar(500),
	amount NUMBER(19,4) not null,
	status varchar(30) not null,	
	CONSTRAINT repair_costs_pk PRIMARY KEY (repair_id),
	CONSTRAINT repair_vehicle_fk FOREIGN KEY (vehicle_id) references vehicles(vehicle_id),
	CONSTRAINT repair_status_ck CHECK (status in ('Pending', 'Paid'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE repair_costs_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER repair_costs_tggr
BEFORE INSERT ON repair_costs
FOR EACH ROW
BEGIN
  SELECT repair_costs_seq.NEXTVAL 
  INTO :new.repair_id
  FROM dual;
END;

/

CREATE TABLE insurance_claims (
    insurance_id number not null,
    vehicle_id number not null,
	policy_number number not null,
	loss_date date not null,
	date_of_issue date not null,
	nature_of_payment varchar(100),
	damages varchar(500),
	CONSTRAINT insurance_id_pk PRIMARY KEY (insurance_id),
	CONSTRAINT insurence_vehicle_fk FOREIGN KEY (vehicle_id) references vehicles(vehicle_id)
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE insurance_claims_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER insurance_claims_tggr
BEFORE INSERT ON insurance_claims
FOR EACH ROW
BEGIN
  SELECT insurance_claims_seq.NEXTVAL 
  INTO :new.insurance_id
  FROM dual;
END;

/

CREATE TABLE services (
    service_id number not null,
    vehicle_id number not null,
	name varchar(100) not null,
	issue_date date not null,
	description varchar(100),
	status varchar(30) not null,	
	CONSTRAINT service_id_pk PRIMARY KEY (service_id),
	CONSTRAINT service_vehicle_fk FOREIGN KEY (vehicle_id) references vehicles(vehicle_id),
	CONSTRAINT service_status_ck CHECK (status in ('Pending', 'Scheduled', 'Ok'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE services_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER services_tggr
BEFORE INSERT ON services
FOR EACH ROW
BEGIN
  SELECT services_seq.NEXTVAL 
  INTO :new.service_id
  FROM dual;
END;

/

CREATE TABLE types_of_service (
    type_of_service_id number not null,
    description varchar(100) not null,
	CONSTRAINT types_of_service_pk PRIMARY KEY (type_of_service_id)
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE types_of_service_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER types_of_service_tggr
BEFORE INSERT ON types_of_service
FOR EACH ROW
BEGIN
  SELECT types_of_service_seq.NEXTVAL 
  INTO :new.type_of_service_id
  FROM dual;
END;

/

CREATE TABLE service_details (
    service_detail_id number not null,
    service_id number not null,
	type_of_service number not null,
	status varchar(30) not null,	
	CONSTRAINT service_details_id_pk PRIMARY KEY (service_detail_id),
	CONSTRAINT service_id_fk FOREIGN KEY (service_id) references services(service_id),
	CONSTRAINT type_of_service_id_fk FOREIGN KEY (type_of_service) references types_of_service(type_of_service_id),
	CONSTRAINT service_details_status_ck CHECK (status in ('Ok', 'Pending', 'Needs Repair', 'Observations'))
)
TABLESPACE VEHICLES_FLEET
;

/

CREATE SEQUENCE service_details_seq
  START WITH 1
  INCREMENT BY 1;
  
/

CREATE OR REPLACE TRIGGER service_details_tggr
BEFORE INSERT ON service_details
FOR EACH ROW
BEGIN
  SELECT service_details_seq.NEXTVAL 
  INTO :new.service_detail_id
  FROM dual;
END;

/

-- INSERT  DRIVERS

INSERT INTO drivers (employee_number,fullname) VALUES ('1693112991099','Quentin Dean');
INSERT INTO drivers (employee_number,fullname) VALUES ('1681030365799','Conan Dennis');
INSERT INTO drivers (employee_number,fullname) VALUES ('1621090318199','Neil Rose');
INSERT INTO drivers (employee_number,fullname) VALUES ('1699112383399','Keegan Mcmahon');
INSERT INTO drivers (employee_number,fullname) VALUES ('1617112348799','Thane Bradley');
INSERT INTO drivers (employee_number,fullname) VALUES ('1698111527799','Berk Long');
INSERT INTO drivers (employee_number,fullname) VALUES ('1639022818499','Todd Young');
INSERT INTO drivers (employee_number,fullname) VALUES ('1694052074899','Sawyer Gutierrez');
INSERT INTO drivers (employee_number,fullname) VALUES ('1660022463999','Chandler Cox');
INSERT INTO drivers (employee_number,fullname) VALUES ('1695033072899','Martin Burke');
INSERT INTO drivers (employee_number,fullname) VALUES ('1608023068799','Duncan Garrison');
INSERT INTO drivers (employee_number,fullname) VALUES ('1682102675199','Geoffrey Silva');
INSERT INTO drivers (employee_number,fullname) VALUES ('1652060265299','Phillip Miranda');
INSERT INTO drivers (employee_number,fullname) VALUES ('1668022346999','Allistair Vega');
INSERT INTO drivers (employee_number,fullname) VALUES ('1699042616099','Laith Cochran');
INSERT INTO drivers (employee_number,fullname) VALUES ('1600111269699','Upton Peck');
INSERT INTO drivers (employee_number,fullname) VALUES ('1610070502099','Brian Byrd');
INSERT INTO drivers (employee_number,fullname) VALUES ('1636052121899','Rafael Craig');
INSERT INTO drivers (employee_number,fullname) VALUES ('1654101297999','Dennis Estrada');
INSERT INTO drivers (employee_number,fullname) VALUES ('1631120293999','Carl Callahan');
INSERT INTO drivers (employee_number,fullname) VALUES ('1657040721299','Nathaniel Bright');
INSERT INTO drivers (employee_number,fullname) VALUES ('1659111450499','Omar Leon');
INSERT INTO drivers (employee_number,fullname) VALUES ('1607032342599','Orlando West');
INSERT INTO drivers (employee_number,fullname) VALUES ('1668040161999','Vaughan Powell');
INSERT INTO drivers (employee_number,fullname) VALUES ('1634031754599','Aristotle Gutierrez');
INSERT INTO drivers (employee_number,fullname) VALUES ('1644101677199','Zeph Rivas');
INSERT INTO drivers (employee_number,fullname) VALUES ('1647121719299','Christopher Mckee');
INSERT INTO drivers (employee_number,fullname) VALUES ('1674121948599','Keane Wise');
INSERT INTO drivers (employee_number,fullname) VALUES ('1677011190399','Seth Chen');
INSERT INTO drivers (employee_number,fullname) VALUES ('1677050185299','Calvin Albert');
INSERT INTO drivers (employee_number,fullname) VALUES ('1684031467199','Richard Wiley');
INSERT INTO drivers (employee_number,fullname) VALUES ('1640051322199','Abel Love');
INSERT INTO drivers (employee_number,fullname) VALUES ('1690072649599','Bradley Oliver');
INSERT INTO drivers (employee_number,fullname) VALUES ('1643071257299','Josiah Grimes');
INSERT INTO drivers (employee_number,fullname) VALUES ('1627012684299','Forrest Carney');
INSERT INTO drivers (employee_number,fullname) VALUES ('1631072552299','Cooper Abbott');
INSERT INTO drivers (employee_number,fullname) VALUES ('1661032999699','Isaiah Velasquez');
INSERT INTO drivers (employee_number,fullname) VALUES ('1698072001599','Rudyard Nieves');
INSERT INTO drivers (employee_number,fullname) VALUES ('1683010930799','Zane Acosta');
INSERT INTO drivers (employee_number,fullname) VALUES ('1643111764399','Chadwick Higgins');
INSERT INTO drivers (employee_number,fullname) VALUES ('1638022320899','Driscoll Villarreal');
INSERT INTO drivers (employee_number,fullname) VALUES ('1627010703099','Dolan Pacheco');
INSERT INTO drivers (employee_number,fullname) VALUES ('1665010849899','Scott Bartlett');
INSERT INTO drivers (employee_number,fullname) VALUES ('1662112127099','Lyle Francis');
INSERT INTO drivers (employee_number,fullname) VALUES ('1685092698099','Caleb Cobb');
INSERT INTO drivers (employee_number,fullname) VALUES ('1618052167399','Rahim Morrow');
INSERT INTO drivers (employee_number,fullname) VALUES ('1642023034599','Brandon Patel');
INSERT INTO drivers (employee_number,fullname) VALUES ('1600010679999','Rafael Cox');
INSERT INTO drivers (employee_number,fullname) VALUES ('1627082905999','Craig Dunlap');
INSERT INTO drivers (employee_number,fullname) VALUES ('1641100153999','Jonas Mccray');
INSERT INTO drivers (employee_number,fullname) VALUES ('1649012570899','Lucian Hudson');
INSERT INTO drivers (employee_number,fullname) VALUES ('1675010143799','Stone Sullivan');
INSERT INTO drivers (employee_number,fullname) VALUES ('1679110972599','Cairo Booker');
INSERT INTO drivers (employee_number,fullname) VALUES ('1619120135399','Boris Nash');
INSERT INTO drivers (employee_number,fullname) VALUES ('1676070848799','Nasim Burton');
INSERT INTO drivers (employee_number,fullname) VALUES ('1674060205299','Colton Crawford');
INSERT INTO drivers (employee_number,fullname) VALUES ('1638020151299','Silas Dominguez');
INSERT INTO drivers (employee_number,fullname) VALUES ('1670060404599','Chancellor Richards');
INSERT INTO drivers (employee_number,fullname) VALUES ('1669071038499','Zane Hendrix');
INSERT INTO drivers (employee_number,fullname) VALUES ('1626051005099','Drake Dalton');
INSERT INTO drivers (employee_number,fullname) VALUES ('1626092749599','Lucius Pitts');
INSERT INTO drivers (employee_number,fullname) VALUES ('1600112484799','Dexter Coffey');
INSERT INTO drivers (employee_number,fullname) VALUES ('1607021008299','Jelani Davis');
INSERT INTO drivers (employee_number,fullname) VALUES ('1689112009999','Rahim Vazquez');
INSERT INTO drivers (employee_number,fullname) VALUES ('1693071487099','Emmanuel Montgomery');
INSERT INTO drivers (employee_number,fullname) VALUES ('1620052393099','Hayden Whitfield');
INSERT INTO drivers (employee_number,fullname) VALUES ('1639080499199','Lamar Garrett');
INSERT INTO drivers (employee_number,fullname) VALUES ('1634022085399','Donovan Frye');
INSERT INTO drivers (employee_number,fullname) VALUES ('1607112165999','Plato Tillman');
INSERT INTO drivers (employee_number,fullname) VALUES ('1697081404699','Chadwick Delgado');
INSERT INTO drivers (employee_number,fullname) VALUES ('1668023004699','Joel Cohen');
INSERT INTO drivers (employee_number,fullname) VALUES ('1618060603699','Cade Robertson');
INSERT INTO drivers (employee_number,fullname) VALUES ('1665122283799','Laith Dalton');
INSERT INTO drivers (employee_number,fullname) VALUES ('1623041206699','Axel Ryan');
INSERT INTO drivers (employee_number,fullname) VALUES ('1616050182099','Jesse Short');
INSERT INTO drivers (employee_number,fullname) VALUES ('1634032239999','Abbot Sanford');
INSERT INTO drivers (employee_number,fullname) VALUES ('1669092452299','Xander Palmer');
INSERT INTO drivers (employee_number,fullname) VALUES ('1669110812299','Garrett Estrada');
INSERT INTO drivers (employee_number,fullname) VALUES ('1662012850899','Brandon Burnett');
INSERT INTO drivers (employee_number,fullname) VALUES ('1603111351299','Barclay Adkins');
INSERT INTO drivers (employee_number,fullname) VALUES ('1626030899099','Lawrence Daniels');
INSERT INTO drivers (employee_number,fullname) VALUES ('1614062730299','Berk Sims');
INSERT INTO drivers (employee_number,fullname) VALUES ('1646071944799','Aquila Hill');
INSERT INTO drivers (employee_number,fullname) VALUES ('1694011495399','Colton Bush');
INSERT INTO drivers (employee_number,fullname) VALUES ('1629070870399','Anthony Palmer');
INSERT INTO drivers (employee_number,fullname) VALUES ('1639062859199','Martin Gibbs');
INSERT INTO drivers (employee_number,fullname) VALUES ('1631102809599','Nathaniel West');
INSERT INTO drivers (employee_number,fullname) VALUES ('1666121995399','Clark Maynard');
INSERT INTO drivers (employee_number,fullname) VALUES ('1631060101699','Trevor Casey');
INSERT INTO drivers (employee_number,fullname) VALUES ('1696012067699','Hop Reilly');
INSERT INTO drivers (employee_number,fullname) VALUES ('1627060110399','Kuame Fields');
INSERT INTO drivers (employee_number,fullname) VALUES ('1634092422499','Noble Ray');
INSERT INTO drivers (employee_number,fullname) VALUES ('1609072771499','Paul Winters');
INSERT INTO drivers (employee_number,fullname) VALUES ('1644080710399','Holmes Kemp');
INSERT INTO drivers (employee_number,fullname) VALUES ('1636050304099','Allistair Yang');
INSERT INTO drivers (employee_number,fullname) VALUES ('1627040672699','Cooper Mccarty');
INSERT INTO drivers (employee_number,fullname) VALUES ('1653080229999','Joel Stout');
INSERT INTO drivers (employee_number,fullname) VALUES ('1611032448499','Aquila Mcleod');
INSERT INTO drivers (employee_number,fullname) VALUES ('1658081360699','Elmo Black');
INSERT INTO drivers (employee_number,fullname) VALUES ('1623092514999','Kadeem Johnston');

-- INSERT types_of_vehicles

INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Moped','N');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Motorcycle','N');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Trike motorcycle','S');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Car','S');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Light rigid heavy vehicle','S');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Medium rigid heavy vehicle','S');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Heavy rigid vehicle','S');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Tractor','N');
INSERT INTO types_of_vehicles (description,special_qualification) VALUES ('Wheelchair vehicle','S');

-- INSERT vehicles

INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('4410512','ABC123','Active','2500','2010','1000000','1500000',sysdate,sysdate,'446655885','N','1');---------------------
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('32210512','ABC753','Active','4500','2014','4000000','900000',sysdate,sysdate,'446444885','N','2');		
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('5450512','ABC456','Active','7500','2014','3000000','800000',sysdate,sysdate,'410655885','N','3');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('45550512','ABC789','Inactive','8500','2011','2000000','700000',sysdate,sysdate,'776655885','N','4');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('5245454','ABC224','Sold','12500','2011','2002000','1000000',sysdate,sysdate,'886655885','N','5');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('445105412','XXX123','Active','2100','2011','3000000','400000',sysdate,sysdate,'446655445','N','6');		
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('45445352','YYY123','Active','500','2011','800000','600000',sysdate,sysdate,'444654775','S','7');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('665657','CSD123','Active','457','2011','400000','700000',sysdate,sysdate,'104255885','N','8');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('4557575','SSA123','Sold','665','2013','700000','800000',sysdate,sysdate,'201455885','N','9');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('56453345','FFF123','Active','5665','2014','1200000','1200000',sysdate,sysdate,'201755885','N','9');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('7757545','YTY123','Active','7588','2014','1200000','1300000',sysdate,sysdate,'201054485','N','8');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('787524124','GGG123','Active','7896','2014','1300000','1300000',sysdate,sysdate,'446654258','N','7');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('5875454','VVV123','Sold','1263','2015','1400000','1300000',sysdate,sysdate,'146654477','S','6');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('8642456','MMM128','Active','1200','2015','1500000','1400000',sysdate,sysdate,'246622825','N','5');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('5454242','QQQ128','Active','1474','2015','1600000','1400000',sysdate,sysdate,'336655335','N','4');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('2828282','TTT124','Active','1598','2017','1700000','1000000',sysdate,sysdate,'776657785','N','3');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('3363635','PPP188','Inactive','12450','2016','500000','1000000',sysdate,sysdate,'996655899','S','2');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('74542420','LLL127','Active','15000','2015','450000','1000000',sysdate,sysdate,'336655833','N','1');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('10444450','ASD124','Active','12555','2014','1200000','1300000',sysdate,sysdate,'386655838','N','1');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('45400004','LKL173','Active','17000','2013','1300000','1200000',sysdate,sysdate,'436655839','N','2');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('40404058','PKP153','Active','18050','2011','1400000','1100000',sysdate,sysdate,'446655400','S','3');
INSERT INTO vehicles (registration_number,plate,status,mileage,model,current_value,replacement_value,
	taxed_date,bought_date,actual_policy_number,written_off,type_of_vehicle_id) 
		VALUES ('7721400','IUI523','Active','14500','2012','1500000','4400000',sysdate,sysdate,'400655885','N','4');

-- INSERT types_of_service

INSERT INTO types_of_service (description) VALUES ('Automatic Transmission Fluid');
INSERT INTO types_of_service (description) VALUES ('Battery and Cables');
INSERT INTO types_of_service (description) VALUES ('Belts');
INSERT INTO types_of_service (description) VALUES ('Brakes');
INSERT INTO types_of_service (description) VALUES ('Cabin Air Filter');
INSERT INTO types_of_service (description) VALUES ('Chassis Lubrication');
INSERT INTO types_of_service (description) VALUES ('Dashboard Indicator Light On');
INSERT INTO types_of_service (description) VALUES ('Coolant (Antifreeze)');
INSERT INTO types_of_service (description) VALUES ('Engine Air Filter');
INSERT INTO types_of_service (description) VALUES ('Engine Oil');
INSERT INTO types_of_service (description) VALUES ('Exhaust');
INSERT INTO types_of_service (description) VALUES ('Hoses');
INSERT INTO types_of_service (description) VALUES ('Lights');
INSERT INTO types_of_service (description) VALUES ('Power Steering Fluid');
INSERT INTO types_of_service (description) VALUES ('Steering and Suspension');
INSERT INTO types_of_service (description) VALUES ('Tire Inflation and Condition');
INSERT INTO types_of_service (description) VALUES ('Wheel Alignment');
INSERT INTO types_of_service (description) VALUES ('Windshield Washer Fluid');
INSERT INTO types_of_service (description) VALUES ('Wiper Blades');

-- INSERT insurance_claims

INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('1','444777',sysdate,sysdate,'Credit card','Stop, wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('2','444778',sysdate,sysdate,'Credit card','Stop, wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('3','444454',sysdate,sysdate,'Credit card','Wheels and paint');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('1','444585',sysdate,sysdate,'Credit card','Wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('1','444969',sysdate,sysdate,'Credit card','Stop');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('4','444869',sysdate,sysdate,'Credit card','Stop, wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('15','444125',sysdate,sysdate,'Credit card','Stop, wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('17','444000',sysdate,sysdate,'Credit card','Lights');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('20','444010',sysdate,sysdate,'Credit card','Stop, wheels');
INSERT INTO insurance_claims (vehicle_id,policy_number,loss_date,date_of_issue,nature_of_payment,damages) 
	VALUES ('3','444104',sysdate,sysdate,'Credit card','Paint');
	
-- INSERT repair_costs

INSERT INTO repair_costs (vehicle_id,repair_date,description,amount,status) 
	VALUES ('1',sysdate,'Working on it','15000','Paid');
INSERT INTO repair_costs (vehicle_id,repair_date,description,amount,status) 
	VALUES ('2',sysdate,'Working on it','17000','Pending');
INSERT INTO repair_costs (vehicle_id,repair_date,description,amount,status) 
	VALUES ('2',sysdate,'Working on it','10000','Paid');
INSERT INTO repair_costs (vehicle_id,repair_date,description,amount,status) 
	VALUES ('15',sysdate,'Working on it','15500','Pending');

-- INSERT services

INSERT INTO services (vehicle_id,name,issue_date,description,status) 
	VALUES ('3','Mandatory 9000_service service; current mileage 9123',sysdate,'','Pending');
INSERT INTO services (vehicle_id,name,issue_date,description,status) 
	VALUES ('20','Mandatory 3000_service service; current mileage 3500',sysdate,'','Pending');
INSERT INTO services (vehicle_id,name,issue_date,description,status) 
	VALUES ('17','Mandatory 3000_service service; current mileage 3804',sysdate,'','Ok');
INSERT INTO services (vehicle_id,name,issue_date,description,status) 
	VALUES ('2','Mandatory 6000_service service; current mileage 7588',sysdate,'','Scheduled');
INSERT INTO services (vehicle_id,name,issue_date,description,status) 
	VALUES ('10','Mandatory 3000_service service; current mileage 3250',sysdate,'','Scheduled');

-- INSERT service_details

INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('1','1','Pending');
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('1','4','Observations');

INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('2','4','Needs Repair');
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('2','3','Needs Repair');

INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('3','9','Needs Repair');
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('3','5','Observations');
	
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('4','2','Ok');
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('4','8','Pending');
	
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('5','2','Ok');
INSERT INTO service_details (service_id,type_of_service,status) 
	VALUES ('5','4','Pending');