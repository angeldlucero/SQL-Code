-- ! Creating a Running Total Using Window Functions (Crear un total de acumulado utilizando window function)


--* Cree un total de acumulado de **standard_amt_usd** (en la tabla **orders**) sobre el tiempo del pedido sin truncamiento de fecha. 

--* La tabla final debe tener dos columnas: 

--? Una con el importe que se añade por cada nueva fila.
--? Una segunda con el total acumulado.


SELECT standard_amt_usd,
	   SUM(standard_amt_usd) OVER (order by occurred_at) AS running_total
FROM orders




-- ! Crear un total acumulado partitioned usando funciones de ventana



--* Siga creando un total acumulado de **standard_amt_usd** (en la tabla **orders**) a lo largo del tiempo de pedido, pero esta vez, trunque date **occurred_at** por año y haga particiones por esa misma variable **occurred_at** truncada por año.

 --* La tabla final debería tener tres columnas: 

--? Una con la cantidad añadida para cada fila, una para la fecha truncada.
--? Una columna final con el total dentro de cada año.


SELECT standard_amt_usd,
	   DATE_TRUNC('year', occurred_at) AS  year,
	   SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

--todo: Esto lo que hace es que nos va a mostrar todos los registros de cada año e ira haciando el acumulado hasta que termine ese año. Seguira con un nuevo acumulado para el proximo año, y así sucesivamente.

SELECT standard_amt_usd,
       DATE_PART('year', occurred_at) as years,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_PART('year', occurred_at) 
								   ORDER BY occurred_at) AS running_total
FROM orders;

--todo: Acá usamos el DATE_PART para se más exacto con el tema del año que queremos. Ya que si así lo deseamos podremos filtrar con where buscando el año que querramos saber el acumulado y no habra problemas.
--? WHERE DATE_PART('year', occurred_at) = 2013;




--! Quiz: ROW_NUMBER & RANK


--* Ranking Total Paper Ordered by Account
--? (Clasificación del total de artículos ordenados por cuenta)

--* Seleccione las variables id, account_id y total de la tabla de orders y, a continuación, cree una columna llamada total_rank que ordene esta cantidad total de papel pedido (de mayor a menor) para cada cuenta utilizando un partition. La tabla final debe tener estas cuatro columnas.

SELECT id,
	   account_id,
	   total,
	   ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;




--! Quiz: Aggregates in Window Functions



--* Aggregates in Window Functions with and without ORDER BY
--? (Agregados en funciones de ventana con y sin ORDER BY)

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders




--! Quiz: Aliases for Multiple Window Functions

--* Ahora, cree y utilice un alias para acortar la siguiente consulta.


SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))



--! Quiz: Comparing a Row to Previous Row
--* (Comparar una fila con la fila anterior)

--* Imagina que eres analista en Parch & Posey y quieres determinar cómo se comparan los ingresos totales del pedido actual ("totales" significa de las ventas de todos los tipos de papel) con los ingresos totales del siguiente pedido.
--* Para ello, deberá utilizar occurred_at y total_amt_usd en la tabla orders junto con LEAD. En los resultados de la consulta, debería haber cuatro columnas: occurred_at, total_amt_usd, lead y lead_difference.

SELECT occurred_at,
       total_amt_sum,
       LEAD(total_amt_sum) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_sum) OVER (ORDER BY occurred_at) - total_amt_sum AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_sum
  FROM orders 
 GROUP BY 1
 ) sub