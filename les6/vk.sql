DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL primary key,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия пользователя',
    email VARCHAR(120) UNIQUE,
    phone BIGINT unsigned unique, -- не должно сущ-ть профилей с одинаковым номером телефона, так как он зачастую используется для авторизации или подтверждения личность/восстановления пароля
    INDEX users_phone_idx(phone), 
    INDEX users_firstname_lastname_idx(firstname, lastname)
);


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender ENUM('M', 'F'), -- для генерации данных с помощью fillbd удобней использовать такой формат
    birthday DATE,
	photo_id BIGINT UNSIGNED null unique, -- уникальный элемент, даже если разные пользователи загрузят одинаковое фото - id у элементов будут разные 
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) on update cascade on delete restrict
);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    is_read BOOL default 0,
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined') DEFAULT 'requested',
	requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	confirmed_at DATETIME DEFAULT NULL,
	
    PRIMARY KEY (initiator_user_id, target_user_id),
	index (initiator_user_id), 
    index (target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);



drop table if exists media_types;
create table media_types (
id SERIAL PRIMARY KEY,
name VARCHAR(255),
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP 
);


drop table if exists media;
create table media (
id SERIAL PRIMARY KEY,
media_type_id BIGINT unsigned not null,
user_id BIGINT unsigned not null,
body text,
filename VARCHAR(255),
size int,
matadata JSON,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, 

index (user_id),
foreign key (user_id) references users(id),
foreign key (media_type_id) references media_types(id)
);



DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	user_id BIGINT UNSIGNED NOT NULL, -- user who leaves a like
	object_id BIGINT UNSIGNED NOT NULL , -- object that was liked
	`status` ENUM('liked', 'unliked'), -- статус нужен, тк при первом взаимодействии пользователя и объекта возникает связь (запись в бд). если забрать лайк - связь остается, но меняется статус.
	`time` DATETIME DEFAULT NOW(),
	PRIMARY KEY (user_id, object_id), -- отношение между пользователем и объектом
	INDEX (user_id), -- поиск по лайкам конкретного пользователя 
    INDEX (object_id),-- поиск по лайкам к конкретному объекту
	FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (object_id) REFERENCES media (id)
);



drop table if exists communities;
create table communities (
id SERIAL PRIMARY KEY,
name varchar(150),
admin_user_id int,
index communities_name_idx(name)
);



drop table if exists users_communities;
create table users_communities (
user_id BIGINT unsigned not null,
community_id BIGINT unsigned not null,

PRIMARY KEY (user_id, community_id),
FOREIGN KEY (user_id) references users(id),
FOREIGN KEY (community_id) references communities(id)
);



DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
id SERIAL,
album_name varchar(255) default null,
user_id BIGINT UNSIGNED,
foreign key (user_id) references users(id),
primary key (id)
);



DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
id serial primary key,
album_id bigint unsigned not null, 
media_id bigint unsigned not null,
`description` text,

foreign key (album_id) references photo_albums(id),
foreign key (media_id) references media(id)
);


