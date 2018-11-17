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


select name, min as min_count_public, id, name_men from departament
       inner join (select name as name_men, min, dip from employee
                   inner join(select distinct departament_id as dip, min(num_public) over (partition by departament_id) as min from employee
                              GROUP by(departament_id, name, num_public)) 
                   as foo on foo.min=employee.num_public and foo.dip=employee.departament_id)
       as fo on fo.dip=departament.id;

--name | min_count_public | id | name_men 
--------------------+------------------+----+----------
--Therapy | 1 | 1 | Alexey
--Therapy | 1 | 1 | Klaudia
--Neurology | 10 | 2 | Kate
--Cardiology | 8 | 3 | Peter
--Gastroenterology | 2 | 4 | Irina
--Hematology | 21 | 5 | Sascha
--Oncology | 18 | 6 | Ann
--(7 rows)

-- задание 5

SELECT name, count, avg from departament INNER JOIN (select departament_id, count(distinct chief_doc_id) as count, avg(num_public) as avg from employee group by(departament_id) having(count(distinct chief_doc_id)) > 1 order by departament_id asc) as foo on departament.id=foo.departament_id;

--name | count | avg 
--------------+-------+---------------------
--Therapy | 2 | 3.5000000000000000
--Neurology | 2 | 11.0000000000000000
--Cardiology | 2 | 10.7500000000000000
--(3 rows)
