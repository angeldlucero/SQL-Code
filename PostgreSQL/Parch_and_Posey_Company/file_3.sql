--! SUM


--* 1) Encuentre la cantidad total de papel standard_qty pedido en la tabla de orders.

SELECT SUM(standard_qty) Cantidad_total
FROM orders;

--* 2) Encuentre el importe total en dólares de las ventas utilizando el total_amt_usd en la tabla de orders.

SELECT SUM(total_amt_usd) Cantidad_total
FROM orders;

--* 3) Halle el standard_amt_usd por unidad de standard_qty . Su solución debe utilizar tanto un operador de agregación como un operador matemático.

SELECT SUM(standard_amt_usd) / SUM(standard_qty) Precio_unitario --? Precio por unidad
FROM orders;


--! MIN, MAX, & AVG


--* 1) ¿Cuándo se realizó el primer pedido? Sólo tiene que indicar la fecha.

SELECT MIN(occurred_at) Primer_pedido
FROM orders;

--* 2) Intente realizar la misma consulta que en la pregunta 1 sin utilizar una función de agregación.

SELECT occurred_at
FROM orders
ORDER BY occurred_at ASC
LIMIT 1;

--* 3) ¿Cuándo se produjo el evento web más reciente (último)?

SELECT MAX(occurred_at) last_event
FROM web_events;


--* 4) Intenta realizar el resultado de la consulta anterior sin utilizar una función de agregación.

SELECT occurred_at last_event
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

--* 5) Encuentre la cantidad media (AVERAGE) gastada por pedido en cada tipo de papel, así como la cantidad media de cada tipo de papel comprado por pedido. Su respuesta final debe tener 6 valores - uno para cada tipo de papel para el número medio de ventas, así como el importe medio.

SELECT AVG(standard_amt_usd) standard_avg_amt_usd,
	   AVG(gloss_amt_usd) gloss_avg_amt_usd,
	   AVG(poster_amt_usd) poster_avg_amt_usd,
	   AVG(standard_qty) standard_avg,
	   AVG(gloss_qty) gloss_avg,
	   AVG(poster_qty) poster_avg
FROM orders;


--! GROUP BY


--* 1) ¿Qué account (por nombre) realizó el pedido más antiguo? Su solución debe incluir el nombre de la cuenta y la fecha del pedido.

SELECT MIN(o.occurred_at),
	   a.name
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 2
ORDER BY 1 ASC
LIMIT 1;

--* 2) Encuentre las ventas totales en usd para cada account. Debe incluir dos columnas: las ventas totales de los pedidos de cada empresa en USD y el nombre de la empresa.

SELECT SUM(o.total_amt_usd),
	   a.name
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name;



--* 3) ¿Quién era el contacto principal (primary_contact) asociado al primer web_event?


SELECT w.occurred_at,
	   a.primary_poc
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
ORDER BY w.occurred_at ASC
LIMIT 1;
--todo: Otra manera con función agregación:
SELECT MIN(w.occurred_at),
	   a.primary_poc
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
GROUP BY 2
ORDER BY 1 ASC
LIMIT 1;


--* 4) Busque el número de representantes de ventas (sales_reps) en cada región. La tabla final debe tener dos columnas: la región y el número de representantes de ventas. Ordénalas de menor a mayor número de representantes.

SELECT r.name,
	   COUNT(s.name) AS cant_reps
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY cant_reps;


--* 5) Para cada account, determine el importe medio gastado por pedido en cada tipo de papel. El resultado debe tener cuatro columnas: una para el nombre de la cuenta y otra para el importe medio gastado en cada tipo de papel.

SELECT a.name name_account,
	   AVG(o.standard_amt_usd) avg_standard_amt_usd,
	   AVG(o.poster_amt_usd) avg_poster_amt_usd,
	   AVG(o.gloss_amt_usd) avg_glossy_amt_usd   
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY name_account;


--* 6) Determine el número de veces que se utilizó un channel determinado en la tabla web_events para cada representante de ventas. La tabla final debe tener tres columnas: el nombre del representante de ventas, el canal y el número de apariciones. Ordene primero la tabla con el mayor número de ocurrencias.


SELECT  s.name name_rep,
		w.channel AS canal,
	    COUNT(w.channel) cant
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
GROUP BY name_rep, canal
ORDER BY cant DESC;


--* 7) Determine el número de veces que se ha utilizado un canal determinado en la tabla web_events para cada región. La tabla final debe tener tres columnas: el nombre de la región, el canal y el número de ocurrencias. Ordene primero la tabla con el mayor número de ocurrencias.

SELECT  r.name AS name_region,
		w.channel AS canal,
		COUNT(w.channel) cantidad
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id
GROUP BY name_region, canal
ORDER BY cantidad DESC;


--! Quiz: HAVING

--* 1) ¿Cuántas accounts tienen más de 20 pedidos?
SELECT a.name name_account,
	   COUNT(o.id) cant_orders
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
HAVING COUNT(o.id) > 20
ORDER BY cant_orders;

--* 2) ¿Qué cuentas gastaron más de 30.000 USD en total en todos los pedidos?
SELECT a.name name_account,
	   SUM(total_amt_usd) amt_spend
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY name_account
HAVING SUM(total_amt_usd) > 30000
ORDER BY amt_spend;

--* 3) ¿Qué cuentas utilizaron facebook como canal para ponerse en contacto con los clientes más de 6 veces?

SELECT a.name name_account,
	   w.channel name_channel,
	   COUNT(w.channel) cant_channel
FROM web_events AS w
JOIN  accounts AS a
ON w.account_id = a.id
GROUP BY name_account, name_channel
HAVING COUNT(w.channel) > 6 AND w.channel = 'facebook'
ORDER BY cant_channel;

--* 4)  ¿Qué cuenta utilizó más facebook como canal?

SELECT a.name name_account,
	   w.channel name_channel,
	   COUNT(w.channel) cant_channel
FROM web_events AS w
JOIN  accounts AS a
ON w.account_id = a.id
GROUP BY name_account, name_channel
HAVING COUNT(w.channel) > 6 AND w.channel = 'facebook'
ORDER BY cant_channel DESC
LIMIT 1;


--! DATE Functions

--* 1) Encuentra las ventas en términos de dólares totales para todos los pedidos de cada year (año), ordenados de mayor a menor. ¿Notas alguna tendencia en los totales de ventas anuales?

SELECT DATE_PART('year', occurred_at) AS ord_age,
	   SUM(total_amt_usd) AS amt_total_per_year
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


--* 2) ¿Qué month (mes) tuvo Parch & Posey mayores ventas en términos de dólares totales? ¿Están todos los meses representados por igual en el conjunto de datos?

SELECT DATE_PART('month', occurred_at) AS ord_month,
	   SUM(total_amt_usd) AS amt_total_per_year
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--* 3) ¿En qué mes de qué año gastó Walmart más en papel satinado (gloss paper) en términos de dólares?

SELECT DATE_TRUNC('month', o.occurred_at) AS months,
	   SUM(o.gloss_amt_usd) AS amt_gloss
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY months
ORDER BY amt_gloss DESC
LIMIT 1;


--! CASE


--* 1) Ahora queremos realizar un cálculo similar al primero, pero queremos obtener el importe total gastado por los clientes solo en 2016 y 2017. Mantenga los mismos niveles que en la pregunta anterior. Ordenar con los clientes que más gastan en primer lugar.


SELECT a.name AS account_name,
	   SUM(o.total_amt_usd) AS total_amt,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top Level'
	   		WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Second Level'
			ELSE 'lowest Level' END AS diferent_level_customer
	   
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-12-31'
GROUP BY 1
ORDER BY 3 DESC;



--* 2) Nos gustaría identificar a los representantes de ventas (sales reps) con mayor rendimiento, que son los representantes de ventas asociados con más de 200 pedidos. Cree una tabla con el nombre del representante de ventas (sales rep name), el número total de pedidos y una columna con top o no dependiendo de si tienen más de 200 pedidos. Coloca los mejores vendedores primero en tu tabla final.


SELECT s.name AS rep_name,
	   COUNT(o.total) order_qty,
	   CASE WHEN COUNT(o.total) > 200 THEN 'Top'
	   		ELSE 'No' END AS best_reps
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


--* 3) El anterior no tenía en cuenta el medio, ni el importe en dólares asociado a las ventas. La dirección decide que también quiere ver representadas estas características. Nos gustaría identificar a los representantes de ventas de mayor rendimiento, que son los representantes de ventas asociados con más de 200 pedidos o más de 750000 en ventas totales. El grupo medio incluye a todos los representantes con más de 150 pedidos o 500.000 en ventas. Cree una tabla con el nombre del representante de ventas, el número total de pedidos, las ventas totales de todos los pedidos y una columna con la parte superior (top), media (middle) o inferior (low) en función de estos criterios. Coloca en primer lugar en la tabla final a los vendedores más importantes en función del importe de las ventas. Puede que veas a algunos vendedores disgustados por este criterio.

SELECT s.name AS name_reps,
	   COUNT(o.total) AS orders_qty,
	   SUM(o.total_amt_usd) AS total_amt,
	   CASE WHEN COUNT(o.total) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'Top'
	   		WHEN COUNT(o.total) > 150 OR SUM(o.total_amt_usd) >= 500000 THEN 'Middle'
			ELSE 'Low' END AS  rep_top_performance
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
GROUP BY 1
ORDER BY rep_top_performance DESC;