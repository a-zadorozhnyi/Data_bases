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

INSERT INTO `users` VALUES ('21','Elouise','Graham','istrosin@example.com','0'),
('23','Taylor','Langworth','igerlach@example.org','925344'),
('24','Ettie','Yundt','antonio97@example.org','1'),
('25','Carolanne','Eichmann','jacobson.alexandria@example.com','686'),
('26','Hershel','Pouros','mckenzie58@example.net','522684'),
('28','Karli','Ruecker','ruthe.feeney@example.com','34987'),
('30','Meda','Luettgen','cswaniawski@example.org','280627'),
('31','Allison','Boyle','terry.brian@example.org','3144032313'),
('32','Amelie','Weissnat','virginie86@example.net','278202'),
('33','Izaiah','West','antonina.pollich@example.com','601375'),
('36','Brenda','Greenfelder','jimmy81@example.org','240'),
('37','Amely','Monahan','lward@example.com','899016'),
('39','Percival','Bailey','yosinski@example.net','253'); 




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

INSERT INTO `profiles` VALUES ('21','M','1994-12-19','2861','2013-06-18 18:10:39','Lake Rosalynton'),
('23','M','1979-03-14','1010','2013-01-10 09:16:31','Schinnerfort'),
('24','M','1998-01-15','2850','1991-08-23 22:33:21','Vivastad'),
('25','F','1996-06-15','2900','1998-02-13 19:24:12','Schmittview'),
('26','F','1989-10-05','1099','2014-04-20 02:05:30','Glovertown'),
('28','M','1971-06-26','2147','2010-09-17 10:02:41','Port Eugeniahaven'),
('30','M','1988-09-19','1436','1992-09-14 13:08:56','Tysonbury'),
('31','F','1990-04-02','1657','1976-09-28 11:13:37','Troyshire'),
('32','F','2007-03-22','1473','1983-06-22 12:14:40','Demondbury'),
('33','M','1973-03-01','1116','1978-04-14 21:23:55','Haskellville'),
('36','M','1976-12-02','1668','1974-03-05 07:09:39','West Oranshire'),
('37','M','1977-05-09','2410','2013-03-07 03:54:17','New Jazmyn'),
('39','M','1983-09-30','2942','1987-03-17 22:39:24','South Thelma'); 


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), 
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

INSERT INTO `messages` VALUES ('1','33','33','Cat. \'I\'d nearly forgotten to ask.\' \'It turned into a pig,\' Alice quietly said, just as well. The twelve jurors were writing down \'stupid things!\' on their throne when they passed too close, and.','1977-07-07 08:49:31'),
('2','25','24','Alice, \'it\'s very easy to know when the tide rises and sharks are around, His voice has a timid and tremulous sound.] \'That\'s different from what I eat\" is the reason so many tea-things are put out.','1973-11-25 20:53:22'),
('3','25','26','Mouse heard this, it turned round and round Alice, every now and then another confusion of voices--\'Hold up his head--Brandy now--Don\'t choke him--How was it, old fellow? What happened to me! I\'LL.','1979-03-29 18:04:56'),
('4','28','21','After a minute or two, it was only a pack of cards!\' At this moment the King, going up to the table to measure herself by it, and they repeated their arguments to her, so she turned away. \'Come.','2006-02-12 03:52:09'),
('5','24','37','YET,\' she said this, she came up to her that she was coming to, but it had VERY long claws and a large dish of tarts upon it: they looked so grave that she had read several nice little dog near our.','2016-10-20 20:55:54'),
('6','33','28','Mock Turtle yet?\' \'No,\' said Alice. \'Who\'s making personal remarks now?\' the Hatter went on, \'if you only walk long enough.\' Alice felt dreadfully puzzled. The Hatter\'s remark seemed to be.','1984-12-06 08:13:25'),
('7','21','32','How brave they\'ll all think me at home! Why, I do wonder what I get\" is the capital of Rome, and Rome--no, THAT\'S all wrong, I\'m certain! I must go and get in at the sudden change, but very.','1977-07-16 13:03:45'),
('8','36','39','Cat; and this was his first speech. \'You should learn not to lie down on her lap as if he had never heard before, \'Sure then I\'m here! Digging for apples, indeed!\' said the March Hare. \'Exactly so,\'.','1985-10-13 05:56:30'),
('9','37','39','The King\'s argument was, that she let the jury--\' \'If any one left alive!\' She was moving them about as she swam nearer to make herself useful, and looking anxiously round to see that she knew that.','1996-05-22 03:05:31'),
('10','28','25','However, \'jury-men\' would have called him a fish)--and rapped loudly at the Duchess and the other two were using it as to prevent its undoing itself,) she carried it off. \'If everybody minded their.','2016-01-29 19:17:11'),
('11','37','39','He says it kills all the other end of half those long words, and, what\'s more, I don\'t think,\' Alice went on to the jury. They were just beginning to grow to my jaw, Has lasted the rest waited in.','1978-10-04 22:21:49'),
('12','31','25','For anything tougher than suet; Yet you balanced an eel on the ground as she passed; it was certainly too much pepper in that case I can kick a little!\' She drew her foot slipped, and in his.','1998-09-13 12:22:38'),
('13','26','31','They all sat down at her side. She was walking hand in her life; it was done. They had a head could be no doubt that it is!\' As she said to one of the teacups as the March Hare went \'Sh! sh!\' and.','2010-11-26 19:00:18'),
('14','39','23','COULD grin.\' \'They all can,\' said the voice. \'Fetch me my gloves this moment!\' Then came a little timidly, for she felt a very long silence, broken only by an occasional exclamation of \'Hjckrrh!\'.','2002-08-25 09:34:01'),
('15','26','21','PLEASE mind what you\'re doing!\' cried Alice, quite forgetting that she was to find any. And yet I don\'t take this young lady to see it pop down a good deal to come before that!\' \'Call the next thing.','2003-06-09 00:45:31'),
('16','24','23','MYSELF, I\'m afraid, but you might like to hear her try and say \"How doth the little golden key was too late to wish that! She went in without knocking, and hurried off to other parts of the.','2020-02-18 02:52:24'),
('17','33','28','The Mock Turtle in a hoarse, feeble voice: \'I heard the Rabbit say, \'A barrowful of WHAT?\' thought Alice; \'I might as well as she could. \'No,\' said the Caterpillar. \'Not QUITE right, I\'m afraid,\'.','2016-10-23 10:34:37'),
('18','25','39','She generally gave herself very good advice, (though she very seldom followed it), and handed them round as prizes. There was certainly English. \'I don\'t think they play at all a pity. I said \"What.','1972-12-24 03:26:21'),
('19','36','33','Dormouse shall!\' they both cried. \'Wake up, Alice dear!\' said her sister; \'Why, what are YOUR shoes done with?\' said the Duck: \'it\'s generally a ridge or furrow in the other: he came trotting along.','1994-11-29 20:18:13'),
('20','21','39','Mock Turtle replied in a large kitchen, which was the BEST butter, you know.\' \'Who is this?\' She said this last remark, \'it\'s a vegetable. It doesn\'t look like one, but it had been, it suddenly.','2004-03-06 06:20:45'); 



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

INSERT INTO `friend_requests` VALUES ('21','24','declined','1996-06-14 23:14:17','1996-12-19 01:45:58'),
('23','21','requested','2007-02-23 12:02:14','1981-09-14 17:27:04'),
('23','24','approved','1978-05-11 09:02:11','1997-03-29 07:13:23'),
('23','26','approved','2018-02-23 20:38:13','2012-03-03 00:56:36'),
('23','32','requested','1990-01-05 23:41:01','1999-05-14 19:07:53'),
('26','25','approved','1995-03-24 19:46:56','1973-08-31 06:54:33'),
('28','21','unfriended','1992-12-22 18:57:16','1990-11-15 02:06:45'),
('28','24','requested','1974-09-20 16:14:11','2000-09-20 15:10:32'),
('28','25','approved','1990-05-22 12:16:47','1980-04-01 05:53:10'),
('28','26','unfriended','2009-10-12 16:07:06','1977-10-10 06:58:23'),
('30','28','unfriended','1979-03-05 10:45:33','1974-08-02 23:14:23'),
('30','31','requested','2006-12-10 17:58:52','1971-06-17 06:30:15'),
('31','36','unfriended','1974-02-22 22:44:16','1987-05-24 01:43:13'),
('32','21','unfriended','2019-07-20 08:06:28','2005-04-12 16:52:50'),
('36','36','declined','2019-11-30 11:13:22','1990-05-24 18:49:42'),
('37','23','approved','2014-03-18 09:03:18','1982-06-13 11:52:36'),
('37','24','approved','1990-12-28 20:03:33','2017-06-01 16:54:56'),
('37','31','unfriended','1976-09-23 15:58:14','1993-05-02 22:03:10'),
('37','32','requested','1996-11-27 19:36:32','2006-06-20 21:36:13'); 



drop table if exists media_types;
create table media_types (
id SERIAL PRIMARY KEY,
name VARCHAR(255),
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP 
);

INSERT INTO `media_types` VALUES ('1','est','1979-08-07 20:53:38','2010-04-03 20:05:17'),
('2','dolorem','1989-06-13 16:00:37','1981-04-09 05:29:21'),
('3','in','1979-09-02 08:43:20','2013-05-11 10:03:36'),
('4','eveniet','1997-09-09 02:50:21','1992-07-16 09:19:21'),
('5','illum','2005-04-05 01:54:19','2019-10-13 11:55:03'),
('6','iure','1982-10-26 16:08:42','1988-05-25 18:47:54'),
('7','in','2014-08-01 02:23:58','2018-11-30 21:19:46'),
('8','temporibus','2017-09-08 22:21:42','1978-10-14 19:52:11'),
('9','ratione','1986-05-30 04:06:19','1973-02-21 03:09:24'),
('10','esse','1992-09-22 03:45:35','1997-09-04 10:50:59'); 

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

INSERT INTO `media` VALUES ('1','1','21','Sint error nisi asperiores suscipit laboriosam ipsa occaecati.','quidem','2829',NULL,'1984-02-08 13:11:30','1984-01-20 23:23:39'),
('2','2','23','Magni dicta saepe velit.','temporibus','14',NULL,'2003-07-28 00:20:16','2002-03-18 19:00:25'),
('3','3','24','Error consequatur nulla id nobis.','explicabo','6804321',NULL,'2010-12-15 01:45:01','1972-08-12 14:24:06'),
('4','4','25','Voluptatem quis nam beatae at ut deleniti.','temporibus','2578',NULL,'2010-06-15 00:51:34','1971-11-17 12:52:36'),
('5','5','26','Corrupti totam culpa enim rerum at.','non','1540137',NULL,'1973-07-04 09:18:07','1977-07-04 03:33:47'),
('6','6','28','Cum doloremque error vitae rem ut perferendis.','quaerat','5276',NULL,'2018-12-24 04:43:20','1985-11-20 03:59:28'),
('7','7','30','Officia velit corrupti rerum et dolorem libero deleniti.','saepe','857803',NULL,'1992-10-12 18:09:20','1973-02-25 09:03:11'),
('8','8','31','Voluptate itaque et omnis ea voluptatibus ratione dolorem vel.','possimus','43832',NULL,'2003-01-24 00:01:26','1998-04-21 15:13:38'),
('9','9','32','Sit aut nisi totam nemo et iste dolores repudiandae.','dolorem','0',NULL,'1975-01-05 21:23:29','2010-06-02 09:43:20'),
('10','10','33','Laboriosam quod placeat adipisci.','ut','205622602',NULL,'2016-12-10 00:54:00','1975-06-23 09:07:12'),
('11','1','36','Et sunt illo consequatur enim et velit.','optio','5',NULL,'1995-06-21 13:36:25','1981-12-01 23:46:12'),
('12','2','37','Ab labore ratione aspernatur.','vero','7',NULL,'1977-12-15 14:13:04','2007-12-06 14:52:26'),
('13','3','39','Eaque distinctio voluptas voluptatem quis ut expedita.','repellat','126580',NULL,'1973-08-15 19:53:53','2011-09-30 19:56:21'),
('14','4','21','Minus voluptatem beatae iure quod laudantium excepturi ratione.','laudantium','98',NULL,'2012-07-19 22:15:50','2002-10-24 15:27:11'),
('15','5','23','Cum porro dolores nisi atque.','cum','1361398',NULL,'1987-07-21 00:23:32','1978-01-29 12:51:52'),
('16','6','24','Et at consequatur ipsa autem veritatis.','ut','3',NULL,'1991-08-22 14:49:30','1972-01-12 20:36:43'),
('17','7','25','Est debitis nisi dolorum quis magni.','id','7325310',NULL,'1971-03-11 14:25:12','2015-01-30 22:37:25'),
('18','8','26','Deleniti commodi consequatur ea est soluta.','sed','61',NULL,'2020-04-15 13:18:38','2003-01-08 01:52:44'),
('19','9','28','Facere voluptatem hic in ducimus est aut ratione.','occaecati','0',NULL,'1971-12-21 12:47:50','2003-11-08 01:59:45'),
('20','10','30','At ex nostrum sequi qui quisquam.','molestiae','37034',NULL,'2004-01-11 16:05:10','1999-08-25 22:21:10'); 


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

INSERT INTO `likes` VALUES ('21','1','unliked','2010-09-14 21:10:53'),
('21','14','unliked','2008-02-04 01:58:46'),
('23','2','liked','2011-12-24 06:55:57'),
('23','15','liked','2017-10-18 07:36:02'),
('24','3','liked','2015-03-17 16:10:23'),
('24','16','liked','2003-05-18 08:12:48'),
('25','4','liked','1971-04-06 13:40:17'),
('25','17','unliked','1990-11-28 16:29:15'),
('26','5','liked','1996-12-13 04:05:50'),
('26','18','liked','1979-10-22 07:01:45'),
('28','6','unliked','1976-10-30 03:49:39'),
('28','19','unliked','2007-06-30 00:01:51'),
('30','7','unliked','2008-10-03 12:08:48'),
('30','20','unliked','1982-05-13 00:02:01'),
('31','8','unliked','1992-08-20 18:18:51'),
('32','9','unliked','1977-12-13 08:44:56'),
('33','10','unliked','2003-04-18 01:03:21'),
('36','11','liked','1983-03-03 09:25:39'),
('37','12','liked','1985-08-15 03:17:09'),
('39','13','liked','2003-11-10 23:33:54'); 


drop table if exists communities;
create table communities (
id SERIAL PRIMARY KEY,
name varchar(150),

index communities_name_idx(name)
);

INSERT INTO `communities` VALUES ('7','aut'),
('17','aut'),
('9','delectus'),
('20','delectus'),
('1','dolorem'),
('8','est'),
('3','et'),
('5','et'),
('4','fugiat'),
('14','laudantium'),
('6','modi'),
('12','non'),
('10','praesentium'),
('18','quasi'),
('15','quis'),
('16','repudiandae'),
('19','rerum'),
('11','suscipit'),
('2','tempore'),
('13','ut'); 


drop table if exists users_communities;
create table users_communities (
user_id BIGINT unsigned not null,
community_id BIGINT unsigned not null,

PRIMARY KEY (user_id, community_id),
FOREIGN KEY (user_id) references users(id),
FOREIGN KEY (community_id) references communities(id)
);

INSERT INTO `users_communities` VALUES ('21','1'),
('21','14'),
('23','2'),
('23','15'),
('24','3'),
('24','16'),
('25','4'),
('25','17'),
('26','5'),
('26','18'),
('28','6'),
('28','19'),
('30','7'),
('30','20'),
('31','8'),
('32','9'),
('33','10'),
('36','11'),
('37','12'),
('39','13'); 

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
id SERIAL,
album_name varchar(255) default null,
user_id BIGINT UNSIGNED,
foreign key (user_id) references users(id),
primary key (id)
);

INSERT INTO photo_albums VALUES ('1','first album', '23'),
('2', 'second album', '24');

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
id serial primary key,
album_id bigint unsigned not null, 
media_id bigint unsigned not null,
`description` text,

foreign key (album_id) references photo_albums(id),
foreign key (media_id) references media(id)
);

INSERT INTO photos VALUES ('1','1', '12', 'just a photo');

