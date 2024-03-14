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
ORDER BY unique_categories DESC
LIMIT 5;

-- Find the top 5 customers who have rented movies from the most number of unique categories.
-- Find the top 5 stores with the highest average rental rate for their movies.
-- Find the top 5 cities with the highest average rental rate for their movies.
-- Find the top 5 countries with the highest average rental rate for their movies.
-- Find the top 5 languages that have the highest average rental rate for their movies.
-- Find the top 5 ratings that have the highest average rental rate for their movies.
-- Find the top 5 actors who have acted in movies with the highest average rental rate.
-- Find the top 5 categories with the highest average rental rate for their movies.
-- Find the top 5 customers who have rented movies with the highest average rental rate.
-- Find the top 5 stores that have the most number of unique customers.
-- Find the top 5 cities that have the most number of unique customers.
-- Find the top 5 countries that have the most number of unique customers.
-- Find the top 5 languages that have the most number of unique customers.
-- Find the top 5 ratings that have the most number of unique customers.
-- Find the top 5 actors who have the most number of unique customers.
-- Find the top 5 categories that have the most number of unique customers.
-- Find the top 5 customers who have rented movies from the most number of unique actors.
-- Find the top 5 customers who have rented movies in the most number of unique languages.
-- Find the top 5 customers who have rented movies with the most number of unique ratings.
-- Find the actor who has acted in the most number of films in each language.
-- Find the customer who has rented the most number of films in each rating.
-- Find the store that has the most rentals in each month of the year.
-- Find the category of films that has the most rentals in each store.
-- Find the film that has been rented the most in each city.
-- Find the actor whose films have the highest average rental rate.
-- Find the customer who has rented films with the highest total rental rate.
-- Find the month that has the highest total rental rate for each year.
-- Find the city that has the highest average rental duration for its films.
-- Find the actor who has acted in films with the highest total length.
-- Find the customer who has rented films with the highest total length.
-- Find the category of films that has the highest average length.
-- Find the language that has the highest average length for its films.
-- Find the rating that has the highest average length for its films.
-- Find the store that has the highest average length for its films.
-- Find the city that has the highest average length for its films.
-- Find the country that has the highest average length for its films.
-- Find the month that has the highest average length for its films.
-- Find the actor whose films have been rented the most in each city.
-- Find the category of films that is most popular among customers from different stores.

-- Final Boss
-- Write a query to identify the top 5 customers who have rented the most diverse range of films in terms of categories, considering that diversity is measured by the number of unique combinations of categories rented by each customer.

-- Create a query to find the top 5 actors whose films have been rented out the least across all countries, excluding actors who have appeared in less than 10 films.

-- Implement a query to find the top 5 customers who have rented movies with the highest total rental rate per category, considering the rental rate of each movie.

-- Develop a query to find the top 5 cities where customers have the highest average rental duration for films belonging to categories with a "Parental Guidance" rating (PG).

-- Write a query to find the top 5 actors whose films have the highest average rental rate in countries where English is not the primary language spoken.

-- Create a query to find the top 5 customers who have rented movies with the highest total rental rate per language, considering the rental rate of each movie.

-- Implement a query to find the top 5 categories of films that have the highest average length, excluding categories with less than 10 films.

-- Write a query to find the top 5 customers who have rented movies from the most diverse range of countries, considering that diversity is measured by the number of unique countries from which movies have been rented by each customer.