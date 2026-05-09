-- ============================================================
-- PROYECTO FINAL - BASES DE DATOS
-- Parte B: Limpieza y Análisis Exploratorio
-- ============================================================


-- 1. Eliminar columnas innecesarias

-- credits_cast: se eliminan profile_path (URL de imagen no usable)
--               y order (orden de aparición, no relevante)
ALTER TABLE raw.credits_cast
    DROP COLUMN IF EXISTS profile_path,
    DROP COLUMN IF EXISTS "order";

-- credits_crew: se elimina profile_path por la misma razón
ALTER TABLE raw.credits_crew
    DROP COLUMN IF EXISTS profile_path;


-- ============================================================
-- 2. Análisis exploratorio
-- ============================================================

-- Conteo de registros por tabla
SELECT 'movies_metadata'                       AS tabla, COUNT(*) AS registros FROM raw.movies_metadata
UNION ALL SELECT 'movies_metadata_genres',                COUNT(*) FROM raw.movies_metadata_genres
UNION ALL SELECT 'movies_metadata_production_companies',  COUNT(*) FROM raw.movies_metadata_production_companies
UNION ALL SELECT 'movies_metadata_production_countries',  COUNT(*) FROM raw.movies_metadata_production_countries
UNION ALL SELECT 'credits_cast',                          COUNT(*) FROM raw.credits_cast
UNION ALL SELECT 'credits_crew',                          COUNT(*) FROM raw.credits_crew
UNION ALL SELECT 'keywords_keywords',                     COUNT(*) FROM raw.keywords_keywords;

-- Valores nulos por columna en movies_metadata
SELECT
    COUNT(*) FILTER (WHERE adult             IS NULL)                           AS nulos_adult,
    COUNT(*) FILTER (WHERE budget            IS NULL)                           AS nulos_budget,
    COUNT(*) FILTER (WHERE movie_id          IS NULL)                           AS nulos_movie_id,
    COUNT(*) FILTER (WHERE imdb_id           IS NULL OR imdb_id = '')           AS nulos_imdb_id,
    COUNT(*) FILTER (WHERE original_language IS NULL OR original_language = '') AS nulos_lang,
    COUNT(*) FILTER (WHERE overview          IS NULL OR overview = '')          AS nulos_overview,
    COUNT(*) FILTER (WHERE release_date      IS NULL)                           AS nulos_fecha,
    COUNT(*) FILTER (WHERE runtime           IS NULL)                           AS nulos_runtime,
    COUNT(*) FILTER (WHERE status            IS NULL OR status = '')            AS nulos_status,
    COUNT(*) FILTER (WHERE vote_average      IS NULL)                           AS nulos_vote_avg,
    COUNT(*) FILTER (WHERE vote_count        IS NULL)                           AS nulos_vote_count
FROM raw.movies_metadata;

-- Rango de fechas
SELECT
    MIN(release_date) AS fecha_minima,
    MAX(release_date) AS fecha_maxima
FROM raw.movies_metadata;

-- Estadísticas numéricas
SELECT
    MIN(budget)                    AS budget_min,
    MAX(budget)                    AS budget_max,
    ROUND(AVG(budget))             AS budget_avg,
    MIN(revenue)                   AS revenue_min,
    MAX(revenue)                   AS revenue_max,
    ROUND(AVG(revenue))            AS revenue_avg,
    MIN(runtime)                   AS runtime_min,
    MAX(runtime)                   AS runtime_max,
    ROUND(AVG(runtime))            AS runtime_avg,
    MIN(vote_average)              AS vote_avg_min,
    MAX(vote_average)              AS vote_avg_max,
    ROUND(AVG(vote_average)::numeric, 2)    AS vote_avg_prom
FROM raw.movies_metadata;

-- Películas con budget o revenue = 0 (datos faltantes)
SELECT
    COUNT(*) FILTER (WHERE budget = 0)  AS budget_cero,
    COUNT(*) FILTER (WHERE revenue = 0) AS revenue_cero,
    COUNT(*) FILTER (WHERE runtime = 0) AS runtime_cero
FROM raw.movies_metadata;

-- IDs duplicados
SELECT
    COUNT(*)                            AS total,
    COUNT(DISTINCT movie_id)            AS ids_unicos,
    COUNT(*) - COUNT(DISTINCT movie_id) AS duplicados
FROM raw.movies_metadata;

-- Idiomas más frecuentes
SELECT original_language, COUNT(*) AS total
FROM raw.movies_metadata
GROUP BY original_language
ORDER BY total DESC
LIMIT 15;

-- Estatus de películas
SELECT status, COUNT(*) AS total
FROM raw.movies_metadata
GROUP BY status
ORDER BY total DESC;

-- Géneros más frecuentes
SELECT name AS genero, COUNT(*) AS total
FROM raw.movies_metadata_genres
GROUP BY name
ORDER BY total DESC
LIMIT 15;

-- Países productores más frecuentes
SELECT name AS pais, COUNT(*) AS total
FROM raw.movies_metadata_production_countries
GROUP BY name
ORDER BY total DESC
LIMIT 10;

-- Compañías productoras más frecuentes
SELECT name AS compania, COUNT(*) AS total
FROM raw.movies_metadata_production_companies
GROUP BY name
ORDER BY total DESC
LIMIT 10;

-- Keywords más frecuentes
SELECT name AS keyword, COUNT(*) AS total
FROM raw.keywords_keywords
GROUP BY name
ORDER BY total DESC
LIMIT 15;
