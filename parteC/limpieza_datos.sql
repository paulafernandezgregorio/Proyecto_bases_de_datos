-- LIMPIEZA DE DATOS

-- Antes de la limpieza
SELECT 'movies_metadata' AS tabla, COUNT(*) FROM raw.movies_metadata
UNION ALL SELECT 'credits_cast', COUNT(*) FROM raw.credits_cast
UNION ALL SELECT 'credits_crew', COUNT(*) FROM raw.credits_crew
UNION ALL SELECT 'movies_metadata_genres', COUNT(*) FROM raw.movies_metadata_genres
UNION ALL SELECT 'movies_metadata_production_companies', COUNT(*) FROM raw.movies_metadata_production_companies
UNION ALL SELECT 'movies_metadata_production_countries', COUNT(*) FROM raw.movies_metadata_production_countries
UNION ALL SELECT 'keywords_keywords', COUNT(*) FROM raw.keywords_keywords;


-- 1. Eliminar filas duplicadas y filas sin movie_id
DELETE FROM raw.movies_metadata
WHERE ctid NOT IN (
    SELECT DISTINCT ON (movie_id) ctid
    FROM raw.movies_metadata
    ORDER BY movie_id, ctid
);
DELETE FROM raw.movies_metadata
WHERE movie_id IS NULL;


-- 2. Convertir budget y revenue de 0 a NULL
UPDATE raw.movies_metadata SET budget  = NULL WHERE budget  = 0;
UPDATE raw.movies_metadata SET revenue = NULL WHERE revenue = 0;


-- 3. Corregir código de idioma incorrecto
UPDATE raw.movies_metadata SET original_language = 'zh' WHERE original_language = 'cn';


-- 4. Eliminar películas sin estatus
DELETE FROM raw.movies_metadata WHERE status IS NULL OR status = '';


-- 5. Convertir runtime de 0 a NULL
UPDATE raw.movies_metadata SET runtime = NULL WHERE runtime = 0;


-- 6. Fechas
-- Con tipo DATE, el formato ya queda validado durante la carga.


-- 7. Adult
-- Con tipo BOOLEAN, la validez ya queda controlada durante la carga.


-- 7.1 Normalizar nombres y géneros para todas las personas con inconsistencias
-- Regla nombre: preferimos formato latino/inglés; luego mayor frecuencia.
-- Regla género: mayor frecuencia, priorizando valores distintos de 0.
WITH persons_all AS (
    SELECT person_id, name, gender FROM raw.credits_cast
    UNION ALL
    SELECT person_id, name, gender FROM raw.credits_crew
),
name_candidates AS (
    SELECT
        person_id,
        name,
        COUNT(*) AS cnt,
        CASE WHEN name ~ '^[A-Za-z0-9 .,''()\-]+$' THEN 1 ELSE 0 END AS is_latin
    FROM persons_all
    WHERE person_id IS NOT NULL
      AND name IS NOT NULL
      AND name <> ''
    GROUP BY person_id, name
),
name_ranked AS (
    SELECT
        person_id,
        name,
        ROW_NUMBER() OVER (
            PARTITION BY person_id
            ORDER BY is_latin DESC, cnt DESC, LENGTH(name), name
        ) AS rn
    FROM name_candidates
),
name_conflicts AS (
    SELECT person_id
    FROM name_candidates
    GROUP BY person_id
    HAVING COUNT(DISTINCT name) > 1
),
name_canonical AS (
    SELECT nr.person_id, nr.name
    FROM name_ranked nr
    JOIN name_conflicts nc ON nc.person_id = nr.person_id
    WHERE nr.rn = 1
),
gender_candidates AS (
    SELECT person_id, gender, COUNT(*) AS cnt
    FROM persons_all
    WHERE person_id IS NOT NULL
      AND gender IS NOT NULL
    GROUP BY person_id, gender
),
gender_ranked AS (
    SELECT
        person_id,
        gender,
        ROW_NUMBER() OVER (
            PARTITION BY person_id
            ORDER BY CASE WHEN gender <> 0 THEN 1 ELSE 0 END DESC, cnt DESC, gender DESC
        ) AS rn
    FROM gender_candidates
),
gender_conflicts AS (
    SELECT person_id
    FROM gender_candidates
    GROUP BY person_id
    HAVING COUNT(DISTINCT gender) > 1
),
gender_canonical AS (
    SELECT gr.person_id, gr.gender
    FROM gender_ranked gr
    JOIN gender_conflicts gc ON gc.person_id = gr.person_id
    WHERE gr.rn = 1
),
resolved AS (
    SELECT
        COALESCE(nc.person_id, gc.person_id) AS person_id,
        nc.name,
        gc.gender
    FROM name_canonical nc
    FULL JOIN gender_canonical gc ON gc.person_id = nc.person_id
)
UPDATE raw.credits_cast cc
SET
    name = COALESCE(r.name, cc.name),
    gender = COALESCE(r.gender, cc.gender)
FROM resolved r
WHERE cc.person_id = r.person_id;

WITH persons_all AS (
    SELECT person_id, name, gender FROM raw.credits_cast
    UNION ALL
    SELECT person_id, name, gender FROM raw.credits_crew
),
name_candidates AS (
    SELECT
        person_id,
        name,
        COUNT(*) AS cnt,
        CASE WHEN name ~ '^[A-Za-z0-9 .,''()\-]+$' THEN 1 ELSE 0 END AS is_latin
    FROM persons_all
    WHERE person_id IS NOT NULL
      AND name IS NOT NULL
      AND name <> ''
    GROUP BY person_id, name
),
name_ranked AS (
    SELECT
        person_id,
        name,
        ROW_NUMBER() OVER (
            PARTITION BY person_id
            ORDER BY is_latin DESC, cnt DESC, LENGTH(name), name
        ) AS rn
    FROM name_candidates
),
name_conflicts AS (
    SELECT person_id
    FROM name_candidates
    GROUP BY person_id
    HAVING COUNT(DISTINCT name) > 1
),
name_canonical AS (
    SELECT nr.person_id, nr.name
    FROM name_ranked nr
    JOIN name_conflicts nc ON nc.person_id = nr.person_id
    WHERE nr.rn = 1
),
gender_candidates AS (
    SELECT person_id, gender, COUNT(*) AS cnt
    FROM persons_all
    WHERE person_id IS NOT NULL
      AND gender IS NOT NULL
    GROUP BY person_id, gender
),
gender_ranked AS (
    SELECT
        person_id,
        gender,
        ROW_NUMBER() OVER (
            PARTITION BY person_id
            ORDER BY CASE WHEN gender <> 0 THEN 1 ELSE 0 END DESC, cnt DESC, gender DESC
        ) AS rn
    FROM gender_candidates
),
gender_conflicts AS (
    SELECT person_id
    FROM gender_candidates
    GROUP BY person_id
    HAVING COUNT(DISTINCT gender) > 1
),
gender_canonical AS (
    SELECT gr.person_id, gr.gender
    FROM gender_ranked gr
    JOIN gender_conflicts gc ON gc.person_id = gr.person_id
    WHERE gr.rn = 1
),
resolved AS (
    SELECT
        COALESCE(nc.person_id, gc.person_id) AS person_id,
        nc.name,
        gc.gender
    FROM name_canonical nc
    FULL JOIN gender_canonical gc ON gc.person_id = nc.person_id
)
UPDATE raw.credits_crew cw
SET
    name = COALESCE(r.name, cw.name),
    gender = COALESCE(r.gender, cw.gender)
FROM resolved r
WHERE cw.person_id = r.person_id;


-- 8. Eliminar registros huérfanos en las tablas secundarias
DELETE FROM raw.credits_cast WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.credits_crew WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_genres WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_production_companies WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_production_countries WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.keywords_keywords WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);


-- 9. Eliminar duplicados en tablas secundarias
DELETE FROM raw.movies_metadata_genres WHERE ctid NOT IN (SELECT MIN(ctid) FROM raw.movies_metadata_genres GROUP BY movie_id, genre_id);
DELETE FROM raw.movies_metadata_production_companies WHERE ctid NOT IN (SELECT MIN(ctid) FROM raw.movies_metadata_production_companies GROUP BY movie_id, company_id);
DELETE FROM raw.movies_metadata_production_countries WHERE ctid NOT IN (SELECT MIN(ctid) FROM raw.movies_metadata_production_countries GROUP BY movie_id, iso_3166_1);
DELETE FROM raw.keywords_keywords WHERE ctid NOT IN (SELECT MIN(ctid) FROM raw.keywords_keywords GROUP BY movie_id, keyword_id);


-- Conteo después de la limpieza
SELECT 'movies_metadata' AS tabla, COUNT(*) FROM raw.movies_metadata
UNION ALL SELECT 'credits_cast', COUNT(*) FROM raw.credits_cast
UNION ALL SELECT 'credits_crew', COUNT(*) FROM raw.credits_crew
UNION ALL SELECT 'movies_metadata_genres', COUNT(*) FROM raw.movies_metadata_genres
UNION ALL SELECT 'movies_metadata_production_companies', COUNT(*) FROM raw.movies_metadata_production_companies
UNION ALL SELECT 'movies_metadata_production_countries', COUNT(*) FROM raw.movies_metadata_production_countries
UNION ALL SELECT 'keywords_keywords', COUNT(*) FROM raw.keywords_keywords;
