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
CREATE TABLE Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    CHECK (CHAR_LENGTH(nickname) >= 3)
);

-- Tabla: Playlist
CREATE TABLE Playlists (
    id_playlist SERIAL PRIMARY KEY,
    nombre_playlist VARCHAR(100) NOT NULL,
    duracion TIME NOT NULL
);

-- Tabla: Canciones
CREATE TABLE Canciones (
    id_cancion SERIAL PRIMARY KEY,
    nombre_cancion VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    n_reproducciones INT DEFAULT 0 CHECK (n_reproducciones >= 0),
    ano_salida INT NOT NULL
);

-- Tabla: Historial
CREATE TABLE Historial (
    id_historial SERIAL PRIMARY KEY,
    n_reproduccion INT DEFAULT 0 CHECK (n_reproduccion >= 0)
);

-- Tabla: Podcast
CREATE TABLE  Podcast (
    id_podcast SERIAL PRIMARY KEY,
    nombre_podcast VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    reproducciones INT DEFAULT 0 CHECK (reproducciones >= 0),
    fecha_salida DATE NOT NULL
);

-- Tabla: Albumes
CREATE TABLE  Albumes (
    id_album SERIAL PRIMARY KEY,
    nombre_album VARCHAR(150) NOT NULL,
    duracion TIME NOT NULL,
    reproduccion INT DEFAULT 0 CHECK (reproduccion >= 0),
    ano_salida INT NOT NULL
);

-- Tabla: Generos
CREATE TABLE Generos (
    id_genero SERIAL PRIMARY KEY,
    nombre_genero VARCHAR(100) NOT NULL
);

-- Tabla: Autores
CREATE TABLE Autores (
    id_autor SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(150) NOT NULL,
    discografia TEXT
);

-- Tabla: Grupo
CREATE TABLE Grupos (
    id_autor SERIAL,
    nombre_grupo VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_autor, nombre_grupo),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Artista
CREATE TABLE Artista (
    id_autor SERIAL,
    nombre_artista VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_autor, nombre_artista),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Host
CREATE TABLE Hosts (
    id_autor SERIAL,
    nombre_host VARCHAR(150) NOT NULL,
    PRIMARY KEY (id_autor,nombre_host),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Discograficas
CREATE TABLE Discograficas (
    id_discografia SERIAL PRIMARY KEY,
    nombre_discografica VARCHAR(150) NOT NULL,
    ubicacion TEXT
);

-- Tabla: Usuarios-Playlist
CREATE TABLE Usuarios_Playlist (
    id_usuario INT NOT NULL,
    id_playlist INT NOT NULL,
    PRIMARY KEY (id_usuario, id_playlist),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_playlist) REFERENCES Playlists(id_playlist) ON DELETE CASCADE
);

-- Tabla: Usuarios-Historial
CREATE TABLE Usuarios_Historial (
    id_usuario INT NOT NULL,
    id_historial INT NOT NULL,
    PRIMARY KEY (id_usuario, id_historial),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_historial) REFERENCES Historial(id_historial) ON DELETE CASCADE
);

-- Tabla: Usuarios-Canciones
CREATE TABLE Usuarios_Canciones (
    id_usuario INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_usuario, id_cancion),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Tabla: Valora
CREATE TABLE Valora (
    id_usuario INT NOT NULL,
    id_cancion INT NOT NULL,
    puntuacion INT CHECK (puntuacion >= 1 AND puntuacion <= 5),
    PRIMARY KEY (id_usuario, id_cancion),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Tabla: Usuarios-Podcast
CREATE TABLE Usuarios_Podcast (
    id_usuario INT NOT NULL,
    id_podcast INT NOT NULL,
    PRIMARY KEY (id_usuario, id_podcast),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_podcast) REFERENCES Podcast(id_podcast) ON DELETE CASCADE
);

-- Tabla: Playlist-Cancion
CREATE TABLE Playlist_Cancion (
    id_playlist INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_playlist, id_cancion),
    FOREIGN KEY (id_playlist) REFERENCES Playlists(id_playlist) ON DELETE CASCADE,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Tabla: Historial-Cancion
CREATE TABLE Historial_Cancion (
    id_historial INT NOT NULL,
    id_cancion INT NOT NULL,
    PRIMARY KEY (id_historial, id_cancion),
    FOREIGN KEY (id_historial) REFERENCES Historial(id_historial) ON DELETE CASCADE,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Tabla: Cancion-Albums
CREATE TABLE Cancion_Albums (
    id_cancion INT NOT NULL,
    id_album INT NOT NULL,
    PRIMARY KEY (id_cancion, id_album),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE,
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE
);

-- Tabla: Cancion-Generos
CREATE TABLE Cancion_Generos (
    id_cancion INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_cancion, id_genero),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero) ON DELETE CASCADE
);

-- Tabla: Canciones-Autores
CREATE TABLE Canciones_Autores (
    id_cancion INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_cancion, id_autor),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Albumes-Genero
CREATE TABLE Albumes_Genero (
    id_album INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_album, id_genero),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero) ON DELETE CASCADE
);

-- Tabla: Genero-Autores
CREATE TABLE Genero_Autores (
    id_genero INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_genero, id_autor),
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Albumes-Autor
CREATE TABLE Albumes_Autor (
    id_album INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_album, id_autor),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Podcast-Autores
CREATE TABLE Podcast_Autores (
    id_podcast INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_podcast, id_autor),
    FOREIGN KEY (id_podcast) REFERENCES Podcast(id_podcast) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE
);

-- Tabla: Albumes-Discografia-Autor
CREATE TABLE Albumes_Discografias_Autores (
    id_album INT NOT NULL,
    id_autor INT NOT NULL,
    id_discografia INT NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_album, id_autor, id_discografia),
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor) ON DELETE CASCADE,
    FOREIGN KEY (id_discografia) REFERENCES Discograficas(id_discografia) ON DELETE CASCADE
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
('Luis', 'Martínez', 'luism', 'luis.martinez@example.com'),
('María', 'López', 'marial', 'maria.lopez@example.com'),
('Carlos', 'Fernández', 'carlitof', 'carlos.fernandez@example.com'),
('Sofía', 'Hernández', 'sofiaher', 'sofia.hernandez@example.com'),
('Pedro', 'Sánchez', 'pedros', 'pedro.sanchez@example.com'),
('Laura', 'Ramírez', 'laurar', 'laura.ramirez@example.com'),
('Javier', 'García', 'javiers', 'javier.garcia@example.com'),
('Lucía', 'Martín', 'luciama', 'lucia.martin@example.com');

-- Inserts para la tabla Playlists
INSERT INTO Playlists (nombre_playlist, duracion) VALUES
('Rock Classics', '02:45:00'),
('Pop Hits', '03:30:00'),
('Chill Vibes', '02:15:00'),
('Workout Beats', '01:45:00'),
('Indie Favorites', '02:50:00');

-- Inserts para la tabla Canciones
INSERT INTO Canciones (nombre_cancion, duracion, n_reproducciones, ano_salida) VALUES
('Bohemian Rhapsody', '00:05:55', 5000, 1975),
('Shape of You', '00:04:24', 12000, 2017),
('Imagine', '00:03:03', 8000, 1971),
('Blinding Lights', '00:03:20', 15000, 2019),
('Hotel California', '00:06:30', 10000, 1976),
('Rolling in the Deep', '00:03:48', 13000, 2010),
('Havana', '00:03:38', 11000, 2017),
('Clocks', '00:05:07', 9000, 2002),
('Lose Yourself', '00:05:26', 16000, 2002),
('Uptown Funk', '00:04:30', 14000, 2014);

-- Inserts para la tabla Historial
INSERT INTO Historial (n_reproduccion) VALUES
(5),
(3),
(10),
(7),
(6);

-- Inserts para la tabla Podcast
INSERT INTO Podcast (nombre_podcast, duracion, reproducciones, fecha_salida) VALUES
('True Crime Stories', '00:45:00', 5000, '2022-01-15'),
('Tech Talks', '00:50:00', 7000, '2021-08-22'),
('The Daily News', '00:30:00', 8000, '2023-03-10'),
('Sports Central', '00:40:00', 3000, '2021-11-05'),
('History Hour', '00:55:00', 9000, '2022-07-12'),
('Movie Reviews', '00:35:00', 4000, '2020-05-25'),
('Music Trends', '00:30:00', 6000, '2023-02-13'),
('Entrepreneurship 101', '00:45:00', 2500, '2021-12-08'),
('Science Weekly', '00:40:00', 7000, '2022-09-11'),
('Life Hacks', '00:50:00', 8500, '2023-06-30');

-- Inserts para la tabla Albumes
INSERT INTO Albumes (nombre_album, duracion, reproduccion, ano_salida) VALUES
('A Night at the Opera', '00:43:00', 5000, 1975),
('Divide', '00:42:00', 12000, 2017),
('Imagine', '00:36:00', 8000, 1971),
('After Hours', '00:50:00', 15000, 2019),
('Hotel California', '00:45:00', 10000, 1976),
('21', '00:55:00', 13000, 2010),
('Camila', '00:38:00', 11000, 2017),
('X&Y', '00:47:00', 9000, 2005),
('The Eminem Show', '00:58:00', 16000, 2002),
('Uptown Special', '00:45:00', 14000, 2014);

-- Inserts para la tabla Generos
INSERT INTO Generos (nombre_genero) VALUES
('Rock'),
('Pop'),
('Jazz'),
('Indie'),
('Hip-Hop'),
('Classical'),
('Blues'),
('R&B'),
('Electronic'),
('Reggae');

-- Inserts para la tabla Autores
INSERT INTO Autores (nombre_autor, discografia) VALUES
('Freddie Mercury', 'A Night at the Opera, Innuendo, etc.'),
('Ed Sheeran', 'Plus, Multiply, Divide, etc.'),
('John Lennon', 'Imagine, Double Fantasy, etc.'),
('The Weeknd', 'Starboy, After Hours, etc.'),
('Don Henley', 'Hotel California, End of the Innocence, etc.'),
('Adele', '21, 25, 30, etc.'),
('Camila Cabello', 'Camila, Romance, etc.'),
('Coldplay', 'Parachutes, X&Y, etc.'),
('Eminem', 'The Eminem Show, Recovery, etc.'),
('Mark Ronson', 'Uptown Special, Late Night Feelings, etc.');

-- Inserts para la tabla Grupos
INSERT INTO Grupos (nombre_grupo) VALUES
('Queen'),
('The Beatles'),
('Coldplay'),
('The Rolling Stones'),
('The Chainsmokers'),
('One Direction'),
('Imagine Dragons'),
('Coldplay'),
('Red Hot Chili Peppers'),
('Maroon 5');

-- Inserts para la tabla Artista
INSERT INTO Artista (nombre_artista) VALUES
('Freddie Mercury'),
('Ed Sheeran'),
('John Lennon'),
('The Weeknd'),
('Don Henley'),
('Adele'),
('Camila Cabello'),
('Coldplay'),
('Eminem'),
('Mark Ronson');

-- Inserts para la tabla Host
INSERT INTO Hosts (nombre_host) VALUES
('Joe Rogan'),
('Bill Simmons'),
('Mark Maron'),
('Alex Cooper'),
('David Tennant'),
('Dax Shepard'),
('Chris D’Elia'),
('Reggie Watts'),
('Bert Kreischer'),
('Tom Segura');

-- Inserts para la tabla Discograficas
INSERT INTO Discograficas (nombre_discografica, ubicacion) VALUES
('Universal Music', 'Los Angeles, USA'),
('Sony Music', 'New York, USA'),
('Warner Music Group', 'London, UK'),
('EMI Records', 'Paris, France'),
('Island Records', 'Jamaica'),
('Columbia Records', 'Los Angeles, USA'),
('Atlantic Records', 'New York, USA'),
('Capitol Music Group', 'Los Angeles, USA'),
('Def Jam Recordings', 'New York, USA'),
('RCA Records', 'Los Angeles, USA');

INSERT INTO Usuarios_Playlist (id_usuario, id_playlist) VALUES
(1, 1),  -- Juan con Playlist Rock Classics
(2, 1),  -- Ana con Playlist Rock Classics
(3, 1),  -- Luis con Playlist Rock Classics
(4, 2),  -- María con Playlist Pop Hits
(5, 2),  -- Carlos con Playlist Pop Hits
(6, 2),  -- Sofía con Playlist Pop Hits
(7, 3),  -- Pedro con Playlist Chill Vibes
(8, 3),  -- Laura con Playlist Chill Vibes
(9, 3),  -- Javier con Playlist Chill Vibes
(10, 4), -- Lucía con Playlist Workout Beats
(1, 4),  -- Juan con Playlist Workout Beats
(2, 4),  -- Ana con Playlist Workout Beats
(3, 5),  -- Luis con Playlist Indie Favorites
(4, 5),  -- María con Playlist Indie Favorites
(5, 5),  -- Carlos con Playlist Indie Favorites
(6, 1),  -- Sofía con Playlist Rock Classics
(7, 2),  -- Pedro con Playlist Pop Hits
(8, 2),  -- Laura con Playlist Pop Hits
(10, 3); -- Lucía con Playlist Workout Beats

-- Inserts para la tabla Usuarios-Historial
INSERT INTO Usuarios_Historial (id_usuario, id_historial) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 1),
(7, 2),
(8, 3),
(9, 4),
(10, 5);

-- Inserts para la tabla Usuarios-Canciones
INSERT INTO Usuarios_Canciones (id_usuario, id_cancion) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Valora
INSERT INTO Valora (id_usuario, id_cancion, puntuacion) VALUES
(1, 1, 5),
(2, 2, 4),
(3, 3, 5),
(4, 4, 3),
(5, 5, 5),
(6, 6, 4),
(7, 7, 5),
(8, 8, 3),
(9, 9, 4),
(10, 10, 5);

-- Inserts para la tabla Usuarios-Podcast
INSERT INTO Usuarios_Podcast (id_usuario, id_podcast) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Playlist-Cancion
INSERT INTO Playlist_Cancion (id_playlist, id_cancion) VALUES
(1, 1), 
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- Inserts para la tabla Historial-Cancion
INSERT INTO Historial_Cancion (id_historial, id_cancion) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6),
(2, 7),
(3, 8),
(4, 9),
(5, 10);

-- Inserts para la tabla Cancion-Albums
INSERT INTO Cancion_Albums (id_cancion, id_album) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Cancion-Generos
INSERT INTO Cancion_Generos (id_cancion, id_genero) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9);

-- Inserts para la tabla Canciones-Autores
INSERT INTO Canciones_Autores (id_cancion, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Albumes-Genero
INSERT INTO Albumes_Genero (id_album, id_genero) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Genero-Autores
INSERT INTO Genero_Autores (id_genero, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Albumes-Autor
INSERT INTO Albumes_Autor (id_album, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Podcast-Autores
INSERT INTO Podcast_Autores (id_podcast, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserts para la tabla Albumes-Discografia-Autor
INSERT INTO Albumes_Discografias_Autores (id_album, id_autor, id_discografia, fecha_publicacion) VALUES
(1, 1, 1, '1975-11-21'),
(2, 2, 2, '2017-03-03'),
(3, 3, 3, '1971-10-11'),
(4, 4, 4, '2019-03-20'),
(5, 5, 5, '1976-12-08'),
(6, 6, 6, '2010-01-24'),
(7, 7, 7, '2017-12-08'),
(8, 8, 8, '2005-06-01'),
(9, 9, 9, '2002-05-26'),
(10, 10, 10, '2014-11-21');
