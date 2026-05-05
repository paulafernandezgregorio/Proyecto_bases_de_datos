## Integrantes
Alejandro Ozymandias Cepeda Beltran, CU:219451  
Renata Pasalagua Payá, CU:218650  
Mariana Rendón Monroy, CU:217225  
Nicolás Burgueño Rodríguez, CU:218065  
Gerardo Villanueva Vargas, CU:219890  
Paula Fernández Gregorio, CU:218821  

## Introducción 
Estamos realizando un proyecto con una base de datos de películas disponible en **Kaggle**, recolectado por **Rounak Banik** llamada The Movies Dataset. Esta base de datos contiene información detallada sobre distintos aspectos de la industria cinematográfica, lo que nos permite analizar películas desde diferentes categorías como el género, el presupuesto o la duración. 
El **objetivo principal** de este proyecto es observar e identificar distintos **patrones repetidos o sesgos comunes dentro de las películas.** Con sesgos nos referimos a tendencias que aparecen en la forma en que ciertas películas son producidas, clasificadas, valoradas o consumidas por el público. Por ejemplo, podemos analizar si ciertos géneros suelen tener mayor presupuesto, si las películas más populares reciben mejores calificaciones, si existe relación entre la duración y la valoración del público, o si algunas características de las películas se repiten con mayor frecuencia que otras.
Además, el dataset nos permite estudiar no solo la información propia de las películas, sino también algunos **patrones relacionados con el comportamiento del público.** A través de datos como la popularidad, el promedio de calificaciones y el número de votos, podemos observar qué tipo de películas generan mayor interés, cuáles son mejor evaluadas y qué tendencias se repiten entre los espectadores.
Esta base de datos **está organizada** en varios archivos, cada uno con información específica. Por ejemplo, el archivo movies _metadata.csv contiene los datos generales de cada película, como título, género, presupuesto, duración, ingresos y popularidad. Por otro lado, el archivo keywords.csv incluye palabras clave relacionadas con la trama de las películas, lo que ayuda a identificar temas o elementos narrativos recurrentes. En conjunto, estos archivos permiten realizar un análisis más completo para comprender los patrones y posibles sesgos presentes tanto en las características de las películas como en la respuesta del público hacia ellas.
Este dataset **no se actualiza con frecuencia**, ya que las películas más nuevas se estrenaron en 2017. Sin embargo, esto no afecta nuestro objetivo ya que no necesitamos que esté actualizada para encontrar los sesgos. 
Las **consideraciones éticas** que se tienen que hacer con este dataset son las siguientes: 
Las calificaciones del usuario no tienen nombre, solo están numeradas, por lo que se está **protegiendo al usuario**. Entonces sería incorrecto tratar de buscar los nombres de las personas que calificaron las películas. 
**No podemos tomar como generales estos datos**, es decir, los sesgos que captamos son de esta base de datos solamente y no de la población en general porque no toda la población votó en la encuesta. 
