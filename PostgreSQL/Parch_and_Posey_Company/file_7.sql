--! Quiz: FULL OUTER JOIN

--* Digamos que eres analista en Parch & Posey y quieres ver:

--* cada cuenta que tenga un comercial y cada comercial que tenga una cuenta (todas las columnas de estas filas devueltas estarán llenas)

--* Pero también cada cuenta que no tenga un representante comercial y cada representante comercial que no tenga una cuenta (algunas de las columnas de estas filas devueltas estarán vacías)

SELECT *
  FROM accounts
 FULL JOIN sales_reps 
 ON accounts.sales_rep_id = sales_reps.id
 --WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL

  --* Si existieran filas no coincidentes (no es el caso de esta consulta), podría aislarlas añadiendo la siguiente línea al final de la consulta.


  --! Quizz Self Join

--* Cambia el intervalo a 1 día para encontrar aquellos eventos web que ocurrieron después, pero no más de 1 día después, de otro evento web. (Quiere decir encontrar otros web_events que ocurrió dentro de un intervalo de un día (1 day) para la misma cuenta)

--* Agrega una columna para la variable de canal ("channel") en ambas instancias de la tabla en tu consulta.

SELECT w1.id AS w1_id,
	   w1.account_id AS w1_account_id,
	   w1.occurred_at AS w1_occurred_at,
     w1.channel AS w1_channel,
	   w2.id AS w2_id,
	   w2.account_id AS w2_account_id,
	   w2.occurred_at AS w2_occurred_at,
     w2.channel AS w2_channel
FROM web_events AS w1
LEFT JOIN web_events AS w2
ON w1.account_id = w2.account_id 
AND w2.occurred_at > w1.occurred_at 
AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w1.occurred_at 

--? Nos devolvera web_events que occurrieron dentro del mismo dìa. (pueden ser distintas horas.)


--! Quizz UNION

--? Añadir datos mediante UNION

--* Escriba una consulta que utilice UNION ALL en dos instancias (y seleccionando todas las columnas) de la tabla de "accounts". A continuación, inspeccione los resultados y responda al cuestionario subsiguiente.

SELECT *
FROM accounts AS a1

UNION ALL

SELECT *
FROM accounts AS a2

--todo: La función UNION solo anexa valores distintos.


--* Utilice la Query que creo en (Añadir datos mediante UNION) y pongala en una CTE y nómbrela double_accounts. A continuación, realice un COUNT del número de veces que aparece un nombre en la tabla double_accounts. Si lo hace correctamente, los resultados de la consulta deberían tener un recuento de 2 para cada nombre.

WITH double_accounts AS (
					SELECT *
					FROM accounts AS a1

					UNION ALL

					SELECT *
					FROM accounts AS a2)

SELECT name,
	   COUNT(*) AS qty
FROM double_accounts
GROUP BY 1

--? RTA: Aparecen dos veces cada nombre de cuenta.
