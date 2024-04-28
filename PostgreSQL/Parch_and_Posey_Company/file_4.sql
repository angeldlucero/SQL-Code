

--! Subqueries

--* 1) Proporcione el nombre del representante de ventas (sales_rep) en cada 'región' con la mayor cantidad de ventas totales_amt_usd.

SELECT t3.name_reps,
	   t2.name_region,
	   t2.max_sales
FROM(
	SELECT name_region,
		   MAX(total_sales) AS max_sales
	FROM(
		SELECT s.name AS name_reps,
			   r.name AS name_region,
			   SUM(total_amt_usd) AS total_sales
		FROM region AS r
		JOIN sales_reps AS s
		ON r.id = s.region_id
		JOIN accounts AS a
		ON s.id = a.sales_rep_id
		JOIN orders AS o
		ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC) AS t1
	GROUP BY 1) as t2
JOIN (
	SELECT s.name AS name_reps,
	   r.name AS name_region,
	   SUM(total_amt_usd) AS total_sales
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC) AS t3
ON t2.name_region = t3.name_region AND t2.max_sales = t3.total_sales

--* 2) Para la región con la mayor (sum) de ventas total_amt_usd, ¿cuántos pedidos totales (count) se realizaron?

SELECT r.name,
	   COUNT(o.total)
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(total_amt_usd) = (
		SELECT MAX(total_sales)
		FROM (
			SELECT r.name AS region_name,
				   SUM(total_amt_usd) total_sales
			FROM region AS r
			JOIN sales_reps AS s
			ON r.id = s.region_id
			JOIN accounts AS a
			ON s.id = a.sales_rep_id
			JOIN orders AS o
			ON a.id = o.account_id
			GROUP BY 1
			ORDER BY 2 ) AS  t1)


--* 3) ¿Cuántas accounts han tenido más compras totales que el nombre de la cuenta que más papel standard_qty ha comprado a lo largo de su vida como cliente?


SELECT COUNT(*)	
FROM(	
	SELECT a.name,
		   SUM(o.total)
	FROM accounts AS a
	JOIN orders AS o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total_qty
						FROM(
							SELECT a.name AS name_acc,
								   SUM(standard_qty) AS sum_standard,
								   SUM(o.total) AS total_qty
							FROM accounts AS a
							JOIN orders AS o
							ON a.id = o.account_id
							GROUP BY 1
							ORDER BY 2 DESC
							LIMIT 1) AS sub)
				)count_table



--! CTE


--* 4) Para el cliente que gastó más (en total a lo largo de su vida como cliente) total_amt_usd, ¿cuántos web_events tuvo por cada canal?

--? Table donde esta el cliente que más gastó en total_amt_usd (4211)
WITH t1 AS (
			SELECT a.id AS acc_id,
				a.name AS name_account,
				SUM(o.total_amt_usd) AS sum_amt_usd
			FROM orders AS o
			JOIN accounts AS a
			ON o.account_id = a.id
			JOIN web_events AS w
			ON a.id = w.account_id
			GROUP BY 1,2
			ORDER BY 3 DESC
			LIMIT 1
			)
			


SELECT  a.id AS account_id,
		w.channel AS name_channel,
		COUNT(w.channel) AS channel_qty
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
WHERE w.account_id = (SELECT acc_id
					  FROM t1)
GROUP BY 1,2
ORDER BY 3 DESC;


--* 5) ¿Cuál es la cantidad media gastada a lo largo de la vida en términos de total_amt_usd para las 10 cuentas con mayor gasto total?

--? Necesito  las 10 cuentas con mayor gasto en total_amt_usd
--? Una vez tengo esas 10 cuentas necesito sacar el promedio.


WITH t1 AS (
		SELECT a.name AS acc_name,
	   	       SUM(total_amt_usd) AS sum_amt_usd
		FROM accounts AS a
		JOIN orders AS o
		ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10)

--? Cantidad media gastasda de las 10 cuentas.
SELECT AVG(t1.sum_amt_usd) AS avg_amt_spent
FROM t1;




--* 6) Cuál es el importe medio gastado a lo largo de la vida en términos de total_amt_usd, incluyendo sólo las empresas que gastaron más por orders, de media, que la media de todos las orders.


-- Buscar el avg de todas las cuentas que gastaron total_amt_usd
   -- Pero solo las empresas donde el promedio de sus ordenes, son 
   -- mayores al promedio de todas ordenes.
   -- Ej: Solo dejar las cuentas donde "account_1 avg(total) > avg(total)"
   
   
   
 -- Primero buscamos el avg de todas las ordenes.
 
SELECT AVG(o.total_amt_usd) AS avg_total_usd
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id;

 
 -- Ahora con el dato de la media total podemos filtrar por cuenta,
 -- sacar el avg(total) de cada cuenta y solo dejar la cuenta
 -- donde su avg(total) sea mayor a la media de todas las orders.

SELECT a.name AS name_accounts,
	   AVG(o.total_amt_usd) AS accounts_avg_spent_usd
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) > ( SELECT AVG(o.total_amt_usd) AS avg_total_usd
						FROM accounts AS a
						JOIN orders AS o
						ON a.id = o.account_id)
ORDER BY 2 DESC;



--? Creamos la tabla WITH.
--? Tabla donde la media de las cuentas son mayores que la media total de 
--? Las orders.

WITH t1 AS (
		SELECT a.name AS name_accounts,
		       AVG(o.total_amt_usd) AS avg_accounts_spent_usd
		FROM accounts AS a
		JOIN orders AS o
		ON a.id = o.account_id
		GROUP BY 1
		HAVING AVG(o.total_amt_usd) > ( SELECT AVG(o.total_amt_usd) AS avg_total_usd
							    FROM accounts AS a
							  	JOIN orders AS o
							 	ON a.id = o.account_id)
		ORDER BY 2 DESC)	



-- Importe medio gastado.

SELECT AVG(t1.avg_accounts_spent_usd) AS  avg_amt_spent_usd
FROM t1;
