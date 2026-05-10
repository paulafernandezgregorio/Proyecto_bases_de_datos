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

**Descripción general:**

El dataset cuenta con alrededor de 45 mil datos de películas estrenadas hasta julio 2017 y no se ha actualizado desde su fecha de publicación. Incluye calificaciones, géneros, presupuestos, país de producción, entre otras cosas.

La base de datos está dividida en varios archivos CSV. El archivo principal `movies_metadata.csv`, incluye información general y financiera sobre la producción y lanzamiento de las películas. Consta de 45,466 tuplas y 24 atributos.

El archivo `credits.csv` contiene nombres del reparto y del equipo técnico de cada película. Consta de 45,476 y 3 atributos.

Los archivos `links.csv` y `links_small.csv` contienen tablas de referencia para cruzar los IDs de las películas entre diferentes bases de datos y plataformas de referencia cinematográfica como IMDb y MovieLens. El archivo `links.csv` consta de 45,843 y 3 atributos; y `links_small.csv` consta de 9,125 tuplas y 3 atributos. 

Por último, los archivos `ratings_small.csv` y `keywords.csv` contienen calificaciones de usuarios y palabras que describen la trama, ambas nos son útiles para identificar patrones de consumo y sesgos comunes. Finalmente, `rating_small.csv` consta de 100,004 tuplas y 4 atributos; y `keywords` consta de 46,419 tuplas y 2 atributos.

hola
Clasificación de atributos:
| | `movies_metadata` | `keywords` | `credits` | `links` | `links_small` | `ratings_small` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Numéricos** | budget, revenue, runtime, popularity, vote_average, vote_count | - | - | movieId, imdbId, tmdbId | movieId, imdbId, tmdbId | rating, userId, movieId |
| **Categóricos** | adult, original_language, status, video | - | - | - | - | - |
| **Texto** | id, imdb_id, title, original_title, overview, tagline, homepage, poster_path, genres, belongs_to_collection, production_companies, production_countries, spoken_language | id, keywords | id, cast, crew | - | - | - |
| **Temporales** | release_date | - | - | - | - | timestamp |

---

## B) Carga Inicial y Análisis Exploratorio

### Decisión sobre ratings y links

Durante la exploración inicial del dataset se identificó que la tabla `ratings` contiene más de 26 millones de registros y ocupa 1.5 GB de espacio en disco. Al intentar ejecutar consultas sobre esta tabla, el sistema presentaba problemas severos de rendimiento, haciendo inviable su uso en el análisis. Dado que el objetivo del proyecto es identificar patrones en las **características propias de las películas** — como género, presupuesto, duración y popularidad — y no en el comportamiento individual de los usuarios, se tomó la decisión de excluir esta tabla del proyecto. La tabla `links`, cuya única función era relacionar películas con sus calificaciones en plataformas externas, también fue excluida por la misma razón.

### Script de python
--FALTANTE: explicar como fue la transición de diccionarios a tablas nuevas, junto con la renombración de datos. Igualmente, incluir la parte en donde se evitan 12 columnas de la tabla generada movies_metadata_genres porque tenían fecha por id

### Carga de archivos .csv a postgresql
-- explicar la parte de definir un squema.sql con la información respectiva de los datos, tienes que correr el archivo "squema.sql"

Posteriormente a la creación de las tablas, utilizaremos el comando \copy para llevar la información de los .csv a nuestro PostGre.

IMPORTANTE: cambiar la codificación de WIN1252 a UTF8 usando las líneas de comando **\encoding UTF8
SHOW client_encoding;
**

| Líneas de comando |
|-------------------|
| \copy raw.credits_cast FROM '{dirección_de_carpeta_en_PC}/credits_cast.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.credits_crew FROM '{dirección_de_carpeta_en_PC}/credits_crew.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.keywords_keywords FROM '{dirección_de_carpeta_en_PC}/keywords_keywords.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.movies_metadata FROM '{dirección_de_carpeta_en_PC}/movies_metadata.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.movies_metadata_genres FROM '{dirección_de_carpeta_en_PC}/movies_metadata_genres.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.movies_metadata_production_companies FROM '{dirección_de_carpeta_en_PC}/movies_metadata_production_companies.csv' DELIMITER ',' CSV HEADER; |
| \copy raw.movies_metadata_production_countries FROM '{dirección_de_carpeta_en_PC}/movies_metadata_production_countries.csv' DELIMITER ',' CSV HEADER; | 

### Esquema inicial

Los datos se cargan en un esquema llamado `raw` dentro de la base de datos `peliculas`. Se utilizó un esquema separado para distinguir los datos en bruto de las tablas normalizadas que se crearán en etapas posteriores. Todos los atributos se definen como `TEXT` en la carga inicial para evitar errores de tipo durante la importación; la conversión a tipos adecuados se realiza en la etapa de limpieza.

El script de creación del esquema se encuentra en `parteB/schema.sql`.

### Tablas cargadas

Las siguientes 7 tablas fueron creadas y cargadas a partir de los archivos CSV del dataset:

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `movies_metadata` | Información general de cada película | 45,349 |
| `movies_metadata_genres` | Géneros asociados a cada película | 90,911 |
| `movies_metadata_production_companies` | Compañías productoras por película | 70,458 |
| `movies_metadata_production_countries` | Países de producción por película | 49,332 |
| `credits_cast` | Actores y personajes por película | 562,152 |
| `credits_crew` | Equipo técnico por película | 464,079 |
| `keywords_keywords` | Palabras clave por película | 156,559 |

### Instrucciones de replicación

1. Descarga el dataset desde [Kaggle - The Movies Dataset](https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset)
2. Clona este repositorio
3. Conéctate a PostgreSQL y crea la base de datos:
```sql
CREATE DATABASE peliculas;
\c peliculas
```
4. Ejecuta el script de creación del esquema:
```sql
\i 'ruta/al/repo/parteB/schema.sql'
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
```

### Limpieza de columnas no relevantes

Se eliminaron las columnas `profile_path` y `order` de `credits_cast`, y `profile_path` de `credits_crew`, ya que no aportan valor analítico. `profile_path` contiene rutas internas de imágenes no accesibles, y `order` representa el orden de aparición en pantalla, irrelevante para el análisis. El script correspondiente se encuentra en `parteB/limpieza.sql`.

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

#### Estadísticas de valores numéricos

| Métrica | Budget | Revenue | Runtime | Vote Average |
|---------|--------|---------|---------|--------------|
| Mínimo | $1 | $1 | 0.0 min | 0.0 |
| Máximo | $380,000,000 | $2,787,965,087 | 338.0 min | 9.1 |
| Promedio | $31,112,688 | $90,408,636 | 110 min | 6.27 |

> Nota: estos valores excluyen registros con budget, revenue o runtime igual a NULL (previamente convertidos desde cero).

#### Valores en cero (datos faltantes disfrazados)

Un hallazgo importante es que una gran proporción de películas tienen `budget` y `revenue` registrados como `0`, lo que en realidad representa datos no disponibles:

| Columna | Registros con valor 0 | Porcentaje |
|---------|-----------------------|------------|
| budget | 36,573 | ~80% |
| revenue | 38,052 | ~84% |
| runtime | 0 | 0% |

Estos valores fueron tratados como nulos durante la limpieza.

#### IDs duplicados

De los 45,466 registros originales en `movies_metadata`, se encontraron **33 IDs duplicados** y **1 registro sin movie_id**, los cuales fueron eliminados en la etapa de limpieza.

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

El 71% de las películas son en inglés. Se detectó el código `cn` que no es un código ISO válido (debería ser `zh`), lo cual fue corregido en la limpieza.

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

---

## C) Limpieza de datos 

El objetivo de la limpieza es preparar los datos para el análisis de patrones y posibles sesgos en películas. Esta etapa fue necesaria porque el dataset original contenía registros duplicados, valores faltantes, valores en cero que en realidad representaban datos no disponibles, códigos de idioma incorrectos y registros relacionados con películas eliminadas.

El script completo de limpieza se encuentra en:

```text
parteC/limpieza_datos.sql
```

**Actividades realizadas**

**1. Eliminación de duplicados y registros sin identificador**
Se encontraron registros con `movie_id` duplicado y registros sin `movie_id`. En ambos casos no era posible identificar correctamente a qué película pertenecía la información, por lo que fueron eliminados. Para los registros duplicados se conservó únicamente la primera aparición de cada película.
Esta limpieza fue necesaria porque `movie_id` es el identificador principal que permite relacionar la tabla de películas con las tablas secundarias, como géneros, compañías, países, reparto, equipo técnico y palabras clave.

**2. Conversión de `budget` y `revenue` de 0 a `NULL`**
En el dataset original, cuando no se conoce el presupuesto (`budget`) o los ingresos (`revenue`) de una película, el valor aparece registrado como `0` en lugar de estar vacío.
Esto es problemático porque un valor `0` puede parecer un dato válido, pero en realidad representa información no disponible. Si no se corrige, los promedios y análisis financieros del proyecto pueden quedar distorsionados. Por esta razón, todos los valores `0` en estas columnas fueron convertidos a `NULL`.

**3. Corrección de código de idioma inválido**
Se detectó el código de idioma `cn`, el cual no corresponde al estándar correcto usado para representar el idioma chino. Para mantener consistencia en los datos, este valor fue corregido a `zh`.
Esta corrección fue necesaria porque el idioma original es una variable categórica importante para el análisis y debe estar representada de forma uniforme.

**4. Eliminación de películas sin estatus**
Se eliminaron los registros donde la columna `status` era `NULL` o estaba vacía. Esta columna indica el estado de la película, por ejemplo si fue estrenada, cancelada, planeada o se encuentra en producción.

Esta limpieza fue necesaria porque, sin conocer el estatus de una película, no es posible interpretarla correctamente dentro del análisis. Por ejemplo, una película sin estatus podría afectar los resultados si se compara con películas ya estrenadas.

**5. Conversión de `runtime` inválido a `NULL`**
Una duración de `0` minutos no representa un valor válido para una película. Por esta razón, los valores de `runtime` iguales a `0` fueron convertidos a `NULL`.
Esta limpieza evita que los cálculos de duración promedio se vean afectados por valores que realmente representan datos faltantes o incorrectos.

**6. Validación de fechas**
La columna de fechas se manejó con tipo `DATE`, por lo que el formato queda validado durante la carga. Esto permite que las fechas se puedan usar correctamente en consultas temporales, como obtener mínimos, máximos o analizar películas por año.
Las fechas vacías o no procesables se consideran valores faltantes y no se utilizan como fechas válidas en el análisis.

**7. Validación de la columna `adult`**
La columna `adult` se maneja como tipo booleano, por lo que solo puede tomar valores válidos como `True` o `False`.
Esto ayuda a evitar registros con valores incorrectos en esta columna y permite usarla correctamente como una variable categórica dentro del análisis.

**8. Normalización de nombres y género en personas**
Se identificaron casos donde una misma persona podía aparecer registrada con más de un nombre o con más de un valor en la columna `gender`. Para resolver esto, se normalizaron los registros de `credits_cast` y `credits_crew`.
La regla utilizada para los nombres fue preferir primero el formato latino o inglés y después el nombre con mayor frecuencia. Para el género, se tomó el valor más frecuente, dando prioridad a valores distintos de `0`.
Esta operación fue necesaria porque una misma persona no debe aparecer como si fueran varias personas diferentes por errores de escritura, diferencias de formato o variaciones en el nombre. También ayuda a mantener la consistencia entre actores y miembros del equipo técnico.

**9. Eliminación de registros huérfanos en tablas secundarias**
Después de limpiar la tabla principal `movies_metadata`, algunas tablas secundarias podían conservar registros relacionados con películas que ya no existían en la tabla principal.
Por esta razón, se eliminaron registros huérfanos en las siguientes tablas:

| Tabla secundaria |
|---|
| `credits_cast` |
| `credits_crew` |
| `movies_metadata_genres` |
| `movies_metadata_production_companies` |
| `movies_metadata_production_countries` |
| `keywords_keywords` |

Esta limpieza fue necesaria para mantener la integridad de los datos, ya que no tendría sentido conservar géneros, actores, compañías, países o palabras clave de películas que ya fueron eliminadas.

**10. Eliminación de duplicados en tablas secundarias**

También se eliminaron registros duplicados en tablas secundarias. Esto ocurrió cuando una misma película tenía repetido el mismo género, compañía productora, país de producción o palabra clave.
Para corregirlo, se conservó únicamente la primera aparición de cada combinación repetida.
Esta limpieza fue necesaria para evitar conteos inflados. Por ejemplo, si una película tenía repetido el mismo género dos veces, el análisis podría contar ese género más veces de las correctas.

**Resultado de la limpieza**

| Tabla | Antes | Después |
|---|---:|---:|
| `movies_metadata` | 45,466 | 45,349 |
| `movies_metadata_genres` | 91,106 | 90,911 |
| `movies_metadata_production_companies` | 70,545 | 70,458 |
| `movies_metadata_production_countries` | 49,423 | 49,332 |
| `credits_cast` | 562,474 | 562,152 |
| `credits_crew` | 464,314 | 464,079 |
| `keywords_keywords` | 158,680 | 156,559 |

La limpieza de datos permitió mejorar la calidad del dataset antes de continuar con las siguientes etapas del proyecto. 
Con estas actividades, el dataset queda más consistente y preparado para analizar patrones relacionados con las películas y su audiencia. 

