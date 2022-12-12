-- Question 1
select t2.title
, count(distinct inventory_id) as inv_unit
from sakila.inventory t1
	inner join sakila.film t2
		on t1.film_id = t2.film_id
		and t2.title = 'Hunchback Impossible'

-- Question 2
select title
	, length 
from sakila.film
where length > (select avg(length)
				from sakila.film)
order by length desc;

-- Question 3
select concat(first_name , ' ' , last_name) as Actor_Name
from sakila.actor
where actor_id in (
			select actor_id
			from sakila.film_actor
			where film_id = (select film_id
							from sakila.film
							where title = 'Alone Trip'))

-- Question 4
select title as Title
, film_id
from sakila.film
	where film_id in (
					select film_id
					from sakila.film_category t1
						inner join category t2
							on t1.category_id = t2.category_id
							and t2.name = 'Family'
					)

-- Question 5
select concat(first_name,' ',last_name) as Customer_Full_Name
, email as Customer_Email
from sakila.customer
where address_id in (
	select address_id
	from sakila.address t2
    inner join sakila.city t3
		on t2.city_id = t3.city_id
    inner join sakila.country t4
		on t3.country_id = t4.country_id
        and t4.country = 'Canada')
        
-- Question 6
with top_actor as (select t1.actor_id
, concat(first_name , ' ' , last_name) as Actor_Name
, count(distinct t2.film_id) as film_count
from sakila.actor t1
	inner join sakila.film_actor t2
		on t1.actor_id = t2.actor_id
group by 1,2
order by film_count desc
limit 1)

select distinct t1.film_id, t3.title
from sakila.film_actor t1
	inner join top_actor t2
		on t1.actor_id = t2.actor_id
	inner join sakila.film t3
		on t1.film_id = t3.film_id;

-- Question 7
with top_customer as (select t1.customer_id
, sum(amount) as amount_spent
from sakila.customer t1
inner join sakila.payment t2
on t1.customer_id = t2.customer_id
group by 1
order by amount_spent desc
limit 1)

select t4.title
, t2.customer_id
from sakila.rental t1
	inner join sakila.inventory t3
		on t1.inventory_id = t3.inventory_id
    inner join sakila.film t4
		on t3.film_id = t4.film_id
inner join top_customer t2
	on t1.customer_id = t2.customer_id

-- Question 8
select t1.customer_id
	, sum(amount) as total_amount_spent
from sakila.customer t1
inner join sakila.payment t2
	on t1.customer_id = t2.customer_id
group by 1
having total_amount_spent > (select avg(total_payment)
					from (select customer_id
                    , sum(amount) as total_payment
                    from sakila.payment
                    group by customer_id) t)
order by total_amount_spent desc;