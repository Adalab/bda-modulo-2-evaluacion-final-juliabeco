-- Evaluación Final - Módulo 2

-- Ubicación
-- https://github.com/Adalab/bda-modulo-2-evaluacion-final-juliabeco


# Resoluciones
 
USE sakila;

 -- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
 
 # Primero exploro la tabla que me interesa y corroboro cuantas películas hay para saber si tengo duplicados o no luego.
 
SELECT *
FROM film; -- el output ya me indica 1000 filas

SELECT COUNT(film_id) AS total_peliculas
FROM film; -- double check

# Esta query muestra todos los nombres de películas sin duplicados
SELECT DISTINCT title AS titulo_pelicula
FROM film;
 
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title AS titulo_PG13
FROM film
WHERE rating = 'PG-13'; -- hay 223

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS titulo, description AS descripcion_amazing 
FROM film
WHERE description LIKE '%amazing%'; -- hay 48

--  4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title AS titulo_duracion_mas2h
FROM film
WHERE length >120; -- 457 PELIS

-- 5. Recupera los nombres de todos los actores.

# 3 OPCIONES DE RESOLUCIÓN

#1 SELECCIONAR TODOS LOS NOMBRES SIN ELIMINAR DUPLICADOS 
SELECT first_name 
FROM actor; -- Son 200

#2 ELIMINANDO DUPLICADOS
SELECT DISTINCT first_name 
FROM actor; -- Son 128

#3 SELECCIONAR TODOS LOS NOMBRES COMPLETOS DE LOS ACTORES.
SELECT CONCAT(first_name, ' ', last_name) AS 'Nombre completo'
FROM actor; -- Son 200

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE last_name LIKE '%GIBSON%'; -- 1 actor

--  7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

#Se incluye en la query actor_id para mostrar que son los id de interés (SE INCLUYEN LOS LÍMITES)
SELECT actor_id, first_name 
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
# 2 EJEMPLOS PARA RESOLVERLO, UNA UTILIZANDO != y AND,  Y OTRA CON NOT IN

#1
SELECT title AS titulo, rating AS clasificacion
FROM film
WHERE rating != 'PG-13' AND rating != 'R'; -- 582 Películas

#2
SELECT title AS titulo, rating AS clasificacion
FROM film
WHERE rating NOT IN ('PG-13','R');  -- 582 Películas

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

# 2 interpretaciones

# Considerando la columna rating como clasificación
SELECT COUNT(*) AS total_peliculas, rating AS clasificacion
FROM film
GROUP BY rating; -- 5 TIPOS DE CLASIFICACIÓN

#Considerando tipo de categoria de la tabla category 
-- ORDEN POR TOTAL Y SI EXISTEN DOS CATEGORIAS CON MISMO VALOR QUE SEA POR ORDEN ALFABETICO
SELECT  c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM film AS f
LEFT JOIN film_category AS fc USING(film_id)
LEFT JOIN category AS c USING(category_id)
GROUP BY c.name
ORDER BY total_peliculas DESC, categoria; -- 16 CATEGORIAS

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id AS id, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS total_alquiladas
FROM customer as c
LEFT JOIN rental AS r USING(customer_id)
GROUP BY id
ORDER BY total_alquiladas DESC; -- 599 CLIENTES


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name, COUNT(DISTINCT r.rental_id) AS total_alquiladas
FROM category AS c
INNER JOIN film_category AS fc USING(category_id)
INNER JOIN film AS f USING (film_id)
INNER JOIN inventory AS i USING(film_id)
INNER JOIN rental AS r USING(inventory_id)
GROUP BY c.name;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

#Considerando la columna rating como clasificación
SELECT rating AS clasificacion, ROUND(AVG(length),2) AS duracion_media
FROM film
GROUP BY rating; -- 5 TIPOS DE CLASIFICACION


#Considerando tipo de categoría de tabla category
SELECT c.name AS categoria, ROUND(AVG(f.length),2) AS duracion_media
FROM category AS c
INNER JOIN film_category AS fc USING(category_id)
INNER JOIN film AS f USING (film_id)
INNER JOIN inventory AS i USING(film_id)
INNER JOIN rental AS r USING(inventory_id)
GROUP BY categoria; -- 16 CATEGORIAS


-- 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
#Se puede incluir o no en el resultado la columna de título, en este caso se muestra para corroborar que peli es

SELECT DISTINCT CONCAT (a.first_name, ' ', a.last_name) AS nombre_completo, f.title AS titulo
FROM actor AS a
INNER JOIN film_actor AS fa USING (actor_id)
INNER JOIN film AS f
WHERE f.title = 'Indian Love'; -- 199 actores

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
#LIKE
SELECT title, description
FROM film
WHERE description LIKE '%dog%' OR description LIKE'%cat%'; -- 167 RESULTADOS 

#REGEX
SELECT title, description
FROM film
WHERE description REGEXP 'dog|cat'; -- 167 RESULTADOS 

-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title AS titulo, release_year AS ano_lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010;
-- PARECE QUE LA BASE SOLO TIENE PELIS LANZADAS DEL 2006

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f. title AS titulo, c.name AS categoria
FROM film AS f
LEFT JOIN film_category AS fc USING (film_id)
LEFT JOIN category AS c USING(category_id)
WHERE c.name = 'Family'; -- 69 películas

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title AS titulo, rating AS clasificacion, length AS duracion
FROM film
WHERE rating ='R' AND length > 120
ORDER BY length; -- 90 pelis



-- BONUS --


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
# MOSTRANDO SOLO NOMBRE Y APELLIDO
SELECT first_name AS nombre, last_name AS apellido
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY actor_id
HAVING COUNT(fa.film_id) >10
ORDER BY COUNT(fa.film_id) DESC;

#MOSTRANDO ADEMAS CANTIDAD DE PELICULAS
SELECT first_name AS nombre, last_name AS apellido, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY actor_id
HAVING cantidad_peliculas >10
ORDER BY cantidad_peliculas DESC;

-- 19. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
SELECT a.actor_id, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY a.actor_id
HAVING cantidad_peliculas <1; -- NO HAY

# Para chequear cual es el actor que tiene el mínimo actuaciones en películas puedo usar el LIMIT 
SELECT a.actor_id, COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY a.actor_id
ORDER BY cantidad_peliculas
LIMIT 1; 

# Si quisiera chequearlo con MIN, deberia hacer una subconsulta que busque calcule y luego encuentre ese valor minimo de peliculas actuadas y despues
# en la query principal buscar el id y cantidad de películas con la condición que sea igual al valor minimo.

SELECT a.actor_id AS id, COUNT(fa.film_id) AS cantidad_peliculas	-- consulta principal que muestra id, cant de pelis, del actor que actuó en el mínimo de pelis de toda la tabla
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) = 
	(SELECT MIN(cantidad_peliculas)   						 		-- sub consulta que selecciona cual es el mínimo de películas que actuó un actor
	FROM (  SELECT COUNT(fa.film_id) AS cantidad_peliculas   		-- sub-sub consulta que calcula la cantidad de pelis de cada actor
			FROM actor AS a
			LEFT JOIN film_actor AS fa USING(actor_id)
			GROUP BY a.actor_id) AS min_pelis);


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS categoria, ROUND(AVG(f.length),2) AS duracion_media
FROM category AS c
INNER JOIN film_category AS fc USING(category_id)
INNER JOIN film AS f USING (film_id)
INNER JOIN inventory AS i USING(film_id)
INNER JOIN rental AS r USING(inventory_id)
GROUP BY c.name
HAVING duracion_media > 120; -- 4 CATEGORIAS


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT first_name AS nombre, COUNT(DISTINCT fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa USING(actor_id)
GROUP BY actor_id
HAVING cantidad_peliculas >5
ORDER BY cantidad_peliculas DESC;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids 
-- con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT DISTINCT f.title AS titulo
FROM film AS f
JOIN inventory AS i USING (film_id)
JOIN rental AS r USING (inventory_id)
WHERE rental_id IN
(SELECT rental_id
	FROM rental AS r
	WHERE DATEDIFF(return_date, rental_date) > 5)
ORDER BY f.title; -- 955 TITULOS DIFERENTES 

# sin subconsulta quedaría más simple:
SELECT DISTINCT f.title AS titulo
FROM film AS f
JOIN inventory AS i USING (film_id)
JOIN rental AS r USING (inventory_id)
WHERE DATEDIFF(r.return_date, r.rental_date) > 5
ORDER BY f.title;

--  23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
-- "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
-- categoría "Horror" y luego exclúyelos de la lista de actores.
 
SELECT a.actor_id, a.first_name AS nombre, a.last_name AS apellido 
 FROM actor AS a
 WHERE NOT EXISTS (
 SELECT 1
 FROM film_actor AS fa
 JOIN film AS f USING (film_id)
 JOIN film_category AS fc USING (film_id)
 JOIN category AS c USING (category_id)
 WHERE fa.actor_id = a.actor_id AND c.name = 'Horror'); -- 44 actores
 
 -- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
 
 SELECT f.title AS titulo -- , c.name AS categoría , f.length AS duración
 FROM film AS f
 LEFT JOIN film_category AS fc USING (film_id)
 LEFT JOIN category AS c USING (category_id)
 WHERE c.name = 'Comedy' AND f.length > 180;  -- 3 películas 
 
 -- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar
 -- el nombre y apellido de los actores y el número de películas en las que han actuado juntos

SELECT 
    a1.actor_id AS id_actor1, -- id del primer actor
    a1.first_name AS nombre_actor1, 
    a1.last_name AS apellido_actor1,
    a2.actor_id AS id_actor2, -- id del segundo actor
    a2.first_name AS nombre_actor2, 
    a2.last_name AS apellido_actor2,
    COUNT(*) AS cantidad_peliculas_juntos -- número de películas en las que trabajaron juntos
FROM film_actor fa1
JOIN film_actor fa2 
    ON fa1.film_id = fa2.film_id 
    AND fa1.actor_id < fa2.actor_id 
    -- se emparejan actores distintos que hayan actuado en la misma película, 
    -- y se usa < en vez de <> para evitar duplicados (ej: evitar contar 1-3 y 3-1 como dos pares distintos)
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a2.actor_id
HAVING COUNT(*) >= 1
ORDER BY cantidad_peliculas_juntos DESC;
  
