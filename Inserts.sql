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
INSERT INTO Albumes_Discografias_Autores (id_album, id_autor, id_discografia) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);
