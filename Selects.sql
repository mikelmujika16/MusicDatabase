-- Consultar todos los usuarios
SELECT * FROM Usuarios;

-- Consultar todos los grupos
SELECT * FROM Grupos;

-- Consultar todos los artistas
SELECT * FROM Artista;

-- Consultar todos los hosts
SELECT * FROM Hosts;

-- Consultar todas las discográficas
SELECT * FROM Discograficas;

-- Consultar todas las playlists
SELECT * FROM Playlists;

-- Consultar todas las canciones
SELECT * FROM Canciones;

-- Consultar todo el historial
SELECT * FROM Historial;

-- Consultar todos los podcasts
SELECT * FROM Podcast;

-- Consultar todos los álbumes
SELECT * FROM Albumes;

-- Consultar todos los géneros
SELECT * FROM Generos;

-- Consultar todos los autores
SELECT * FROM Autores;

-- Consultar relaciones entre usuarios y playlists
SELECT * FROM Usuarios_Playlist;

-- Consultar relaciones entre usuarios e historial
SELECT * FROM Usuarios_Historial;

-- Consultar relaciones entre usuarios y canciones
SELECT * FROM Usuarios_Canciones;

-- Consultar puntuaciones en la tabla Valora
SELECT * FROM Valora;

-- Consultar relaciones entre usuarios y podcasts
SELECT * FROM Usuarios_Podcast;

-- Consultar relaciones entre playlists y canciones
SELECT * FROM Playlist_Cancion;

-- Consultar relaciones entre historial y canciones
SELECT * FROM Historial_Cancion;

-- Consultar relaciones entre canciones y álbumes
SELECT * FROM Cancion_Albums;

-- Consultar relaciones entre canciones y géneros
SELECT * FROM Cancion_Generos;

-- Consultar relaciones entre canciones y autores
SELECT * FROM Canciones_Autores;

-- Consultar relaciones entre álbumes y géneros
SELECT * FROM Albumes_Genero;

-- Consultar relaciones entre géneros y autores
SELECT * FROM Genero_Autores;

-- Consultar relaciones entre álbumes y autores
SELECT * FROM Albumes_Autor;

-- Consultar relaciones entre podcasts y autores
SELECT * FROM Podcast_Autores;

-- Consultar relaciones entre álbumes, discográficas y autores
SELECT * FROM Albumes_Discografias_Autores;
