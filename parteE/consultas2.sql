--Religión: ¿Hay algún sesgo si se menciona alguna religión en la descripción de la película? 
--Sea los keywords: 186, christianity, 187, islam, 188, buddhism 
SELECT 
    mk.keyword_id,
    SUM(m.budget) as suma_total
FROM core.movies m
JOIN core.movie_keywords mk ON mk.movie_id = m.movie_id
WHERE mk.keyword_id IN (186, 187, 188) 
  AND m.budget IS NOT NULL
GROUP BY mk.keyword_id
ORDER BY suma_total ASC;

-- Sesgo de Longevidad y "Ageism"
-- Compara cuántos años pasan entre la primera y la última película de cada persona según su género.
SELECT 
    core.persons.gender,
    ROUND(AVG(subconsulta_carrera.años_duracion), 2) AS años_activos_promedio,
    COUNT(core.persons.person_id) AS total_personas
FROM core.persons
JOIN (
        SELECT 
        core.movie_cast.person_id,
        MAX(EXTRACT(YEAR FROM core.movies.release_date)) - MIN(EXTRACT(YEAR FROM core.movies.release_date)) AS años_duracion
    FROM core.movie_cast
    JOIN core.movies ON core.movie_cast.movie_id = core.movies.movie_id
    WHERE core.movies.release_date IS NOT NULL
    GROUP BY core.movie_cast.person_id
) AS subconsulta_carrera ON core.persons.person_id = subconsulta_carrera.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;

-- Sesgo de "Tokenismo" en el Reparto
-- Analiza la representación de género en películas donde la primera figura (protagonista) es mujer.
WITH PelisProtagonistaFemenina AS (
    SELECT movie_id
    FROM (
        SELECT 
            core.movie_cast.movie_id, 
            core.persons.gender, 
            ROW_NUMBER() OVER(PARTITION BY core.movie_cast.movie_id ORDER BY core.movie_cast.cast_id ASC) AS rango_reparto
        FROM core.movie_cast
        JOIN core.persons ON core.movie_cast.person_id = core.persons.person_id
    ) AS ranking_cast
    WHERE ranking_cast.rango_reparto = 1 AND ranking_cast.gender = 1
)
SELECT 
    core.persons.gender,
    COUNT(*) AS total_actores,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM core.movie_cast
JOIN PelisProtagonistaFemenina ON core.movie_cast.movie_id = PelisProtagonistaFemenina.movie_id
JOIN core.persons ON core.movie_cast.person_id = core.persons.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;

-- Sesgo de Roles de Poder (Crew de Alto Nivel)
-- Calcula la participación femenina en puestos clave mediante un conteo directo con FILTER.
SELECT 
    core.movie_crew.job,
    COUNT(*) FILTER (WHERE core.persons.gender = 1) AS total_mujeres,
    COUNT(*) FILTER (WHERE core.persons.gender = 2) AS total_hombres,
    ROUND(COUNT(*) FILTER (WHERE core.persons.gender = 1) * 100.0 / COUNT(*), 2) AS porcentaje_mujeres
FROM core.movie_crew
JOIN core.persons ON core.movie_crew.person_id = core.persons.person_id
WHERE core.movie_crew.job IN ('Director', 'Producer', 'Editor', 'Writer', 'Director of Photography')
GROUP BY core.movie_crew.job
ORDER BY porcentaje_mujeres ASC;

-- Sesgo de Centralización (Oligopolio de Productoras)
-- Determina qué porcentaje de los ingresos totales concentran las grandes empresas.
WITH IngresoGlobal AS (
    SELECT SUM(core.movies.revenue) AS total_mundial 
    FROM core.movies 
    WHERE core.movies.revenue > 0
)
SELECT 
    core.companies.name,
    SUM(core.movies.revenue) AS revenue_empresa,
    ROUND((SUM(core.movies.revenue) * 100.0 / (SELECT total_mundial FROM IngresoGlobal)), 2) AS porcentaje_mercado
FROM core.companies
JOIN core.movie_companies ON core.companies.company_id = core.movie_companies.company_id
JOIN core.movies ON core.movie_companies.movie_id = core.movies.movie_id
WHERE core.movies.revenue > 0 
GROUP BY core.companies.name
ORDER BY revenue_empresa DESC LIMIT 10;

-- Sesgo de Género en la Escritura (Guionistas)
-- Analiza si hay una brecha de género específica en el departamento de Writing.
SELECT 
    core.persons.gender,
    COUNT(core.movie_crew.person_id) AS total_escritores,
    ROUND(AVG(core.movies.vote_average)::numeric, 2) AS que_tan_buena_es_la_peli
FROM core.movie_crew
JOIN core.persons ON core.movie_crew.person_id = core.persons.person_id
JOIN core.movies ON core.movie_crew.movie_id = core.movies.movie_id
WHERE core.movie_crew.department = 'Writing' 
  AND core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;

-- Sesgo de Rentabilidad por Idioma Original (ROI)
-- Determina si las películas en idiomas distintos al inglés son más rentables proporcionalmente.
SELECT 
    core.movies.original_language,
    COUNT(core.movies.movie_id) AS total_peliculas,
    ROUND(AVG(core.movies.revenue / NULLIF(core.movies.budget, 0)), 2) AS retorno_inversion_promedio
FROM core.movies
WHERE core.movies.budget > 1000000 
  AND core.movies.revenue > 0
GROUP BY core.movies.original_language
HAVING COUNT(core.movies.movie_id) > 5
ORDER BY retorno_inversion_promedio DESC;

-- Sesgo de Representación en el Top de Popularidad
-- Analiza el género de los protagonistas (primer cast_id) en las 100 películas más populares.
WITH TopCienPopulares AS (
    SELECT core.movies.movie_id
    FROM core.movies
    ORDER BY core.movies.popularity DESC
    LIMIT 100
),
ProtagonistasTop AS (
    SELECT 
        core.movie_cast.movie_id,
        core.persons.gender,
        ROW_NUMBER() OVER(PARTITION BY core.movie_cast.movie_id ORDER BY core.movie_cast.cast_id ASC) AS rango
    FROM core.movie_cast
    JOIN core.persons ON core.movie_cast.person_id = core.persons.person_id
    JOIN TopCienPopulares ON core.movie_cast.movie_id = TopCienPopulares.movie_id
)
SELECT 
    gender,
    COUNT(*) AS total_protagonistas_en_top_100
FROM ProtagonistasTop
WHERE rango = 1 AND gender IN (1, 2)
GROUP BY gender;

-- Sesgo de Visibilidad: Actores vs Personajes con Nombre
-- Compara cuántos actores por género aparecen sin un nombre de personaje definido (NULL o vacío).
SELECT 
    core.persons.gender,
    COUNT(*) FILTER (WHERE core.movie_cast.character IS NULL OR core.movie_cast.character = '') AS personajes_sin_nombre,
    COUNT(*) AS total_apariciones,
    ROUND(COUNT(*) FILTER (WHERE core.movie_cast.character IS NULL OR core.movie_cast.character = '') * 100.0 / COUNT(*), 2) AS porcentaje_invisibilidad
FROM core.movie_cast
JOIN core.persons ON core.movie_cast.person_id = core.persons.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;


 

