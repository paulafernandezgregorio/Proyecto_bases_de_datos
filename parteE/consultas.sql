--Sesgo de Genero
--Porcentaje de directores mujeres vs hombres:
SELECT 
    CASE gender 
        WHEN 1 THEN 'Mujer'
        WHEN 2 THEN 'Hombre'
        ELSE 'No especificado'
    END AS genero,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM core.movie_crew mc
JOIN core.persons p ON p.person_id = mc.person_id
WHERE mc.job = 'Director'
GROUP BY gender
ORDER BY total DESC;

--Presupuesto promedio según género del director
SELECT 
    CASE p.gender 
        WHEN 1 THEN 'Mujer'
        WHEN 2 THEN 'Hombre'
        ELSE 'No especificado'
    END AS genero_director,
    ROUND(AVG(m.budget)) AS presupuesto_promedio,
    ROUND(AVG(m.revenue)) AS revenue_promedio,
    COUNT(*) AS total_peliculas
FROM core.movie_crew mc
JOIN core.persons p ON p.person_id = mc.person_id
JOIN core.movies m ON m.movie_id = mc.movie_id
WHERE mc.job = 'Director'
  AND m.budget IS NOT NULL
  AND m.budget > 0
  AND m.revenue IS NOT NULL
  AND m.revenue > 0
GROUP BY p.gender
ORDER BY presupuesto_promedio DESC;

---Porcentaje del cast por género:
SELECT 
    CASE p.gender 
        WHEN 1 THEN 'Mujer'
        WHEN 2 THEN 'Hombre'
        ELSE 'No especificado'
    END AS genero,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM core.movie_cast mc
JOIN core.persons p ON p.person_id = mc.person_id
GROUP BY p.gender
ORDER BY total DESC;

--Sesgos de idioma/país
--Presupuesto y revenue promedio por idioma (Top 10)
SELECT 
    original_language,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(budget)) AS presupuesto_promedio,
    ROUND(AVG(revenue)) AS revenue_promedio
FROM core.movies
WHERE budget > 0 AND revenue > 0
GROUP BY original_language
ORDER BY total_peliculas DESC
LIMIT 10;

--Países que más producen y su revenue promedio:
SELECT 
    c.name AS pais,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(m.revenue)) AS revenue_promedio,
    ROUND(AVG(m.budget)) AS presupuesto_promedio
FROM core.movie_countries mc
JOIN core.countries c ON c.iso_3166_1 = mc.iso_3166_1
JOIN core.movies m ON m.movie_id = mc.movie_id
WHERE m.revenue > 0 AND m.budget > 0
GROUP BY c.name
ORDER BY total_peliculas DESC
LIMIT 15;

--Sesgos de género cinematográfico
--Presupuesto promedio por género cinematográfico y su calificacion

SELECT 
    g.name AS genero,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(m.budget)) AS presupuesto_promedio,
    ROUND(AVG(m.revenue)) AS revenue_promedio,
    ROUND(AVG(m.vote_average)::numeric, 2) AS calificacion_promedio
FROM core.movie_genres mg
JOIN core.genres g ON g.genre_id = mg.genre_id
JOIN core.movies m ON m.movie_id = mg.movie_id
WHERE m.budget > 0 AND m.revenue > 0
GROUP BY g.name
ORDER BY presupuesto_promedio DESC;

--Relación presupuesto/revenue por género (rentabilidad)
SELECT 
    g.name AS genero,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(m.revenue::NUMERIC / NULLIF(m.budget, 0)), 2) AS roi_promedio
FROM core.movie_genres mg
JOIN core.genres g ON g.genre_id = mg.genre_id
JOIN core.movies m ON m.movie_id = mg.movie_id
WHERE m.budget > 0 AND m.revenue > 0
GROUP BY g.name
ORDER BY roi_promedio DESC;

--Sesgos temporales
--Diversidad de idiomas por década
SELECT 
    (EXTRACT(YEAR FROM release_date) / 10 * 10)::INT AS decada,
    COUNT(DISTINCT original_language) AS idiomas_distintos,
    COUNT(*) AS total_peliculas
FROM core.movies
WHERE release_date IS NOT NULL
GROUP BY decada
ORDER BY decada;

-- Evolución de directoras por década
SELECT 
    (EXTRACT(YEAR FROM m.release_date) / 10 * 10)::INT AS decada,
    COUNT(*) AS total_directores,
    SUM(CASE WHEN p.gender = 1 THEN 1 ELSE 0 END) AS directoras_mujeres,
    ROUND(SUM(CASE WHEN p.gender = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_mujeres
FROM core.movie_crew mc
JOIN core.persons p ON p.person_id = mc.person_id
JOIN core.movies m ON m.movie_id = mc.movie_id
WHERE mc.job = 'Director'
  AND m.release_date IS NOT NULL
GROUP BY decada
ORDER BY decada;

--Presupuesto promedio por década
SELECT 
    (EXTRACT(YEAR FROM release_date) / 10 * 10)::INT AS decada,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(budget)::NUMERIC) AS presupuesto_promedio,
    ROUND(AVG(revenue)::NUMERIC) AS revenue_promedio
FROM core.movies
WHERE release_date IS NOT NULL
  AND budget > 0 AND revenue > 0
GROUP BY decada
ORDER BY decada;

-- Mes de estreno y su impacto en revenue
SELECT 
    EXTRACT(MONTH FROM release_date) AS mes,
    TO_CHAR(release_date, 'Month') AS nombre_mes,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(revenue)::NUMERIC) AS revenue_promedio
FROM core.movies
WHERE release_date IS NOT NULL AND revenue > 0
GROUP BY mes, nombre_mes
ORDER BY revenue_promedio DESC;


--Sesgos de duración
SELECT 
    CASE 
        WHEN runtime < 90 THEN 'Corta (<90 min)'
        WHEN runtime < 120 THEN 'Normal (90-120 min)'
        WHEN runtime < 150 THEN 'Larga (120-150 min)'
        ELSE 'Muy larga (>150 min)'
    END AS duracion,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(budget)::NUMERIC) AS presupuesto_promedio,
    ROUND(AVG(revenue)::NUMERIC) AS revenue_promedio,
    ROUND(AVG(vote_average)::NUMERIC, 2) AS calificacion_promedio
FROM core.movies
WHERE runtime > 0 AND budget > 0 AND revenue > 0
GROUP BY duracion
ORDER BY revenue_promedio DESC;

--Relación entre popularidad y calificación
SELECT 
    CASE 
        WHEN vote_average >= 8 THEN 'Excelente (8-10)'
        WHEN vote_average >= 6 THEN 'Buena (6-8)'
        WHEN vote_average >= 4 THEN 'Regular (4-6)'
        ELSE 'Mala (0-4)'
    END AS rango_calificacion,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(popularity)::NUMERIC, 2) AS popularidad_promedio,
    ROUND(AVG(revenue)::NUMERIC) AS revenue_promedio
FROM core.movies
WHERE vote_average > 0
GROUP BY rango_calificacion
ORDER BY rango_calificacion DESC;
