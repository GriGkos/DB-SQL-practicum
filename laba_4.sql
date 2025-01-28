-- 1 задача
SELECT (MIN(avg_cost)) AS min_cost, 
	(MAX(avg_cost)) AS max_cost,
	(SUM(avg_cost)) AS sum_cost,
	(AVG(avg_cost)) AS avg_cost, 
	(COUNT(avg_cost)) AS count_cost 
FROM routes
WHERE route_id BETWEEN 10001 and 20000

-- 2 задача
SELECT 
    station_name,
    wait_cost,
    CASE 
        WHEN wait_cost = (SELECT MIN(wait_cost) FROM stations) THEN 'мин.'
        WHEN wait_cost = (SELECT MAX(wait_cost) FROM stations) THEN 'макс.'
        ELSE NULL 
    END AS cost_type
FROM 
    stations
WHERE 
    wait_cost = (SELECT MIN(wait_cost) FROM stations)
    OR wait_cost = (SELECT MAX(wait_cost) FROM stations);


-- 3 задача (?)
DELETE FROM dislocations WHERE station_id = 656;

INSERT INTO dislocations (station_id, loaded_empty, cars_quantity, car_type, period, wait_time)
VALUES 
(971201,0,1,1,1,'от 0 до 7'),
(921202,2,1,1,1,'от 0 до 6'),
(843408,1,1,1,1,'от 0 до 6'),
(843408,1,1,1,1,'от 0 до 6'); 

CREATE TABLE EmptyCars (
    cars_quantity INT,
    car_type INT,
    wait_time VARCHAR(20),
    period INT,
    station_id INT
);

INSERT INTO EmptyCars (cars_quantity, car_type, wait_time, period, station_id)
SELECT cars_quantity, car_type, wait_time, period, station_id
FROM dislocations;

SELECT car_type, period, station_id, COUNT(*)
FROM EmptyCars
GROUP BY car_type, period, station_id
HAVING COUNT(*) > 1;

DROP TABLE EmptyCars;

-- 4 задача
UPDATE stations
SET wait_cost = wait_cost * 1.2
WHERE stations.min_ > 0;

select * from stations
where stations.min_ > 0;

-- 5 задача
SELECT 
    station_id,
    period,
    ROUND(AVG(CASE WHEN loaded_empty = 1 THEN cars_quantity ELSE 0 END),3) AS avg_loaded_cars,
    ROUND(AVG(CASE WHEN loaded_empty = 0 THEN cars_quantity ELSE 0 END),3) AS avg_empty_cars,
    ROUND(AVG(CASE WHEN loaded_empty = 1 THEN cars_quantity ELSE 0 END) + AVG(CASE WHEN loaded_empty = 0 THEN cars_quantity ELSE 0 END),3) AS total_avg
FROM dislocations
WHERE CAST(station_id AS CHAR(6)) LIKE '%0%0%'
GROUP BY station_id, period
ORDER BY period DESC;

-- 6 задача
SELECT 
    period,
    COUNT(DISTINCT station_id) AS count_stations,
    ROUND(AVG(cars_quantity),3) AS avg_cars
FROM dislocations
GROUP BY period
HAVING ABS(AVG(cars_quantity) - (SELECT MAX(avg_cars) 
								 FROM (SELECT AVG(cars_quantity) AS avg_cars 
									 FROM dislocations GROUP BY period) AS subquery)) <= 5

-- 7 задача
--А(Скалярный подзапрос (возврат одного значения))
SELECT station_from,
		station_to,
       (SELECT MIN(avg_cost) FROM routes) AS max_cost
FROM routes;

--Б(Подзапрос в условии (IN))
SELECT station_from
FROM routes
WHERE station_from IN (SELECT station_id 
					   FROM stations 
					   WHERE station_name = 'Оричи' OR station_name = 'Вязники');
					   
--В(Подзапрос с EXISTS)
SELECT surname, first_name, second_name
FROM persons
WHERE EXISTS (SELECT 1 FROM repair_routes WHERE repair_routes.id_person = persons.pass_id);

--Г(Подзапрос с ANY/ALL (сравнение с любым/всем значениями))
SELECT route_id, avg_cost
FROM routes
WHERE avg_cost > ALL(SELECT avg_cost FROM routes WHERE route_id = 22717);

--Д(Подзапрос с JOIN)
SELECT routes.route_id
FROM routes
LEFT JOIN repair_routes ON routes.route_id = repair_routes.route_id
WHERE avg_cost > 100000;

-- 8 задача
SELECT station_name
FROM stations
WHERE station_id NOT IN 
	(SELECT station_from
	 FROM orders);

-- 9 задача
-- SELECT station_name, station_id
-- FROM stations
-- WHERE station_id IN (SELECT station_to
-- 					 FROM routes
-- 					 GROUP BY station_to
-- 					 HAVING MIN(avg_cost) > 10000)
					 
SELECT station_name
FROM stations
WHERE station_id IN (SELECT station_to
					 FROM orders
					 GROUP BY station_to
					 HAVING MIN(revenue_per_car * car_required) > 10000)					 

-- 10 задача 
SELECT station_to, COUNT(station_from) AS num_departures
FROM routes
GROUP BY station_to
ORDER BY num_departures DESC
LIMIT 5

-- 11 задача

SELECT CONCAT_WS('_', COALESCE(_from.station_name, 'Неизвестная_станция'), 'to', 
		  COALESCE(_to.station_name, 'Неизвестная_станция')) AS combined_name
FROM orders
JOIN stations _from ON (orders.station_from = _from.station_id)
JOIN stations _to ON (orders.station_to = _to.station_id)
WHERE order_id IN (SELECT order_id
					FROM schedule
					WHERE sum_cars_quatity BETWEEN 29 AND 41)

-- 12 задача
ALTER TABLE repair_routes
ADD COLUMN unknow_person VARCHAR(3);

UPDATE repair_routes
SET unknow_person = 
    CASE 
        WHEN EXISTS (SELECT 1 FROM persons WHERE persons.pass_id = repair_routes.id_person) THEN 'yes'
        ELSE 'no'
    END;

SELECT unknow_person
FROM repair_routes;

-- 13 задача
DROP TABLE IF EXISTS temp_tab;
CREATE TABLE temp_tab AS SELECT * FROM repair_routes;
DELETE FROM temp_tab WHERE id_person NOT IN (SELECT pass_id FROM persons);
ALTER TABLE temp_tab ADD CONSTRAINT fk_person_id FOREIGN KEY (id_person) REFERENCES persons(pass_id) ON DELETE CASCADE;
DROP TABLE temp_tab;
-- ON DELETE RESTRICT: Запрещает удаление родительской записи, если на нее есть ссылки в дочерней таблице.
-- ON DELETE SET NULL: Устанавливает NULL в дочерней таблице для внешнего ключа, если родительская запись была удалена.


-- 14 задача
SELECT surname
FROM persons
GROUP BY surname

-- 15 задача
SELECT routes.route_id
FROM routes
WHERE NOT EXISTS (SELECT 1 FROM repair_routes WHERE route_id = routes.route_id) AND (route_id IS NOT NULL);

-- 16 задача
CREATE TABLE donner (
    donner_id serial PRIMARY KEY,
    chef_id int,
    preparation_date date,
    total_amount numeric
);

INSERT INTO donner (chef_id, preparation_date, total_amount) VALUES
    (1, '2023-01-01', 500),
    (2, '2023-01-02', 750),
    (1, '2023-01-03', 300),
    (3, '2023-01-04', 1200),
    (2, '2023-01-05', 600),
    (3, '2023-01-06', 900),
    (1, '2023-01-07', 800),
    (2, '2023-01-08', 400);

INSERT INTO donner (chef_id, preparation_date, total_amount)
SELECT chef_id, preparation_date + i, total_amount
FROM donner, generate_series(1, 1000000) i;

EXPLAIN ANALYZE
SELECT chef_id, SUM(total_amount) as total_spent
FROM donner
WHERE chef_id > 500
GROUP BY chef_id;

EXPLAIN ANALYZE
SELECT chef_id, SUM(total_amount) as total_spent
FROM donner
GROUP BY chef_id
HAVING chef_id > 500;

DROP TABLE donner;
