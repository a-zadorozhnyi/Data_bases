use project;



-- Добавление в БД нового пользователя
START TRANSACTION;
savepoint save_1; 
INSERT INTO users (firstname, lastname, birthday, media_id, email, address, phone, pet_id) VALUES
  ('Chandler',  'Bing', '1976-07-27', '395', 'c.bing@gmail.com', 'NY, mapple street', 98651651655, 2);
-- rollback
-- ROLLBACK TO SAVEPOINT save_1; 
COMMIT;


-- возвращающает пользователей у которых сегодня день рождения

DROP PROCEDURE IF EXISTS BD_today;
delimiter //
CREATE PROCEDURE BD_today ()
BEGIN
select * from users where (select concat(day(birthday),'-',month(birthday))) in (select concat(day(now()),'-', month(now())));
end //

call BD_today;

-- вывод основной инф о пользователях + питомец
select u.id, u.firstname, u.lastname, p.species from users as u join pets as p on u.pet_id = p.id order by u.id;  


-- вывод пользователей с учетом типа питом
select u.id, u.firstname, u.lastname, (select species from pets where id = 1) from users u where pet_id = 1;  

--

use project;
drop view if exists order_detailss;

 create view order_detailss AS select o.id, o.user_id, o.employee_id, o.status , od.product_properties_id from orders o join order_details od on o.id = od.order_id;
 
 select * from order_detailss;

-- логирование создания новых пользователей
drop trigger if exists users_log; 
DELIMITER //
create trigger user_log AFTER INSERT on users 
for each row 
BEGIN
	insert into project.`logs` (created_at, table_name, id, firstname, lastname)
    VALUES (NOW(), 'users', NEW.id, NEW.firstname, NEW.lastname);
END//
delimiter ;


-- выборки по заказам

set @order_num = 238;  -- задаем номер заказа для поиска

select *  from orders o join order_details od on o.id = order_id where o.user_id = @order_num;  


select id, user_id, employee_id from orders order by paid;


-- вывести всех сотрудников магазина 

select * from users u where u.id in (select user_id from employees);