-- CRUD operations

-- INSERT INTO

use vk;

insert into `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
values ('45', 'Lu', 'Kim', 'k11im@example.com', '188242012'); 

insert into `users`values 
('46', 'Lung', 'Kim', 'k211im@example.com', '18242012'); 

insert into users
SET
	firstname = 'Ivan',
    lastname = 'Zarovec',
    email = 'I_zar@example.com',
    phone = '654657654'
;

insert into vk.`users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
select `id`, `firstname`, `lastname`, `email`, `phone`
from add_db.users;    
    
update friend_requests 
set
	status = 'approved',
    confirmed_at = NOW()
WHERE initiator_user_id = 21 and target_user_id = 24;
    
    update friend_requests 
set
	target_user_id = '28',
    confirmed_at = NOW()
WHERE initiator_user_id = 36 and target_user_id = 36;

delete from users
where firstname = 'Ivan' and lastname = 'Zarovec';

truncate messages;