-- List all movies in the ‘Action’ category.
SELECT f.title AS movies
FROM film AS f
JOIN film_category fc on f.film_id = fc.film_id
JOIN category c on c.category_id = fc.category_id
WHERE  c.name = 'Action';


-- Find all customers who have spent more than $100.
SELECT concat(c.first_name, ' ', c.last_name) AS name
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING SUM(p.amount) > 100;


-- Find all movies that actor 'Kevin Bloom' has acted in.
SELECT f.title
FROM film f
INNER JOIN film_actor fa on f.film_id = fa.film_id
INNER JOIN actor a on a.actor_id = fa.actor_id
WHERE a.first_name = 'Kevin' AND a.last_name = 'Bloom';


-- List all the actors who have appeared in more than 20 movies.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as film_count
FROM actor a
INNER JOIN film_actor fa on a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 20;


-- List all the customers who have rented a movie more than once in a single day.
SELECT first_name, last_name, COUNT(r.rental_id)
FROM customer AS c
INNER JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, r.rental_date
HAVING COUNT(rental_date) > 1;


-- List all the movies that have not been rented yet.
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date IS NULL;


-- List all the customers who have rented a movie in the ‘Action’ category but not in the ‘Comedy’ category.
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON ca.category_id = fc.category_id
WHERE ca.name = 'Action'
AND c.customer_id NOT IN (
    SELECT c2.customer_id
    FROM customer c2
    JOIN rental r2 ON c2.customer_id = r2.customer_id
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON f2.film_id = i2.film_id
    JOIN film_category fc2 ON f2.film_id = fc2.film_id
    JOIN category ca2 ON ca2.category_id = fc2.category_id
    WHERE ca2.name = 'Comedy'
)
GROUP BY c.customer_id;


-- List all the movies that have been rented more than 50 times.
SELECT f.title
FROM film AS f
JOIN inventory i on f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.title
HAVING count(rental_id) > 50;


-- List all the movies that have been rented by a customer who has a first name starting with ‘J’.
SELECT f.title
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN customer AS c ON r.customer_id = c.customer_id
WHERE c.first_name LIKE 'J%'
GROUP BY f.title;


-- List all the movies that have been rented more than once by the same customer.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY f.title, c.customer_id
HAVING COUNT(r.rental_id) > 1;


-- List all the movies that were released in 2006.
SELECT f.title
FROM film f
WHERE f.release_year = 2006