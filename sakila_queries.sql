USE sakila_mini;

-- 1-2: contents of each table
SELECT * FROM film;
SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM payment;

-- 2-1
SELECT film_id, title, length
FROM film
WHERE length > 120
LIMIT 10;

-- 2-2
SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS number_of_rents
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(*) > 5
LIMIT 10;

-- 2-2 sanity check (optional)
SELECT customer_id, COUNT(*) AS number_of_rents
FROM rental
GROUP BY customer_id
ORDER BY number_of_rents DESC
LIMIT 10;

-- 2-3
SELECT f.film_id, f.title, COUNT(*) AS times_rented
FROM film f
JOIN rental r ON f.film_id = r.film_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 3;
-- Optional tie-breaker: ORDER BY times_rented DESC, f.film_id

-- 2-4
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > 3.99
LIMIT 10;

-- 2-5
SELECT customer_id, first_name, last_name, city
FROM customer
WHERE first_name LIKE 'A%'
LIMIT 10;

-- 2-6
SELECT film_id, title, release_year, length
FROM film
ORDER BY length DESC
LIMIT 10;

-- 2-7
SELECT MAX(length) AS max_length, MIN(length) AS min_length
FROM film;

-- 2-8
SELECT category, COUNT(*) AS film_count
FROM film
GROUP BY category
LIMIT 10;

-- 2-9
SELECT film_id, title, category
FROM film
LIMIT 10;

-- 2-10 (extra)
SELECT r.rental_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
       r.rental_date
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
LIMIT 10;

-- 2-11 (extra), Option 1: LEFT JOIN
SELECT f.film_id, f.title
FROM film f
LEFT JOIN rental r ON f.film_id = r.film_id
WHERE r.rental_id IS NULL
LIMIT 10;

-- 2-11 (extra), Option 2: NOT IN
SELECT film_id, title
FROM film
WHERE film_id NOT IN (SELECT film_id FROM rental)
LIMIT 10;