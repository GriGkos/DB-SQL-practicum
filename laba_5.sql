/* ++
1) Создать и заполнить таблицу из следующих столбцов: 1)название станции (с пятью
гласными буквами); 2) название отделения (которое соответствует названию станции).
*/
DROP TABLE IF EXISTS stats_deps_names;
CREATE TABLE IF NOT EXISTS stats_deps_names
(
	station_name text,
	department_name text
);

-- ON
INSERT INTO stats_deps_names SELECT station_name, name_department
FROM stations_departments SD
JOIN stations S ON S.station_id = SD.station_id
JOIN departments D ON D.department_id = SD.department_id
WHERE station_name ~* '^([^аяуюоеёэиы]*[аяуюоеёэиы][^аяуюоеёэиы]*){5}$';

-- USING
INSERT INTO stats_deps_names SELECT station_name, name_department
FROM stations_departments SD
JOIN stations S USING(station_id)
JOIN departments D USING(department_id)
WHERE station_name ~* '^([^аяуюоеёэиы]*[аяуюоеёэиы][^аяуюоеёэиы]*){5}$';

SELECT * FROM stats_deps_names;


/* ++
2) Вывести следующую таблицу, состоящую из двух столбцов с названиями:
name_road_or_department и name_station. В первом столбце находятся названия всех дорог
и отделений, а во втором – названия соответствующих станции. На каждую дорогу и на
каждое отделение выводить по два (при наличии) названия станций.
*/
SELECT name_road_or_department, name_station, COUNT(*) OVER (PARTITION BY name_road_or_department) cnt FROM (
	SELECT name_department name_road_or_department, station_name name_station, 
	ROW_NUMBER() OVER (PARTITION BY name_department) row_cnt
	FROM stations S
	JOIN stations_departments SD ON S.station_id = SD.station_id
	JOIN departments D ON D.department_id = SD.department_id
	UNION 
	SELECT road_name name_road_or_department, station_name name_station,
	ROW_NUMBER() OVER (PARTITION BY road_name) row_cnt
	FROM stations S
	JOIN stations_roads SR ON S.station_id = SR.station_id
	JOIN roads R ON R.road_id = SR.road_id
	ORDER BY name_road_or_department
) sq WHERE row_cnt <= 2 ORDER BY cnt ASC;


/* ++
3) Вывести всевозможные пары станций и количество маршрутов для них, первая
станция – начало маршрута, вторая станция – конец маршрута. Столбцы при выводе
назвать: start_st, finish_st, num_routes.
*/
SELECT S1.station_name start_st, S2.station_name finish_st, COUNT(*) num_routes
FROM stations S1 CROSS JOIN stations S2
LEFT JOIN routes ON station_from = S1.station_id AND station_to = S2.station_id
GROUP BY S1.station_name, S2.station_name ORDER BY num_routes ASC;


/* ++
4) Вывести количество станций, сумму длин названий станций для каждого периода от
10 до 15 включительно либо отрицательного (объединение всех отрицательных). Вывод
отсортировать по убыванию суммы длин станций.
*/
SELECT -1 AS period, COUNT(*), SUM(LENGTH(station_name)) sum FROM schedule S
JOIN orders R ON S.order_id = R.order_id
JOIN stations ST ON R.station_from = ST.station_id OR R.station_to = ST.station_id
WHERE period < 0
UNION 
SELECT period, COUNT(*), SUM(LENGTH(station_name)) FROM schedule S
JOIN orders R ON S.order_id = R.order_id
JOIN stations ST ON R.station_from = ST.station_id OR R.station_to = ST.station_id
WHERE period BETWEEN 10 AND 15 GROUP BY period
ORDER BY sum DESC;


/* ++
5) Продемонстрировать известные типы JOIN для таблиц Stations и Dislocation
(предварительно добавить в таблицы кортежи (007777,Горки-1,0,600,600) и
(005555,337755,0,1,1,1,NULL) соответственно). Можно ли с помощью конкретного JOIN
проверить, есть ли станции без дислокации?
*/
INSERT INTO stations VALUES ('007777', 'Горки-1', 0, 600, 600) RETURNING *;
INSERT INTO dislocations VALUES (005555, '337755', false, 1, 1, 1, NULL) RETURNING *;

SELECT * FROM stations S
JOIN dislocations D ON S.station_id = D.station_id;

SELECT * FROM stations S
NATURAL JOIN dislocations D;

SELECT * FROM stations S
LEFT JOIN dislocations D ON S.station_id = D.station_id; 

SELECT * FROM stations S
RIGHT JOIN dislocations D ON S.station_id = D.station_id;  

SELECT * FROM stations S
FULL JOIN dislocations D ON S.station_id = D.station_id; 

SELECT * FROM stations S
CROSS JOIN dislocations D; 

SELECT * FROM stations S
LEFT JOIN dislocations D ON S.station_id = D.station_id
WHERE id IS NULL; 


/* ++
6) Создать таблицу Copy_stations (копию таблицы Stations) и удалить в ней строки так,
чтобы остались только те, где значения поля max уникальны.
*/
DROP TABLE IF EXISTS copy_stations CASCADE;
CREATE TABLE IF NOT EXISTS copy_stations AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY max) AS row_cnt FROM stations);

INSERT INTO stations(station_id, max) VALUES ('999666', NULL), ('989666', NULL);

DELETE FROM Copy_stations WHERE row_cnt > 1;
ALTER TABLE Copy_stations DROP row_cnt;

SELECT * FROM copy_stations ORDER BY max ASC;


/* +
7) Создать представление, где для каждой станции из таблицы Dislocation по
возможности выбираются по 5 маршрутов с наибольшей стоимостью на обязательные и
по 5 маршрутов с наименьшей стоимостью на необязательные заявки (станция
дислокации – станция отправления маршрута, станция отправления заявки – станция
назначения маршрута). Вывести ID расположения дислокации, имя станции, количество
отобранных маршрутов на обязательные заявки, количество отобранных маршрутов на
необязательные заявки и общее количество маршрутов для них.
*/
DROP VIEW IF EXISTS station_info CASCADE;
CREATE OR REPLACE VIEW station_info AS 
	SELECT disloc_id, station_name, must_do, order_id
	FROM (
		SELECT id disloc_id, station_name, must_do, order_id,
		ROW_NUMBER(*) OVER (PARTITION BY id, D.station_id, must_do ORDER BY (revenue_per_car * car_required) DESC) row_cnt
		FROM dislocations D
		JOIN stations S ON D.station_id = S.station_id
		LEFT JOIN orders O ON station_from = D.station_id
		WHERE must_do IS NOT NULL 
		AND (station_from, station_to) IN (SELECT DISTINCT station_from, station_to FROM routes)
	) sq WHERE row_cnt <= 5;

SELECT * FROM station_info ORDER BY station_name, must_do;

DROP VIEW IF EXISTS station_detailed_info;
CREATE OR REPLACE VIEW station_detailed_info AS
	SELECT *, (required_cnt+optional_cnt) total_cnt
	FROM (
		SELECT disloc_id, station_name, 
		CASE WHEN cnt1 IS NULL THEN 0 ELSE cnt1 END required_cnt,
		CASE WHEN cnt2 IS NULL THEN 0 ELSE cnt2 END optional_cnt
		FROM (
			SELECT disloc_id, station_name, COUNT(*) cnt1
			FROM station_info WHERE must_do = true
			GROUP BY disloc_id, station_name
		) sq1
		FULL JOIN (
			SELECT disloc_id, station_name, COUNT(*) cnt2
			FROM station_info WHERE must_do = false
			GROUP BY disloc_id, station_name
		) sq2 USING(disloc_id, station_name)
	) sq ORDER BY station_name;
	
SELECT * FROM station_detailed_info;


/* +
8) Выполнить проверку на наличие маршрутов для всех обязательных заявок: если будут
заявки без маршрутов, то выбрать до 4 маршрутов (по возможности) на эту заявку со
станций дислокации и со станций прихода заявок (станция дислокации = станция
отправления маршрута, станция отправления заявки = станция назначения маршрута или
конечная станция другой заявки = станция отправления маршрута, станция отправления
заявки = станция назначения маршрута). Вывести отобранные маршруты и указать номер
соответствующей заявки.
*/
DROP VIEW IF EXISTS orders_wt_routes CASCADE;
CREATE OR REPLACE VIEW orders_wt_routes AS
	SELECT order_id, station_from, station_to
	FROM orders 
	LEFT JOIN routes USING(station_from, station_to)
	WHERE must_do = true AND route_id IS NULL;
	
SELECT * FROM orders_wt_routes;

DROP VIEW IF EXISTS orders_routes CASCADE;
CREATE OR REPLACE VIEW orders_routes AS
	SELECT route_id, order_id FROM (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY order_id) row_cnt
		FROM (
			SELECT route_id, order_id 
			FROM (SELECT DISTINCT station_id FROM dislocations) sq1
			JOIN routes R ON R.station_from = station_id
			JOIN orders_wt_routes O ON R.station_to = O.station_from
			UNION
			SELECT route_id, order_id 
			FROM (SELECT DISTINCT station_to FROM orders) sq2
			JOIN routes R ON R.station_from = sq2.station_to
			JOIN orders_wt_routes O ON R.station_to = O.station_from
		) sq
	) ssq WHERE row_cnt <= 4;
	
SELECT * FROM orders_routes ORDER BY order_id;


/* +
9) Вывести количество маршрутов, общих для пунктов 7) и 8).
*/
SELECT COUNT(*) FROM (
	SELECT route_id FROM station_info
	JOIN orders USING(order_id)
	JOIN routes USING(station_from, station_to)
	INTERSECT
	SELECT route_id FROM orders_routes
) sq;

/* ++
10) Для каждого года рождения лиц, контролирующих заявки, вывести произведение
номеров существующих соответствующих заявок, номера которых не превосходят 100.
*/
SELECT born_data, ROUND(EXP(SUM(LN(order_id)))::numeric, 3) FROM control_person WHERE order_id <= 100 GROUP BY born_data;


/* ++
11) Вывести номера пропусков из таблицы control_person, которых нет в таблице person.
*/
SELECT pass_id FROM control_person EXCEPT SELECT pass_id FROM person;


/* +
12) Для каждой станций отправления с несколькими заявками показать, как
увеличивается число отправленных вагонов, если выполнять все заявки в порядке
увеличения суммарного времени загрузки и разгрузки одного вагона.
*/
SELECT station_from, car_required FROM (
	SELECT station_from, car_required, 
	RANK() OVER (PARTITION BY station_from ORDER BY (car_required * time_load_one_car), time_unload_one_car) cars
	FROM orders ORDER BY station_from
) sq;

/* +
13) Создать изменяемое представление на основе одной таблицы и на основе двух
таблиц. Продемонстрировать работу с представлением.
*/
DROP VIEW IF EXISTS person_info1;
CREATE OR REPLACE VIEW person_info1 AS 
	SELECT surname, first_name, second_name, sex, pass_id FROM person;
SELECT * FROM person_info1;

INSERT INTO person_info1(pass_id) VALUES ('999686');
SELECT * FROM person_info1;

SELECT * FROM person;


DROP VIEW IF EXISTS person_info2;
CREATE OR REPLACE VIEW person_info2 AS 
	SELECT surname, first_name, second_name, sex, born_data, PERS.pass_id, order_id
	FROM person PERS
	JOIN control_person CPERS ON PERS.pass_id = CPERS.pass_id;
SELECT * FROM person_info2;

INSERT INTO person_info2(pass_id) VALUES ('989686');

CREATE OR REPLACE RULE pi2_rule1 AS ON INSERT TO person_info2
DO INSTEAD INSERT INTO person 
VALUES(NEW.surname, NEW.first_name, NEW.second_name, NEW.pass_id, NEW.sex, NULL);

CREATE OR REPLACE RULE pi2_rule2 AS ON INSERT TO person_info2
DO INSTEAD INSERT INTO control_person 
VALUES(NEW.born_data, NULL, NEW.pass_id, NEW.order_id);

CREATE OR REPLACE RULE pi2_rule3 AS ON INSERT TO person_info2
DO INSTEAD INSERT INTO orders(order_id)
VALUES(NEW.order_id);

INSERT INTO person_info2 VALUES ('Петров', 'Петр', 'Петрович', 'м', NULL, '597148', 123456);

SELECT * FROM person_info2;

SELECT * FROM person;
SELECT * FROM control_person;
SELECT * FROM orders;


/* +
14)Вывести все номера маршрутов для ремонта, цена ремонта которых является второй,
четвертой или десятой (может быть несколько маршрутов на одной позиции). Указать
значение цены и номер ранг.
*/
SELECT * FROM (
	SELECT route_id, price, 
	DENSE_RANK() OVER (ORDER BY price DESC NULLS LAST) rnk
	FROM repair_routes
) sq WHERE rnk IN (2, 4, 10) ORDER BY rnk;


/* +
15*) Найти самую длинную цепочку сотрудников в подчинении.
*/
DROP VIEW IF EXISTS subordinates;
CREATE RECURSIVE VIEW subordinates(subline, pass_id) AS
	SELECT (surname || ' ' || first_name || ' ' || second_name) subline, pass_id
	FROM person
	WHERE submis IS NULL
	UNION ALL
	SELECT (S.subline || ' <- ' || surname || ' ' || first_name || ' ' || second_name) subline,
	PERS.pass_id
	FROM person PERS
	JOIN subordinates S ON PERS.submis = S.pass_id
	WHERE PERS.pass_id <> PERS.submis;
