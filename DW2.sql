-- 1) Выведем тех пользователей, у которых средний рейтинг выше 4.5. Сгруппируем --по пользователям по возрастанию их id.

SELECT userId, AVG(rating) AS avgrating FROM ratings GROUP BY userId HAVING AVG(rating) > 4.5 ORDER BY userId ASC LIMIT 10;

-- userid |    avgrating     
----------+------------------
--     21 |           4.5625
--     51 | 4.83050847457627
--     57 |                5
--    110 |           4.6875
--    121 |                5
--    206 |              4.9
--    214 |                5
--    238 |                5
--    258 |                5
--    282 | 4.57142857142857
--(10 rows)
 
-- 2) Выведем imdbid из таблицы links фильмов у которых средний рейтинг выше 4.5 (используем JOIN)

SELECT DISTINCT imdbid FROM links JOIN (SELECT movieid FROM ratings GROUP BY movieid HAVING AVG(rating) > 4.5) as foo ON links.movieid=foo.movieid LIMIT 10;

-- imdbid  
-----------
-- 0112702
-- 0114671
-- 0031612
-- 0109066
-- 0027893
-- 0029855
-- 0112777
-- 0034493
-- 0116310
-- 0112951
--(10 rows)

-- 3) Выведем тех пользователей (их id), у которых более 20 оценок и средний рейтинг есть 5. 

SELECT userid FROM ratings GROUP BY userid HAVING AVG(rating) = 5 AND COUNT(userid) > 20  limit 10;
 
--userid 
----------
--   4434
--   5463
--   6755
--   6178
--(4 rows)

-- 4) Выведем средний рейтинг по всем пользователем, у которых больше 10 оценок

WITH tmp_table AS (SELECT userid FROM ratings GROUP BY userid HAVING COUNT(userid) > 10) SELECT AVG(rating) FROM ratings JOIN tmp_table ON ratings.userid=tmp_table.userid LIMIT 10;

--       avg        
--------------------
-- 3.54432638703174
--(1 row)

-- 5) Выведем по возростанию id пользователей их максимальный и минимальный рейтинг (используя аналит. функции).

SELECT DISTINCT userid, MAX(rating) OVER (PARTITION BY userId), min(rating) OVER (PARTITION BY userid) FROM ratings GROUP BY userid, rating order by userid asc limit 15;

-- userid | max | min 
----------+-----+-----
--      1 |   5 | 0.5
--      2 |   5 |   1
--      3 |   4 |   2
--      4 |   5 |   1
--      5 |   5 |   1
--      6 |   5 |   3
--      7 |   5 |   1
--      8 |   5 |   1
--      9 |   5 | 0.5
--     10 |   5 |   3
--     11 |   5 | 0.5
--     12 |   5 |   1
--     13 | 4.5 | 1.5
--     14 |   5 |   2
--     15 |   5 | 0.5
--(15 rows)

-- 6) Выведем по возростанию id пользователей их нормированный рейтинг и разницу между максимальным и минимальным рейтингом (используя аналит. функции).

SELECT userid, rating/MAX(rating) OVER (PARTITION BY userId) as normed_rating,
	       max(rating) OVER (PARTITION BY userid) - min(rating) OVER (PARTITION BY userid) as diff
       FROM ratings GROUP BY userid, rating order by userid asc limit 15;

--userid | normed_rating | diff 
----------+---------------+------
--      1 |           0.7 |  4.5
--      1 |           0.5 |  4.5
--      1 |           0.8 |  4.5
--      1 |           0.2 |  4.5
--      1 |           0.9 |  4.5
--      1 |           0.1 |  4.5
--      1 |             1 |  4.5
--      2 |             1 |    4
--      2 |           0.6 |    4
--      2 |           0.2 |    4
--      2 |           0.4 |    4
--      2 |           0.8 |    4
--      3 |          0.75 |    2
--      3 |             1 |    2
--      3 |           0.5 |    2
--(15 rows)

-- 7) Выведем фильмы (их id) по убыванию, у которых сумма рейтингов самая большая.

SELECT DISTINCT movieid, SUM(rating) OVER (PARTITION BY movieid) AS sum FROM ratings ORDER BY sum DESC LIMIT 10;

-- movieid |   sum   
-----------+---------
--     318 |   12417
--     356 |   11022
--     296 | 11003.5
--     593 | 10516.5
--    2571 |    9869
--     260 |  9438.5
--     527 |    8737
--     480 |  8359.5
--       1 |    7947
--     110 |  7885.5
--(10 rows)

-- 8) Найдем самых активных пользователей (тех, кто поставил больше всего рейтинга в сумме).

SELECT DISTINCT userid, SUM(rating) over (PARTITION BY userid) AS sum FROM ratings ORDER BY sum DESC LIMIT 10;

-- userid |   sum   
----------+---------
--   5620 | 12818.5
--   4387 | 10988.5
--   4160 | 10659.5
--   4916 |    9984
--    741 |    9816
--   5829 |    9139
--   4294 |  8544.5
--   4323 |  8206.5
--   3437 |    7763
--   6513 |    7541
--(10 rows)

-- 9) Cравним результаты функции AVG и самостоятельного деления SUM на COUNT

SELECT DISTINCT userid, COUNT(rating) OVER (PARTITION BY userid) AS count,
		SUM(rating) OVER (PARTITION BY userid) AS sum,
		AVG(rating) OVER (PARTITION BY userid) as avg_1,
		SUM(rating) OVER (PARTITION BY userid)/COUNT(rating) OVER (PARTITION BY userid) as avg_2
                FROM ratings ORDER BY count DESC limit 10;

-- userid | count |   sum   |      avg_1       |      avg_2       
----------+-------+---------+------------------+------------------
--   4387 |  3370 | 10988.5 |  3.2606824925816 |  3.2606824925816
--   4916 |  3051 |    9984 | 3.27236971484759 | 3.27236971484759
--   5620 |  3037 | 12818.5 | 4.22077708264735 | 4.22077708264735
--   5829 |  2955 |    9139 |  3.0927241962775 |  3.0927241962775
--    741 |  2811 |    9816 | 3.49199573105656 | 3.49199573105656
--   4160 |  2681 | 10659.5 | 3.97594181275643 | 3.97594181275643
--   6513 |  2670 |    7541 | 2.82434456928839 | 2.82434456928839
--   3437 |  2608 |    7763 | 2.97661042944785 | 2.97661042944785
--   4294 |  2385 |  8544.5 | 3.58259958071279 | 3.58259958071279
--   4323 |  2253 |  8206.5 | 3.64247669773635 | 3.64247669773635
--(10 rows)


-- 10)

-- Создаем функцию пересечения массивов

CREATE OR REPLACE FUNCTION cross_arr (anyarray, anyarray) RETURNS anyarray language sql as $FUNCTION$ WITH arr3 as (select unnest($1) as arr intersect select unnest($2)) SELECT array_agg(arr) from arr3;; $FUNCTION$;

-- Создаем массивы рейтингов для первой таблицы и сохраняем их

SELECT userID as u1, array_agg(rating) as r1 INTO public.user_rating_agg1 FROM ratings GROUP BY (userid) LIMIT 500;

-- Создаем массивы рейтингов для второй таблицы и сохраняем их

SELECT userID as u2, array_agg(rating) as r2 INTO public.user_rating_agg2 FROM ratings GROUP BY (userid) LIMIT 500;

-- Обьединяем их.

SELECT * INTO user_rating_agg FROM user_rating_agg1 CROSS JOIN user_rating_agg2;

-- Находим пересечение по рейтингам.

SELECT u1, u2, cross_arr(r1, r2) INTO common_user_views FROM user_rating_agg;

-- Вывод результата для юзеров с айди 15 и 100. (то есть юзер с айди 15 и юзер с айди 100 ставили рейтинг 3 и рейтинг 3.5)

SELECT * FROM common_user_views WHERE u1 = 15 and u2 = 100;

-- u1 | u2  | cross_arr 
------+-----+-----------
-- 15 | 100 | {3,3.5}
--(1 row)
 
















