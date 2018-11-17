-- задание 1

SELECT name, count from departament INNER JOIN (select departament_id, count(distinct chief_doc_id) as count from employee group by(departament_id) order by departament_id asc) as foo on departament.id=foo.departament_id;
 
--name | count 
--------------------+-------
--Therapy | 2
--Neurology | 2
--Cardiology | 2
--Gastroenterology | 1
--Hematology | 1
--Oncology | 1
--(6 rows)

-- задание 2

SELECT id as dep_id, count from departament INNER JOIN (select departament_id, count(chief_doc_id) as count from employee group by(departament_id) having(count(chief_doc_id)) >= 3 order by departament_id asc) as foo on departament.id=foo.departament_id;

--dep_id | count 
----------+-------
--1 | 6
--2 | 3
--3 | 4
--4 | 3
--(4 rows)

-- задание 3


SELECT id as dep_id, sum from departament INNER JOIN (select departament_id, sum(num_public) as sum from employee group by(departament_id)) as foo on departament.id=foo.departament_id group by(id, sum) order by sum desc limit 2;

--dep_id | sum 
----------+-----
--3 | 43
--5 | 43
--(2 rows)

-- задание 4


select DISTINCT departament_id, min(num_public) OVER (partition by departament_id) from employee group by (departament_id, num_public);
--departament_id | min 
------------------+-----
--6 | 18
--1 | 1
--4 | 2
--2 | 10
--5 | 21
--3 | 8
--(6 rows)

-- задание 5

SELECT name, count, avg from departament INNER JOIN (select departament_id, count(distinct chief_doc_id) as count, avg(num_public) as avg from employee group by(departament_id) having(count(distinct chief_doc_id)) > 1 order by departament_id asc) as foo on departament.id=foo.departament_id;

--name | count | avg 
--------------+-------+---------------------
--Therapy | 2 | 3.5000000000000000
--Neurology | 2 | 11.0000000000000000
--Cardiology | 2 | 10.7500000000000000
--(3 rows)
