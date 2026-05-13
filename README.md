# Proyecto Final - Bases de Datos

## Integrantes
- Alejandro Ozymandias Cepeda Beltran, CU:219451 git: https://github.com/ozycepeda
- Renata Pasalagua Payá, CU:218650 git: https://github.com/renatapasalagua 
- Mariana Rendón Monroy, CU:217225 git: https://github.com/marianarendon2006
- Nicolás Burgueño Rodríguez, CU:218065 git: https://github.com/itsGUCC1MAN
- Gerardo Villanueva Vargas, CU:219890 git: https://github.com/geraVillV
- Paula Fernández Gregorio, CU:218821 git: https://github.com/paulafernandezgregorio


## A) Introducción

Estamos realizando un proyecto con una base de datos de películas disponible en **Kaggle**, recolectado por **Rounak Banik** llamada **The Movies Dataset**. Esta base de datos contiene información detallada sobre distintos aspectos de la industria cinematográfica, lo que nos permite analizar películas desde diferentes categorías como el género, el presupuesto o la duración.

El **objetivo principal** de este proyecto es **observar e identificar distintos patrones repetidos o sesgos comunes dentro de las películas.** Con sesgos nos referimos a tendencias que aparecen en la forma en que ciertas películas son producidas, clasificadas, valoradas o consumidas por el público. Por ejemplo, podemos analizar si ciertos géneros suelen tener mayor presupuesto, si las películas más populares reciben mejores calificaciones, si existe relación entre la duración y la valoración del público, o si algunas características de las películas se repiten con mayor frecuencia que otras.

Además, el dataset nos permite estudiar no solo la información propia de las películas, sino también algunos **patrones relacionados con el comportamiento del público**. A través de datos como la popularidad, el promedio de calificaciones y el número de votos, podemos observar qué tipo de películas generan mayor interés, cuáles son mejor evaluadas y qué tendencias se repiten entre los espectadores.

**Esta base de datos está organizada** en varios archivos, cada uno con información específica. Por ejemplo, el archivo `movies_metadata.csv` contiene los datos generales de cada película, como título, género, presupuesto, duración, ingresos y popularidad. Por otro lado, el archivo `keywords.csv` incluye palabras clave relacionadas con la trama de las películas, lo que ayuda a identificar temas o elementos narrativos recurrentes. En conjunto, estos archivos permiten realizar un análisis más completo para comprender los patrones y posibles sesgos presentes tanto en las características de las películas como en la respuesta del público hacia ellas.

**Este dataset no se actualiza con frecuencia**, ya que las películas más nuevas se estrenaron en 2017. Sin embargo, esto no afecta nuestro objetivo ya que no necesitamos que esté actualizada para encontrar los sesgos.

**Las consideraciones éticas** que se tienen que hacer con este dataset son las siguientes: 
- las calificaciones del usuario no tienen nombre, solo están numeradas, por lo que se está protegiendo al usuario. Sería incorrecto tratar de buscar los nombres de las personas que calificaron las películas. 
- No podemos tomar como generales estos datos, es decir, los sesgos que captamos son de esta base de datos solamente y no de la población en general porque no toda la población votó en la encuesta.

**Descripción del dataset:**
Los datos los podemos obtener del siguiente link: https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset?select=ratings_small.csv 

El conjunto de datos está dividido en varios **archivos**: 
- **archivo principal**: movies_metadata.csv, el cual tiene 45,466 tuplas y 24 atributos 
- **2do archivo**: ratings_small.csv, el cual tiene 100,004 tuplas y 24 atributos 
- **archivos complementarios**: keywords.csv, credits.csv, links.csv, los cuales tienen información sobre palabras clave y equipo de producción. 
Para poder entender y realizar nuestro objetivo, el cual es encontrar sesgos, tenemos que entender los atributos y los tipos que son para poder usarlos correctamente:
 
| Atributo | Archivo | Significado |
|---|---|---|
| `adult` | `movies_metadata.csv` | Indica si la película está clasificada como contenido para adultos. |
| `belongs_to_collection` | `movies_metadata.csv` | Indica si la película pertenece a una colección o saga. |
| `budget` | `movies_metadata.csv` | Presupuesto de producción de la película. |
| `genres` | `movies_metadata.csv` | Géneros asociados a la película, como acción, drama, comedia, entre otros. |
| `homepage` | `movies_metadata.csv` | Página web oficial de la película, si existe. |
| `id` | `movies_metadata.csv` | Identificador único de la película dentro del dataset. |
| `imdb_id` | `movies_metadata.csv` | Identificador de la película en IMDb. |
| `original_language` | `movies_metadata.csv` | Idioma original de la película. |
| `original_title` | `movies_metadata.csv` | Título original de la película. |
| `overview` | `movies_metadata.csv` | Breve descripción o resumen de la película. |
| `popularity` | `movies_metadata.csv` | Medida de popularidad de la película dentro de la base de datos. |
| `poster_path` | `movies_metadata.csv` | Ruta o identificador del póster de la película. |
| `production_companies` | `movies_metadata.csv` | Compañías productoras que participaron en la película. |
| `production_countries` | `movies_metadata.csv` | Países donde se produjo la película. |
| `release_date` | `movies_metadata.csv` | Fecha de estreno de la película. |
| `revenue` | `movies_metadata.csv` | Ingresos generados por la película. |
| `runtime` | `movies_metadata.csv` | Duración de la película en minutos. |
| `spoken_languages` | `movies_metadata.csv` | Idiomas hablados dentro de la película. |
| `status` | `movies_metadata.csv` | Estado de la película, por ejemplo, estrenada o cancelada. |
| `tagline` | `movies_metadata.csv` | Frase promocional de la película. |
| `title` | `movies_metadata.csv` | Título de la película. |
| `video` | `movies_metadata.csv` | Indica si existe un video asociado a la película. |
| `vote_average` | `movies_metadata.csv` | Promedio de calificaciones recibidas por la película. |
| `vote_count` | `movies_metadata.csv` | Número total de votos recibidos por la película. |
| `userId` | `ratings_small.csv` | Identificador del usuario que calificó una película. |
| `movieId` | `ratings_small.csv` | Identificador de la película calificada. |
| `rating` | `ratings_small.csv` | Calificación asignada por el usuario a la película. |
| `timestamp` | `ratings_small.csv` | Momento en que el usuario realizó la calificación. |


| Tipo de atributo | Atributos | ¿Para qué sirven? |
|---|---|---|
| Numéricos | `budget`, `revenue`, `runtime`, `popularity`, `vote_average`, `vote_count`, `userId`, `movieId`, `rating`, `timestamp` | Permiten realizar comparaciones, cálculos estadísticos y análisis cuantitativos dentro del proyecto. |
| Categóricos | `adult`, `genres`, `original_language`, `status`, `video`, `production_companies`, `production_countries`, `spoken_languages` | Permiten clasificar las películas en distintos grupos o categorías, como género, idioma, país de producción o estado de lanzamiento. |
| Texto | `title`, `original_title`, `overview`, `tagline`, `homepage`, `imdb_id`, `poster_path` | Contienen nombres, descripciones, identificadores, frases promocionales o rutas relacionadas con la información de cada película. |
| Temporales o de fecha | `release_date`, `timestamp` | `release_date` indica la fecha de estreno de la película y `timestamp` registra el momento en que un usuario realizó una calificación dentro del archivo de ratings. |

—

##Documentación 

## B) Carga Inicial y análisis preliminar 

La carga inicial del set de datos se realizó en base de datos PostgreSQL. 
Para esto, se descargaron los archivos .csv del dataset que recolectamos anteriormente, después creamos una base de datos en SQL para poder almacenar toda la información disponible de las películas. 
Para poder **organizar la información**, se creó un esquema llamado raw, en el que se cargaron todas las tablas originales de los archivos de la base de datos. Este esquema lo utilizamos como una primera capa, **para que los datos del dataset no se perdieran** y se conservaran en su forma original antes de limpiarlos y acomodarlos. 

```sql
CREATE DATABASE peliculas;
\c peliculas
\i 'ruta/al/repo/parteB/schema.sql'
```

Posteriormente, se cargan los archivos `.csv` utilizando el comando `\copy`. Es importante reemplazar `/ruta/` por la ubicación real de los archivos en la computadora donde se está ejecutando PostgreSQL.

```sql
\copy raw.movies_metadata FROM '/ruta/movies_metadata.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.movies_metadata_genres FROM '/ruta/movies_metadata_genres.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.movies_metadata_production_companies FROM '/ruta/movies_metadata_production_companies.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.movies_metadata_production_countries FROM '/ruta/movies_metadata_production_countries.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.credits_cast FROM '/ruta/credits_cast.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.credits_crew FROM '/ruta/credits_crew.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

\copy raw.keywords_keywords FROM '/ruta/keywords_keywords.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
```

En esta carga inicial las **tablas que principalmente se usaron** fueron las siguientes: 

| Tabla | Descripción |
|---|---|
| `raw.movies_metadata` | Contiene la información general de las películas, como título, presupuesto, ingresos, duración, fecha de estreno, idioma, popularidad y votos. |
| `raw.movies_metadata_genres` | Contiene los géneros asociados a cada película. |
| `raw.movies_metadata_production_companies` | Contiene las compañías productoras relacionadas con cada película. |
| `raw.movies_metadata_production_countries` | Contiene los países de producción asociados a cada película. |
| `raw.credits_cast` | Contiene información del reparto de las películas. |
| `raw.credits_crew` | Contiene información del equipo de producción de las películas. |
| `raw.keywords_keywords` | Contiene las palabras clave relacionadas con cada película. |

Después de obtener este esquema inicial, realizamos una **limpieza básica a los datos** para eliminar las columnas que no sirven para cumplir nuestro objetivo. En la tabla raw.credits_cast eliminamos las columnas profile_path y order debido a que daban informacion sobre la ruta de imagen y sobre el orden de reparto. De igual manera, en la tabla raw.credits_crew se eliminó la columna profile_path por las mismas razones. 
Con esta limpieza podemos realizar el proyecto de manera más ordenada.

Después realizamos consultas para poder conocer el **funcionamiento y estructura del dataset**, para poder observar si hay problemas en los datos y los posibles patrones que podemos observar. Así utilizamos las consultas: 

| Análisis realizado | Objetivo |
|---|---|
| Conteo de registros por tabla | Conocer cuántas tuplas tiene cada tabla cargada en la base de datos. |
| Conteo de valores nulos | Identificar columnas con información faltante o vacía. |
| Rango de fechas | Obtener la fecha mínima y máxima de estreno de las películas. |
| Estadísticas numéricas | Obtener mínimos, máximos y promedios de variables como presupuesto, ingresos, duración y calificaciones. |
| Conteo de valores en cero | Detectar posibles datos faltantes representados como `0`, especialmente en `budget`, `revenue` y `runtime`. |
| Identificación de IDs duplicados | Revisar si existen películas repetidas dentro de la tabla principal. |
| Idiomas más frecuentes | Conocer cuáles son los idiomas originales más comunes en el dataset. |
| Estatus de películas | Revisar cuántas películas aparecen como estrenadas, canceladas u otro estado. |
| Géneros más frecuentes | Identificar los géneros más repetidos dentro de las películas. |
| Países productores más frecuentes | Conocer los países con mayor presencia en la base de datos. |
| Compañías productoras más frecuentes | Identificar las compañías con más películas dentro del dataset. |
| Keywords más frecuentes | Observar los temas o palabras clave más repetidas. |
| Personas con múltiples nombres | Detectar inconsistencias en actores o miembros del equipo registrados con más de un nombre. |
| Personas con múltiples géneros | Detectar posibles inconsistencias en la clasificación de género dentro de créditos de reparto o equipo. |

En la limpieza preliminar encontramos los siguientes resultados: 

| Tabla | Descripción | Registros |
|---|---|---:|
| `movies_metadata` | Información general de cada película. | 45,349 |
| `movies_metadata_genres` | Géneros asociados a cada película. | 90,911 |
| `movies_metadata_production_companies` | Compañías productoras por película. | 70,458 |
| `movies_metadata_production_countries` | Países de producción por película. | 49,332 |
| `credits_cast` | Actores y personajes por película. | 562,152 |
| `credits_crew` | Equipo técnico por película. | 464,079 |
| `keywords_keywords` | Palabras clave por película. | 156,559 |

**datos nulos**

| Columna | Valores nulos o vacíos |
|---|---:|
| `adult` | 3 |
| `budget` | 3 |
| `overview` | 954 |
| `release_date` | 90 |
| `runtime` | 263 |
| `status` | 87 |
| `vote_average` | 6 |

La columna con más datos faltantes es `overview`, con 954 registros sin descripción.

**Estadisticas numéricas** 

| Métrica | Budget | Revenue | Runtime | Vote Average |
|---|---:|---:|---:|---:|
| Mínimo | $1 | $1 | 0.0 min | 0.0 |
| Máximo | $380,000,000 | $2,787,965,087 | 338.0 min | 9.1 |
| Promedio | $31,112,688 | $90,408,636 | 110 min | 6.27 |

**Valores en cero** 

| Columna | Registros con valor 0 | Porcentaje aproximado |
|---|---:|---:|
| `budget` | 36,573 | ~80% |
| `revenue` | 38,052 | ~84% |
| `runtime` | 0 | 0% |

Una gran proporción de películas tiene `budget` y `revenue` registrados como `0`. Estos valores se interpretaron como datos faltantes, ya que no representan necesariamente que la película no haya tenido presupuesto o ingresos, sino que esa información no estaba disponible en el dataset.

**Rango de fechas**

Las películas abarcan desde `1874-12-09` hasta `2020-12-16`, aunque la mayoría se concentra entre 1990 y 2017.

**Idioma**

| Idioma | Películas |
|---|---:|
| Inglés (`en`) | 32,269 |
| Francés (`fr`) | 2,438 |
| Italiano (`it`) | 1,529 |
| Japonés (`ja`) | 1,350 |
| Alemán (`de`) | 1,080 |

El 71% de las películas se encuentran registradas en inglés. También se detectó el código `cn`, que no corresponde al código ISO correcto para chino y fue corregido a `zh` durante la limpieza.

**Status de la película**

| Status | Películas |
|---|---:|
| `Released` | 45,014 |
| `Rumored` | 230 |
| `Post Production` | 98 |
| `NULL` | 87 |
| `In Production` | 20 |
| `Planned` | 15 |
| `Canceled` | 2 |

La mayoría de las películas del dataset se encuentran en estado `Released`, lo cual es esperado porque el conjunto de datos se enfoca principalmente en películas ya estrenadas.

**Géneros más frecuentes** 

| Género | Películas |
|---|---:|
| Drama | 20,265 |
| Comedy | 13,182 |
| Thriller | 7,624 |
| Romance | 6,735 |
| Action | 6,596 |

Los géneros más frecuentes son Drama y Comedy, lo que indica que estos tipos de películas tienen una presencia muy alta dentro del dataset.

**Inconsistencias encontradas**
Durante el análisis preliminar se encontraron algunas inconsistencias en el set de datos. Entre ellas se identificaron valores en cero en columnas como `budget` y `revenue`, los cuales fueron interpretados como datos faltantes. También se encontraron 33 IDs duplicados y 1 registro sin `movie_id`, por lo que fueron eliminados durante la limpieza. Además, se detectó el código de idioma `cn`, que no corresponde al código ISO correcto para chino, por lo que fue corregido a `zh`
—

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

—

## D) Normalización de datos hasta cuarta forma normal 
El objetivo de esta etapa fue transformar los datos limpios del esquema `raw` en un diseño más organizado y normalizado dentro de un nuevo esquema llamado `core`.

En las etapas anteriores, los datos fueron cargados y limpiados en tablas cercanas a los archivos originales del dataset. Sin embargo, algunas columnas contenían información repetida o relaciones de muchos a muchos, por ejemplo: una película puede tener varios géneros, varias compañías productoras, varios países de producción, varias palabras clave, varios actores y varios miembros del equipo técnico.

Por esta razón, se realizó una descomposición de los datos en entidades independientes y tablas de relación. Esto permite reducir redundancia, evitar tuplas duplicadas y facilitar consultas posteriores.

El script completo de normalización se encuentra en:

```text
parteD/normalizacion.sql
```

**Esquema utilizado**
Para la normalización se creó el esquema `core`, separado del esquema `raw`.
El esquema `raw` conserva los datos limpios en una estructura cercana a los archivos originales, mientras que el esquema `core` contiene el diseño normalizado final.

```sql
CREATE SCHEMA IF NOT EXISTS core;
```
**Entidades principales del diseño normalizado**
A partir del análisis del dataset, se identificaron las siguientes entidades principales:
| Entidad | Tabla en `core` | Descripción |
|---|---|---|
| Película | `core.movies` | Contiene la información principal de cada película. |
| Persona | `core.persons` | Contiene actores y miembros del equipo técnico. |
| Género | `core.genres` | Contiene los géneros cinematográficos. |
| Keyword | `core.keywords` | Contiene las palabras clave asociadas a películas. |
| Compañía | `core.companies` | Contiene compañías productoras. |
| País | `core.countries` | Contiene países de producción. |

**Tablas de relación**
También se crearon tablas intermedias para representar relaciones de muchos a muchos. Esto fue necesario porque una película puede estar relacionada con varios elementos de una misma entidad, y un mismo elemento puede aparecer en muchas películas.

| Relación | Tabla intermedia | Descripción |
|---|---|---|
| Películas y géneros | `core.movie_genres` | Relaciona cada película con sus géneros. |
| Películas y keywords | `core.movie_keywords` | Relaciona cada película con sus palabras clave. |
| Películas y compañías | `core.movie_companies` | Relaciona cada película con sus compañías productoras. |
| Películas y países | `core.movie_countries` | Relaciona cada película con sus países de producción. |
| Películas y reparto | `core.movie_cast` | Relaciona cada película con las personas que participaron como actores. |
| Películas y equipo técnico | `core.movie_crew` | Relaciona cada película con las personas que participaron en el equipo técnico. |

**Justificación de la descomposición**
La descomposición fue necesaria porque en el dataset original varias columnas contenían información multivaluada. Por ejemplo, una película podía tener varios géneros dentro de una misma columna, varias compañías productoras, varios países de producción y varias palabras clave.
Si esta información se mantuviera dentro de una sola tabla, se repetirían datos y sería más difícil hacer consultas. Por ejemplo, el nombre de un género como `Drama` aparecería repetido muchas veces en diferentes películas. Lo mismo sucedería con compañías, países, keywords y personas.
Al separar estas entidades en tablas independientes, cada dato se almacena una sola vez y las relaciones se manejan mediante tablas intermedias. Esto mejora la organización de la base, reduce redundancia y facilita el análisis de patrones.

**Dependencias funcionales principales**
A partir del diseño normalizado, se identificaron las siguientes dependencias funcionales principales:
| Tabla | Dependencia funcional | Explicación |
|---|---|---|
| `core.movies` | `movie_id → adult, budget, imdb_id, original_language, original_title, overview, popularity, release_date, revenue, runtime, status, vote_average, vote_count` | Cada `movie_id` identifica de manera única a una película y determina sus atributos principales. |
| `core.persons` | `person_id → gender, name` | Cada `person_id` identifica a una persona y determina su nombre y género registrado. |
| `core.genres` | `genre_id → name` | Cada `genre_id` identifica un género específico. |
| `core.keywords` | `keyword_id → name` | Cada `keyword_id` identifica una palabra clave específica. |
| `core.companies` | `company_id → name` | Cada `company_id` identifica una compañía productora. |
| `core.countries` | `iso_3166_1 → name` | Cada código `iso_3166_1` identifica un país de producción. |
| `core.movie_cast` | `(movie_id, person_id) → character, cast_id` | La combinación de película y persona determina el personaje y el identificador de reparto. |
| `core.movie_crew` | `(movie_id, person_id) → department, job` | La combinación de película y persona determina el departamento y trabajo realizado en el equipo técnico. |

**Dependencias multivaluadas no triviales**
También se identificaron dependencias multivaluadas, ya que una película puede estar relacionada con varios valores independientes. Por ejemplo, una película puede tener varios géneros y también varias compañías productoras, pero los géneros no dependen de las compañías ni las compañías dependen de los géneros.
Las principales dependencias multivaluadas son:
| Dependencia multivaluada | Explicación |
|---|---|
| `movie_id →→ genre_id` | Una película puede tener varios géneros. |
| `movie_id →→ keyword_id` | Una película puede tener varias palabras clave. |
| `movie_id →→ company_id` | Una película puede tener varias compañías productoras. |
| `movie_id →→ iso_3166_1` | Una película puede estar asociada con varios países de producción. |
| `movie_id →→ person_id` en reparto | Una película puede tener varios actores. |
| `movie_id →→ person_id` en equipo técnico | Una película puede tener varios integrantes del equipo técnico. |
Estas dependencias multivaluadas justifican la creación de tablas intermedias como `movie_genres`, `movie_keywords`, `movie_companies`, `movie_countries`, `movie_cast` y `movie_crew`.
Si estas relaciones se dejaran dentro de una sola tabla, se generarían repeticiones innecesarias. Por ejemplo, si una película tiene varios géneros y varias compañías productoras, combinar todo en una misma tabla produciría muchas filas repetidas para la misma película. Por eso se separaron en relaciones independientes.



###Consultas

### Sesgo de Género en la Dirección Cinematográfica

La siguiente query calcula el porcentaje de directores por género en la industria cinematográfica. Se puede observar que los hombres dominan ampliamente la dirección con un 56.13%, mientras que las mujeres representan apenas el 3.88% del total.

```sql
-- Sesgo de Genero
-- Porcentaje de directores mujeres vs hombres:
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
```

| genero | total | porcentaje |
|---|---|---|
| Hombre | 26,716 | 56.13% |
| No especificado | 19,029 | 39.98% |
| Mujer | 1,848 | 3.88% |

Este resultado evidencia un sesgo de género muy pronunciado: por cada directora mujer existen aproximadamente 14 directores hombres. El 39.98% de registros sin género especificado limita el análisis, pero incluso en el escenario más optimista la brecha seguiría siendo significativa. Esto refleja décadas de desigualdad en el acceso de las mujeres a roles de dirección dentro de la industria del cine.

### Presupuesto y Revenue Promedio según Género del Director

La siguiente query compara el presupuesto promedio y el revenue promedio de las películas según el género de su director, considerando únicamente películas con datos financieros disponibles.

```sql
-- Presupuesto promedio según género del director
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
```

| genero_director | presupuesto_promedio | revenue_promedio | total_peliculas |
|---|---|---|---|
| Hombre | $34,662,925 | $103,648,285 | 4,360 |
| Mujer | $27,609,620 | $82,126,234 | 236 |
| No especificado | $20,456,304 | $58,817,673 | 1,015 |

Los resultados muestran que las películas dirigidas por hombres reciben en promedio un presupuesto **25.5% mayor** que las dirigidas por mujeres ($34.6M vs $27.6M). Esta brecha se amplía en el revenue, donde las películas de directores hombres generan un **26.2% más** que las de directoras ($103.6M vs $82.1M). Sin embargo, es importante considerar que esta diferencia de revenue puede ser consecuencia directa de la diferencia de presupuesto, ya que con menos recursos es natural obtener menores ingresos, lo que refuerza el sesgo en lugar de indicar menor capacidad de las directoras.

### Sesgo de Género en el Reparto (Cast)

La siguiente query analiza la distribución de género dentro del reparto de las películas, comparando la proporción de actores hombres y mujeres en el total de créditos de actuación.

```sql
-- Porcentaje del cast por género
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
```

| genero | total | porcentaje |
|---|---|---|
| Hombre | 226,071 | 40.33% |
| No especificado | 222,912 | 39.77% |
| Mujer | 111,532 | 19.90% |

A diferencia de la dirección donde las mujeres representaban apenas el 3.88%, en el reparto la presencia femenina sube al **19.90%**, lo que sigue siendo significativamente menor que la masculina del 40.33%. Esto indica que aunque las mujeres tienen mayor acceso a roles de actuación que a roles de dirección, la brecha sigue siendo considerable: por cada actriz hay aproximadamente 2 actores hombres. El alto porcentaje de género no especificado (39.77%) nuevamente limita el análisis completo, pero la tendencia es clara: la industria favorece históricamente la participación masculina tanto frente como detrás de las cámaras.

### Sesgos de género en los distintos departamentos de la industria

La siguiente query analiza la distribución de género dentro de todos los departamentos de la industria cinematográfica, comparando la cantidad de mujeres y hombres en cada departamento.

```sql
SELECT mc.department,
       p.gender,
       COUNT(*) as total_personas,
       RANK() OVER(PARTITION BY mc.department ORDER BY COUNT(*) DESC) as lugar_ocupado
FROM core.movie_crew mc
JOIN core.persons p ON mc.person_id = p.person_id
GROUP BY mc.department, p.gender
ORDER BY mc.department, lugar_ocupado;
```

Si gender es igual 0 significa que el género no está especificado, que sea igual a 1 significa que son mujeres y que sea igual a 2 significa que son hombres.

| department | gender | total_person | lugar_ocupado |
| :--- | :--- | :--- | :--- |
| Actors | 0 | 11 | 1 |
| Actors | 2 | 6 | 2 |
| Actors | 1 | 2 | 3 |
| Art | 0 | 26086 | 1 |
| Art | 2 | 11372 | 2 |
| Art | 1 | 2827 | 3 |
| Camera | 0 | 18160 | 1 |
| Camera | 2 | 14590 | 2 |
| Camera | 1 | 412 | 3 |
| Costume & M | 0 | 22857 | 1 |
| Costume & M | 1 | 4626 | 2 |
| Costume & M | 2 | 2619 | 3 |
| Crew | 0 | 24510 | 1 |
| Crew | 2 | 5856 | 2 |
| Crew | 1 | 776 | 3 |
| Directing | 2 | 28027 | 1 |
| Directing | 0 | 25630 | 2 |
| Directing | 1 | 3155 | 3 |
| Editing | 0 | 16091 | 1 |
| Editing | 2 | 10007 | 2 |
| Editing | 1 | 1971 | 3 |
| Lighting | 0 | 4385 | 1 |
| Lighting | 2 | 414 | 2 |
| Lighting | 1 | 11 | 3 |
| Production | 0 | 44793 | 1 |
| Production | 2 | 29703 | 2 |
| Production | 1 | 11999 | 3 |
| Sound | 0 | 31135 | 1 |
| Sound | 2 | 16546 | 2 |
| Sound | 1 | 1010 | 3 |
| Visual Effects | 0 | 12809 | 1 |
| Visual Effects | 2 | 1511 | 2 |
| Visual Effects | 1 | 120 | 3 |
| Writing | 0 | 27638 | 1 |
| Writing | 2 | 18616 | 2 |
| Writing | 1 | 2306 | 3 |

Basado en la tabla resultante de la consulta observamos que el género masculino (2) predomina el los departamentos de Directing y Writing. Por otro lado, en áreas como Production, Sound y Art, el volumen más alto de registros recae en la categoría de género no especificado (0), sin embargo, la cantidad de hombres sigue siendo considerablemente mayor a la de mujeres. Por último, la participación femenina (1) se mantiene como la minoría en casi todas las categorías, alcanzando su cifra más alta en Production. Concluimos entonces que en la industria cinmeatográfica predomina el género masculino en todos los departamentos.

### Sesgo de Idioma: Presupuesto y Revenue Promedio por Idioma (Top 10)

La siguiente query analiza la distribución de presupuesto y revenue promedio según el idioma original de las películas, considerando únicamente aquellas con datos financieros disponibles.

```sql
-- Sesgos de idioma/país
-- Presupuesto y revenue promedio por idioma (Top 10)
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
```

| idioma | total_peliculas | presupuesto_promedio | revenue_promedio |
|---|---|---|---|
| en (Inglés) | 4,795 | $33,726,280 | $98,157,736 |
| hi (Hindi) | 99 | $6,913,674 | $24,967,194 |
| fr (Francés) | 88 | $13,183,020 | $24,695,494 |
| ru (Ruso) | 70 | $6,164,228 | $10,189,745 |
| zh (Chino) | 44 | $23,243,759 | $75,306,385 |
| es (Español) | 38 | $7,462,575 | $21,404,293 |
| ja (Japonés) | 38 | $14,977,571 | $56,266,631 |
| it (Italiano) | 31 | $6,538,796 | $16,434,427 |
| ta (Tamil) | 26 | $5,864,075 | $19,288,462 |
| ko (Coreano) | 25 | $8,680,960 | $27,548,102 |

El análisis confirma la hegemonía del inglés en el cine, concentrando el 83% de la producción con datos financieros y presupuestos cinco veces superiores a los del hindi. Sin embargo, destaca la eficiencia de los mercados asiáticos: el chino y el japonés logran los mayores ingresos tras el inglés, pese a contar con menos inversión. En contraste, el español muestra una marcada infrarrepresentación, con solo 38 filmes y una inversión promedio de apenas $7.4M, una cifra reducida frente a su alcance global.

### Países que más producen y su revenue promedio

La consulta examina el rendimiento financiero promedio de las películas segpun su país de origen, permitiendo identificar qué mercados nacionales tienen mayor abundancia en cuanto a producción y cuáles tienen una mayor eficiencia en cuanto al retorno de inversión, es decir, que países tienen mayores ganancias.

```sql
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
```

| pais | total_peliculas | revenue_promedio | presupuesto_promedio |
|---|---|---|---|
| **United States** | 4,382 | $104,752,594 | $35,594,324 |
| **United Kingdom** | 666 | $107,578,601 | $35,881,350 |
| **France** | 367 | $51,556,917 | $24,382,993 |
| **Germany** | 318 | $88,469,000 | $41,345,496 |
| **Canada** | 235 | $76,355,181 | $32,511,460 |
| **India** | 182 | $32,862,395 | $10,579,624 |
| **Australia** | 120 | $93,099,764 | $42,207,463 |
| **Italy** | 111 | $43,331,608 | $24,293,880 |
| **Japan** | 87 | $87,656,169 | $29,082,325 |
| **Russia** | 85 | $14,547,194 | $8,591,294 |
| **Spain** | 73 | $42,903,122 | $25,472,574 |
| **China** | 73 | $142,621,014 | $46,756,431 |
| **Hong Kong** | 54 | $84,988,022 | $36,616,699 |
| **Ireland** | 45 | $38,797,034 | $20,266,905 |
| **Belgium** | 41 | $27,904,413 | $18,138,554 |

Mientras que Estados Unidos ejerce una hegemonía cuantitativa con más de 4,000 títulos y un sólido equilibrio financiero, el análisis de rentabilidad revela dinámicas geográficas opuestas. China emerge como el mercado más eficiente, logrando un promedio de ingresos que supera incluso al estadounidense, mientras que India destaca por su capacidad de optimización, logrando triplicar su inversión pese a manejar presupuestos considerablemente bajos. En contraste, el modelo europeo representado por Francia y España muestra una vulnerabilidad financiera: a pesar de contar con presupuestos más holgados que el mercado indio, sus producciones encuentran mayores dificultades para duplicar o triplicar sus retornos, evidenciando una brecha en la eficiencia comercial frente a las potencias asiáticas y norteamericanas.

### Países con mayor y menor presupuesto de producción

Esta consulta permite identificar los extremos de inversión en la industria cinematográfica global, contrastando los países con los presupuesto más altos frente a aquellos con menor presupuesto.
```sql
-- mayor presupuesto
WITH MayorPresupuestoPorPais AS (
    SELECT c.name AS pais,
           SUM(m.budget) AS presupuesto_total,
           RANK() OVER (ORDER BY SUM(m.budget) DESC) AS ranking_mundial
    FROM core.movie_countries mc
    JOIN core.countries c ON mc.iso_3166_1 = c.iso_3166_1
    JOIN core.movies m ON mc.movie_id = m.movie_id
    WHERE m.budget > 0
    GROUP BY c.name
)
SELECT pais, 
	   presupuesto_total, 
	   ranking_mundial
FROM MayorPresupuestoPorPais
WHERE ranking_mundial <= 5;
-- menor presupuesto
WITH MenorPresupuestoPorPais AS (
    SELECT c.name AS pais,
           SUM(m.budget) AS presupuesto_total,
           RANK() OVER (ORDER BY SUM(m.budget) ASC) AS ranking_mundial
    FROM core.movie_countries mc
    JOIN core.countries c ON mc.iso_3166_1 = c.iso_3166_1
    JOIN core.movies m ON mc.movie_id = m.movie_id
    WHERE m.budget > 0
    GROUP BY c.name
)
SELECT pais,
	   presupuesto_total,
	   ranking_mundial
FROM MenorPresupuestoPorPais
WHERE ranking_mundial <= 5;
```

| **pais** | **presupuesto_total** | **ranking_mundial** |
| :--- | :--- | :--- |
| *United States* | 1.7215E+11 | 1 |
| *United Kingdom* | 2.6367E+10 | 2 |
| *Germany* | 1.547E+10 | 3 |
| *France* | 1.24E+10 | 4 |
| *Canada* | 9,292,505,600 | 5 |

| **pais** | **presupuesto_total** | **ranking_mundial** |
| :--- | :--- | :--- |
| *Uganda* | 200 | 1 |
| *Kenya* | 35,000 | 2 |
| *Afghanistan* | 46,000 | 3 |
| *Bolivia* | 60,000 | 4 |
| *Honduras* | 200,000 | 5 |
| *Jamaica* | 200,000 | 5 |
| *Cuba* | 200,000 | 5 |
| *Nicaragua* | 200,000 | 5 |

Podemos observar la enorme brecha entre los presupuesto de Estados Unidos y países como Uganda o Bolivia, esto representa un sesgo económico profundo (al menos en la industria), donde las potencias mundiales dominan la capacidad de producción y distribución global. Mientras que en las economías desarrolladas el cine es una industria de exportación masiva con presupuestos de millones, en naciones con economías emergentes o en desarrollo, las cifras sugieren producciones independientes o locales con recursos extremadamente limitados.

### Sesgos de género cinematográfico: Presupuesto promedio por género cinematográfico y su calificacion

La consulta muestra el desempeño financiero y la recepción crítica promedio de las películas agrupadas por género, las ordena de forma descendente según su presupuesto de producción.

```sql
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
```

| **genero** | **total_peliculas** | **presupuesto_promedio** | **revenue_promedio** | **calificacion_promedio** |
| :--- | :--- | :--- | :--- | :--- |
| *Adventure* | 957 | $63,865,792 | $205,003,134 | 6.25 |
| *Animation* | 292 | $63,660,027 | $224,202,425 | 6.48 |
| *Fantasy* | 510 | $61,990,664 | $198,993,331 | 6.17 |
| *Family* | 530 | $57,989,444 | $195,559,381 | 6.19 |
| *Science Fiction* | 634 | $52,353,195 | $152,310,137 | 6.1 |
| *Action* | 1,414 | $49,730,128 | $139,007,314 | 6.1 |
| *Thriller* | 1,502 | $32,363,496 | $83,893,484 | 6.17 |
| *War* | 203 | $31,885,662 | $77,348,644 | 6.72 |
| *History* | 235 | $30,050,228 | $61,931,948 | 6.8 |
| *Western* | 89 | $29,583,281 | $54,520,312 | 6.66 |
| *Mystery* | 443 | $29,511,660 | $75,343,167 | 6.34 |
| *Comedy* | 1,851 | $28,253,421 | $83,524,445 | 6.09 |
| *Crime* | 861 | $27,981,420 | $69,923,568 | 6.39 |
| *Drama* | 2,583 | $22,375,742 | $57,968,003 | 6.52 |
| *Romance* | 1,013 | $21,385,002 | $66,883,838 | 6.31 |
| *Music* | 192 | $19,923,967 | $66,616,619 | 6.48 |
| *Horror* | 586 | $16,375,529 | $50,859,134 | 5.83 |
| *TV Movie* | 1 | $5,000,000 | $42,000,000 | 6.0 |
| *Documentary* | 59 | $4,316,854 | $17,556,358 | 6.68 |
| *Foreign* | 33 | $3,631,380 | $4,193,511 | 5.38 |

El análisis evidencia una clara priorización industrial hacia el espectáculo visual, donde los géneros de Aventura y Animación concentran las mayores inversiones y retornos económicos a nivel global. Sin embargo, esta apuesta por el entretenimiento masivo contrasta con la valoración cualitativa de las obras: géneros con presupuestos más austeros, como Historia y Documental, logran consistentemente las calificaciones más altas de la audiencia y la crítica. Esta disparidad confirma que, en la industria cinematográfica, la rentabilidad financiera y el prestigio artístico transitan por caminos paralelos, sugiriendo que la apreciación crítica suele florecer donde la presión del éxito comercial es menos asfixiante.

### Relación presupuesto/revenue por género (rentabilidad)

La consulta muestra la rentabilidad promedio (ROI) por género cinematográfico, calculada como la proporción entre los ingresos y el presupuesto, permitiendo identificar qué tipos de películas generan un mayor retorno por cada dólar invertido.

```sql
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
```

| **genero** | **total_peliculas** | **roi_promedio** |
| :--- | :--- | :--- |
| *War* | 203 | 20682.08 |
| *History* | 235 | 17874.91 |
| *Crime* | 861 | 14402.47 |
| *Romance* | 1013 | 13275.65 |
| *Drama* | 2583 | 10126.81 |
| *Comedy* | 1851 | 8368.61 |
| *Family* | 530 | 1927.32 |
| *Horror* | 586 | 1746.95 |
| *Adventure* | 957 | 1071.17 |
| *Action* | 1414 | 726.06 |
| *Thriller* | 1502 | 671.94 |
| *Documentary* | 59 | 106 |
| *Mystery* | 443 | 42.38 |
| *TV Movie* | 1 | 8.4 |
| *Animation* | 292 | 6.77 |
| *Music* | 192 | 5.97 |
| *Fantasy* | 510 | 5.96 |
| *Science Fiction* | 634 | 5.28 |
| *Western* | 89 | 4.21 |
| *Foreign* | 33 | 3.16 |

Los datos revelan una paradoja financiera en la industria: mientras géneros como **Guerra e Historia** muestran un ROI inflado gracias a producciones de nicho que logran retornos notables con inversiones mínimas, los sectores de **Animación y Ciencia Ficción** presentan márgenes porcentuales mucho menores debido a sus exorbitantes costos de producción. Este sesgo estadístico sugiere que el cine de corte más "humano" representa, en realidad, un modelo de negocio más eficiente y sostenible, al no depender de presupuestos multimillonarios ni de una saturación de efectos visuales para alcanzar la rentabilidad.

### Películas de adultos con mayor o menor presupuesto

La consulta compara el presupuesto promedio entre películas clasificadas para adultos y aquellas destinadas al público general, revelando una diferencia abismal en la inversión según el tipo de contenido.

```sql
SELECT adult AS es_para_adultos, 
	   ROUND(AVG(budget)::Numeric,2) AS presupuesto_promedio
FROM core.movies
WHERE budget > 0
GROUP BY adult;
```

| **es_para_adultos** | **presupuesto_promedio** |
| :--- | :--- |
| *false* | 21,623,516.4 |
| *true* | 750,000 |

El análisis financiero revela una brecha presupuestaria abismal entre las producciones para todos los públicos y el contenido exclusivo para adultos. Esta disparidad encuentra su origen en el peso de las grandes producciones animadas, las cuales, al estar diseñadas para una audiencia universal, demandan inversiones masivas debido a los elevados costos técnicos de la animación. Así, el mercado prioriza el financiamiento de contenidos familiares por su capacidad de escala, dejando a las categorías restringidas con presupuestos significativamente más austeros en comparación.

## Diversidad de idiomas por década

La consulta analiza cómo ha evolucionado la cantidad de idiomas distintos presentes en las películas a lo largo de las décadas, además de mostrar el crecimiento en el número total de producciones cinematográficas.

```sql
SELECT 
    (EXTRACT(YEAR FROM release_date) / 10 * 10)::INT AS decada,
    COUNT(DISTINCT original_language) AS idiomas_distintos,
    COUNT(*) AS total_peliculas
FROM core.movies
WHERE release_date IS NOT NULL
GROUP BY decada
ORDER BY decada;
```

| decada | idiomas_distintos | total_peliculas |
|--------|-------------------|-----------------|
| 1874 | 1 | 1 |
| 1888 | 1 | 2 |
| 1929 | 9 | 76 |
| 1955 | 17 | 209 |
| 1965 | 23 | 247 |
| 1972 | 25 | 381 |
| 1984 | 26 | 361 |
| 1997 | 29 | 659 |
| 2004 | 38 | 990 |
| 2009 | 41 | 1579 |
| 2014 | 48 | 1973 |

El análisis histórico refleja una correlación directa entre la expansión de la industria cinematográfica y su diversificación lingüística. Mientras que las primeras décadas estuvieron marcadas por el predominio de apenas un par de idiomas debido al limitado volumen de producción, la segunda mitad del siglo XX dio paso a una internacionalización acelerada. Este fenómeno de globalización cultural alcanzó su apogeo hacia 2014, año en el que se registraron casi 2,000 películas en 48 idiomas distintos, consolidando un ecosistema donde la pluralidad de voces y mercados locales ha transformado el cine en una industria verdaderamente multicultural.

## Evolución de directoras por década

La consulta analiza la participación de mujeres directoras en la industria cinematográfica a lo largo del tiempo, mostrando cuántas directoras hubo por década y qué porcentaje representan del total de directores registrados.

```sql
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
```

| decada | total_directores | directoras_mujeres | porcentaje_mujeres |
|--------|------------------|--------------------|--------------------|
| 1903 | 23 | 1 | 4.35 |
| 1916 | 37 | 2 | 5.41 |
| 1931 | 102 | 3 | 2.94 |
| 1966 | 323 | 7 | 2.17 |
| 1977 | 349 | 9 | 2.58 |
| 1985 | 387 | 14 | 3.62 |
| 1995 | 644 | 40 | 6.21 |
| 1998 | 720 | 48 | 6.67 |
| 2000 | 803 | 52 | 6.48 |
| 2009 | 1648 | 103 | 6.25 |
| 2011 | 1772 | 107 | 6.04 |
| 2017 | 572 | 44 | 7.69 |

La evolución histórica de la dirección cinematográfica revela una exclusión sistemática de las mujeres, cuya participación se mantuvo estancada cerca del 0% durante gran parte del siglo XX. No fue sino hasta la década de los noventa cuando se inició un crecimiento sostenido en la incursión femenina tras las cámaras. Si bien el liderazgo masculino continúa siendo predominante, las cifras recientes reflejan una tendencia hacia una mayor apertura y representatividad, alcanzando en 2017 un hito histórico con un 7.69% de mujeres directoras, la cifra más alta registrada hasta la fecha.

## Presupuesto promedio por década

La consulta analiza cómo han evolucionado los presupuestos y ganancias promedio de las películas a lo largo de las décadas, permitiendo observar el crecimiento económico de la industria cinematográfica.

```sql
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
```

| decada | total_peliculas | presupuesto_promedio | revenue_promedio |
|--------|-----------------|----------------------|------------------|
| 1915 | 2 | 58656 | 5568683 |
| 1939 | 6 | 1976896 | 74864031 |
| 1950 | 6 | 2030964 | 46465074 |
| 1965 | 9 | 7500000 | 70203538 |
| 1977 | 21 | 7457143 | 90184690 |
| 1989 | 62 | 17878241 | 76151000 |
| 1995 | 101 | 28109598 | 75818958 |
| 2000 | 133 | 37540376 | 85955913 |
| 2009 | 216 | 36684574 | 103897981 |
| 2012 | 209 | 38310408 | 120521174 |
| 2015 | 211 | 36869278 | 132780617 |
| 2017 | 71 | 60749796 | 210284083 |

Los resultados muestran un crecimiento constante tanto en el presupuesto promedio como en las ganancias promedio de las películas con el paso del tiempo. Las primeras producciones cinematográficas manejaban presupuestos relativamente bajos, mientras que las películas modernas alcanzan inversiones multimillonarias. A partir de los años ochenta y noventa se observa un incremento mucho más acelerado, relacionado con el auge de los blockbusters, los efectos especiales y la globalización del mercado cinematográfico. La década más reciente destaca por tener los presupuestos y revenues promedio más altos, reflejando el enorme impacto económico de la industria del cine contemporáneo.

## Mes de estreno y su impacto en revenue

La consulta analiza cómo influye el mes de estreno de una película en sus ingresos promedio, identificando las temporadas más rentables para la industria cinematográfica.

```sql
SELECT 
    EXTRACT(MONTH FROM release_date) AS mes,
    TO_CHAR(release_date, 'Month') AS nombre_mes,
    COUNT(*) AS total_peliculas,
    ROUND(AVG(revenue)::NUMERIC) AS revenue_promedio
FROM core.movies
WHERE release_date IS NOT NULL AND revenue > 0
GROUP BY mes, nombre_mes
ORDER BY revenue_promedio DESC;
```

| mes | nombre_mes | total_peliculas | revenue_promedio |
|-----|------------|-----------------|------------------|
| 6 | June | 596 | 121037730 |
| 5 | May | 585 | 98536546 |
| 12 | December | 696 | 96173285 |
| 11 | November | 541 | 95887328 |
| 7 | July | 567 | 93067215 |
| 3 | March | 564 | 66200403 |
| 4 | April | 558 | 62062921 |
| 2 | February | 519 | 52025178 |
| 10 | October | 697 | 48089356 |
| 8 | August | 658 | 45464569 |
| 9 | September | 903 | 32732394 |
| 1 | January | 512 | 31401516 |

El análisis de estacionalidad confirma que la industria cinematográfica concentra su éxito financiero en ventanas estratégicas vinculadas a los periodos vacacionales y festivos. Junio lidera la rentabilidad promedio, seguido de cerca por mayo, diciembre y noviembre; estos meses actúan como el escenario predilecto para el lanzamiento de blockbusters que buscan maximizar el consumo masivo durante el verano y el fin de año. Por el contrario, enero y septiembre se consolidan como los periodos menos competitivos, funcionando como valles comerciales donde los ingresos promedio descienden significativamente ante la falta de estrenos de alto impacto.

## Sesgos de duración

La consulta analiza cómo la duración de las películas se relaciona con su presupuesto, ingresos y calificaciones promedio, agrupando las producciones en distintas categorías de tiempo.

```sql
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
```

| duracion | total_peliculas | presupuesto_promedio | revenue_promedio | calificacion_promedio |
|----------------------|-----------------|----------------------|------------------|-----------------------|
| Muy larga (>150 min) | 276 | 41855273 | 158495040 | 6.95 |
| Larga (120-150 min) | 1138 | 44306331 | 140611555 | 6.65 |
| Normal (90-120 min) | 3315 | 28047139 | 74276564 | 6.16 |
| Corta (<90 min) | 634 | 19256258 | 56503558 | 5.93 |

Los resultados muestran que las películas más largas tienden a tener mayores presupuestos, mejores ingresos y calificaciones promedio más altas. Las producciones de más de 150 minutos destacan como las más exitosas económicamente y las mejor valoradas, probablemente porque suelen corresponder a grandes producciones épicas o franquicias importantes. En contraste, las películas cortas presentan menores presupuestos y revenues promedio, además de una calificación ligeramente inferior.

## Relación entre popularidad y calificación

La consulta analiza cómo se relacionan las calificaciones de las películas con su nivel de popularidad e ingresos promedio, agrupando las producciones según rangos de evaluación.

```sql
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
```

| rango_calificacion | total_peliculas | popularidad_promedio | revenue_promedio |
|--------------------|-----------------|----------------------|------------------|
| Regular (4-6) | 15839 | 2.77 | 47883674 |
| Mala (0-4) | 2343 | 1.20 | 9425358 |
| Excelente (8-10) | 1886 | 1.95 | 113904559 |
| Buena (6-8) | 22311 | 3.66 | 80492144 |

Los datos establecen una correlación directa entre la calidad percibida y el rendimiento financiero: las películas calificadas como "Excelente" lideran los ingresos promedio, mientras que las producciones "Malas" sufren el castigo del mercado con los niveles más bajos de popularidad y recaudación. Sin embargo, emerge un matiz interesante en la categoría "Buena", que ostenta la popularidad promedio más alta de todas. Este fenómeno sugiere que los grandes éxitos de consumo masivo no requieren necesariamente la excelencia crítica para triunfar, sino que encuentran un "punto dulce" donde el equilibrio entre la aceptación del público y un desempeño comercial sólido garantiza su dominio en la conversación global.

## Religión y presupuesto cinematográfico

La consulta analiza si existe algún sesgo en los presupuestos de películas que mencionan ciertas religiones dentro de sus keywords, comparando el total invertido en producciones relacionadas con cristianismo, islam y budismo.

```sql
SELECT 
    mk.keyword_id,
    SUM(m.budget) as suma_total
FROM core.movies m
JOIN core.movie_keywords mk ON mk.movie_id = m.movie_id
WHERE mk.keyword_id IN (186, 187, 188) 
  AND m.budget IS NOT NULL
GROUP BY mk.keyword_id
ORDER BY suma_total ASC;
```

| keyword_id | suma_total |
|------------|------------|
| 188 | 151300000 |
| 187 | 154800000 |
| 186 | 629000000 |

El análisis revela una disparidad significativa en el financiamiento cinematográfico según el trasfondo religioso de las obras. Las producciones vinculadas al cristianismo concentran un volumen de inversión drásticamente superior en comparación con aquellas centradas en el islam o el budismo. Esta brecha financiera sugiere una hegemonía de las narrativas cristianas en los circuitos comerciales, impulsada probablemente por la solidez de la industria occidental y una estrategia de mercado que prioriza historias con mayor arraigo cultural en las regiones que históricamente dominan la producción de alto presupuesto.

## Sesgo de longevidad y “Ageism”

La consulta analiza la duración promedio de las carreras cinematográficas de las personas según su género, calculando cuántos años transcurren entre su primera y última aparición en películas registradas.

```sql
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
) AS subconsulta_carrera 
ON core.persons.person_id = subconsulta_carrera.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;
```

| gender | años_activos_promedio | total_personas |
|--------|-----------------------|----------------|
| 1 | 7.95 | 25741 |
| 2 | 10.48 | 38392 |

Los hallazgos evidencian una brecha estructural en la longevidad de las trayectorias profesionales dentro del cine según el género. Mientras que las personas identificadas con el gender = 2 logran mantener carreras más extensas con un promedio de 10.48 años, el grupo de gender = 1 presenta una vida laboral significativamente más corta, promediando apenas 7.95 años. Esta disparidad de casi tres años sugiere la presencia de sesgos de permanencia que condicionan la estabilidad laboral, indicando que ciertos perfiles enfrentan barreras sistémicas que dificultan la consolidación de carreras prolongadas en comparación con sus homólogos.

## Sesgo de “Tokenismo” en el reparto

La consulta analiza la representación de género dentro del reparto de películas cuya figura principal o protagonista es mujer, evaluando si existe un balance equitativo entre actores y actrices en estas producciones.

```sql
WITH PelisProtagonistaFemenina AS (
    SELECT movie_id
    FROM (
        SELECT 
            core.movie_cast.movie_id, 
            core.persons.gender, 
            ROW_NUMBER() OVER(
                PARTITION BY core.movie_cast.movie_id 
                ORDER BY core.movie_cast.cast_id ASC
            ) AS rango_reparto
        FROM core.movie_cast
        JOIN core.persons 
            ON core.movie_cast.person_id = core.persons.person_id
    ) AS ranking_cast
    WHERE ranking_cast.rango_reparto = 1 
      AND ranking_cast.gender = 1
)

SELECT 
    core.persons.gender,
    COUNT(*) AS total_actores,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 
        2
    ) AS porcentaje
FROM core.movie_cast
JOIN PelisProtagonistaFemenina 
    ON core.movie_cast.movie_id = PelisProtagonistaFemenina.movie_id
JOIN core.persons 
    ON core.movie_cast.person_id = core.persons.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;
```

| gender | total_actores | porcentaje |
|--------|---------------|------------|
| 1 | 39599 | 44.00 |
| 2 | 50389 | 56.00 |

El análisis revela que el protagonismo femenino no garantiza la paridad en el conjunto de la obra: incluso en películas encabezadas por mujeres, la composición del reparto mantiene una predominancia masculina. Con una distribución del 56% frente al 44% a favor de los actores, los datos sugieren que la elección de una protagonista es un avance focalizado que no altera necesariamente la estructura demográfica del resto del elenco, evidenciando una resistencia a la representación equilibrada de género en los roles secundarios y de reparto.

## Sesgo de roles de poder en el crew cinematográfico

La consulta analiza la participación femenina en puestos clave dentro de la producción cinematográfica, evaluando la representación de mujeres en cargos de alto nivel como dirección, producción, edición, escritura y fotografía.

```sql
SELECT 
    core.movie_crew.job,
    COUNT(*) FILTER (WHERE core.persons.gender = 1) AS total_mujeres,
    COUNT(*) FILTER (WHERE core.persons.gender = 2) AS total_hombres,
    ROUND(
        COUNT(*) FILTER (WHERE core.persons.gender = 1) * 100.0 / COUNT(*), 
        2
    ) AS porcentaje_mujeres
FROM core.movie_crew
JOIN core.persons 
    ON core.movie_crew.person_id = core.persons.person_id
WHERE core.movie_crew.job IN (
    'Director', 
    'Producer', 
    'Editor', 
    'Writer', 
    'Director of Photography'
)
GROUP BY core.movie_crew.job
ORDER BY porcentaje_mujeres ASC;
```

| job | total_mujeres | total_hombres | porcentaje_mujeres |
|-------------------------|---------------|---------------|--------------------|
| Director of Photography | 263 | 12215 | 1.32 |
| Director | 1848 | 26716 | 3.88 |
| Writer | 805 | 5613 | 4.71 |
| Producer | 2688 | 16509 | 7.22 |
| Editor | 1784 | 9323 | 8.08 |

Los resultados muestran una fuerte desigualdad de género en los puestos de mayor poder dentro de la industria cinematográfica. Los cargos técnicos y de liderazgo continúan estando ampliamente dominados por hombres, especialmente en áreas como dirección de fotografía y dirección general. Aunque puestos como edición y producción presentan una participación femenina ligeramente mayor, los porcentajes siguen siendo bajos, evidenciando una subrepresentación persistente de mujeres en roles clave del crew cinematográfico.

## Sesgo de centralización en la industria cinematográfica

La consulta analiza qué porcentaje de los ingresos totales de la industria cinematográfica está concentrado en las principales compañías productoras, permitiendo identificar posibles patrones de oligopolio dentro del mercado.

```sql
WITH IngresoGlobal AS (
    SELECT SUM(core.movies.revenue) AS total_mundial 
    FROM core.movies 
    WHERE core.movies.revenue > 0
)

SELECT 
    core.companies.name,
    SUM(core.movies.revenue) AS revenue_empresa,
    ROUND(
        (SUM(core.movies.revenue) * 100.0 / 
        (SELECT total_mundial FROM IngresoGlobal)), 
        2
    ) AS porcentaje_mercado
FROM core.companies
JOIN core.movie_companies 
    ON core.companies.company_id = core.movie_companies.company_id
JOIN core.movies 
    ON core.movie_companies.movie_id = core.movies.movie_id
WHERE core.movies.revenue > 0 
GROUP BY core.companies.name
ORDER BY revenue_empresa DESC 
LIMIT 10;
```

| name | revenue_empresa | porcentaje_mercado |
|----------------------------------------|-----------------|--------------------|
| Warner Bros. | 63525187272 | 12.47 |
| Universal Pictures | 55259190410 | 10.85 |
| Paramount Pictures | 48769399614 | 9.57 |
| Twentieth Century Fox Film Corporation | 47687746332 | 9.36 |
| Walt Disney Pictures | 40837270159 | 8.02 |
| Columbia Pictures | 32279735705 | 6.34 |
| New Line Cinema | 22173391499 | 4.35 |
| Amblin Entertainment | 17343720181 | 3.40 |
| DreamWorks SKG | 15475754744 | 3.04 |
| Dune Entertainment | 15003789066 | 2.95 |

Los hallazgos confirman una estructura oligopólica en la industria cinematográfica, donde la riqueza y el alcance se concentran en un reducido grupo de corporaciones. Gigantes como Warner Bros., Universal y Paramount no solo acaparan la mayor parte del mercado global, sino que su dominio económico les otorga un control casi absoluto sobre los canales de distribución. Esta centralización de poder permite a estas pocas empresas actuar como filtros culturales, dictando las tendencias y definiendo el tipo de contenidos que logran visibilidad y éxito comercial a escala mundial.

## Sesgo de género en el departamento de escritura

La consulta analiza la representación de género dentro del departamento de Writing, comparando la cantidad de escritores y escritoras junto con la calificación promedio de las películas en las que participaron.

```sql
SELECT 
    core.persons.gender,
    COUNT(core.movie_crew.person_id) AS total_escritores,
    ROUND(AVG(core.movies.vote_average)::numeric, 2) AS que_tan_buena_es_la_peli
FROM core.movie_crew
JOIN core.persons 
    ON core.movie_crew.person_id = core.persons.person_id
JOIN core.movies 
    ON core.movie_crew.movie_id = core.movies.movie_id
WHERE core.movie_crew.department = 'Writing' 
  AND core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;
```

| gender | total_escritores | que_tan_buena_es_la_peli |
|--------|------------------|--------------------------|
| 1 | 2306 | 5.79 |
| 2 | 18616 | 5.82 |

Los hallazgos evidencian una brecha de género estructural en los departamentos de guion, donde la presencia masculina supera drásticamente a la femenina en roles de escritura. No obstante, el análisis de desempeño cualitativo revela que las calificaciones promedio de las obras son prácticamente idénticas, independientemente del género de quien las escribe. Esta paridad en la recepción crítica demuestra que la disparidad en la participación no responde a una diferencia en la calidad del trabajo, sino a barreras históricas de acceso y representación que continúan condicionando quién cuenta las historias en la industria cinematográfica.

## Sesgo de rentabilidad por idioma original (ROI)

La consulta analiza si las películas producidas en distintos idiomas presentan diferencias en su retorno de inversión promedio, comparando qué tan rentables son proporcionalmente respecto a su presupuesto.

```sql
SELECT 
    core.movies.original_language,
    COUNT(core.movies.movie_id) AS total_peliculas,
    ROUND(
        AVG(core.movies.revenue / NULLIF(core.movies.budget, 0)), 
        2
    ) AS retorno_inversion_promedio
FROM core.movies
WHERE core.movies.budget > 1000000 
  AND core.movies.revenue > 0
GROUP BY core.movies.original_language
HAVING COUNT(core.movies.movie_id) > 5
ORDER BY retorno_inversion_promedio DESC;
```

| original_language | total_peliculas | retorno_inversion_promedio |
|-------------------|-----------------|----------------------------|
| zh | 40 | 5.93 |
| sv | 7 | 4.71 |
| te | 6 | 4.50 |
| de | 21 | 4.48 |
| ko | 17 | 4.35 |
| es | 36 | 3.64 |
| hi | 89 | 3.62 |
| ja | 34 | 3.24 |
| en | 4425 | 3.19 |
| ta | 17 | 2.88 |
| fr | 81 | 2.06 |
| it | 26 | 1.88 |
| ru | 64 | 1.78 |
| da | 11 | 1.55 |

Los hallazgos confirman que la desigualdad en la contratación de guionistas no guarda relación con la calidad del material. Mientras la presencia masculina domina numéricamente, la calificación promedio de las obras es paritaria. Esto evidencia que la disparidad responde a un problema de representación y acceso sistémico, y no a una diferencia en el desempeño creativo.

## Sesgo de representación en el top de popularidad

La consulta analiza el género de los protagonistas principales en las 100 películas más populares, utilizando el primer integrante del cast (`cast_id`) como referencia del personaje principal.

```sql
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
        ROW_NUMBER() OVER(
            PARTITION BY core.movie_cast.movie_id 
            ORDER BY core.movie_cast.cast_id ASC
        ) AS rango
    FROM core.movie_cast
    JOIN core.persons 
        ON core.movie_cast.person_id = core.persons.person_id
    JOIN TopCienPopulares 
        ON core.movie_cast.movie_id = TopCienPopulares.movie_id
)

SELECT 
    gender,
    COUNT(*) AS total_protagonistas_en_top_100
FROM ProtagonistasTop
WHERE rango = 1 
  AND gender IN (1, 2)
GROUP BY gender;
```

| gender | total_protagonistas_en_top_100 |
|--------|--------------------------------|
| 1 | 28 |
| 2 | 69 |

El análisis del top 100 de popularidad revela una marcada asimetría de género en los roles protagónicos. La predominancia masculina frente a una menor presencia femenina sugiere la persistencia de un sesgo de representación en las producciones de mayor impacto comercial, limitando la diversidad en el cine de alta visibilidad.

## Sesgo de visibilidad: actores vs personajes con nombre

La consulta analiza cuántos actores y actrices aparecen en películas sin un personaje identificado, es decir, con nombres de personaje vacíos o nulos, permitiendo observar posibles diferencias de visibilidad según género.

```sql
SELECT 
    core.persons.gender,
    COUNT(*) FILTER (
        WHERE core.movie_cast.character IS NULL 
           OR core.movie_cast.character = ''
    ) AS personajes_sin_nombre,
    
    COUNT(*) AS total_apariciones,
    
    ROUND(
        COUNT(*) FILTER (
            WHERE core.movie_cast.character IS NULL 
               OR core.movie_cast.character = ''
        ) * 100.0 / COUNT(*), 
        2
    ) AS porcentaje_invisibilidad
FROM core.movie_cast
JOIN core.persons 
    ON core.movie_cast.person_id = core.persons.person_id
WHERE core.persons.gender IN (1, 2)
GROUP BY core.persons.gender;
```

| gender | personajes_sin_nombre | total_apariciones | porcentaje_invisibilidad |
|--------|-----------------------|-------------------|--------------------------|
| 1 | 2707 | 111532 | 2.43 |
| 2 | 6222 | 226071 | 2.75 |

Los datos indican una brecha menor, pero perceptible, en la calidad de la representación: el grupo gender = 2 tiende a ocupar roles menos definidos con mayor frecuencia. Aunque la diferencia no es drástica, la mayor presencia de personajes sin nombre en este segmento apunta a una desigualdad persistente en la visibilidad y el protagonismo dentro de la industria.
