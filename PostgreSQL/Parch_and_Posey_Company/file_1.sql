--! ORDER BY


--* 1) Escriba una Query para devolver los primeros 10 pedidos de la tabala "orders". Incluyendo el id, fecha y monto todal.

SELECT id, 
       occurred_at, 
       total_amt_usd     
FROM orders
ORDER BY occurred_at
LIMIT 10;

--* 2) Escriba una Query que devuelva las primeras 5 ordenes con "mayor" monto total. Incluya el id, fecha y monto total.


SELECT id, 
       occurred_at, 
       total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

--* 3) Escriba una Query que devuelva los 20 pedidos mas bajos en relación al monto total. Incluya el id, fecha, y monto total .

SELECT id, 
       occurred_at,    
       total_amt_usd
FROM orders
ORDER BY  total_amt_usd 
LIMIT 20;


--* 4) Escriba una Query que muestre el "id" de orders, account_id y el monto total de todos los pedidos. Ordenarlos primero por le account_id ASC y luego por el monto total DESC.

SELECT id, 
       account_id, 
       total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;


--* 5) Extrae las 10 primeras filas y todas las columnas de la tabla de orders que tengan un monto total inferior a 500.

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;


--! WHERE


--* 1) Filtre la tabla accounts para incluir el website, company name y el primary_poc (punto de contacto) sólo para la empresa 'Exxon Mobil' en la tabla accounts.

SELECT name, 
       website, 
       primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

--! OPERADOR ARITMETICO


--* 1) Cree una columna que divida standard_amt_usd por standard_qty para encontrar el unit price (precio unitario) del papel estándar para cada orders. Limita los resultados a las 10 primeras ordenes e incluye los campos id y account_id.

SELECT id, 
       account_id, 
       (standard_amt_usd / standard_qty) AS unit_price
FROM orders
LIMIT 10;

--! LIKE


--* 1) Todas las empresas cuyos nombres empiezan por "C".
SELECT *
FROM accounts
WHERE name LIKE 'C%';

--* 2) Todas las empresas cuyos nombres contienen la cadena "one" en algún lugar del nombre.

SELECT *
FROM accounts
WHERE name LIKE '%one%';

--* 3) Todas las empresas cuyos nombres terminan en "s".

SELECT *
FROM accounts
WHERE name LIKE '%s';

--! IN


--* 1)  Utilice la tabla accounts para encontrar el account name, primary_poc y sales_rep_id para 'Walmart', 'Target' y 'Nordstrom'.

SELECT name, 
       primary_poc, 
       sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


--* 2) Utilice la tabla web_events para encontrar toda la información sobre las personas que fueron contactadas a través del "channel" 'organic' o 'adwords'.

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

--! NOT

--* 1) Utilice la tabla account para encontrar el account name, el primary_poc y el sales_rep_id de ventas para todas las tiendas excepto Walmart, Target y Nordstrom.
SELECT name, 
       primary_poc,
       sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

--* 2) Utilice la tabla web_events para encontrar toda la información relativa a las personas con las que se contactó a través de cualquier channel, excepto los channel organic o adwords.
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


--!  AND and BETWEEN


--* 1) Escriba una Query que devuelva todos las ordenes en los que standard_qty sea superior a 1000, poster_qty sea 0 y gloss_qty sea 0.

SELECT * 
FROM orders
WHERE standard_qty > 1000  AND poster_qty = 0 AND gloss_qty = 0;

--* 2)  Utilizando la tabla accounts, encuentre todas las empresas cuyos nombres no empiecen por "C" y terminen por "s".

SELECT * 
FROM accounts
WHERE (name NOT LIKE 'C%') AND  (name LIKE '%s');

--*4) Utilice la tabla web_events para encontrar toda la información relativa a las personas con las que se contactó a través de los channels 'orgánic' o 'adwords', y que iniciaron su cuenta en cualquier momento de 2016, ordenadas de la más reciente a la más antigua.

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND (occurred_at BETWEEN '2016-01-01' AND '2017-01-01')
ORDER BY occurred_at DESC;


--! OR

--* 1) Buscar lista de ids de orders donde gloss_qty o poster_qty es mayor que 4000. Solo incluye el campo id en la tabla resultante.

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty >4000;



--* 2) Escriba una consulta que devuelva una lista de orders en los que standard_qty sea cero y gloss_qty o poster_qty sean superiores a 1000.

SELECT *
FROM orders
WHERE  standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty >1000);

--* 3) Encuentra todos los nombres de empresa que empiecen por 'C' o 'W', y el primary_poc contenga 'ana' o 'Ana', pero no contenga 'eana'.

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%' 
AND (primary_poc NOT LIKE '%eana%'));
