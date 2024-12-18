# :notes: Music Database :notes:

## :dizzy: Introducción

Este proyecto consiste en una base de datos de música utilizando PostgreSQL. La base de datos está diseñada para almacenar información sobre artistas, álbumes, canciones y géneros musicales. Proporciona una estructura organizada y eficiente para gestionar grandes volúmenes de datos musicales y realizar consultas complejas.

## :spiral_notepad: Documentación del Proyecto

Para ver la documentación del proyecto y todas las relaciones de clases en la página web, entra aquí:

`https://dbdocs.io/mikelmujika16/MusicDB`

## :bar_chart: Modelo Entidad-Relación

![Modelo Entidad-Relación](Diagramas\EntidadRelacionMusica.png)

## :bar_chart: Modelo Relacional

![Modelo Relacional](Diagramas\MusicDB.png)

## :hammer_and_wrench: Requisitos del Proyecto

Para ejecutar este proyecto, necesitas tener instalados los siguientes requisitos:

- **Docker**: Para crear y gestionar contenedores.
- **Docker Compose**: Para orquestar los contenedores Docker.
- **Python 3.9**: Para ejecutar la aplicación Flask.
- **PostgreSQL**: Base de datos utilizada en el proyecto.

### Dependencias de Python

Las dependencias de Python necesarias para este proyecto están listadas en el archivo `requirements.txt`:

```plaintext
Flask==2.0.3
SQLAlchemy==1.4.22
psycopg2-binary==2.9.1
Flask-Migrate==3.1.0
Flask-SQLAlchemy==2.5.1
python-dotenv==0.19.1
```

### Variables de Entorno

Asegúrate de tener un archivo 

.env

 con las siguientes variables de entorno:

```plaintext
POSTGRES_DB=music_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=admin
DB_HOST=db
```

## :rocket: Guía de Instalación

### (Opcion 1) Instalación de la Base de Datos en PostgreSQL

1. **Instalar PostgreSQL**:
   - Descarga e instala PostgreSQL desde [aquí](https://www.postgresql.org/download/).

2. **Crear la base de datos y el usuario**:
   - Abre la terminal de PostgreSQL (psql) y ejecuta los siguientes comandos:

   ```sql
   CREATE DATABASE music_db;
   CREATE USER postgres WITH ENCRYPTED PASSWORD 'admin';
   GRANT ALL PRIVILEGES ON DATABASE music_db TO postgres;
   ```

3. **Importar el archivo SQL**:
   - Ejecuta el siguiente comando en la terminal para importar el archivo `Music Database.sql`:

   ```sh
   psql -U postgres -d music_db -f "ruta/a/tu/archivo/Music Database.sql"
   ```

### (Opcion 2) Despliegue con Docker

1. **Clonar el repositorio**:

   ```sh
   git clone https://github.com/mikelmujika16/MusicDatabase
   cd MusicDatabase
   ```

2. Crear un archivo **.env** en la raíz del proyecto con el siguiente contenido:

   ```plaintext
   POSTGRES_DB=music_db
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=admin
   DB_HOST=db
   ```

3. **Construir y ejecutar los contenedores Docker**:

   ```sh
   docker-compose up --build
   ```

4. **Acceder a la aplicación**:

   Abre tu navegador web y ve a `http://localhost:5000`.

Con estos pasos, deberías poder instalar la base de datos en PostgreSQL o desplegar la aplicación utilizando Docker Compose. 
