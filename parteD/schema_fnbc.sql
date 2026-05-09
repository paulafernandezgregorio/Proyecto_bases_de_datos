ROLLBACK;

BEGIN;

CREATE SCHEMA IF NOT EXISTS core;

DROP TABLE IF EXISTS core.movie_crew;
DROP TABLE IF EXISTS core.movie_cast;
DROP TABLE IF EXISTS core.movie_countries;
DROP TABLE IF EXISTS core.movie_companies;
DROP TABLE IF EXISTS core.movie_genres;
DROP TABLE IF EXISTS core.movie_keywords;
DROP TABLE IF EXISTS core.countries;
DROP TABLE IF EXISTS core.companies;
DROP TABLE IF EXISTS core.genres;
DROP TABLE IF EXISTS core.keywords;
DROP TABLE IF EXISTS core.persons;
DROP TABLE IF EXISTS core.movies;

CREATE TABLE core.movies (
    movie_id BIGINT PRIMARY KEY,
    adult BOOLEAN,
    budget BIGINT,
    imdb_id text,
    original_language text,
    original_title text,
    overview text,
    popularity DOUBLE PRECISION,
    release_date DATE,
    revenue BIGINT,
    runtime DOUBLE PRECISION,
    status text,
    vote_average DOUBLE PRECISION,
    vote_count BIGINT
);

CREATE TABLE core.persons (
    person_id BIGINT PRIMARY KEY,
    gender BIGINT,
    name text,
    UNIQUE (person_id, gender, name)
);

CREATE TABLE core.keywords (
    keyword_id BIGINT PRIMARY KEY,
    name text
);

CREATE TABLE core.genres (
    genre_id BIGINT PRIMARY KEY,
    name text
);

CREATE TABLE core.companies (
    company_id BIGINT PRIMARY KEY,
    name text
);

CREATE TABLE core.countries (
    iso_3166_1 text PRIMARY KEY,
    name text
);

CREATE TABLE core.movie_keywords (
    movie_id BIGINT NOT NULL,
    keyword_id BIGINT NOT NULL,
    PRIMARY KEY (movie_id, keyword_id),
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (keyword_id) REFERENCES core.keywords (keyword_id)
);

CREATE TABLE core.movie_genres (
    movie_id BIGINT NOT NULL,
    genre_id BIGINT NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (genre_id) REFERENCES core.genres (genre_id)
);

CREATE TABLE core.movie_companies (
    movie_id BIGINT NOT NULL,
    company_id BIGINT NOT NULL,
    PRIMARY KEY (movie_id, company_id),
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (company_id) REFERENCES core.companies (company_id)
);

CREATE TABLE core.movie_countries (
    movie_id BIGINT NOT NULL,
    iso_3166_1 text NOT NULL,
    PRIMARY KEY (movie_id, iso_3166_1),
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (iso_3166_1) REFERENCES core.countries (iso_3166_1)
);

CREATE TABLE core.movie_cast (
    movie_id BIGINT NOT NULL,
    person_id BIGINT NOT NULL,
    character text,
    cast_id BIGINT,
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (person_id) REFERENCES core.persons (person_id),
    PRIMARY KEY (movie_id, person_id)
);

CREATE TABLE core.movie_crew (
    movie_id BIGINT NOT NULL,
    person_id BIGINT NOT NULL,
    department text,
    job text,
    FOREIGN KEY (movie_id) REFERENCES core.movies (movie_id),
    FOREIGN KEY (person_id) REFERENCES core.persons (person_id),
    PRIMARY KEY (movie_id, person_id)
);

INSERT INTO core.movies (
    movie_id, adult, budget, imdb_id, original_language, original_title, overview,
    popularity, release_date, revenue, runtime, status, vote_average, vote_count
)
SELECT DISTINCT
    movie_id, adult, budget, imdb_id, original_language, original_title, overview,
    popularity, release_date, revenue, runtime, status, vote_average, vote_count
FROM raw.movies_metadata
WHERE movie_id IS NOT NULL;

INSERT INTO core.persons (person_id, gender, name)
SELECT DISTINCT person_id, gender, name
FROM raw.credits_cast
WHERE person_id IS NOT NULL
UNION
SELECT DISTINCT person_id, gender, name
FROM raw.credits_crew
WHERE person_id IS NOT NULL;

INSERT INTO core.keywords (keyword_id, name)
SELECT DISTINCT keyword_id, name
FROM raw.keywords_keywords
WHERE keyword_id IS NOT NULL;

INSERT INTO core.genres (genre_id, name)
SELECT DISTINCT genre_id, name
FROM raw.movies_metadata_genres
WHERE genre_id IS NOT NULL;

INSERT INTO core.companies (company_id, name)
SELECT DISTINCT company_id, name
FROM raw.movies_metadata_production_companies
WHERE company_id IS NOT NULL;

INSERT INTO core.countries (iso_3166_1, name)
SELECT DISTINCT iso_3166_1, name
FROM raw.movies_metadata_production_countries
WHERE iso_3166_1 IS NOT NULL AND iso_3166_1 <> '';

INSERT INTO core.movie_keywords (movie_id, keyword_id)
SELECT DISTINCT rk.movie_id, rk.keyword_id
FROM raw.keywords_keywords rk
JOIN core.movies m ON m.movie_id = rk.movie_id
JOIN core.keywords k ON k.keyword_id = rk.keyword_id
WHERE rk.movie_id IS NOT NULL
  AND rk.keyword_id IS NOT NULL;

INSERT INTO core.movie_genres (movie_id, genre_id)
SELECT DISTINCT rg.movie_id, rg.genre_id
FROM raw.movies_metadata_genres rg
JOIN core.movies m ON m.movie_id = rg.movie_id
JOIN core.genres g ON g.genre_id = rg.genre_id
WHERE rg.movie_id IS NOT NULL
  AND rg.genre_id IS NOT NULL;

INSERT INTO core.movie_companies (movie_id, company_id)
SELECT DISTINCT rc.movie_id, rc.company_id
FROM raw.movies_metadata_production_companies rc
JOIN core.movies m ON m.movie_id = rc.movie_id
JOIN core.companies c ON c.company_id = rc.company_id
WHERE rc.movie_id IS NOT NULL
  AND rc.company_id IS NOT NULL;

INSERT INTO core.movie_countries (movie_id, iso_3166_1)
SELECT DISTINCT rc.movie_id, rc.iso_3166_1
FROM raw.movies_metadata_production_countries rc
JOIN core.movies m ON m.movie_id = rc.movie_id
JOIN core.countries c ON c.iso_3166_1 = rc.iso_3166_1
WHERE rc.movie_id IS NOT NULL
  AND rc.iso_3166_1 IS NOT NULL AND rc.iso_3166_1 <> '';

INSERT INTO core.movie_cast (movie_id, person_id, character, cast_id)
SELECT
    cc.movie_id,
    cc.person_id,
    MIN(cc.character) AS character,
    MIN(cc.cast_id) AS cast_id
FROM raw.credits_cast cc
JOIN core.movies m ON m.movie_id = cc.movie_id
JOIN core.persons p ON p.person_id = cc.person_id
WHERE cc.movie_id IS NOT NULL
  AND cc.person_id IS NOT NULL
GROUP BY cc.movie_id, cc.person_id;

INSERT INTO core.movie_crew (movie_id, person_id, department, job)
SELECT
    cw.movie_id,
    cw.person_id,
    MIN(cw.department) AS department,
    MIN(cw.job) AS job
FROM raw.credits_crew cw
JOIN core.movies m ON m.movie_id = cw.movie_id
JOIN core.persons p ON p.person_id = cw.person_id
WHERE cw.movie_id IS NOT NULL
  AND cw.person_id IS NOT NULL
GROUP BY cw.movie_id, cw.person_id;

COMMIT;
