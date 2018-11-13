-- Создадим таблицу с данными о любимых фильмах

CREATE TABLE filmes(film_id serial PRIMARY KEY,
					title TEXT UNIQUE NOT NULL,
					country TEXT NOT NULL,
					box_office INT NOT NULL,
					release_year TIMESTAMP);
					
-- Заполним ее данными

INSERT INTO filmes VALUES (1, 'Pulp fiction', 'USA', 214000000, '1999-2-1'::timestamp);

INSERT INTO filmes VALUES (2, 'The Lord of the Rings', 'USA', 816000000, '2001-10-11'::timestamp);

INSERT INTO filmes VALUES (3, 'The Wolf of WALL Street', 'USA', 390000000, '2014-6-2'::timestamp);

INSERT INTO filmes VALUES (4, 'Inseption', 'USA', 826000000, '2014-7-22'::timestamp);

INSERT INTO filmes VALUES (5, 'Inglourious Basterds', 'USA', 321000000, '2009-9-20'::timestamp);

-- Создадим таблицу с данными по персонам, которые так или иначе связанны с фильмом

CREATE TABLE persons(person_id serial PRIMARY KEY, fio TEXT UNIQUE NOT NULL);

-- Заполним ее данными

INSERT INTO persons VALUES (1, 'Quentin Jerome Tarantino'), (2, 'Peter Jackson'),
						   (3, 'Martin Scorsese'),(4, 'Christopher Nolan'),
						   (5, 'William Bradley Pitt');

-- Создадим таблицу с данными по должности персоны в фильме

CREATE TABLE people2contents(film_id INT, person_id INT, person_type TEXT NOT NULL);

-- Заполним ее данными

INSERT INTO people2contents VALUES (1, 1, 'Director'), (2, 2, 'Director'), (3, 3, 'Director'), (4, 4, 'Director'), (5, 5, 'Actor');

-- Создадим таблицу с данными по биографии этих персон

CREATE TABLE biography(person_id serial PRIMARY KEY, place_of_birth TEXT NOT NULL,
					   data_of_birth TIMESTAMP, citizenship TEXT NOT NULL);
					   
-- Заполним ее данными

INSERT INTO biography VALUES(1, 'Knoxville', '1963-3-27'::timestamp, 'USA'),
							(2, 'Wellington','1961-10-31'::timestamp, 'New Zealand'),
							(3, 'New York City', '1942-11-17'::timestamp, 'USA'), 
							(4, 'Westminster','1970-7-30'::timestamp, 'UK'),
							(5, 'Shawnee', '1963-12-18'::timestamp, 'USA');
							
-- Свяжем таблицы по внешнему ключу

ALTER TABLE biography ADD FOREIGN KEY(person_id) REFERENCES persons(person_id);

ALTER TABLE people2contents ADD FOREIGN KEY(film_id) REFERENCES filmes(film_id);

ALTER TABLE people2contents ADD FOREIGN KEY(person_id) REFERENCES persons(person_id);

-- Выведем полученные таблицы

-- SELECT * FROM filmes;

-- film_id | title | country | box_office | release_year
-----------+-------------------------+---------+------------+---------------------
-- 1 | Pulp fiction | USA | 214000000 | 1999-02-01 00:00:00
-- 2 | The Lord of the Rings | USA | 816000000 | 2001-10-11 00:00:00
-- 3 | The Wolf of WALL Street | USA | 390000000 | 2014-06-02 00:00:00
-- 4 | Inseption | USA | 826000000 | 2014-07-22 00:00:00
-- 5 | Inglourious Basterds | USA | 321000000 | 2009-09-20 00:00:00
--(5 rows)

-- SELECT * FROM persons;

-- person_id | fio
-------------+--------------------------
-- 1 | Quentin Jerome Tarantino
-- 2 | Peter Jackson
-- 3 | Martin Scorsese
-- 4 | Christopher Nolan
-- 5 | William Bradley Pitt
--(5 rows)

-- SELECT * FROM people2contents;

-- film_id | person_id | person_type
-----------+-----------+-------------
-- 1 | 1 | Director
-- 2 | 2 | Director
-- 3 | 3 | Director
-- 4 | 4 | Director
-- 5 | 5 | Actor
--(5 rows)

-- SELECT * FROM biography;

-- person_id | place_of_birth | data_of_birth | citizenship
-------------+----------------+---------------------+-------------
-- 1 | Knoxville | 1963-03-27 00:00:00 | USA
-- 2 | Wellington | 1961-10-31 00:00:00 | New Zealand
-- 3 | New York City | 1942-11-17 00:00:00 | USA
-- 4 | Westminster | 1970-07-30 00:00:00 | UK
-- 5 | Shawnee | 1963-12-18 00:00:00 | USA
--(5 rows)