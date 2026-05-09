CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.credits_cast;
CREATE TABLE raw.credits_cast (
    movie_id BIGINT,
    cast_id BIGINT,
    character TEXT,
    credit_id TEXT,
    gender BIGINT,
    person_id BIGINT,
    name TEXT,
    "order" BIGINT,
    profile_path TEXT
);

DROP TABLE IF EXISTS raw.credits_crew;
CREATE TABLE raw.credits_crew (
    movie_id BIGINT,
    credit_id TEXT,
    department TEXT,
    gender BIGINT,
    person_id BIGINT,
    job TEXT,
    name TEXT,
    profile_path TEXT
);

DROP TABLE IF EXISTS raw.keywords_keywords;
CREATE TABLE raw.keywords_keywords (
    movie_id BIGINT,
    keyword_id BIGINT,
    name TEXT
);

DROP TABLE IF EXISTS raw.movies_metadata;
CREATE TABLE raw.movies_metadata (
    adult BOOLEAN,
    budget BIGINT,
    movie_id BIGINT,
    imdb_id TEXT,
    original_language TEXT,
    original_title TEXT,
    overview TEXT,
    popularity DOUBLE PRECISION,
    release_date DATE,
    revenue BIGINT,
    runtime DOUBLE PRECISION,
    status TEXT,
    vote_average DOUBLE PRECISION,
    vote_count BIGINT
);

DROP TABLE IF EXISTS raw.movies_metadata_genres;
CREATE TABLE raw.movies_metadata_genres (
    movie_id BIGINT,
    genre_id BIGINT,
    name TEXT
);

DROP TABLE IF EXISTS raw.movies_metadata_production_companies;
CREATE TABLE raw.movies_metadata_production_companies (
    movie_id BIGINT,
    name TEXT,
    company_id BIGINT
);

DROP TABLE IF EXISTS raw.movies_metadata_production_countries;
CREATE TABLE raw.movies_metadata_production_countries (
    movie_id BIGINT,
    iso_3166_1 TEXT,
    name TEXT
);
