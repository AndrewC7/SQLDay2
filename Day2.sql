-- What languages are spoken in the United States? (12)
SELECT c.name AS country,
       cl.language AS language
FROM countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
WHERE
     c.name = 'United States'
ORDER BY c.name, cl.language

-- Brazil? (not Spanish...)
SELECT c.name AS country,
       cl.language AS language
FROM countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
WHERE
     c.name = 'Brazil'
ORDER BY c.name, cl.language

-- Switzerland? (6)
SELECT c.name AS country,
       cl.language AS language
FROM countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
WHERE
     c.name = 'Switzerland'
ORDER BY c.name, cl.language


-- What are the cities of the US? (274)
SELECT c.name AS country,
       ci.name AS city
FROM countries c JOIN
     cities ci ON (c.code = ci.countrycode)
WHERE
      c.name = 'United States'
ORDER BY ci.name, c.name
-- India? (341)
SELECT c.name AS country,
       ci.name AS city
FROM countries c JOIN
     cities ci ON (c.code = ci.countrycode)
WHERE
      c.name = 'India'
ORDER BY ci.name, c.name

-- What are the official languages of Switzerland?
SELECT c.name AS country,
       cl.language AS language,
       cl.isofficial AS official
FROM countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
WHERE
     c.name = 'Switzerland'
ORDER BY c.name, cl.language, cl.isofficial

-- Which country or contries speak the most languages?
WITH totalLang AS (
SELECT c.name AS country,
       cl.language AS language
  FROM countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
  GROUP BY c.name, cl.language)

SELECT COUNT(totalLang.language) AS TotalLanguages, totalLang.country
  FROM totalLang
  GROUP BY totalLang.country
  ORDER BY TotalLanguages DESC

-- Which country or contries have the most offficial languages?
  SELECT cl.isofficial,
  c.code,
  c.name AS country,
  COUNT(cl.language) AS language
  FROM countrylanguages cl JOIN countries c
  ON (cl.countrycode = c.code)
  WHERE cl.isofficial <> 'f'
  GROUP BY c.name, cl.isofficial, c.code
  ORDER BY language DESC


-- Which languages are spoken in the ten largest (area) countries?
WITH large AS (
SELECT *
FROM countries
WHERE surfacearea > 0
ORDER BY surfacearea DESC LIMIT 11)

SELECT cl.language AS language, name
FROM countrylanguages cl JOIN large l
ON (l.code = cl.countrycode)
ORDER BY code desc


-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)


WITH poorest AS (
SELECT name, gnp, code, (gnp/population) AS capita_gnp
FROM countries
WHERE gnp > 0
ORDER BY gnp LIMIT 20)

SELECT cl.language AS language, name, capita_gnp
FROM countrylanguages cl JOIN poorest p
ON (p.code = cl.countrycode)
ORDER BY code desc

--Are there any countries without an official language?
SELECT
  cl.language AS language,
  c.name AS country,
  cl.isofficial AS is_official
FROM
  countries c JOIN
  countrylanguages cl ON (c.code = cl.countrycode)
WHERE cl.countrycode NOT IN (
	SELECT countrycode
	FROM countrylanguages
	WHERE isofficial = TRUE)
GROUP BY
  cl.language,
  c.name,
  cl.isofficial
ORDER BY
  c.name
