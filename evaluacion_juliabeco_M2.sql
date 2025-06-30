

#Carpeta
-- https://github.com/Adalab/bda-modulo-2-evaluacion-final-juliabeco


# Resoluciones
/*
Ejercicios
 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su
 descripción.
 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
 5. Recupera los nombres de todos los actores.
 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su
 clasificación.
 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación
 junto con el recuento.
 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
 nombre y apellido junto con la cantidad de películas alquiladas.
 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría
 junto con el recuento de alquileres.
 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
 clasificación junto con el promedio de duración.
 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
 15. Encuentr a el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".
 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla
 film.
 BONUS
 Nota: Los ejercicios bonus son opcionales. Si decides hacerlos, te recomendamos que primero hagas
 los ejercicios obligatorios y luego los bonus. La realización de estos ejercicios puede ayudarte a
 reforzar tus conocimientos y habilidades en SQL. No influyen en tu nota final.
 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y
 muestra el nombre de la categoría junto con el promedio de duración.
 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con
 la cantidad de películas en las que han actuado.
 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
 subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
 películas correspondientes.
 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
 "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
 categoría "Horror" y luego exclúyelos de la lista de actores.
 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
 tabla film.
 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar
 el nombre y apellido de los actores y el número de películas en las que han actuado juntos
 */
 
USE sakila;

 -- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
 
 # Primero exploro la tabla que me interesa y corroboro cuantas peliculas hay para saber si tengo duplicados o no luego.
 
SELECT *
FROM film; -- el output ya me indica 1000 filas

SELECT COUNT(film_id)
FROM film; -- corroboró con la PK

# Esta query muestra todos los nombres de peliculas sin duplicados
SELECT DISTINCT title 
FROM film;
 
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title 
FROM film
WHERE rating = 'PG-13'; -- hay 223

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description 
FROM film
WHERE description LIKE '%amazing%'; -- hay 48

--  4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title
FROM film
WHERE length >120;

-- 5. Recupera los nombres de todos los actores.

# 3 OPCIONES DE RESOLUCION

# SELECCIONAR TODOS LOS NOMBRES SIN ELIMINAR DUPLICADOS O ELIMINANDO DUPLICADOS
#1
SELECT first_name 
FROM actor; -- Son 200
#2
SELECT DISTINCT first_name 
FROM actor; -- Son 128
#3
#SELECCIONAR TODOS LOS NOMBRES COMPLETOS DE LOS ACTORES.
SELECT CONCAT(first_name, ' ', last_name) AS 'Nombre completo'
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS nombre, last_name AS apellido
FROM actor
WHERE last_name LIKE '%GIBSON%';

--  7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
#Inclui en la query actor_id para mostrar que son los id de interes
SELECT actor_id, first_name 
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
# 2 EJEMPLOS PARA RESOLVERLO, UNA UTILIZANDO != y AND,  Y OTRA CON NOT IN

#1
SELECT title, rating 
FROM film
WHERE rating != 'PG-13' AND rating != 'R'; -- 582 Peliculas
#2
SELECT title, rating 
FROM film
WHERE rating NOT IN ('PG-13','R');  -- 582 Peliculas

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT COUNT(*) AS total_peliculas, rating AS categoria
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquiladas
FROM customer as c
LEFT JOIN rental AS r USING(customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquiladas DESC;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(DISTINCT r.rental_id) AS total_alquiladas, f.rating AS categoria 
FROM rental AS r
INNER JOIN inventory AS i USING(inventory_id)
INNER JOIN film AS f USING(film_id)
GROUP BY rating;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating AS categoria, ROUND(AVG(length),2) AS duracion_media
FROM film
GROUP BY rating;

-- 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
#Se puede incluir o no en el resultado la columna de titulo, en este caso se muestra para corroborar que peli es

SELECT DISTINCT CONCAT (a.first_name, ' ', a.last_name) AS nombre_completo, f.title AS titulo
FROM actor AS a
INNER JOIN film_actor AS fa USING (actor_id)
INNER JOIN film AS f
WHERE f.title = 'Indian Love'; -- 199 actores

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE '%dog%' OR description LIKE'%cat%'; -- 167 RESULTADOS 

-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;
-- PARECE QUE LA BASE SOLO TIENE PELIS LANZADAS DEL 2006

-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f. title, c.name
FROM film AS F
LEFT JOIN film_category AS fc USING (film_id)
LEFT JOIN category AS c USING(category_id)
WHERE c.name = 'Family'; -- 69 peliculas

-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title, rating, length
FROM film
WHERE rating ='R' AND length > 120
ORDER BY length; -- 90 pelis