use les5;
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

-- 1 задание. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
update users
set created_at = CURRENT_TIMESTAMP,
	updated_at = CURRENT_TIMESTAMP;
    
-- 2 задание. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
    -- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
describe users;
ALTER TABLE users CHANGE created_at created_at datetime; 
ALTER TABLE users CHANGE updated_at updated_at datetime;
describe users;
select created_at, updated_at from users;

-- 3 задание. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 1000 ELSE value END;

/* 4 задание. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')*/

select name, birthday_at from users where month(birthday_at) = 08 or month(birthday_at) = 05;

-- 5 задание. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

select * from catalogs where id in (5, 1, 2) order by field(id, 5, 1, 2);

-- Практическое задание теме “Агрегация данных”

-- 1 задание. Подсчитайте средний возраст пользователей в таблице users

SELECT ROUND(AVG(timestampdiff(year, birthday_at, now())),0) as `avarage age` from users;

-- 2 задание. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

 SELECT count(*), dayname(concat('2020-', (substring(birthday_at,6, 10)))) as `birthday on` from users group by `birthday on` ORDER BY `birthday on` DESC;

