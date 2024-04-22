--! JOIN


--* 1) Proporcionar una tabla para todos los web_events asociados con el nombre de cuenta de "Walmart". Asegúrese de incluir el primary_poc, la hora del evento y el channel para cada evento. 

--* Además, podría añadir una cuarta columna para asegurarse de que sólo se han elegido eventos de "Walmart".

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events AS w
JOIN accounts  AS a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

--* 2) Proporcione una tabla que proporcione la "region" para cada "sales_rep" junto con sus "accounts" asociadas. La tabla final debe incluir Tres columnas: el nombre de la región, el nombre del representante de ventas y el nombre de la cuenta. Ordene las cuentas alfabéticamente (A-Z) según el nombre de la cuenta.

SELECT r.name AS region, 
	   s.name AS representante, 
	   a.name AS cuenta
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON  s.id = a.sales_rep_id
ORDER BY cuenta;

--* 3) Proporcione el nombre de cada región para cada orden, así como el nombre de la cuenta y el precio unitario que pagaron (total_amt_usd/total) por la orden. La tabla final debe tener 3 columnas: nombre de la región, nombre de la cuenta y precio unitario. Algunas cuentas tienen 0 para el total, así que dividí por (total + 0.01) para asegurarme de no dividir por cero.

SELECT r.name AS region, 
	   a.name AS cuenta,
	   o.total_amt_usd/(o.total + 0.01) AS precio_unitario
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON  s.id = a.sales_rep_id
JOIN orders AS  o
ON a.id = o.account_id;

--* 4) Proporcionar una tabla que proporcione la región para cada sales_rep junto con sus cuentas asociadas. Esta vez sólo para la región del Medio Oeste (Midwest). La tabla final debe incluir tres columnas: el name de la región, el name del representante de ventas y el name de la cuenta. Ordene las cuentas alfabéticamente (A-Z) según el nombre de la cuenta.

SELECT r.name Name_region, 
	   s.name Name_rep,
	   a.name Name_account
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name;


--* 5) Proporcionar una tabla que proporcione la región para cada sales_rep junto con sus cuentas asociadas. Esta vez sólo para las cuentas en las que el name del representante de ventas empiece por "S" y se encuentren en la región del Medio Oeste (Midwest). La tabla final debe incluir tres columnas: el name de la región, el name del representante de ventas y el name de la cuenta. Ordene las cuentas alfabéticamente (A-Z) según el nombre de la cuenta


 SELECT r.name Name_region,
	   s.name Name_rep,
	   a.name Name_account
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE s.name LIKE 'S%' AND r.name = 'Midwest'
ORDER BY a.name;


--* 6) Proporcionar una tabla que proporcione la región para cada sales_rep junto con sus cuentas asociadas. Esta vez sólo para las cuentas en las que el representante de ventas tenga un last name (apellido) que empiece por K y en la región del Medio Oeste (Midwest). La tabla final debe incluir tres columnas: el name de la región, el name del representante de ventas y el name de la cuenta. Ordene las cuentas alfabéticamente (A-Z) según el nombre de la cuenta.


SELECT r.name Name_region,
	   s.name Name_rep,
	   a.name Name_account
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE s.name LIKE '% K%' AND  r.name = 'Midwest'
ORDER BY a.name;


--* 7) Proporcione el name de cada región para cada orden, así como el account name y el precio unitario (unit price) que pagaron (total_amt_usd/total) por la orden. Sin embargo, sólo debe proporcionar los resultados si la cantidad estándar de la orden (standard order quantity) es superior a 100. La tabla final debe tener 3 columnas: name de la región, account name y precio unitario. Para evitar un error de división por cero, añadir .01 al denominador aquí es útil total_amt_usd/(total+0.01).

SELECT r.name Name_region,
	   a.name Name_account,
	   o.total_amt_usd / (o.total + 0.01) Unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100;

--*8) Proporcione el name de cada región para cada orden, así como el account name y el precio unitario (unit price) que pagaron (total_amt_usd/total) por la orden. Sin embargo, sólo debe proporcionar los resultados si la cantidad estándar de la orden  (standard_qty) es superior a 100 y la cantidad de la orden con cartel (poster_qty) es superior a 50. La tabla final debe tener 3 columnas: name de la región, account name y precio unitario. Ordene primero por el precio unitario más bajo. Para evitar un error de división por cero, es útil añadir 0,01 al denominador (total_amt_usd/(total+0,01).

SELECT r.name Name_region,
	   a.name Name_rep,
	   o.total_amt_usd / (o.total + 0.01) Unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY Unit_price ASC;

--*9) ¿Cuáles son los diferentes channel utilizados por el identificador de cuenta 1001? La tabla final debería tener sólo 2 columnas: el account name y los diferentes canales. Puedes probar SELECT DISTINCT para limitar los resultados a sólo los valores únicos.

SELECT DISTINCT a.name Name_account,
	   w.channel Name_channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.id = 1001; 

--* 10) Busque todos lAs ordenes que se produjeron en 2015. La tabla final debe tener 4 columnas: occurred_at, account name, order total y order total_amt_usd.

SELECT o.occurred_at Fecha,
	   a.name Name_Account,
	   o.total Cantidad_de_ordenes,
	   o.total_amt_usd Monto_total
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY Fecha; --? Se agrego para tener un orden en la fecha.