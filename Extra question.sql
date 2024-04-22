-- Find the least rented movie in each category.
WITH category_film AS (SELECT c.name, f.title, count(r.rental_id) AS times_rented
                       FROM category c
                                JOIN film_category fc USING (category_id)
                                JOIN film f USING (film_id)
                                JOIN inventory i USING (film_id)
                                JOIN rental r USING (inventory_id)
                       GROUP BY c.name, f.title
                       ORDER BY name),

     film_rank AS (SELECT name,
                          title,
                          times_rented,
                          row_number() over (partition by name order by times_rented ASC) AS rank
                   FROM category_film
                   GROUP BY name, title, times_rented)

SELECT name, title, times_rented
FROM film_rank
WHERE rank = 1
ORDER BY name;
-- Write a query to find the top 5 least rented movies in each category, along with the number of times each movie has been rented.
WITH category_film AS (SELECT c.name, f.title, count(r.rental_id) AS times_rented
                       FROM category c
                                JOIN film_category fc USING (category_id)
                                JOIN film f USING (film_id)
                                JOIN inventory i USING (film_id)
                                JOIN rental r USING (inventory_id)
                       GROUP BY c.name, f.title
                       ORDER BY name),

     film_rank AS (SELECT name,
                          title,
                          times_rented,
                          row_number() over (partition by name order by times_rented ASC) AS rank
                   FROM category_film
                   GROUP BY name, title, times_rented)

SELECT name, title, times_rented
FROM film_rank
WHERE rank <= 5
ORDER BY name;
-- Write a query to find the top 5 least profitable stores, along with the total revenue generated by each store.
WITH store_revenue AS (SELECT s.store_id, sum(p.amount) AS revenue
                       FROM store s
                                JOIN staff st USING (store_id)
                                JOIN payment p USING (staff_id)
                       GROUP BY s.store_id),

     store_rank AS (SELECT store_id,
                           revenue,
                           row_number() over (partition by store_id order by revenue ASC) AS rank
                    FROM store_revenue
                    GROUP BY store_id, revenue)

SELECT store_id, revenue
FROM store_rank
WHERE rank <= 5
ORDER BY store_id;
-- Write a query to find the top 5 least profitable cities, along with the total revenue generated by each city.
WITH city_revenue AS (SELECT c.city, sum(p.amount) AS revenue
                      FROM city c
                               JOIN address a USING (city_id)
                               JOIN staff st USING (address_id)
                               JOIN payment p USING (staff_id)
                      GROUP BY c.city),

     city_rank AS (SELECT city,
                          revenue,
                          row_number() over (partition by city order by revenue ASC) AS rank
                   FROM city_revenue
                   GROUP BY city, revenue)

SELECT city, revenue
FROM city_rank
WHERE rank <= 5
ORDER BY city;
-- Write a query to find out which month had the lowest number of rentals for each year.
WITH month_rentals AS (SELECT extract(MONTH FROM payment_date) AS month,
                              extract(YEAR FROM payment_date)  AS year,
                              count(rental_id)                 AS times_rented
                       FROM payment p
                       GROUP BY month, year),

     rental_ranks AS (SELECT month,
                             year,
                             times_rented,
                             row_number() over (PARTITION BY year ORDER BY times_rented ASC) AS rank
                      FROM month_rentals)

SELECT month, year, times_rented
FROM rental_ranks
WHERE rank = 1;
-- Write a query to find out which store has generated less revenue from action films than comedy films.
WITH action_rentals AS (SELECT st.manager_staff_id, st.store_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN store st USING (store_id)
                        WHERE c.name = 'Action'
                        GROUP BY st.manager_staff_id, st.store_id),

     comedy_rentals AS (SELECT st.manager_staff_id, st.store_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN store st USING (store_id)
                        WHERE c.name = 'Comedy'
                        GROUP BY st.manager_staff_id, st.store_id)


SELECT ar.manager_staff_id
FROM action_rentals ar
         JOIN comedy_rentals cr USING (store_id)
WHERE ar.revenue < cr.revenue;
-- Write a query to find out which country has generated less revenue from comedy films than drama films.
WITH action_rentals AS (SELECT co.country, co.country_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN address a USING (address_id)
                                 JOIN city ci USING (city_id)
                                 JOIN country co USING (country_id)
                        WHERE c.name = 'Action'
                        GROUP BY co.country, co.country_id),

     comedy_rentals AS (SELECT co.country, co.country_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN address a USING (address_id)
                                 JOIN city ci USING (city_id)
                                 JOIN country co USING (country_id)
                        WHERE c.name = 'Comedy'
                        GROUP BY co.country, co.country_id)


SELECT ar.country
FROM action_rentals ar
         JOIN comedy_rentals cr USING (country_id)
WHERE ar.revenue < cr.revenue;
-- Write a query to find out which actor’s films have been rented out the least by customers from different countries.
WITH actor_rentals AS (SELECT a.first_name, a.last_name, title, co.country, count(rental_id) as times_rented
                       FROM actor a
                                JOIN film_actor USING (actor_id)
                                JOIN film USING (film_id)
                                JOIN inventory USING (film_id)
                                JOIN rental USING (inventory_id)
                                JOIN customer c USING (customer_id)
                                JOIN address USING (address_id)
                                JOIN city ci USING (city_id)
                                JOIN country co USING (country_id)
                       GROUP BY a.first_name, a.last_name, title, co.country),

     rental_rank AS (SELECT first_name,
                            last_name,
                            title,
                            country,
                            times_rented,
                            row_number() over (partition by country order by times_rented ASC) as rank
                     FROM actor_rentals)


SELECT first_name, last_name, title, country, times_rented
FROM rental_rank
WHERE rank = 1
ORDER BY country;
-- Write a query to find out which category of films is least popular among customers from different countries.
WITH actor_rentals AS (SELECT ca.name, co.country, count(rental_id) as times_rented
                       FROM category ca
                                JOIN film_category USING (category_id)
                                JOIN film USING (film_id)
                                JOIN inventory USING (film_id)
                                JOIN rental USING (inventory_id)
                                JOIN customer c USING (customer_id)
                                JOIN address USING (address_id)
                                JOIN city ci USING (city_id)
                                JOIN country co USING (country_id)
                       GROUP BY ca.name, title, co.country),

     rental_rank AS (SELECT name,
                            country,
                            times_rented,
                            row_number() over (partition by country order by times_rented ASC) as rank
                     FROM actor_rentals)


SELECT name, country, times_rented
FROM rental_rank
WHERE rank = 1
ORDER BY country;
-- Write a query to find out which store has generated less revenue from action films than comedy films.
WITH action_rentals AS (SELECT s.manager_staff_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN store s USING (store_id)
                        WHERE c.name = 'Action'
                        GROUP BY s.manager_staff_id),

     comedy_rentals AS (SELECT s.manager_staff_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN store s USING (store_id)
                        WHERE c.name = 'Comedy'
                        GROUP BY s.manager_staff_id)


SELECT manager_staff_id
FROM action_rentals ar
         JOIN comedy_rentals cr USING (manager_staff_id)
WHERE ar.revenue < cr.revenue;
-- Write a query to find out which country has generated less revenue from comedy films than drama films.
WITH action_rentals AS (SELECT co.country, co.country_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN address a USING (address_id)
                                 JOIN city ci USING (city_id)
                                 JOIN country co USING (country_id)
                        WHERE c.name = 'Action'
                        GROUP BY co.country, co.country_id),

     comedy_rentals AS (SELECT co.country, co.country_id, sum(p.amount) as revenue
                        FROM category c
                                 JOIN film_category USING (category_id)
                                 JOIN film USING (film_id)
                                 JOIN inventory USING (film_id)
                                 JOIN rental USING (inventory_id)
                                 JOIN payment p USING (rental_id)
                                 JOIN staff st USING (store_id)
                                 JOIN address a USING (address_id)
                                 JOIN city ci USING (city_id)
                                 JOIN country co USING (country_id)
                        WHERE c.name = 'Comedy'
                        GROUP BY co.country, co.country_id)


SELECT ar.country
FROM action_rentals ar
         JOIN comedy_rentals cr USING (country_id)
WHERE ar.revenue < cr.revenue;
-- Write a query to find out which actor’s films have been rented out the least by customers from different countries.
WITH actor_rentals AS (SELECT a.first_name, a.last_name, count(rental_id) as times_rented
                       FROM actor a
                                JOIN film_actor USING (actor_id)
                                JOIN film USING (film_id)
                                JOIN inventory USING (film_id)
                                JOIN rental USING (inventory_id)
                                JOIN customer c USING (customer_id)
                                JOIN address USING (address_id)
                                JOIN city ci USING (city_id)
                                JOIN country co USING (country_id)
                       GROUP BY a.first_name, a.last_name, title, co.country),

     rental_rank AS (SELECT first_name,
                            last_name,
                            times_rented,
                            row_number() over (partition by first_name, last_name order by times_rented ASC) as rank
                     FROM actor_rentals)

SELECT first_name,
       last_name,
       times_rented
FROM rental_rank
WHERE rank = 1
ORDER BY times_rented;
-- Find the top 5 actors who have acted in the most number of unique categories.
SELECT a.first_name,
       a.last_name,
       COUNT(DISTINCT c.category_id) as unique_categorie_number
FROM actor a
         JOIN film_actor fa ON a.actor_id = fa.actor_id
         JOIN film_category fc ON fa.film_id = fc.film_id
         JOIN category c ON fc.category_id = c.category_id
GROUP BY a.first_name, a.last_name
ORDER BY unique_categorie_number DESC
LIMIT 5;
-- Find the top 5 customers who have rented movies from the most number of unique categories.
SELECT c.first_name,
       c.last_name,
       COUNT(DISTINCT ct.category_id) as unique_categorie_number
FROM customer c
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
         JOIN film_category fc ON f.film_id = fc.film_id
         JOIN category ct ON fc.category_id = ct.category_id
GROUP BY c.first_name, c.last_name
ORDER BY unique_categorie_number DESC
LIMIT 5;
-- Find the top 5 stores with the highest average rental rate for their movies.
SELECT st.address_id, avg(p.amount) AS average_rate
FROM payment p
         JOIN staff s USING (staff_id)
         JOIN store st USING (store_id)
GROUP BY st.address_id
ORDER BY average_rate DESC
LIMIT 5;
-- Find the top 5 cities with the highest average rental rate for their movies.
SELECT c.city, avg(p.amount) AS average_rate
FROM payment p
         JOIN staff s USING (staff_id)
         JOIN address a USING (address_id)
         JOIN city c USING (city_id)
GROUP BY c.city
ORDER BY average_rate DESC
LIMIT 5;
-- Find the top 5 countries with the highest average rental rate for their movies.
SELECT c.country, avg(p.amount) AS average_rate
FROM payment p
         JOIN staff s USING (staff_id)
         JOIN address a USING (address_id)
         JOIN city ct USING (city_id)
         JOIN country c USING (country_id)
GROUP BY c.country
ORDER BY average_rate DESC
LIMIT 5;
-- Find the top 5 languages that have the highest average rental rate for their movies.
SELECT l.name, avg(p.amount) AS average_rate
FROM payment p
         JOIN rental r USING (rental_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
         JOIN language l USING (language_id)
GROUP BY l.name
ORDER BY average_rate DESC
LIMIT 5;
-- Find the top 5 ratings that have the highest average rental rate for their movies.
SELECT DISTINCT rating, AVG(rental_rate) AS average_rental_rate
FROM film
group by rating
ORDER BY average_rental_rate DESC
LIMIT 5;
-- Find the top 5 actors who have acted in movies with the highest average rental rate.
SELECT DISTINCT a.first_name, a.last_name, AVG(rental_rate) AS average_rental_rate
FROM film
         JOIN film_actor fa USING (film_id)
         JOIN actor a USING (actor_id)
group by a.first_name, a.last_name
ORDER BY average_rental_rate DESC
LIMIT 5;
-- Find the top 5 categories with the highest average rental rate for their movies.
SELECT DISTINCT c.name, AVG(rental_rate) AS average_rental_rate
FROM film
         JOIN film_category fc USING (film_id)
         JOIN category c USING (category_id)
group by c.name
ORDER BY average_rental_rate DESC
LIMIT 5;
-- Find the top 5 customers who have rented movies with the highest average rental rate.
SELECT DISTINCT cu.first_name, cu.last_name, AVG(rental_rate) AS average_rental_rate
FROM film
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN customer cu USING (customer_id)
group by cu.first_name, cu.last_name
ORDER BY average_rental_rate DESC
LIMIT 5;
-- Find the top 5 stores that have the most number of unique customers.
SELECT DISTINCT s.address_id, count(cu.customer_id) AS number_of_customers
FROM store s
         JOIN staff st USING (store_id)
         JOIN customer cu USING (store_id)
group by s.address_id
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 cities that have the most number of unique customers.
SELECT DISTINCT c.city, count(cu.customer_id) AS number_of_customers
FROM city c
         JOIN address a USING (city_id)
         JOIN customer cu USING (address_id)
group by c.city
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 countries that have the most number of unique customers.
SELECT DISTINCT co.country, count(cu.customer_id) AS number_of_customers
FROM country co
         JOIN city c USING (country_id)
         JOIN address a USING (city_id)
         JOIN customer cu USING (address_id)
group by co.country
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 languages that have the most number of unique customers.
SELECT DISTINCT l.name, count(cu.customer_id) AS number_of_customers
FROM language l
         JOIN film f USING (language_id)
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN customer cu USING (customer_id)
group by l.name
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 ratings that have the most number of unique customers.
SELECT DISTINCT f.rating, count(cu.customer_id) AS number_of_customers
FROM film f
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN customer cu USING (customer_id)
group by f.rating
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 actors who have the most number of unique customers.
SELECT DISTINCT a.first_name, a.last_name, count(cu.customer_id) AS number_of_customers
FROM actor a
         JOIN film_actor fa USING (actor_id)
         JOIN film f USING (film_id)
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN customer cu USING (customer_id)
group by a.first_name, a.last_name
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 categories that have the most number of unique customers.
SELECT DISTINCT c.name, count(cu.customer_id) AS number_of_customers
FROM category c
         JOIN film_category fc USING (category_id)
         JOIN film f USING (film_id)
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN customer cu USING (customer_id)
group by c.name
ORDER BY number_of_customers DESC
LIMIT 5;
-- Find the top 5 customers who have rented movies from the most number of unique actors.
SELECT DISTINCT c.first_name, c.last_name, count(a.actor_id) AS number_of_actors
FROM customer c
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
         JOIN film_actor fa USING (film_id)
         JOIN actor a USING (actor_id)
group by c.first_name, c.last_name
ORDER BY number_of_actors DESC
LIMIT 5;
-- Find the top 5 customers who have rented movies in the most number of unique languages.
SELECT DISTINCT c.first_name, c.last_name, count(l.language_id) AS number_of_languages
FROM customer c
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
         JOIN language l USING (language_id)
group by c.first_name, c.last_name
ORDER BY number_of_languages DESC
LIMIT 5;
-- Find the top 5 customers who have rented movies with the most number of unique ratings.
SELECT DISTINCT c.first_name, c.last_name, count(f.rating) AS number_of_ratings
FROM customer c
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
group by c.first_name, c.last_name
ORDER BY number_of_ratings DESC
LIMIT 5;
-- Find the actor who has acted in the most number of films in each language.
WITH actor_language AS (SELECT l.name, a.first_name, a.last_name, COUNT(f.film_id) AS film_count
                        FROM actor a
                                 JOIN film_actor fa USING (actor_id)
                                 JOIN film f USING (film_id)
                                 JOIN language l USING (language_id)
                        GROUP BY a.first_name, a.last_name, l.name
                        ORDER BY film_count DESC),

     actor_language_rank AS (SELECT name,
                                    first_name,
                                    last_name,
                                    film_count,
                                    row_number() over (partition by name order by film_count desc) AS rank
                             FROM actor_language)

SELECT name, first_name, last_name, film_count
FROM actor_language_rank
WHERE rank = 1;
-- Find the customer who has rented the most number of films in each rating.
WITH customer_ratings AS (SELECT f.rating, c.first_name, c.last_name, COUNT(f.film_id) AS film_count
                          FROM customer c
                                   JOIN rental r USING (customer_id)
                                   JOIN inventory i USING (inventory_id)
                                   JOIN film f USING (film_id)
                          GROUP BY c.first_name, c.last_name, f.rating
                          ORDER BY film_count DESC),

     customer_ratings_rank AS (SELECT rating,
                                      first_name,
                                      last_name,
                                      film_count,
                                      row_number() over (partition by rating order by film_count desc) AS rank
                               FROM customer_ratings)

SELECT rating, first_name, last_name, film_count
FROM customer_ratings_rank
WHERE rank = 1
ORDER BY rating DESC;
-- Find the store that has the most rentals in each month of the year.
WITH store_rentals AS (SELECT s.address_id,
                              extract(MONTH from p.payment_date) AS month,
                              count(r.rental_id)                 AS film_count
                       FROM store s
                                JOIN staff st USING (store_id)
                                JOIN payment p USING (staff_id)
                                JOIN rental r USING (rental_id)
                       GROUP BY s.address_id, p.payment_date
                       ORDER BY film_count DESC),

     store_rentals_rank AS (SELECT address_id,
                                   month,
                                   film_count,
                                   row_number() over (partition by month order by film_count desc) AS rank
                            FROM store_rentals)

SELECT address_id, month, film_count
FROM store_rentals_rank
WHERE rank = 1
ORDER BY month DESC;
-- Find the category of films that has the most rentals in each store.
WITH store_rentals AS (SELECT c.name,
                              extract(MONTH from p.payment_date) AS month,
                              count(r.rental_id)                 AS film_count
                       FROM category c
                                JOIN film_category fc USING (category_id)
                                JOIN inventory i USING (film_id)
                                JOIN rental r USING (inventory_id)
                                JOIN payment p USING (rental_id)
                       GROUP BY c.name, p.payment_date
                       ORDER BY film_count DESC),

     store_rentals_rank AS (SELECT name,
                                   month,
                                   film_count,
                                   row_number() over (partition by month order by film_count desc) AS rank
                            FROM store_rentals)

SELECT name, month, film_count
FROM store_rentals_rank
WHERE rank = 1
ORDER BY month DESC;
-- Find the film that has been rented the most in each city.
WITH city_rentals AS (SELECT f.title,
                             ci.city,
                             count(r.rental_id) AS film_count
                      FROM film f

                               JOIN inventory i USING (film_id)
                               JOIN rental r USING (inventory_id)
                               JOIN customer c USING (customer_id)
                               JOIN address a USING (address_id)
                               JOIN city ci USING (city_id)

                      GROUP BY f.title, ci.city
                      ORDER BY film_count DESC),

     city_rentals_rank AS (SELECT title,
                                  city,
                                  film_count,
                                  row_number() over (partition by city order by film_count desc) AS rank
                           FROM city_rentals)

SELECT title,
       city,
       film_count
FROM city_rentals_rank
WHERE rank = 1
ORDER BY city;
-- Find the actor whose films have the highest average rental rate.
SELECT a.first_name, a.last_name, avg(p.amount)
FROM actor a
         JOIN film_actor fa USING (actor_id)
         JOIN film f USING (film_id)
         JOIN inventory i USING (film_id)
         JOIN rental r USING (inventory_id)
         JOIN payment p USING (rental_id)
GROUP BY a.first_name, a.last_name
ORDER BY avg(p.amount) DESC
LIMIT 1;
-- Find the customer who has rented films with the highest total rental rate.
SELECT c.first_name, c.last_name, f.title, SUM(p.amount) AS total_spent
FROM customer c
         JOIN payment p USING (customer_id)
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
GROUP BY c.first_name, c.last_name, f.title
ORDER BY total_spent DESC
LIMIT 1;
-- Find the month that has the highest total rental rate for each year.
WITH store_rentals AS (SELECT extract(MONTH from payment_date) AS month,
                              extract(YEAR from payment_date)  AS year,
                              sum(amount)                      AS total_rent_rate
                       FROM payment p
                       GROUP BY payment_date
                       ORDER BY total_rent_rate DESC),

     store_rentals_rank AS (SELECT month,
                                   year,
                                   total_rent_rate,
                                   row_number() over (partition by year order by total_rent_rate desc) AS rank
                            FROM store_rentals)

SELECT month,
       year,
       total_rent_rate
FROM store_rentals_rank
WHERE rank = 1
ORDER BY month DESC;
-- Find the city that has the highest average rental duration for its films.
WITH city_rental_duration AS (SELECT c.city, avg(r.return_date - r.rental_date) AS average_rental_length
                              FROM city c
                                       JOIN address a USING (city_id)
                                       JOIN customer ct USING (address_id)
                                       JOIN rental r USING (customer_id)
                              group by c.city),

     city_rental_duration_rank AS (SELECT city,
                                          average_rental_length,
                                          row_number()
                                          over (partition by city order by average_rental_length desc) AS rank
                                   FROM city_rental_duration)

SELECT city,
       average_rental_length
FROM city_rental_duration_rank
WHERE rank = 1
ORDER BY average_rental_length DESC
LIMIT 1;
-- Find the actor who has acted in films with the highest total length.
SELECT a.first_name, a.last_name, sum(f.length) as total_length
FROM actor a
         JOIN film_actor fa USING (actor_id)
         JOIN film f USING (film_id)
GROUP BY a.first_name, a.last_name
ORDER BY total_length DESC
LIMIT 1;
-- Find the customer who has rented films with the highest total length.
SELECT a.first_name, a.last_name, sum(f.length) as total_length
FROM customer a
         JOIN rental r USING (customer_id)
         JOIN inventory i USING (inventory_id)
         JOIN film f USING (film_id)
GROUP BY a.first_name, a.last_name
ORDER BY total_length DESC
LIMIT 1;
-- Find the category of films that has the highest average length.
SELECT c.name, avg(f.length) AS average_film_length
FROM category c
         JOIN film_category fc USING (category_id)
         JOIN film f USING (film_id)
GROUP BY c.name
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the language that has the highest average length for its films.
SELECT l.name, avg(f.length) AS average_film_length
FROM language l
         JOIN film f USING (language_id)
GROUP BY l.name
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the rating that has the highest average length for its films.
SELECT f.rating, avg(f.length) AS average_film_length
FROM film f
GROUP BY f.rating
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the store that has the highest average length for its films.
SELECT s.address_id, a.address, avg(f.length) AS average_film_length
FROM film f
         JOIN inventory USING (film_id)
         JOIN rental USING (inventory_id)
         JOIN store s USING (store_id)
         JOIN address a ON a.address_id = s.address_id
GROUP BY s.address_id, a.address
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the city that has the highest average length for its films.
SELECT c.city, avg(f.length) AS average_film_length
FROM film f
         JOIN inventory USING (film_id)
         JOIN rental USING (inventory_id)
         JOIN store s USING (store_id)
         JOIN address a ON a.address_id = s.address_id
         JOIN city c ON a.city_id = c.city_id
GROUP BY c.city
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the country that has the highest average length for its films.
SELECT c.country, avg(f.length) AS average_film_length
FROM film f
         JOIN inventory USING (film_id)
         JOIN rental USING (inventory_id)
         JOIN store s USING (store_id)
         JOIN address a ON a.address_id = s.address_id
         JOIN city ct ON a.city_id = ct.city_id
         JOIN country c ON ct.country_id = c.country_id
GROUP BY c.country
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the month that has the highest average length for its films.
SELECT extract(MONTH from r.rental_date), avg(f.length) AS average_film_length
FROM film f
         JOIN inventory USING (film_id)
         JOIN rental r USING (inventory_id)
GROUP BY r.rental_date
ORDER BY average_film_length DESC
LIMIT 1;
-- Find the actor whose films have been rented the most in each city.
WITH store_rentals AS (SELECT a.first_name,
                              a.last_name,
                              ci.city,
                              count(r.rental_id) AS times_rented
                       FROM actor a
                                JOIN film_actor fa USING (actor_id)
                                JOIN film f USING (film_id)
                                JOIN inventory i USING (film_id)
                                JOIN rental r USING (inventory_id)
                                JOIN customer c USING (customer_id)
                                JOIN address ad USING (address_id)
                                JOIN city ci USING (city_id)
                       group by a.first_name, a.last_name, ci.city
                       ORDER BY times_rented DESC),

     store_rentals_rank AS (SELECT first_name,
                                   last_name,
                                   city,
                                   times_rented,
                                   row_number() over (partition by city order by times_rented desc) AS rank
                            FROM store_rentals)

SELECT first_name,
       last_name,
       city,
       times_rented
FROM store_rentals_rank
WHERE rank = 1
ORDER BY city DESC;
-- Find the category of films that is most popular among customers from different stores.
WITH store_rentals AS (SELECT c.name,
                              s.address_id,
                              count(c.category_id) AS number_od_films_in_category
                       FROM category c
                                JOIN film_category fc USING (category_id)
                                JOIN film f USING (film_id)
                                JOIN inventory i USING (film_id)
                                JOIN rental r USING (inventory_id)
                                JOIN payment p USING (rental_id)
                                JOIN staff st USING (store_id)
                                JOIN store s USING (store_id)

                       group by s.address_id, c.name),

     store_rentals_rank AS (SELECT name,
                                   address_id,
                                   number_od_films_in_category,
                                   row_number()
                                   over (partition by address_id order by number_od_films_in_category desc) AS rank
                            FROM store_rentals)

SELECT name,
       address_id,
       number_od_films_in_category
FROM store_rentals_rank
WHERE rank = 1
ORDER BY number_od_films_in_category DESC;
-- Final Boss
-- Write a query to identify the top 5 customers who have rented the most diverse range of films in terms of categories, considering that diversity is measured by the number of unique combinations of categories rented by each customer.

-- Create a query to find the top 5 actors whose films have been rented out the least across all countries, excluding actors who have appeared in less than 10 films.

-- Implement a query to find the top 5 customers who have rented movies with the highest total rental rate per category, considering the rental rate of each movie.

-- Develop a query to find the top 5 cities where customers have the highest average rental duration for films belonging to categories with a "Parental Guidance" rating (PG).

-- Write a query to find the top 5 actors whose films have the highest average rental rate in countries where English is not the primary language spoken.

-- Create a query to find the top 5 customers who have rented movies with the highest total rental rate per language, considering the rental rate of each movie.

-- Implement a query to find the top 5 categories of films that have the highest average length, excluding categories with less than 10 films.

-- Write a query to find the top 5 customers who have rented movies from the most diverse range of countries, considering that diversity is measured by the number of unique countries from which movies have been rented by each customer.