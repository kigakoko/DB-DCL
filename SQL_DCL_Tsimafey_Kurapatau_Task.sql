create user rentaluser with password 'rentalpassword';
grant connect on database dvdrental to rentaluser;
--
grant select on table customer to rentaluser;
select * from customer;
--
create group rental;
grant rental to rentaluser;
--
grant insert, update on rental to rental;
grant usage on sequence rental_rental_id_seq to rental;

set role rentaluser;
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
values (current_timestamp, 1, 1, current_timestamp, 1, current_timestamp);
reset role;
grant select on rental to rental;
set role rentaluser;
update rental set return_date = current_timestamp where rental_id = 1;
reset role;
revoke select on rental from rental;
--
revoke insert on table rental from group rental;
--
create role client_mary_smith;
grant select on rental, payment, customer to client_mary_smith;

alter table rental enable row level security;
alter table payment enable row level security;
create policy rental_policy on rental 
  using (customer_id = (select customer_id from customer where first_name = 'MARY' and last_name = 'SMITH'));
create policy payment_policy on payment 
  using (customer_id = (select customer_id from customer where first_name = 'MARY' and last_name = 'SMITH'));

set role client_mary_smith;
select * from rental where customer_id = (select customer_id from customer where first_name = 'MARY' and last_name = 'SMITH');
select * from payment where customer_id = (select customer_id from customer where first_name = 'MARY' and last_name = 'SMITH');
reset role;




