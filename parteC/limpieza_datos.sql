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
-- Si una película aparece más de una vez, conservamos solo la primera aparición.
-- También eliminamos filas que no tienen identificador de película.
DELETE FROM raw.movies_metadata
WHERE ctid NOT IN (
    SELECT DISTINCT ON (movie_id) ctid
    FROM raw.movies_metadata
    ORDER BY movie_id, ctid
);
DELETE FROM raw.movies_metadata
WHERE movie_id IS NULL OR movie_id = '';


-- 2. Convertir budget y revenue de 0 a NULL
-- En este dataset, cuando no se conoce el presupuesto o los ingresos de una película,
-- el valor aparece como 0 en lugar de estar vacío. Esto es engañoso porque 0 parece
-- un dato real. Lo convertimos a NULL para indicar que el dato no está disponible.
UPDATE raw.movies_metadata SET budget  = NULL WHERE budget  = '0';
UPDATE raw.movies_metadata SET revenue = NULL WHERE revenue = '0';


-- 3. Corregir código de idioma incorrecto
-- El código 'cn' no existe en el estándar ISO de idiomas.
-- El idioma chino se representa correctamente como 'zh'.
UPDATE raw.movies_metadata SET original_language = 'zh' WHERE original_language = 'cn';


-- 4. Eliminar películas sin estatus
-- No podemos saber si la película fue estrenada o no, por lo que estos registros
-- no son útiles para el análisis.
DELETE FROM raw.movies_metadata WHERE status IS NULL OR status = '';


-- 5. Convertir runtime de 0 o vacío a NULL
-- Una duración de 0 minutos no es válida, por lo que se trata como dato faltante.
UPDATE raw.movies_metadata SET runtime = NULL WHERE runtime = '' OR runtime = '0';


-- 6. Eliminar fechas con formato incorrecto y convertir fechas vacías a NULL
-- Solo conservamos fechas con el formato YYYY-MM-DD.
-- Las fechas vacías se convierten a NULL para indicar que no están disponibles.
DELETE FROM raw.movies_metadata
WHERE release_date IS NOT NULL AND release_date != ''
  AND release_date !~ '^\d{4}-\d{2}-\d{2}$';
UPDATE raw.movies_metadata SET release_date = NULL WHERE release_date = '';


-- 7. Eliminar filas con valores inválidos en la columna adult
-- Esta columna solo debe contener 'True' o 'False'.
-- Cualquier otro valor indica un error en los datos.
DELETE FROM raw.movies_metadata WHERE adult NOT IN ('True', 'False');


-- 8. Eliminar registros huérfanos en las tablas secundarias
-- Un registro huérfano es aquel que hace referencia a una película
-- que ya no existe en movies_metadata (fue eliminada en pasos anteriores).
DELETE FROM raw.credits_cast WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.credits_crew WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_genres WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_production_companies WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.movies_metadata_production_countries WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);
DELETE FROM raw.keywords_keywords WHERE movie_id NOT IN (SELECT movie_id FROM raw.movies_metadata);


-- 9. Eliminar duplicados en tablas secundarias
-- Eliminamos casos donde la misma película tiene el mismo género, país,
-- compañía o keyword registrado más de una vez.
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