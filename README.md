# Proyecto Final - Bases de Datos

## Integrantes
- Alejandro Ozymandias Cepeda Beltran, CU:219451
- Renata Pasalagua Payá, CU:218650
- Mariana Rendón Monroy, CU:217225
- Nicolás Burgueño Rodríguez, CU:218065
- Gerardo Villanueva Vargas, CU:219890
- Paula Fernández Gregorio, CU:218821

---

## A) Introducción

Estamos realizando un proyecto con una base de datos de películas disponible en Kaggle, recolectado por Rounak Banik llamada The Movies Dataset. Esta base de datos contiene información detallada sobre distintos aspectos de la industria cinematográfica, lo que nos permite analizar películas desde diferentes categorías como el género, el presupuesto o la duración.

El objetivo principal de este proyecto es observar e identificar distintos patrones repetidos o sesgos comunes dentro de las películas. Con sesgos nos referimos a tendencias que aparecen en la forma en que ciertas películas son producidas, clasificadas, valoradas o consumidas por el público. Por ejemplo, podemos analizar si ciertos géneros suelen tener mayor presupuesto, si las películas más populares reciben mejores calificaciones, si existe relación entre la duración y la valoración del público, o si algunas características de las películas se repiten con mayor frecuencia que otras.

Además, el dataset nos permite estudiar no solo la información propia de las películas, sino también algunos patrones relacionados con el comportamiento del público. A través de datos como la popularidad, el promedio de calificaciones y el número de votos, podemos observar qué tipo de películas generan mayor interés, cuáles son mejor evaluadas y qué tendencias se repiten entre los espectadores.

Esta base de datos está organizada en varios archivos, cada uno con información específica. Por ejemplo, el archivo `movies_metadata.csv` contiene los datos generales de cada película, como título, género, presupuesto, duración, ingresos y popularidad. Por otro lado, el archivo `keywords.csv` incluye palabras clave relacionadas con la trama de las películas, lo que ayuda a identificar temas o elementos narrativos recurrentes. En conjunto, estos archivos permiten realizar un análisis más completo para comprender los patrones y posibles sesgos presentes tanto en las características de las películas como en la respuesta del público hacia ellas.

Este dataset no se actualiza con frecuencia, ya que las películas más nuevas se estrenaron en 2017. Sin embargo, esto no afecta nuestro objetivo ya que no necesitamos que esté actualizada para encontrar los sesgos.

Las consideraciones éticas que se tienen que hacer con este dataset son las siguientes: las calificaciones del usuario no tienen nombre, solo están numeradas, por lo que se está protegiendo al usuario. Sería incorrecto tratar de buscar los nombres de las personas que calificaron las películas. No podemos tomar como generales estos datos, es decir, los sesgos que captamos son de esta base de datos solamente y no de la población en general porque no toda la población votó en la encuesta.

---

## B) Carga Inicial y Análisis Exploratorio

### Esquema inicial

Los datos se cargan en un esquema llamado `raw` dentro de la base de datos `peliculas`. Se utilizó un esquema separado para distinguir los datos en bruto de las tablas normalizadas que se crearán en etapas posteriores. Todos los atributos se definen como `TEXT` en la carga inicial para evitar errores de tipo durante la importación; la conversión a tipos adecuados se realiza en la etapa de limpieza.

El script de creación del esquema se encuentra en `B_carga_inicial/01_create_schema.sql`.

### Tablas cargadas

Las siguientes 9 tablas fueron creadas y cargadas a partir de los archivos CSV del dataset:

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `movies_metadata` | Información general de cada película | 45,466 |
| `movies_metadata_genres` | Géneros asociados a cada película | 91,106 |
| `movies_metadata_production_companies` | Compañías productoras por película | 70,545 |
| `movies_metadata_production_countries` | Países de producción por película | 49,423 |
| `credits_cast` | Actores y personajes por película | 562,474 |
| `credits_crew` | Equipo técnico por película | 464,314 |
| `keywords_keywords` | Palabras clave por película | 158,680 |
| `links` | IDs de películas en IMDb y TMDb | 45,843 |
| `ratings` | Calificaciones de usuarios | 26,024,289 |

### Instrucciones de replicación

1. Descarga el dataset desde [Kaggle - The Movies Dataset]([https://www.kaggle.com/datasets/rounakbanik/the-movie-dataset](https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset))
2. Clona este repositorio
3. Conéctate a PostgreSQL y crea la base de datos:
```sql
CREATE DATABASE peliculas;
\c peliculas
```
4. Ejecuta el script de creación del esquema:
```sql
\i 'ruta/al/repo/B_carga_inicial/schema.sql'
```
5. Carga cada CSV con `\copy` (reemplaza `/ruta/` con la ruta real a tu carpeta de archivos):
```sql
\copy raw.movies_metadata FROM '/ruta/movies_metadata.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.movies_metadata_genres FROM '/ruta/movies_metadata_genres.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.movies_metadata_production_companies FROM '/ruta/movies_metadata_production_companies.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.movies_metadata_production_countries FROM '/ruta/movies_metadata_production_countries.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.credits_cast FROM '/ruta/credits_cast.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.credits_crew FROM '/ruta/credits_crew.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.keywords_keywords FROM '/ruta/keywords_keywords.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.links FROM '/ruta/links.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
\copy raw.ratings FROM '/ruta/ratings.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
```

### Limpieza de columnas no relevantes

Se eliminaron las columnas `profile_path` y `order` de `credits_cast`, y `profile_path` de `credits_crew`, ya que no aportan valor analítico. `profile_path` contiene rutas internas de imágenes no accesibles, y `order` representa el orden de aparición en pantalla, irrelevante para el análisis. El script correspondiente se encuentra en `B_carga_inicial/limpieza.sql`.

### Análisis exploratorio

#### Valores nulos en `movies_metadata`

| Columna | Valores nulos o vacíos |
|---------|----------------------|
| adult | 3 |
| budget | 3 |
| overview | 954 |
| release_date | 90 |
| runtime | 263 |
| status | 87 |
| vote_average | 6 |

La columna con más datos faltantes es `overview` con 954 registros sin descripción.

#### Valores en cero (datos faltantes disfrazados)

Un hallazgo importante es que una gran proporción de películas tienen `budget` y `revenue` registrados como `0`, lo que en realidad representa datos no disponibles:

| Columna | Registros con valor 0 | Porcentaje |
|---------|-----------------------|------------|
| budget | 36,573 | ~80% |
| revenue | 38,052 | ~84% |
| runtime | 0 | 0% |

Estos valores deberán tratarse como nulos durante la limpieza.

#### IDs duplicados

De los 45,466 registros en `movies_metadata`, se encontraron **33 IDs duplicados**, los cuales deberán eliminarse en la etapa de limpieza.

#### Rango de fechas

Las películas abarcan desde **1874-12-09** hasta **2020-12-16**, con la mayoría concentradas entre 1990 y 2017.

#### Distribución por idioma original (Top 5)

| Idioma | Películas |
|--------|-----------|
| Inglés (en) | 32,269 |
| Francés (fr) | 2,438 |
| Italiano (it) | 1,529 |
| Japonés (ja) | 1,350 |
| Alemán (de) | 1,080 |

El 71% de las películas son en inglés. Se detectó el código `cn` que no es un código ISO válido (debería ser `zh`), lo cual se corregirá en la limpieza.

#### Distribución por estatus

| Estatus | Películas |
|---------|-----------|
| Released | 45,014 |
| Rumored | 230 |
| Post Production | 98 |
| NULL | 87 |
| In Production | 20 |
| Planned | 15 |
| Canceled | 2 |

#### Géneros más frecuentes (Top 5)

| Género | Películas |
|--------|-----------|
| Drama | 20,265 |
| Comedy | 13,182 |
| Thriller | 7,624 |
| Romance | 6,735 |
| Action | 6,596 |

#### Estadísticas de calificaciones de usuarios

| Métrica | Valor |
|---------|-------|
| Rating mínimo | 0.5 |
| Rating máximo | 5.0 |
| Rating promedio | 3.53 |
| Usuarios únicos | 270,896 |
| Películas calificadas | 45,115 |
| Período cubierto | 1995-01-09 a 2017-08-04 |

#### Inconsistencias entre tablas

Se verificó que todas las películas con calificaciones en `ratings` tienen su correspondiente entrada en `links`, con **0 registros huérfanos**, lo que indica buena integridad referencial entre estas dos tablas.
