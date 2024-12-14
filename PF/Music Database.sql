-- Crear la base de datos
DROP DATABASE IF EXISTS music_db;
CREATE DATABASE music_db;

\c music_db

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

-- Tabla: Grupo
CREATE TABLE IF NOT EXISTS Grupos (
    id_autor SERIAL PRIMARY KEY,
    nombre_grupo VARCHAR(150) NOT NULL
);

-- Tabla: Artista
CREATE TABLE IF NOT EXISTS Artista (
    id_autor SERIAL PRIMARY KEY,
    nombre_artista VARCHAR(150) NOT NULL
);

-- Tabla: Host
CREATE TABLE IF NOT EXISTS Hosts (
    id_autor SERIAL PRIMARY KEY,
    nombre_host VARCHAR(150) NOT NULL
);


-- Tabla: Discograficas
CREATE TABLE IF NOT EXISTS Discograficas (
    id_discografia SERIAL PRIMARY KEY,
    nombre_discografica VARCHAR(150) NOT NULL,
    ubicacion TEXT
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
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_album, id_autor, id_discografia),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor),
    FOREIGN KEY (id_discografia) REFERENCES Discograficas(id_discografia)
);


-- Script para CHECKs y TRIGGERs necesarios en la base de datos de música

-- CHECKs para las tablas principales

-- Tabla: Usuarios
ALTER TABLE Usuarios
ADD CONSTRAINT chk_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Tabla: Canciones
ALTER TABLE Canciones
ADD CONSTRAINT chk_ano_salida CHECK (ano_salida >= 1900 AND ano_salida <= EXTRACT(YEAR FROM CURRENT_DATE));

-- Tabla: Albumes
ALTER TABLE Albumes
ADD CONSTRAINT chk_ano_salida_album CHECK (ano_salida >= 1900 AND ano_salida <= EXTRACT(YEAR FROM CURRENT_DATE));

-- Tabla: Valora
ALTER TABLE Valora
ADD CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 1 AND 5);

-- TRIGGERs para automatizar operaciones

-- TRIGGER para incrementar reproducciones en Historial cuando se agrega una canción
CREATE OR REPLACE FUNCTION incrementar_reproducciones()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Historial
    SET n_reproduccion = n_reproduccion + 1
    WHERE id_historial = NEW.id_historial;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_incrementar_reproducciones
AFTER INSERT ON Historial_Cancion
FOR EACH ROW
EXECUTE FUNCTION incrementar_reproducciones();

-- TRIGGER para asegurar unicidad de nickname y email en Usuarios
CREATE OR REPLACE FUNCTION validar_unicidad_usuario()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Usuarios WHERE email = NEW.email OR nickname = NEW.nickname
    ) THEN
        RAISE EXCEPTION 'El email o nickname ya existe';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_unicidad_usuario
BEFORE INSERT OR UPDATE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION validar_unicidad_usuario();

-- TRIGGER para actualizar n_reproducciones en Canciones cuando se agrega una nueva reproducción
CREATE OR REPLACE FUNCTION actualizar_reproducciones_cancion()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Canciones
    SET n_reproducciones = n_reproducciones + 1
    WHERE id_cancion = NEW.id_cancion;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_reproducciones_cancion
AFTER INSERT ON Historial_Cancion
FOR EACH ROW
EXECUTE FUNCTION actualizar_reproducciones_cancion();

-- TRIGGER para asegurar que una playlist no supere una duración máxima (por ejemplo, 5 horas)
CREATE OR REPLACE FUNCTION validar_duracion_playlist()
RETURNS TRIGGER AS $$
DECLARE
    duracion_total INTERVAL;
BEGIN
    SELECT SUM(duracion) INTO duracion_total
    FROM Playlist_Cancion pc
    INNER JOIN Canciones c ON pc.id_cancion = c.id_cancion
    WHERE pc.id_playlist = NEW.id_playlist;

    IF duracion_total > INTERVAL '5 hours' THEN
        RAISE EXCEPTION 'La duración total de la playlist no puede superar las 5 horas';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_duracion_playlist
AFTER INSERT OR DELETE ON Playlist_Cancion
FOR EACH ROW
EXECUTE FUNCTION validar_duracion_playlist();

-- Inserts para la tabla Usuarios
INSERT INTO Usuarios (nombre, apellido, nickname, email) VALUES
('Juan', 'Pérez', 'juanp', 'juan.perez@example.com'),
('Ana', 'Gómez', 'anag', 'ana.gomez@example.com'),
('Luis', 'Martínez', 'luism', 'luis.martinez@example.com');

-- Inserts para la tabla Grupos
INSERT INTO Grupos (nombre_autor) VALUES
('Coldplay'),
('The Beatles'),
('Imagine Dragons');

-- Inserts para la tabla Artista
INSERT INTO Artista (nombre_autor) VALUES
('Ed Sheeran'),
('Adele'),
('Shakira');

-- Inserts para la tabla Hosts
INSERT INTO Hosts (nombre_autor) VALUES
('Joe Rogan'),
('Sarah Koenig'),
('Marc Maron');

-- Inserts para la tabla Discograficas
INSERT INTO Discograficas (nombre_discografica, ubicacion) VALUES
('Sony Music', 'New York, USA'),
('Universal Music', 'Los Angeles, USA'),
('Warner Music', 'London, UK');

-- Inserts para la tabla Playlists
INSERT INTO Playlists (nombre_playlist, duracion) VALUES
('Rock Classics', '01:30:00'),
('Pop Hits', '02:00:00'),
('Chill Vibes', '01:15:00');

-- Inserts para la tabla Canciones
INSERT INTO Canciones (nombre_cancion, duracion, n_reproducciones, ano_salida) VALUES
('Shape of You', '00:04:24', 1000000, 2017),
('Hello', '00:04:55', 2000000, 2015),
('Bohemian Rhapsody', '00:05:55', 5000000, 1975);

-- Inserts para la tabla Historial
INSERT INTO Historial (n_reproduccion) VALUES
(10),
(20),
(15);

-- Inserts para la tabla Podcast
INSERT INTO Podcast (nombre_podcast, duracion, reproducciones, fecha_salida) VALUES
('The Daily', '00:30:00', 10000, '2023-12-01'),
('Serial', '00:45:00', 20000, '2022-11-15'),
('TED Talks Daily', '00:25:00', 15000, '2023-01-10');

-- Inserts para la tabla Albumes
INSERT INTO Albumes (nombre_album, duracion, reproduccion, ano_salida) VALUES
('Divide', '00:59:00', 3000000, 2017),
('25', '00:48:00', 2500000, 2015),
('A Night at the Opera', '00:43:00', 4000000, 1975);

-- Inserts para la tabla Generos
INSERT INTO Generos (nombre_genero) VALUES
('Rock'),
('Pop'),
('Jazz');

-- Inserts para la tabla Autores
INSERT INTO Autores (nombre_autor, discografia) VALUES
('Freddie Mercury', 'A Night at the Opera'),
('Chris Martin', 'Parachutes'),
('Paul McCartney', 'Abbey Road');

-- Inserts para la tabla Usuarios_Playlist
INSERT INTO Usuarios_Playlist (id_usuario, id_playlist) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Usuarios_Historial
INSERT INTO Usuarios_Historial (id_usuario, id_historial) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Usuarios_Canciones
INSERT INTO Usuarios_Canciones (id_usuario, id_cancion) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Valora
INSERT INTO Valora (id_usuario, id_cancion, puntuacion) VALUES
(1, 1, 5),
(2, 2, 4),
(3, 3, 5);

-- Inserts para la tabla Usuarios_Podcast
INSERT INTO Usuarios_Podcast (id_usuario, id_podcast) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Playlist_Cancion
INSERT INTO Playlist_Cancion (id_playlist, id_cancion) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Historial_Cancion
INSERT INTO Historial_Cancion (id_historial, id_cancion) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Cancion_Albums
INSERT INTO Cancion_Albums (id_cancion, id_album) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Cancion_Generos
INSERT INTO Cancion_Generos (id_cancion, id_genero) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Canciones_Autores
INSERT INTO Canciones_Autores (id_cancion, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Albumes_Genero
INSERT INTO Albumes_Genero (id_album, id_genero) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Genero_Autores
INSERT INTO Genero_Autores (id_genero, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Albumes_Autor
INSERT INTO Albumes_Autor (id_album, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Podcast_Autores
INSERT INTO Podcast_Autores (id_podcast, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserts para la tabla Albumes_Discografias_Autores
INSERT INTO Albumes_Discografias_Autores (id_album, id_autor, id_discografia, fecha_publicacion) VALUES
(1, 1, 1,  '2022-11-15'),
(2, 2, 2,  '2022-11-15'),
(3, 3, 3,  '2022-11-15');


