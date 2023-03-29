USE sakila;

#1 How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(inventory_id) AS Number_of_copies 
FROM inventory
WHERE film_id = (
	SELECT film_id FROM film 
    WHERE title = "Hunchback Impossible");
#ANS : 6 copies exist

#2 List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (
	SELECT AVG(length) FROM film)
ORDER BY length DESC;
#ANS : listed films should have a length longer than the average 115.27 min

#3 Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(a.first_name,' ' ,a.last_name) AS actor_names
FROM actor a
WHERE a.actor_id IN (
	SELECT b.actor_id
	FROM film_actor b
WHERE b.film_id = (
    SELECT c.film_id
    FROM film c
    WHERE c.title = 'Alone Trip'));

#ANS: 8 actors

SELECT DISTINCT(name) FROM category;

#4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT a.title FROM film a
WHERE a.film_id IN (
  SELECT b.film_id
  FROM film_category b
  WHERE b.category_id = (
    SELECT c.category_id
    FROM category c
    WHERE name = 'Family'));

SELECT a.title, c.name FROM film a 
JOIN film_category b
ON a.film_id = b.film_id
JOIN category c
ON b.category_id = c.category_id
WHERE c.name = 'Family';


#5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

#SUBQUERY
SELECT CONCAT(first_name, ' ', last_name) AS Customer_Name, email
FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (
		SELECT city_id FROM city
        WHERE country_id IN (
			SELECT country_id FROM country
            WHERE country = 'Canada')));
  
  
#JOIN 
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Customer_Name, a.email 
FROM customer a
JOIN address b
ON a.address_id = b.address_id
JOIN city c
ON b.city_id = c.city_id
JOIN country d
ON c.country_id = d.country_id
WHERE d.country = 'Canada';


#6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT distinct(a.title), CONCAT(b.first_name, ' ', b.last_name) AS actor
FROM film a
JOIN film_actor c
ON a.film_id = c.film_id
JOIN actor b
ON b.actor_id = c.actor_id
WHERE b.actor_id = (
	SELECT c.actor_id 
	FROM film_actor c 
	GROUP BY c.actor_id 
	ORDER BY count(c.actor_id) DESC 
	LIMIT 1);


#7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT c.title FROM film c
JOIN inventory d
ON c.film_id = d.film_id
JOIN rental e
ON d.inventory_id = e.inventory_id
WHERE e.customer_id = ( 
	SELECT b.customer_id FROM payment b
	GROUP BY b.customer_id
	ORDER BY SUM(b.amount) DESC
	LIMIT 1);


#8 Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, SUM(amount) AS Total_Amount_Spent 
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
	SELECT AVG(avg_) AS avg_
    FROM (
		SELECT customer_id, AVG(amount) AS avg_ #create a table of averages
        FROM payment
        GROUP BY customer_id) AS avg_amount_spent)  # group by to add averages together
ORDER BY Total_Amount_Spent DESC;


