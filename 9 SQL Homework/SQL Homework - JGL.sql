-- Activate Sakila Database
use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name, " ", last_name) as "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select actor_id,first_name,last_name
from actor
where first_name like "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like "%gen%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor where last_name like "%li%"
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
where country in ("Afghanistan","Bangladesh","China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).
alter table actor add column description blob;
select * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop column description;
select * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name)
from actor 
group by last_name
having count(last_name)>1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "Williams";
select * from actor
where first_name = "HARPO" and last_name = "Williams";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name = "GROUCHO"
where first_name = "HARPO";

select * from actor
where first_name = "GROUCHO";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.address
from staff s
left join address as a
on (s.address_id=a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.first_name, s.last_name,sum(p.amount) as "Total Amount Rung"
from staff s
left join payment as p
on (s.staff_id = p.staff_id)
group by s.last_name, s.first_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(distinct(fa.actor_id)) as "Actor Count"
from film as f
inner join film_actor as fa
on (f.film_id = fa.film_id)
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.film_id, f.title, (select count(film_id) from inventory where f.film_id = inventory.film_id) as "Number of Copies"
from film as f
where f.title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select c.first_name, c.last_name,sum(p.amount) as "Total Paid"
from customer as c
left join payment as p
on (c.customer_id = p.customer_id)
group by c.last_name
order by c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of 
-- movies starting with the letters K and Q whose language is English.
select f.title , eng.name as "Language"
from film as f, (select language_id, name from language
	where name = "English") as eng
where f.title like "K%" or title like "Q%";

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name,finalAlo.title
from actor as a,(
	select actor_id, alo.title
	from film_actor as fa, (select film_id, title from film as f where title = "Alone Trip") as alo
	where alo.film_id = fa.film_id) as finalAlo
where a.actor_id = finalAlo.actor_id;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the 
-- names and email addresses of all Canadian customers. Use joins to retrieve this information. 

-- used an implicit join + subqueries :)
select cust.first_name, cust.last_name, cust.email, coFin.country
from customer as cust, (
	select address_id, co2.country
	from address as a,(
		select c.city_id,co.country
		from city as c, (
			select country_id, country from country
			where country = "Canada") as co
		where c.country_id = co.country_id) as co2
	where a.city_id = co2.city_id) as coFin
where coFin.address_id = cust.address_id;
            
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film
where film_id in(
	select film_id from film_category
	where category_id in (
		select category_id from category
		where name = "Family"));

-- 7e. Display the most frequently rented movies in descending order.
select combine.title, count(r.rental_id) from rental as r
left join (select i.inventory_id,i.film_id,f.title from inventory as i
left join film as f on i.film_id=f.film_id) as combine
on r.inventory_id = combine.inventory_id
group by combine.title
order by count(r.rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(p.amount) from payment as p
left join staff as s
on p.staff_id = s.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id,c.city,co.country from store as s
left join address as a
on s.address_id= a.address_id
left join city as c
on a.city_id = c.city_id
left join country as co
on c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name,sum(p.amount) as "Gross Revenue" from payment as p
left join rental as r on p.rental_id = r.rental_id
left join inventory as i on r.inventory_id = i.inventory_id
left join film_category as fc on i.film_id=fc.film_id
left join category as c on fc.category_id = c.category_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres as 
select c.name,sum(p.amount) as "Gross Revenue" from payment as p
left join rental as r on p.rental_id = r.rental_id
left join inventory as i on r.inventory_id = i.inventory_id
left join film_category as fc on i.film_id=fc.film_id
left join category as c on fc.category_id = c.category_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_five_genres;