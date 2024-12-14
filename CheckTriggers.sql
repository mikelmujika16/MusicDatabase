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