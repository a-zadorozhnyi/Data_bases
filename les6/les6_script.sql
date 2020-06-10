/*Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”

Пусть задан некоторый пользователь. 
1. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
*/

use vk;

alter table messages 
ADD COLUMN is_read BOOL default FALSE;
-- добавляем колонку прочитано/непрочитано в таблицу messages

select * from messages where to_user_id = 23 and is_read = TRUE order by created_at DESC; -- 

alter table communities 
ADD column admin_user_id int default 1 not null;

-- 1. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. id = 111
-- найти друзей пользователя:

select from_user_id, to_user_id, (from_user_id + to_user_id ) as pair_index, count(*) from messages where 
(from_user_id in (
(select target_user_id  from friend_requests where initiator_user_id = 111 and status = 'approved') 
union
(select initiator_user_id from friend_requests where target_user_id = 111 and status = 'approved')
) and to_user_id = 111)
or
(to_user_id in (
(select target_user_id from friend_requests where initiator_user_id = 111 and status = 'approved') 
union
(select initiator_user_id from friend_requests where target_user_id = 111 and status = 'approved')
) and from_user_id = 111) group by from_user_id, to_user_id order by count(*) desc limit 1
;


-- попробовал переписать запрос, но получил, судя по всему, то же самое.
select * from
((select COUNT(*) messages_count, from_user_id, to_user_id, (from_user_id + to_user_id) pair_id from
((select from_user_id, to_user_id from messages where from_user_id in
((select initiator_user_id id from friend_requests where target_user_id = 111 and status = 'approved')
union
(select target_user_id id from friend_requests where initiator_user_id = 111 and status = 'approved'))
and to_user_id = 111)
) as count group by pair_id order by count(*) desc)
union all
(select COUNT(*) messages_count, from_user_id, to_user_id, (from_user_id + to_user_id) pair_id from
((select from_user_id, to_user_id from messages where to_user_id in
((select initiator_user_id id from friend_requests where target_user_id = 111 and status = 'approved')
union
(select target_user_id id from friend_requests where initiator_user_id = 111 and status = 'approved'))
and from_user_id = 111)
) as count group by pair_id order by count(*) desc)) as ad order by messages_count desc limit 1; 

-- 2  Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

drop table if exists temp_tbl;
create table temp_tbl (
user_id bigint);

INSERT INTO `temp_tbl`
   SELECT user_id
   FROM (select user_id, timestampdiff(year, birthday, now()) as age from profiles order by age limit 10) as allies; 
-- таблица id 10 самых молодых пользователей. костыль, тк не дает использовать LIMIT в IN... 

select id, user_id from media where user_id in (select user_id from temp_tbl); -- медиа 10 самых молодых 
 
 select count(*) as 'summary likes' from likes where object_id in (select id from media where user_id in (select user_id from temp_tbl)) and status = 'liked'; 
 -- находим и суммируем лайки полученные медиа принадлежащих 10 самым молодым пользователям.


-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- сортировка м/ж
select user_id from profiles where gender = 'M';
select user_id from profiles where gender = 'F';

select count(*) from likes where user_id in (select user_id from profiles where gender = 'M'); -- лайки поставленные мужчинами
select count(*) from likes where user_id in (select user_id from profiles where gender = 'F'); -- лайки поставленные женщинами


-- сравнение и вывод результата
SELECT IF (
(select count(*) from likes where user_id in (select user_id from profiles where gender = 'M')) > 
(select count(*) from likes where user_id in (select user_id from profiles where gender = 'F')), 
'мужчины оставили больше лайков', 'женщины оставили больше лайков'
) as 'кто оставил больше лайков?';

-- 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

select count(*) as activity, id from ((select from_user_id as id from messages) 
union all (select user_id as id from likes) 
union all (select user_id as id from media ) 
union all (select initiator_user_id as id from friend_requests)) 
as sad group by id order by activity limit 10;




