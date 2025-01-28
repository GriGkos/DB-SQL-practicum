SELECT * FROM stations         --1
WHERE LEFT(station_id, 1)=RIGHT(station_id,1);

SELECT * FROM stations         --2.1
WHERE station_id LIKE '%00%' 
  AND station_id NOT LIKE '%000%';

SELECT * FROM stations         --2.2
WHERE station_id LIKE '%000%'; 

SELECT * FROM stations         --2.3
WHERE station_id ~ '^[^0]*00[^0]*$'; 

SELECT * FROM stations         --2.4
WHERE station_id ~ '^[^0]*0{3,}[^0]*$'; 



SELECT station_id, station_name                  --3
FROM stations
WHERE LENGTH(station_name) >= 7
  AND station_name ILIKE '%а%а%';

SELECT station_name FROM stations WHERE station_name ~ '[^а-яА-Яa-zA-Z ]' --4
OR LENGTH(station_name) = 3;

SELECT CASE sex                 --5
        WHEN 'м' THEN 'Мужчина'
        WHEN 'ж' THEN 'Женщина'
        ELSE 'Неизвестно'
    END || ': ' ||
CONCAT(UPPER(LEFT(first_name, 1)), '.') || ' ' ||
CONCAT(UPPER(LEFT(second_name, 1)), '.') || ' ' ||
surname as information
FROM persons 
WHERE (surname LIKE '%ко') 
  AND (first_name ILIKE 'а%') 
  AND (second_name ILIKE 'а%'); 
  
SELECT date_part('year', age(born_data)), order_id, pass_id  --6
FROM control_person  
WHERE MOD(order_id,2)=0 
  AND pass_id >= 100000
  AND pass_id <= 999999 
  AND pass_id % 10 % 2 = 0
  AND pass_id %100 /10 % 2 = 0;

SELECT DISTINCT station_id, car_type_name, wait_time, dislocations.period, --7
(substring(wait_time, 'от (\d+)')::int + substring(wait_time, 'до (\d+)')::int) / 2 as average_wait_time
FROM dislocations, car_types
WHERE car_types.car_type_id=dislocations.car_type
ORDER BY average_wait_time DESC, dislocations.period ASC;

SELECT * FROM routes   --8
WHERE station_from = 
  (SELECT station_id 
  FROM stations 
  WHERE station_name = 'Сайгатка') 
  AND avg_cost >=15724  
LIMIT 7;

SELECT order_id,             --9
  revenue_per_car, 
  car_required, 
  SUM(revenue_per_car*car_required) AS total_revenue,
  time_unload_one_car 
FROM orders
WHERE (car_required BETWEEN 20 AND 30) OR (car_required IN (71, 35))
GROUP BY order_id
ORDER BY total_revenue DESC, car_required ASC;

SELECT order_id FROM orders WHERE must_do IS NULL; --10

SELECT adress FROM control_person WHERE adress ~ '-|_'; --11

SELECT wait_cost FROM stations WHERE wait_cost IS NULL;  --12.1

SELECT wait_cost FROM stations WHERE COALESCE(wait_cost, NULL) IS NULL; --12.2