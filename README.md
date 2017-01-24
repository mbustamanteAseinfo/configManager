# Config Manager
Software capable of executing scripts separado en dos partes, una de creacion de mapa de ejecucción y otra encargada de realizar la ejecución

##Generador de Scripts

Este software realiza un mapa de ejecución basada en un folder estructurado que contiene los scripts que deben ser ejecutados.

####Folder estructurado

Este folder debe contener de manera estructurada los scripts que se desean ejecutar, siguiendo las convenciones listadas a continuacion:

* Un folder contenedor pricipal que sera tomado como la ruta para el software
* Cada directorio debe tener dos caracteres numericos que identiquen su posicion en la ejecución, un espacio, un guion, un espacio, el nombre de la base de datos donde deben ser ejecutados(estos nombres son los convencionales de Evolution), un espacio, un guion, un espacio y el nombre del directorio. Ej. 00 - Primeros Pasos
* Cada script .sql dentro de los directorios debe tener dos caracteres numericos que identifiquen su posicion en la ejecución, un espacio, un guion, un espacio, el nombre de la base de datos donde deben ser ejecutados(estos nombres son los convencionales de Evolution), un espacio, un guion, un espacio y el nombre del script. Ej. 00 - PrimerScript.sql

####Conevención de escritura de los scripts

* Usar USE para indicar la base de datos que sera afectada por el script.
* Utilizar EXISTS para comprobar un drop o alter antes de realizarlo.
* Quitar la revision de llaves antes de hacer una modificación en algun catalogo y volver a activarlo cuando termine la ejecución.

####Mapa de Ejecución

El mapa de ejecución es un archivo JSON que contiene el orden en el que deberan ser ejecutados los scripts dentro del folder estructurado, este es guardado por el software una vez finalizado.

####Pasos para utilizar el sofware

* Se inicia con el ejecutable
* En la ventana que se abre podremos observar dos botónes:
  * El botón "Folder" es con el cual seleccionaremos la ruta al folder estructurado
  * El botón "Generar" hará el proceso para generar el mapa de ejecución

##Wizard o EvoExecuteScript

El wizard es una software que tiene como finalidad ejecutar scripts siguiendo un mapa de ejecución que es un archivo JSON que le indica al mismo donde se encuentran las scripts, el orden y la base de datos donde los mismos deben ser ejecutados. 
Si el wizard encuentra algun error este finalizara la ejecución y mostrara el error, el error nos indicara en que script se genero, una vez reparado el error se debe iniciar el software nuevamente este iniciara desde el script que genero el error.
Tomar en cuenta que si se hace algun cambio al folder se debe volver a generar el mapa de ejecución y la misma iniciara desde el primer script.

####Archivo JSON

Este archivo consta de los siguientes campos

* Ruta - indica la ruta donde se encuentra el script.
* Paso - numero de ejecución del script
* Necesario - indica si es o no requerido correrlo, este campo servira en futuras versiones para hacer una selecciones de que scripts si queremos correr y cuales no.
* Posicion - indica el correlativo de ejecución superior. Ej. Daddy + Step es el numero completo de ejecucion, 00.01.13
* Nombre - Nos muestra el nombre del script.
* Ejecutado - Si ya fue ejecutado el script o no.
* dataBase - La base de datos donde debe ser ejecutado

####Pasos para utilizar el software

* Se inicia el ejecutable
* En la nueva ventana podemos observar tres campo, aqui se debe indicar el nombre de las bases de datos del cliente correspondientes a las basicas de Evolution.
* Podremos observar tres botónes
  * El botón "Folder" abrira una ventana para seleccionar la ruta donde se encuentra el mapa de ejecución.
  * El botón "Conexión" abrira una ventana para seleccionar la conexión a la base de datos.
  * El botón "Ejecutar" iniciara el proceso de ejecución de los scripts.
  

