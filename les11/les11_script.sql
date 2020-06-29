-- Оптимизация запросов

-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, 
--  название таблицы, идентификатор первичного ключа и содержимое поля name.

 use shop;
 
 
drop table if exists `logs`;
create table logs (
created_at DATETIME not null,
table_name vARCHAR(50) not null,
id BIGINT not null,
name varchar(50) not null
) engine = archive; 

-- создание триггеров для логирования

drop trigger if exists users_log; -- логирование создания новых пользователей
DELIMITER //
create trigger user_log AFTER INSERT on users 
for each row 
BEGIN
	insert into shop.`logs` (created_at, table_name, id, name)
    VALUES (NOW(), 'users', NEW.id, NEW.name);
END//
delimiter ;

drop trigger if exists catalogs_log; -- логирование создания новых каталогов
DELIMITER //
create trigger catalogs_log AFTER INSERT on catalogs 
for each row 
BEGIN
	insert into shop.`logs` (created_at, table_name, id, name)
    VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END//
delimiter ;

drop trigger if exists products_log; -- логирование создания новых товаров
DELIMITER //
create trigger products_log AFTER INSERT on products 
for each row 
BEGIN
	insert into shop.`logs` (created_at, table_name, id, name)
    VALUES (NOW(), 'products', NEW.id, NEW.name);
END//
delimiter ;

-- 2. Создайте SQL-запрос, который помещает в таблицу users миллион записей.

drop table if exists kk_users;
create table kk_users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS kk_users ;
delimiter //
CREATE PROCEDURE kk_users ()
BEGIN
	DECLARE i INT DEFAULT 1000; -- создание 1000 пользователей занимает ~3.2c, так что 1млн пользователей займет ~54 минуты. остановлюсь на сотне
	DECLARE j INT DEFAULT 1;
	WHILE i > 0 DO
		INSERT INTO kk_users(name, birthday_at) VALUES (CONCAT('citizen number ', j), NOW());
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

call kk_users;


-- Практическое задание по теме “NoSQL”
 -- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

SADD IP '127.0.0.1' '127.0.0.2' '127.0.0.3' '127.0.0.4' '127.0.0.5' -- множество со значениями
SMEMBERS IP -- просматриваем список элементов
SCARD IP -- возвращает количество элементов в множестве

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
MSET Allan 'Al_0101@gmail.com' Sam 'xXSAMXx@dumb.com' -- задем ключ-значени (имя-почта)
GET Allan -- получаем значение (почту) по ключу (имени)
MSET 'Al_0101@gmail.com' Allan 'xXSAMXx@dumb.com' Sam  -- задем ключ-значени (почта-имя)
GET 'Al_0101@gmail.com' -- получаем значение (имя) по ключу (почте)
