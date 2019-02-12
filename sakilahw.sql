SELECT * FROM sakila.actor;
-- 1A and 1B
ALTER TABLE actor DROP combined;
ALTER TABLE actor ADD COLUMN combined VARCHAR(250);
UPDATE actor SET combined = CONCAT(first_name, '  ', last_name);
ALTER TABLE actor CHANGE combined Actor_Name VARCHAR(250);
-- 2A, B,C, and D
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'JOE';  	

-- 2b SELECT * FROM actor WHERE last_name = '%GEN%';

-- 2c SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

select * FROM actor;

-- 3 A
ALTER TABLE actor ADD COLUMN description BLOB;

-- 3 B
ALTER TABLE actor DROP COLUMN description;

-- 4A
SELECT DISTINCT
    last_name, COUNT(last_name) AS 'name_count'
FROM
    actor
GROUP BY last_name;
  	
-- 4b. 
SELECT DISTINCT
    last_name, COUNT(last_name) AS 'name_count'
FROM
    actor
GROUP BY last_name 
HAVING name_count >= 2;

-- 4c. 
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- 4d. 
UPDATE actor 
SET 
    first_name = 
		CASE
        WHEN first_name = 'HARPO'
        THEN 'GROUCHO'
        ELSE 'MUCHO GROUCHO'
    END
WHERE
    actor_id = 172;
    
    -- 5 A
    -- this query is showing that table exists
SHOW CREATE TABLE address; 
-- this is the query to use if we did not know if table existed but we wanted to create it again.
CREATE TABLE IF NOT EXISTS
 `address` (
 `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
 `address` varchar(50) NOT NULL,
 `address2` varchar(50) DEFAULT NULL,
 `district` varchar(20) NOT NULL,
 `city_id` smallint(5) unsigned NOT NULL,
 `postal_code` varchar(10) DEFAULT NULL,
 `phone` varchar(20) NOT NULL,
 `location` geometry NOT NULL,
 `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (`address_id`),
 KEY `idx_fk_city_id` (`city_id`),
 SPATIAL KEY `idx_location` (`location`),
 CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6 A
SELECT 
    staff.first_name, staff.last_name, address.address, city.city, country.country
FROM
    staff
        INNER JOIN
    address ON staff.address_id = address.address_id 
		INNER JOIN
	city ON address.city_id = city.city_id
		INNER JOIN
	country ON city.country_id = country.country_id;
    
-- 6b

SELECT 
    staff.first_name, staff.last_name, SUM(payment.amount) AS revenue_received
FROM
    staff
        INNER JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE
    payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;

-- 6 C

SELECT 
    title, COUNT(actor_id) AS number_of_actors
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6 D
SELECT 
    title, COUNT(inventory_id) AS number_of_copies
FROM
    film
        INNER JOIN
    inventory ON film.film_id = inventory.film_id
WHERE
    title = 'Hunchback Impossible';
    
    -- 6 E
    
    SELECT 
    last_name, first_name, SUM(amount) AS total_paid
FROM
    payment
        INNER JOIN
    customer ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

-- 7 A

SELECT title FROM film
WHERE language_id IN
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

-- 7 B

SELECT last_name, first_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id IN 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));
        
-- 7 C

SELECT customer.last_name, customer.first_name, customer.email
FROM
    customer
        INNER JOIN
    customer_list ON customer.customer_id = customer_list.ID
WHERE
    customer_list.country = 'Canada';
    
-- 7 D

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));
-- 7 E

SELECT 
    film.title, COUNT(*) AS 'rent_count'
FROM
    film,
    inventory,
    rental
WHERE
    film.film_id = inventory.film_id
        AND rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id
ORDER BY COUNT(*) DESC, film.title ASC;

-- 7 F

SELECT 
    store.store_id, SUM(amount) AS revenue
FROM
    store
        INNER JOIN
    staff ON store.store_id = staff.store_id
        INNER JOIN
    payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;

-- 7G
SELECT 
    store.store_id, city.city, country.country
FROM
    store
        INNER JOIN
    address ON store.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id;


-- 7H
SELECT 
    name, SUM(p.amount) AS gross_revenue
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        RIGHT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8 A
-- DROP VIEW IF EXISTS top_five_genres;


CREATE VIEW top_five_genres AS

SELECT 
    name, SUM(p.amount) AS gross_revenue
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        RIGHT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;


-- 8 B

SELECT * FROM top_five_genres;


-- 8 C

DROP VIEW top_five_genres;



