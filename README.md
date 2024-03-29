# **PostgreSQL Practice Exercises**

## Table of Contents

### <a id="beginner"></a>Beginner
- [List all movies in the ‘Action’ category.](#list-all-movies-in-the-action-category)
- [Find all customers who have spent more than $100.](#find-all-customers-who-have-spent-more-than-100)
- [Find all movies that actor 'Kevin Bloom' has acted in.](#find-all-movies-that-actor-kevin-bloom-has-acted-in)
- [List all the actors who have appeared in more than 20 movies.](#list-all-the-actors-who-have-appeared-in-more-than-20-movies)
- [List all the customers who have rented a movie more than once in a single day.](#list-all-the-customers-who-have-rented-a-movie-more-than-once-in-a-single-day)
- [List all the movies that have not been rented yet.](#list-all-the-movies-that-have-not-been-rented-yet)
- [List all the customers who have rented a movie in the ‘Action’ category but not in the ‘Comedy’ category.](#list-all-the-customers-who-have-rented-a-movie-in-the-action-category-but-not-in-the-comedy-category)
- [List all the movies that have been rented more than 50 times.](#list-all-the-movies-that-have-been-rented-more-than-50-times)
- [List all the movies that have been rented by a customer who has a first name starting with ‘J’.](#list-all-the-movies-that-have-been-rented-by-a-customer-who-has-a-first-name-starting-with-j)
- [List all the movies that have been rented more than once by the same customer.](#list-all-the-movies-that-have-been-rented-more-than-once-by-the-same-customer)
- [List all the movies that were released in 2006.](#list-all-the-movies-that-were-released-in-2006)
- [Find all movies that are longer than 2 hours.](#find-all-movies-that-are-longer-than-2-hours)
- [Find all movies that are rated ‘PG-13’.](#find-all-movies-that-are-rated-pg-13)
- [List all the films that have ‘Love’ in their title.](#list-all-the-films-that-have-love-in-their-title)
- [Find all movies that were rented in the last 7 days.](#find-all-movies-that-were-rented-in-the-last-7-days)

### <a id="intermediate"></a>Intermediate
- [Find the most popular movie (the movie that has been rented the most).](#find-the-most-popular-movie-the-movie-that-has-been-rented-the-most)
- [Find the total rentals by store.](#find-the-total-rentals-by-store)
- [Find the top 5 customers who have rented the most movies.](#find-the-top-5-customers-who-have-rented-the-most-movies)
- [Find the average rental duration for each movie category.](#find-the-average-rental-duration-for-each-movie-category)
- [Find the total revenue generated by each movie category.](#find-the-total-revenue-generated-by-each-movie-category)
- [Find the top 10 most rented movies in the ‘Drama’ category.](#find-the-top-10-most-rented-movies-in-the-drama-category)
- [Find the average rental duration for each store.](#find-the-average-rental-duration-for-each-store)
- [Find the customers who have rented the most number of movies in each city.](#find-the-customers-who-have-rented-the-most-number-of-movies-in-each-city)
- [Find the total number of rentals for each customer.](#find-the-total-number-of-rentals-for-each-customer)
- [Find the total number of movies in each category.](#find-the-total-number-of-movies-in-each-category)
- [Find the total sales by each customer.](#find-the-total-sales-by-each-customer)
- [Find the top 5 most rented movies of all time.](#find-the-top-5-most-rented-movies-of-all-time)
- [Find the total number of rentals for each movie.](#find-the-total-number-of-rentals-for-each-movie)
- [List all customers who have rented a movie in both ‘Action’ and ‘Comedy’ categories.](#list-all-customers-who-have-rented-a-movie-in-both-action-and-comedy-categories)
- [Find the total revenue generated by each store in 2006.](#find-the-total-revenue-generated-by-each-store-in-2006)
- [List all actors who have acted in a ‘Science Fiction’ movie.](#list-all-actors-who-have-acted-in-a-science-fiction-movie)
- [Find the top 5 customers who have spent the most on rentals.](#find-the-top-5-customers-who-have-spent-the-most-on-rentals)
- [Find the total number of rentals made by each staff member.](#find-the-total-number-of-rentals-made-by-each-staff-member)

### <a id="advanced"></a>Advanced
- [Find the top 5 most profitable movies.](#find-the-top-5-most-profitable-movies)
- [List all the customers who have rented a movie in the ‘Family’ category but not in the ‘Children’ category.](#list-all-the-customers-who-have-rented-a-movie-in-the-family-category-but-not-in-the-children-category)
- [Find the average rental duration for each actor.](#find-the-average-rental-duration-for-each-actor)
- [Find the customers who have rented the most number of movies in each country.](#find-the-customers-who-have-rented-the-most-number-of-movies-in-each-country)
- [Write a query to find the top 5 most rented movies in each language, along with the number of times each movie has been rented.](#write-a-query-to-find-the-top-5-most-rented-movies-in-each-language-along-with-the-number-of-times-each-movie-has-been-rented)
- [Write a query to find the top 5 most profitable movies in each language, along with the total revenue generated by each movie.](#write-a-query-to-find-the-top-5-most-profitable-movies-in-each-language-along-with-the-total-revenue-generated-by-each-movie)
- [Write a query to find the top 5 most profitable actors, along with the total revenue generated by each actor.](#write-a-query-to-find-the-top-5-most-profitable-actors-along-with-the-total-revenue-generated-by-each-actor)
- [Write a query to find the top 5 most profitable categories, along with the total revenue generated by each category, for each year.](#write-a-query-to-find-the-top-5-most-profitable-categories-along-with-the-total-revenue-generated-by-each-category-for-each-year)
- [Write a query to find the top 5 customers who have rented the most number of movies in each city, along with the total number of movies rented by each customer.](#write-a-query-to-find-the-top-5-customers-who-have-rented-the-most-number-of-movies-in-each-city-along-with-the-total-number-of-movies-rented-by-each-customer)
- [Find the total revenue generated by each actor.](#find-the-total-revenue-generated-by-each-actor)
- [Find the top 5 actors who have acted in the most number of films.](#find-the-top-5-actors-who-have-acted-in-the-most-number-of-films)
- [Write a query to find the top 5 most rented movies in each rating, along with the number of times each movie has been rented.](#write-a-query-to-find-the-top-5-most-rented-movies-in-each-rating-along-with-the-number-of-times-each-movie-has-been-rented)
- [Write a query to find the top 5 most profitable movies in each rating, along with the total revenue generated by each movie.](#write-a-query-to-find-the-top-5-most-profitable-movies-in-each-rating-along-with-the-total-revenue-generated-by-each-movie)
- [Write a query to find the top 5 most profitable languages, along with the total revenue generated by each language.](#write-a-query-to-find-the-top-5-most-profitable-languages-along-with-the-total-revenue-generated-by-each-language)
- [Write a query to find the top 5 most profitable ratings, along with the total revenue generated by each rating.](#write-a-query-to-find-the-top-5-most-profitable-ratings-along-with-the-total-revenue-generated-by-each-rating)
- [Write a query to find the top 5 customers who have rented the most number of movies in each rating, along with the total number of movies rented by each customer.](#write-a-query-to-find-the-top-5-customers-who-have-rented-the-most-number-of-movies-in-each-rating-along-with-the-total-number-of-movies-rented-by-each-customer)
- [Write a query to find the top 5 customers who have rented the most number of movies in each language, along with the total number of movies rented by each customer.](#write-a-query-to-find-the-top-5-customers-who-have-rented-the-most-number-of-movies-in-each-language-along-with-the-total-number-of-movies-rented-by-each-customer)
- [Write a query to find out which actor’s films have been rented out by customers from different cities.](#write-a-query-to-find-out-which-actors-films-have-been-rented-out-by-customers-from-different-cities)
- [Write a query to find out which category of films is most popular among customers from different countries.](#write-a-query-to-find-out-which-category-of-films-is-most-popular-among-customers-from-different-countries)

### <a id="expert"></a>Expert
- [Find the most rented movie in each category.](#find-the-most-rented-movie-in-each-category)
- [Write a query to find the top 5 most rented movies in each category, along with the number of times each movie has been rented.](#write-a-query-to-find-the-top-5-most-rented-movies-in-each-category-along-with-the-number-of-times-each-movie-has-been-rented)
- [Write a query to find the top 5 most profitable movies in each category, along with the total revenue generated by each movie.](#write-a-query-to-find-the-top-5-most-profitable-movies-in-each-category-along-with-the-total-revenue-generated-by-each-movie)
- [Write a query to find the top 5 most profitable stores, along with the total revenue generated by each store.](#write-a-query-to-find-the-top-5-most-profitable-stores-along-with-the-total-revenue-generated-by-each-store)
- [Write a query to find the top 5 most profitable cities, along with the total revenue generated by each city.](#write-a-query-to-find-the-top-5-most-profitable-cities-along-with-the-total-revenue-generated-by-each-city)
- [Write a query to find out which month had the highest number of rentals for each year.](#write-a-query-to-find-out-which-month-had-the-highest-number-of-rentals-for-each-year)
- [Write a query to find out which actor’s films have been rented out by customers from different countries.](#write-a-query-to-find-out-which-actors-films-have-been-rented-out-by-customers-from-different-countries)
- [Write a query to find out which category of films is most popular among customers from different cities.](#write-a-query-to-find-out-which-category-of-films-is-most-popular-among-customers-from-different-cities)
- [Write a query to find out which store has generated more revenue from comedy films than action films.](#write-a-query-to-find-out-which-store-has-generated-more-revenue-from-comedy-films-than-action-films)
- [Write a query to find out which country has generated more revenue from drama films than comedy films.](#write-a-query-to-find-out-which-country-has-generated-more-revenue-from-drama-films-than-comedy-films)
- [Write a query to find out which actor’s films have been rented out by customers from different countries.](#write-a-query-to-find-out-which-actors-films-have-been-rented-out-by-customers-from-different-countries)
- [Write a query to find out which category of films is most popular among customers from different countries.](#write-a-query-to-find-out-which-category-of-films-is-most-popular-among-customers-from-different-countries)
- [Write a query to find out which store has generated more revenue from comedy films than action films.](#write-a-query-to-find-out-which-store-has-generated-more-revenue-from-comedy-films-than-action-films)
- [Write a query to find out which country has generated more revenue from drama films than comedy films.](#write-a-query-to-find-out-which-country-has-generated-more-revenue-from-drama-films-than-comedy-films)
- [Write a query to find out which actor’s films have been rented out by customers from different countries.](#write-a-query-to-find-out-which-actors-films-have-been-rented-out-by-customers-from-different-countries)
