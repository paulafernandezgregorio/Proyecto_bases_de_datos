-- ============================================================
--  PROYECTO FINAL: BASE DE DATOS - MovieLens
--  Dataset: The Movies Dataset (Kaggle)
--  Archivos fuente: movies_metadata.csv, credits.csv,
--                   keywords.csv, ratings_small.csv, links.csv
-- ============================================================

-- ============================================================
-- 1. PELICULA
--    Fuente: movies_metadata.csv
--    Entidad principal del modelo
-- ============================================================
CREATE TABLE Pelicula (
    movie_id        INT             PRIMARY KEY,
    titulo          VARCHAR(500)    NOT NULL,
    titulo_original VARCHAR(500),
    descripcion     TEXT,
    fecha_estreno   DATE,
    idioma_original VARCHAR(10),
    presupuesto     BIGINT          DEFAULT 0,
    ingresos        BIGINT          DEFAULT 0,
    duracion        INT,            -- en minutos
    popularidad     FLOAT,
    promedio_votos  FLOAT,
    total_votos     INT             DEFAULT 0,
    es_adulto       BOOLEAN         DEFAULT FALSE,
    tiene_video     BOOLEAN         DEFAULT FALSE,
    estado          VARCHAR(50),    -- Released, Post Production, etc.
    eslogan         TEXT,
    homepage        VARCHAR(500),
    poster_path     VARCHAR(300),
    coleccion_id    INT             -- FK -> Coleccion (nullable)
);

-- ============================================================
-- 2. COLECCION
--    Fuente: belongs_to_collection en movies_metadata.csv
--    Una colección agrupa varias películas (ej. Toy Story Collection)
-- ============================================================
CREATE TABLE Coleccion (
    coleccion_id    INT             PRIMARY KEY,
    nombre          VARCHAR(300)    NOT NULL,
    poster_path     VARCHAR(300),
    backdrop_path   VARCHAR(300)
);

ALTER TABLE Pelicula
    ADD CONSTRAINT fk_pelicula_coleccion
    FOREIGN KEY (coleccion_id) REFERENCES Coleccion(coleccion_id);

-- ============================================================
-- 3. GENERO
--    Fuente: genres en movies_metadata.csv (JSON anidado)
--    Relación muchos-a-muchos con Pelicula
-- ============================================================
CREATE TABLE Genero (
    genero_id       INT             PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL
);

CREATE TABLE Pelicula_Genero (
    movie_id        INT             NOT NULL,
    genero_id       INT             NOT NULL,
    PRIMARY KEY (movie_id, genero_id),
    CONSTRAINT fk_pg_pelicula FOREIGN KEY (movie_id)    REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_pg_genero   FOREIGN KEY (genero_id)   REFERENCES Genero(genero_id)
);

-- ============================================================
-- 4. COMPANIA_PRODUCTORA
--    Fuente: production_companies en movies_metadata.csv
--    Relación muchos-a-muchos con Pelicula
-- ============================================================
CREATE TABLE Compania_Productora (
    compania_id     INT             PRIMARY KEY,
    nombre          VARCHAR(300)    NOT NULL
);

CREATE TABLE Pelicula_Compania (
    movie_id        INT             NOT NULL,
    compania_id     INT             NOT NULL,
    PRIMARY KEY (movie_id, compania_id),
    CONSTRAINT fk_pc_pelicula  FOREIGN KEY (movie_id)    REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_pc_compania  FOREIGN KEY (compania_id) REFERENCES Compania_Productora(compania_id)
);

-- ============================================================
-- 5. PAIS
--    Fuente: production_countries en movies_metadata.csv
--    Relación muchos-a-muchos con Pelicula
-- ============================================================
CREATE TABLE Pais (
    iso_3166_1      CHAR(2)         PRIMARY KEY,
    nombre          VARCHAR(200)    NOT NULL
);

CREATE TABLE Pelicula_Pais (
    movie_id        INT             NOT NULL,
    iso_3166_1      CHAR(2)         NOT NULL,
    PRIMARY KEY (movie_id, iso_3166_1),
    CONSTRAINT fk_pp_pelicula FOREIGN KEY (movie_id)   REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_pp_pais     FOREIGN KEY (iso_3166_1) REFERENCES Pais(iso_3166_1)
);

-- ============================================================
-- 6. PERSONA
--    Fuente: credits.csv (cast y crew)
--    Actores y miembros del equipo técnico
-- ============================================================
CREATE TABLE Persona (
    persona_id      INT             PRIMARY KEY,
    nombre          VARCHAR(300)    NOT NULL,
    genero          TINYINT,        -- 0=No especificado, 1=Femenino, 2=Masculino
    perfil_path     VARCHAR(300)
);

-- ============================================================
-- 7. CAST (Reparto)
--    Fuente: cast dentro de credits.csv
--    Relación muchos-a-muchos Pelicula <-> Persona
-- ============================================================
CREATE TABLE Cast_Pelicula (
    movie_id        INT             NOT NULL,
    persona_id      INT             NOT NULL,
    personaje       VARCHAR(500),
    orden           INT,            -- orden de aparición en créditos
    PRIMARY KEY (movie_id, persona_id),
    CONSTRAINT fk_cast_pelicula FOREIGN KEY (movie_id)   REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_cast_persona  FOREIGN KEY (persona_id) REFERENCES Persona(persona_id)
);

-- ============================================================
-- 8. CREW (Equipo técnico)
--    Fuente: crew dentro de credits.csv
--    Directores, productores, guionistas, etc.
-- ============================================================
CREATE TABLE Crew_Pelicula (
    crew_id         INT             PRIMARY KEY AUTO_INCREMENT,
    movie_id        INT             NOT NULL,
    persona_id      INT             NOT NULL,
    departamento    VARCHAR(100),   -- Directing, Production, Writing, etc.
    puesto          VARCHAR(100),   -- Director, Producer, Screenplay, etc.
    CONSTRAINT fk_crew_pelicula FOREIGN KEY (movie_id)   REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_crew_persona  FOREIGN KEY (persona_id) REFERENCES Persona(persona_id)
);

-- ============================================================
-- 9. KEYWORD
--    Fuente: keywords.csv
--    Palabras clave del argumento de la película
-- ============================================================
CREATE TABLE Keyword (
    keyword_id      INT             PRIMARY KEY,
    nombre          VARCHAR(200)    NOT NULL
);

CREATE TABLE Pelicula_Keyword (
    movie_id        INT             NOT NULL,
    keyword_id      INT             NOT NULL,
    PRIMARY KEY (movie_id, keyword_id),
    CONSTRAINT fk_pk_pelicula FOREIGN KEY (movie_id)   REFERENCES Pelicula(movie_id),
    CONSTRAINT fk_pk_keyword  FOREIGN KEY (keyword_id) REFERENCES Keyword(keyword_id)
);

-- ============================================================
-- 10. USUARIO
--     Fuente: ratings_small.csv (userId)
--     Usuarios anónimos que califican películas
-- ============================================================
CREATE TABLE Usuario (
    user_id         INT             PRIMARY KEY
);

-- ============================================================
-- 11. CALIFICACION
--     Fuente: ratings_small.csv
--     Relación muchos-a-muchos Usuario <-> Pelicula
-- ============================================================
CREATE TABLE Calificacion (
    user_id         INT             NOT NULL,
    movie_id        INT             NOT NULL,
    rating          DECIMAL(2,1)    NOT NULL CHECK (rating BETWEEN 0.5 AND 5.0),
    timestamp       BIGINT,         -- UNIX timestamp
    PRIMARY KEY (user_id, movie_id),
    CONSTRAINT fk_cal_usuario  FOREIGN KEY (user_id)  REFERENCES Usuario(user_id),
    CONSTRAINT fk_cal_pelicula FOREIGN KEY (movie_id) REFERENCES Pelicula(movie_id)
);

-- ============================================================
-- 12. ENLACES_EXTERNOS
--     Fuente: links.csv
--     IDs externos de TMDB e IMDB para cada película
-- ============================================================
CREATE TABLE Enlace_Externo (
    movie_id        INT             PRIMARY KEY,
    imdb_id         VARCHAR(20),
    tmdb_id         INT,
    CONSTRAINT fk_enlace_pelicula FOREIGN KEY (movie_id) REFERENCES Pelicula(movie_id)
);

-- ============================================================
-- FIN DEL SCHEMA
-- Tablas: 12 entidades + 5 tablas de relación = 17 tablas total
-- Entidades principales: Pelicula, Coleccion, Genero,
--   Compania_Productora, Pais, Persona, Keyword, Usuario,
--   Calificacion, Enlace_Externo, Cast_Pelicula, Crew_Pelicula
-- ============================================================
