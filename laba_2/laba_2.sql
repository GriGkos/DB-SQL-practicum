DROP TABLE IF EXISTS Car_types CASCADE;
CREATE TABLE Car_types
(
  car_type_id INT NOT NULL,
  car_type_name VARCHAR(30),
  max_weight INT,
  PRIMARY KEY(car_type_id),
  UNIQUE(car_type_id)
);

DROP TABLE IF EXISTS Stations CASCADE;
CREATE TABLE Stations
(
  station_id CHAR(6) NOT NULL UNIQUE, 
  station_name VARCHAR(60) NOT NULL,
  min_ INT NOT NULL CONSTRAINT min_check CHECK(min_>=0),
  max_ INT NOT NULL CONSTRAINT max_check CHECK (max_ >= min_),
  wait_cost INT,
  PRIMARY KEY(station_id)
);

DROP TABLE IF EXISTS Stations CASCADE;
CREATE TABLE Stations
(
  station_id CHAR(6) NOT NULL UNIQUE, 
  station_name VARCHAR(60) NOT NULL,
  min_ INT NOT NULL CONSTRAINT min_check CHECK(min_>=0),
  max_ INT NOT NULL CONSTRAINT max_check CHECK (max_ >= min_),
  wait_cost INT,
  PRIMARY KEY(station_id)
);


DROP TABLE IF EXISTS Dislocations CASCADE;
CREATE TABLE Dislocations
(
  id INT CONSTRAINT PRIMARY KEY,
  station_id CHAR(6) NOT NULL REFERENCES Stations (station_id),
  loaded_empty INT,
  cars_quantity INT NOT NULL CONSTRAINT cars_quantity_check CHECK (cars_quantity<100 AND cars_quantity >=0),
  car_type INT NOT NULL REFERENCES Car_types (car_type_id),
  period INT NOT NULL,
  wait_time VARCHAR (60) NOT NULL
);

DROP TABLE IF EXISTS Orders CASCADE;
CREATE TABLE Orders
(
  order_id INT NOT NULL PRIMARY KEY,
  station_from CHAR(6) NOT NULL REFERENCES Stations (station_id),
  station_to CHAR(6) NOT NULL REFERENCES Stations (station_id),
  revenue_per_car REAL,
  car_required INT NOT NULL,
  car_type INT NOT NULL REFERENCES Car_types (car_type_id),
  time_load_one_car REAL NOT NULL,
  time_unload_one_car REAL NOT NULL,
  must_do INT,
  CHECK (must_do = 0 OR must_do = 1 OR text(must_do) = '')
);


DROP TABLE IF EXISTS Routes CASCADE;
CREATE TABLE Routes
(
  route_id INT NOT NULL UNIQUE,
  station_from CHAR(6),
  station_to CHAR(6),
  avg_cost INT NOT NULL,
  PRIMARY KEY (route_id)--
);


DROP TABLE IF EXISTS Roads CASCADE;
CREATE TABLE Roads
(
  road_id INT NOT NULL PRIMARY KEY,
  name_road VARCHAR(60) NOT NULL
);

DROP TABLE IF EXISTS Departments CASCADE;
CREATE TABLE Departments
(
  department_id INT NOT NULL PRIMARY KEY,
  name_department VARCHAR(60) NOT NULL
);



DROP TABLE IF EXISTS Stations_Roads CASCADE;
CREATE TABLE Stations_Roads
(
  station_id CHAR(6) REFERENCES Stations(station_id),
  road_id INT REFERENCES Roads(road_id),
  PRIMARY KEY (road_id, station_id)
);

DROP TABLE IF EXISTS Stations_Departments CASCADE;
CREATE TABLE Stations_Departments
(
  station_id CHAR(6) NOT NULL REFERENCES Stations(station_id) ,
  department_id INT NOT NULL REFERENCES Departments(department_id),
  PRIMARY KEY (department_id, station_id)
);

DROP TABLE IF EXISTS Schedule CASCADE;
CREATE TABLE Schedule
(
  order_id INT NOT NULL REFERENCES Orders(order_id),
  period_ INT NOT NULL,
  sum_cars_quatity INT NOT NULL CONSTRAINT sum_cars_quatity_check CHECK(sum_cars_quatity>0),
  PRIMARY KEY(order_id, period_)
);

DROP TABLE IF EXISTS Persons CASCADE;
CREATE TABLE Persons
(
  surname VARCHAR(60) NOT NULL,
  first_name VARCHAR(60) NOT NULL,
  second_name VARCHAR(60),
  pass_id INT PRIMARY KEY,
  sex CHAR(1) NOT NULL CONSTRAINT sex_check CHECK(sex = 'м' or sex = 'ж'),
  submis INT,
  FOREIGN KEY(submis) REFERENCES Persons(pass_id)
);

DROP TABLE IF EXISTS Control_person CASCADE;
CREATE TABLE Control_person
(
  adress VARCHAR(60),
  pass_id INT NOT NULL,
  order_id INT NOT NULL,
  FOREIGN KEY (pass_id) REFERENCES Persons(pass_id),
  PRIMARY KEY(pass_id, order_id)
);

DROP TABLE IF EXISTS Repair_routes CASCADE;
CREATE TABLE Repair_routes
(
  route_id INT NOT NULL,
  price INT,
  id_person INT,
  start_period INT,
  FOREIGN KEY (route_id) REFERENCES Routes(route_id),
  PRIMARY KEY (route_id, price, id_person)
);


DROP TABLE IF EXISTS Control_person CASCADE;
CREATE TABLE Control_person
(
  born_data DATE,
  adress VARCHAR(60),
  pass_id INT NOT NULL,
  order_id INT NOT NULL,
  FOREIGN KEY (pass_id) REFERENCES Persons(pass_id),
  PRIMARY KEY(pass_id, order_id)
);

DROP TABLE IF EXISTS Repair_routes CASCADE;
CREATE TABLE Repair_routes
(
  route_id INT NOT NULL REFERENCES Routes(route_id),
  price INT,
  id_person INT,
  start_period INT
);

copy Car_types FROM 'C:\uxcheba\based\2ndlab\car_types.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Stations FROM 'C:\uxcheba\based\2ndlab\stations2.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Dislocations FROM 'C:\uxcheba\based\2ndlab\dislocations2.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Orders FROM 'C:\uxcheba\based\2ndlab\orders2.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Routes FROM 'C:\uxcheba\based\2ndlab\routes.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
UPDATE Routes SET station_from='000102' WHERE station_from = '0';
UPDATE Routes SET station_to='000206' WHERE station_to = '0';
ALTER TABLE Routes
   ADD CONSTRAINT FK_station_from FOREIGN KEY (station_from)
      REFERENCES Stations (station_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
;
ALTER TABLE Routes
   ADD CONSTRAINT FK_station_to FOREIGN KEY (station_to)
      REFERENCES Stations (station_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
;
copy Roads FROM 'C:\uxcheba\based\2ndlab\roads.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Departments FROM 'C:\uxcheba\based\2ndlab\departments.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Stations_Roads FROM 'C:\uxcheba\based\2ndlab\stations_roads.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Stations_Departments FROM 'C:\uxcheba\based\2ndlab\stations_departments2.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy schedule FROM 'C:\uxcheba\based\2ndlab\schedule.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy persons FROM 'C:\uxcheba\based\2ndlab\persons2.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;
copy Control_person FROM 'C:\uxcheba\based\2ndlab\control_persons.csv' DELIMITER ',' HEADER CSV;
copy Repair_routes FROM 'C:\uxcheba\based\2ndlab\repair_routes.csv' DELIMITER ';' HEADER ENCODING 'WIN1251' CSV;