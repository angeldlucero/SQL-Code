--! Quiz: LEFT & RIGHT


--* 1) En la tabla de accounts, hay una columna que contiene el website de cada empresa. Los tres últimos dígitos especifican qué tipo de dirección web están utilizando. Aquí se proporciona una lista de extensiones (y precios). Extraiga estas extensiones e indique cuántas de cada tipo de website existen en la tabla de accounts.

--? Manera 2: Con WITH. (Es mucho mas rapida la ejecución con WITH)

WITH t1 AS (
		SELECT RIGHT(website, 3) AS web_domain
		FROM accounts)


SELECT 	t1.web_domain,
		COUNT(t1.web_domain) AS web_domain_qty
FROM t1
GROUP BY 1
ORDER BY 2 DESC;


--* 2) Existe un gran debate sobre la importancia del nombre (o incluso de la primera letra del nombre de una empresa). Utilice la tabla de accounts para extraer la primera letra de cada nombre de empresa y ver la distribución de nombres de empresa que empiezan por cada letra (o número).

WITH t1 AS (
	    SELECT LEFT(UPPER(name), 1) AS first_letter
		FROM accounts)


SELECT 	t1.first_letter,
		COUNT(t1.first_letter) AS first_letter_qty
FROM t1
GROUP BY 1
ORDER BY 2 DESC;

--* 3) Utilice la tabla de accounts y una sentencia CASE para crear dos grupos: un grupo de nombres de empresas que empiecen por número y un segundo grupo de nombres de empresas que empiecen por letra. ¿Qué proporción de nombres de empresa empiezan por letra?

--? Crear una columna donde esta solo la primera letra de las empresas.

--? Crear dos grupos con CASE.
    --? Nombre de empresa que empiece con "Numero"
    --? Nombre de empresa que empiece con "Letra"

--? Sacar la proporción (porcentaje) de empresas que empiezan con "Letra"

WITH t1 AS (
		SELECT LEFT(name, 1) AS first_letter
		FROM accounts),
		
	 t2 AS (
	 	SELECT first_letter,
	   	CASE WHEN substring(first_letter from '^[0-9]') IS NOT NULL THEN 'Number'
	   		 ELSE 'Letter' END grupo	   
		FROM t1)
		

	
SELECT grupo AS name_grupo,
	   COUNT(grupo) AS grupo_qty,
	   COUNT(*) * 1.0 / (SELECT COUNT(*) FROM t2) AS percentage

FROM t2
GROUP BY 1
ORDER BY 2;




--! Quizzes POSITION & STRPOS



--* 1) Utilice la tabla de accounts para crear columnas de nombre y apellido que contengan el nombre y apellido de Primary_poc.

SELECT primary_poc,
	   LEFT(primary_poc, POSITION(' ' IN primary_poc) -1) AS First_name,
	   RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS  Last_name
FROM accounts;

--*2) Ahora vea si puede hacer lo mismo para cada nombre de representante en la tabla sales_reps. Una vez más, proporcione las columnas de nombre y apellido.

SELECT name AS nombre_y_apellido,
	   LEFT(name, STRPOS(name, ' ') -1) AS First_name,
	   RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS  Last_name
FROM sales_reps


--! Quiz: CONCAT

--* 1) Cada empresa en la tabla de accounts quiere crear una dirección de correo electrónico para cada primary_poc. La dirección de correo electrónico debe ser el name_of_the_primary_poc.last_name_primary_poc@company_name.com


WITH t1 AS (
		SELECT name,
	   primary_poc,
	   LEFT(primary_poc, POSITION(' ' IN primary_poc) -1) AS first_name,
	   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS  last_name	   	   
FROM accounts)



SELECT 	CONCAT(first_name,'.',last_name,'@', name,'.com') AS email
FROM t1

--* 2) Habrás notado que en la solución anterior algunos de los nombres de empresa incluyen espacios, lo que sin duda no funcionará en una dirección de correo electrónico. Vea si puede crear una dirección de correo electrónico que funcione eliminando todos los espacios en el nombre de la cuenta, pero por lo demás su solución debería ser igual que en la pregunta 1.


WITH t1 AS (
		SELECT name,
	   primary_poc,
	   LEFT(primary_poc, POSITION(' ' IN primary_poc) -1) AS first_name,
	   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS  last_name	   	   
FROM accounts)



SELECT 	CONCAT(first_name,'.',last_name,'@', replace(name, ' ', ''),'.com') AS email
FROM t1

--? Replace: Cambiar una palabra por otra o cambiar un caracter por otro o cambiar un espacio por sin espacio.





--! Quiz: COALESCE





--*  2)  Utilice COALESCE para completar la columna orders.account_id con el accounts.id para el valor NULL de la tabla en 1.

--todo: La frase "para el valor NULL de la tabla en 1" se puede entender de otra manera como "para cada valor NULL de la tabla que se menciona en el mensaje 1". En este caso, el mensaje 1 es el mensaje que contiene la consulta SQL proporcionada.

--todo: Por lo tanto, la frase se refiere a todos los valores NULL en las columnas qty y usd de los registros de la tabla orders que cumplen con la condición o.total IS NULL.

SELECT a.*, 
		COALESCE(o.id, a.id) id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, 
		o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, 
		o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


--* 2) Utilice COALESCE para rellenar cada una de las columnas "qty" , "usd" y "total" con 0 para la tabla en 1. 

SELECT a.*, 
		COALESCE(o.id, a.id) id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, 
		COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty, 0) gloss_qty, 
		COALESCE(o.poster_qty, 0) poster_qty, COALESCE(o.total, 0) total, 
		COALESCE(o.standard_amt_usd, 0) standard_amt_usd, COALESCE(o.gloss_amt_usd, 0) gloss_amt_usd, 
		COALESCE(o.poster_amt_usd, 0) poster_amt_usd, COALESCE(o.total_amt_usd, 0) total_amt_usd 
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;