-- CREACIÓN DE TODAS LAS TABLAS SEGÚN EL MODELO RELACIONAL

-- Eliminar tablas existentes (en orden inverso de dependencias)
DROP TABLE IF EXISTS Historial_Cancion CASCADE;
DROP TABLE IF EXISTS Usuarios_Historial CASCADE;
DROP TABLE IF EXISTS Usuarios_Playlist CASCADE;
DROP TABLE IF EXISTS Genero_Autores CASCADE;
DROP TABLE IF EXISTS Valora CASCADE;
DROP TABLE IF EXISTS Playlist_Cancion CASCADE;
DROP TABLE IF EXISTS Usuarios_Canciones CASCADE;
DROP TABLE IF EXISTS Canciones_Autores CASCADE;
DROP TABLE IF EXISTS Albumes_Autor CASCADE;
DROP TABLE IF EXISTS Albumes_Discografias_Autores CASCADE;
DROP TABLE IF EXISTS Usuarios_Podcast CASCADE;
DROP TABLE IF EXISTS Podcast_Autores CASCADE;
DROP TABLE IF EXISTS Playlists CASCADE;
DROP TABLE IF EXISTS Canciones CASCADE;
DROP TABLE IF EXISTS Podcast CASCADE;
DROP TABLE IF EXISTS Albumes CASCADE;
DROP TABLE IF EXISTS Cancion_Albums CASCADE;
DROP TABLE IF EXISTS Cancion_Generos CASCADE;
DROP TABLE IF EXISTS Albumes_Genero CASCADE;
DROP TABLE IF EXISTS Generos CASCADE;
DROP TABLE IF EXISTS Discograficas CASCADE;
DROP TABLE IF EXISTS Autores CASCADE;
DROP TABLE IF EXISTS Grupos CASCADE;
DROP TABLE IF EXISTS Artista CASCADE;
DROP TABLE IF EXISTS Hosts CASCADE;
DROP TABLE IF EXISTS Usuarios CASCADE;
DROP TABLE IF EXISTS Historial CASCADE;

-- Tabla: Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    CHECK (CHAR_LENGTH(nickname) >= 3)
);

-- Tabla: Grupo
CREATE TABLE IF NOT EXISTS Grupos (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL
);

-- Tabla: Artista
CREATE TABLE IF NOT EXISTS Artista (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL
);

-- Tabla: Host
CREATE TABLE IF NOT EXISTS Hosts (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL
);

-- Tabla: Discograficas
CREATE TABLE IF NOT EXISTS Discograficas (
    id_discografia SERIAL PRIMARY KEY,
    nombre_discografica VARCHAR(150) NOT NULL,
    ubicacion TEXT
);

-- Tabla: Playlist
CREATE TABLE IF NOT EXISTS Playlists (
    id_playlist SERIAL PRIMARY KEY,
    nombre_playlist VARCHAR(100) NOT NULL,
    duracion TIME NOT NULL
);

-- Tabla: Canciones
CREATE TABLE IF NOT EXISTS Canciones (
    id_cancion SERIAL PRIMARY KEY,
    nombre_cancion VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    n_reproducciones INT DEFAULT 0 CHECK (n_reproducciones >= 0),
    ano_salida INT NOT NULL
);

-- Tabla: Historial
CREATE TABLE IF NOT EXISTS Historial (
    id_historial SERIAL PRIMARY KEY,
    n_reproduccion INT DEFAULT 0 CHECK (n_reproduccion >= 0)
);

-- Tabla: Podcast
CREATE TABLE IF NOT EXISTS Podcast (
    id_podcast SERIAL PRIMARY KEY,
    nombre_podcast VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    reproducciones INT DEFAULT 0 CHECK (reproducciones >= 0),
    fecha_salida DATE NOT NULL
);

-- Tabla: Albumes
CREATE TABLE IF NOT EXISTS Albumes (
    id_album SERIAL PRIMARY KEY,
    nombre_album VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    reproduccion INT DEFAULT 0 CHECK (reproduccion >= 0),
    ano_salida INT NOT NULL
);

-- Tabla: Generos
CREATE TABLE IF NOT EXISTS Generos (
    id_genero SERIAL PRIMARY KEY,
    nombre_genero VARCHAR(100) NOT NULL
);

-- Tabla: Autores
CREATE TABLE IF NOT EXISTS Autores (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL,
    discografia TEXT
);

-- Tabla: Usuarios-Playlist
CREATE TABLE IF NOT EXISTS Usuarios_Playlist (
    id_usuario INT NOT NULL,
    id_playlist INT NOT NULL,
    PRIMARY KEY (id_usuario, id_playlist),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_playlist) REFERENCES Playlists(id_playlist)
);

-- Tabla: Usuarios-Historial
CREATE TABLE IF NOT EXISTS Usuarios_Historial (
    id_usuario INT NOT NULL,
    id_historial INT NOT NULL,
    PRIMARY KEY (id_usuario, id_historial),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_historial) REFERENCES Historial(id_historial)
);

-- Tabla: Usuarios-Canciones
CREATE TABLE IF NOT EXISTS Usuarios_Canciones (
    id_usuario INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_usuario, id_cancion),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion)
);

-- Tabla: Valora
CREATE TABLE IF NOT EXISTS Valora (
    id_usuario INT NOT NULL,
    id_cancion INT NOT NULL,
    puntuacion INT CHECK (puntuacion >= 1 AND puntuacion <= 5),
    PRIMARY KEY (id_usuario, id_cancion),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion)
);

-- Tabla: Usuarios-Podcast
CREATE TABLE IF NOT EXISTS Usuarios_Podcast (
    id_usuario INT NOT NULL,
    id_podcast INT NOT NULL,
    PRIMARY KEY (id_usuario, id_podcast),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_podcast) REFERENCES Podcast(id_podcast)
);

-- Tabla: Playlist-Cancion
CREATE TABLE IF NOT EXISTS Playlist_Cancion (
    id_playlist INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_playlist, id_cancion),
    FOREIGN KEY (id_playlist) REFERENCES Playlists(id_playlist),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion)
);

-- Tabla: Historial-Cancion
CREATE TABLE IF NOT EXISTS Historial_Cancion (
    id_historial INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_historial, id_cancion),
    FOREIGN KEY (id_historial) REFERENCES Historial(id_historial),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion)
);

-- Tabla: Cancion-Albums
CREATE TABLE IF NOT EXISTS Cancion_Albums (
    id_cancion INT NOT NULL,
    id_album INT NOT NULL,
    PRIMARY KEY (id_cancion, id_album),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album)
);

-- Tabla: Cancion-Generos
CREATE TABLE IF NOT EXISTS Cancion_Generos (
    id_cancion INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_cancion, id_genero),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero)
);

-- Tabla: Canciones-Autores
CREATE TABLE IF NOT EXISTS Canciones_Autores (
    id_cancion INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_cancion, id_autor),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);

-- Tabla: Albumes-Genero
CREATE TABLE IF NOT EXISTS Albumes_Genero (
    id_album INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_album, id_genero),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album),
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero)
);

-- Tabla: Genero-Autores
CREATE TABLE IF NOT EXISTS Genero_Autores (
    id_genero INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_genero, id_autor),
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);

-- Tabla: Albumes-Autor
CREATE TABLE IF NOT EXISTS Albumes_Autor (
    id_album INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_album, id_autor),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);

-- Tabla: Podcast-Autores
CREATE TABLE IF NOT EXISTS Podcast_Autores (
    id_podcast INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_podcast, id_autor),
    FOREIGN KEY (id_podcast) REFERENCES Podcast(id_podcast),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);

-- Tabla: Albumes-Discografia-Autor
CREATE TABLE IF NOT EXISTS Albumes_Discografias_Autores (
    id_album INT NOT NULL,
    id_autor INT NOT NULL,
    id_discografia INT NOT NULL,
    PRIMARY KEY (id_album, id_autor, id_discografia),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor),
    FOREIGN KEY (id_discografia) REFERENCES Discograficas(id_discografia)
);


