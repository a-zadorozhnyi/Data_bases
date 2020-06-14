-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select id, name from users where id in (select distinct user_id from orders);

-- вариант с JOIN

select distinct u.id, u.name from users as u join orders as o on u.id = o.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

select id, name ,(select name from catalogs where id = products.catalog_id) as catalog from products;

-- вариантс с JOIN

select p.id, p.name, c.name from products as p join catalogs as c on c.id = p.catalog_id;


-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
use flights;
select id, (select name from cities where label = flights.`from`) as `from`,(select name from cities where label = flights.`to`) as `to` from flights;