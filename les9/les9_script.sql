-- Транзакции, переменные, представления

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

use shop;

use sample;
drop table if exists users; -- создание второй таблицы users
create table users (
id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';


START TRANSACTION; -- транзакция
insert into sample.users select * from shop.users where id = 1;
-- ROLLBACK; -- откат если нужен
commit;

START TRANSACTION; -- транзакция с SAVEPOINT
savepoint save_1; 
insert into sample.users select * from shop.users where id = 1;
-- ROLLBACK TO SAVEPOINT save_1; 
commit;


-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

use shop;

 create view les9_2 AS select p.name 'наименование', c.name 'раздел каталога' from products p join catalogs c on p.catalog_id = c.id;
 
 select * from les9_2;


-- 3. Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

use sample;

drop table if exists august;
create table august (`date` date);

insert into august values ('2018-08-01'),('2018-08-02'),('2018-08-03'),('2018-08-04'),('2018-08-05'),('2018-08-06'),('2018-08-07'),('2018-08-08'),('2018-08-09'),('2018-08-10'),('2018-08-11'),
('2018-08-12'),('2018-08-13'),('2018-08-14'),('2018-08-15'),('2018-08-16'),('2018-08-17'),('2018-08-18'),('2018-08-19'),('2018-08-20'),('2018-08-21'),('2018-08-22'),('2018-08-23'),
('2018-08-24'),('2018-08-25'),('2018-08-26'),('2018-08-27'),('2018-08-28'),('2018-08-29'),('2018-08-30'),('2018-08-31');

drop table if exists august_1;
create table august_1 (`date` date);

insert into august_1 values ('2018-08-01'),('2018-08-03'),('2018-08-04'),('2018-08-05'),('2018-08-06'),('2018-08-07'),('2018-08-10'),('2018-08-11'),
('2018-08-12'),('2018-08-13'),('2018-08-15'),('2018-08-20'),('2018-08-21'),('2018-08-22'),('2018-08-23'),
('2018-08-24'),('2018-08-26'),('2018-08-27'),('2018-08-28'),('2018-08-31');


select a.`date`, 
CASE 
	when a.`date` in (select * from august_1) THEN '1'
	else '0'
END as compare 
from august a; 

-- 4. Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

drop table if exists august_2;
create table august_2 (`date` date);

insert into august_2 values ('2018-08-01'),('2018-08-03'),('2018-08-04'),('2018-08-05'),('2018-08-06'),('2018-08-07'),('2018-08-10'),('2018-08-11'),
('2018-08-12'),('2018-08-13'),('2018-08-15'),('2018-08-20'),('2018-08-21'),('2018-08-22'),('2018-08-23'),
('2018-08-24'),('2018-08-26'),('2018-08-27'),('2018-08-28'),('2018-08-31');

prepare del from 'delete from august_2 order by `date` limit ?'; -- удаление записей с начала таблицы до ограничителя 

set @cnt=(select count(*)-5 from august_2); -- подсчет кол-во строк для удаления

execute del using @cnt;


--  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

-- Администрирование MySQL

-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

create user 'shop_read'@'localhost' identified by '123';
create user 'shop'@'localhost' identified by '123';

grant all on shop.* to shop;
grant usage, select on shop.* to shop_read;



-- 2. Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. 
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.


-- - - - - - - - 

-- “Хранимые процедуры и функции, триггеры"
	select '6:00' < '8:00' < '12:00' 
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

drop function if exists hello;
delimiter //
create function hello ()
returns tinytext deterministic
begin
	declare hour int;
    set hour = hour(now());
	case 
		when hour between 0 and 5 then
			return 'Доброй ночи';
		when hour between 6 and 11 then
			return 'Доброе утро';
		when hour between 12 and 18 then
			return  'Добрый день';
		else 
			return 'Добрый вечер';
	end case;
end//
            
select hello();		


-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

use shop;

drop trigger if exists if_both_null_insert;
delimiter //
create trigger if_both_null_insert before insert on products
for each row
begin
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN -- проверка вставляемых данных на isnull
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both fields are NULL!'; -- сообщение выводимое при срабатывании триггера
	end if;
end//



insert into products (name, description) values ('GEFORCE RTX 2070', 'a nice videocard'); -- ok
insert into products (name) values ('GEFORCE RTX 2070'); -- ok
insert into products (description) values ('a nice videocard'); -- ok
insert into products (name, description) values (null, null); -- not ok. trigger warning.

select * from products;

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

drop PROCEDURE if exists fib;
delimiter //
CREATE PROCEDURE fib (IN num INT)
BEGIN
  declare count int default 2;
  declare j int default 1;
  DECLARE i INT DEFAULT 0;
  
  IF (num > 2) THEN
	
		WHILE num >=  count DO
			set j = i + j;
            set i = j - i;
            set count = count + 1;
		END WHILE;
        
  ELSE
	SELECT 'Ошибочное значение параметра';
  END IF;
  select j;
END//

call fib(10); -- получему-то работает правильно



drop function if exists fib;
delimiter //
CREATE function fib (num INT)
returns int deterministic
BEGIN
  declare count int default 2;
  declare j int default 1;
  DECLARE i INT DEFAULT 0;
  
  IF (num > 2) THEN
	
		WHILE num >=  count DO
			set j = i + j;
            set i = j - i;
            set count = count + 1;
		END WHILE;
        
  ELSE
	return 'Ошибочное значение параметра';
  END IF;
  return j;
END//

select fib(10);