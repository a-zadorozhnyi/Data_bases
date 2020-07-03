drop database if exists project;
create database project;

use project;


drop table if exists shop; -- основная информация о магазине
create table shop (
name varchar(255) not NULL,
location varchar(255) not NULL,
description text not null,
`e-mail` varchar(50) not null,
phone bigint unsigned
);



drop table if exists media;  -- каталог медиа файлов, используемых в магазине
create table media (
id SERIAL primary key,
name varchar(50),
size bigint, 
created_at DATETIME DEFAULT NOW()
);	



drop table if exists pets; -- каталог животных
create table pets (
id serial primary key,
species ENUM ('Dog', 'Cat', 'Fish', 'Rodent', 'Reptile', 'Bird') not null,
media_id BIGINT UNSIGNED NOT NULL,
foreign key (media_id) references media(id)
);



drop table if exists users; -- таблица будет использоваться как профиль для групп сотрудников и клиентов 
create table users (
id SERIAL PRIMARY KEY,
firstname VARCHAR(50),
lastname VARCHAR(50),
birthday DATE,
media_id BIGINT UNSIGNED NOT NULL,
`password` bigint,
email VARCHAR(120) UNIQUE,
address VARCHAR(150),
phone BIGINT unsigned unique,
pet_id BIGINT UNSIGNED,
created_at DATETIME DEFAULT NOW(),
INDEX users_phone_idx(phone), 
INDEX users_firstname_lastname_idx(firstname, lastname),
foreign key (media_id) references media(id),
foreign key (pet_id) references pets(id)
);



drop table if exists `customers`; 
create table `customers` (
id SERIAL primary key,
user_id BIGINT UNSIGNED NOT NULL,
category ENUM('Regular', 'Bronze', 'Silver', 'Gold', 'VIP'),
permanent_discount_size int default null, -- скидка завязана на категорию покупателя
foreign key (user_id) references users(id)
);



drop table if exists `employees`;
create table `employees` (
id SERIAL primary key,
user_id BIGINT UNSIGNED NOT NULL,
departament ENUM('Moderator', 'Admin', 'Orders and shippment', 'marketing', 'IT'),
foreign key (user_id) references users(id)
);



drop table if exists manufactorer; -- каталог производителей и информации о них
create table manufactorer (
id serial primary key,
name varchar(255),
description text,
media_id BIGINT UNSIGNED NOT NULL,
CONSTRAINT media_id_manufactorer foreign key (media_id) references media(id)
);



drop table if exists catalog;
create table catalog (
id SERIAL primary key,
media_id BIGINT UNSIGNED NOT NULL,
name varchar(50),
description text,
parent_id BIGINT UNSIGNED default null,
foreign key (media_id) references media(id),
foreign key (parent_id) references catalog(id)
);



drop table if exists product; -- основная таблица товаров
create table product (
id SERIAL primary key,
name varchar(255) not null,
catalog_id BIGINT UNSIGNED NOT NULL,
media_id BIGINT UNSIGNED UNIQUE NOT NULL,
manufactorer_id BIGINT UNSIGNED NOT NULL,
suitable_for BIGINT UNSIGNED NOT NULL,
short_description text,
description text,
foreign key (manufactorer_id) references manufactorer(id),
foreign key (catalog_id) references catalog(id),
foreign key (media_id) references media(id),
foreign key (suitable_for) references pets(id),
created_at DATETIME DEFAULT NOW(),
changed_at DATETIME DEFAULT NULL
);


DROP TABLE IF EXISTS product_properties;
CREATE  TABLE product_properties ( -- таблица спецификаций конкретного товара (размеры, цвет, цена)
	id SERIAL PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    price DECIMAL(20,2) not null,
    size varchar(50) default null,
    color varchar(50) default null,
    materials varchar(255) default null,
	foreign key (product_id) references product(id)
  );



drop table if exists warehouse; -- таблица склада
create table warehouse (
id SERIAL primary key,
location varchar(255) default NULL,
description text default null,
`e-mail` text default null,
phone int unsigned
);



drop table if exists storage; -- таблица хранимого на складе товара
create table storage (
product_properties_id BIGINT UNSIGNED UNIQUE NOT NULL PRIMARY KEY,
warehouse_id BIGINT UNSIGNED NOT NULL,
quantity int not null, -- количество товарной позиции. поле показывает и наличие/отсутствие товара на складе (если кол-во = 0)
storage_cell int,
foreign key (product_properties_id) references product_properties(id),
foreign key (warehouse_id) references warehouse(id)
);



drop table if exists discounts; -- скидки на определенные товары или на категорию товаров
create table discounts (
id SERIAL primary key,
product_id BIGINT UNSIGNED,
catalog_category_id BIGINT UNSIGNED,
discount_size varchar(25),
start_date DATETIME not null,
end_date datetime,
foreign key (product_id) references product(id),
foreign key (catalog_category_id) references catalog(id)
);


drop table if exists orders; -- таблица заказов
create table orders (
id SERIAL primary key,
user_id BIGINT UNSIGNED NOT NULL, -- заказчик 
employee_id BIGINT UNSIGNED NOT NULL, -- сотрудник, отвечающий за выполнение заказа
status ENUM('processing', 'complete','rejecter'), -- статус заказа 
payment_via enum('WebMoney', 'VISA', 'MasterCard', 'PayPal', 'Cash' ), -- способ оплаты
paid enum('1','0') not null, -- оплачено ли
`comment` text,
created_at datetime default NOW() not null, -- дата размещения заказа
closed_at datetime default null, -- дата закрытия заказа
foreign key (user_id) references users(id),
foreign key (employee_id) references `employees`(id)
);



drop table if exists order_details; -- таблица детализации заказа
create table order_details (
order_id BIGINT UNSIGNED UNIQUE NOT NULL primary key,
product_properties_id BIGINT UNSIGNED UNIQUE NOT NULL,
quantity int not null, -- кол-во товара в заказе
total_price DECIMAL(20,2) not null, -- итоговая цена
foreign key (order_id) references orders(id),
foreign key (product_properties_id) references product_properties(id)
);