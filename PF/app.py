from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

# Conexión a la base de datos
conn = psycopg2.connect(
    dbname="music_db",
    user="postgres",
    password="usuario",
    host="localhost"
)
cursor = conn.cursor()

# ---------------------- Rutas de Usuarios ----------------------

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/users')
def users():
    cursor.execute("SELECT * FROM Usuarios")
    usuarios = cursor.fetchall()
    return render_template('users.html', usuarios=usuarios)

@app.route('/users/add', methods=['POST'])
def add_user():
    nombre = request.form['name']
    email = request.form['email']
    cursor.execute(
        "INSERT INTO Usuarios (nombre, apellido, nickname, email) VALUES (%s, %s, %s, %s)",
        (nombre, "Apellido", "nickname", email)
    )
    conn.commit()
    return redirect(url_for('users'))

@app.route('/users/delete', methods=['POST'])
def delete_user():
    user_id = request.form['id']
    cursor.execute("DELETE FROM Usuarios WHERE id_usuario = %s", (user_id,))
    conn.commit()
    return redirect(url_for('users'))

# ---------------------- Rutas de Canciones ----------------------

@app.route('/songs')
def songs():
    cursor.execute("SELECT * FROM Canciones")
    canciones = cursor.fetchall()
    return render_template('songs.html', canciones=canciones)

@app.route('/songs/add', methods=['POST'])
def add_song():
    titulo = request.form['title']
    album_id = request.form['album_id']
    autor_id = request.form['author_id']
    cursor.execute(
        "INSERT INTO Canciones (titulo, id_album, id_autor) VALUES (%s, %s, %s)",
        (titulo, album_id, autor_id)
    )
    conn.commit()
    return redirect(url_for('songs'))

@app.route('/songs/delete', methods=['POST'])
def delete_song():
    song_id = request.form['id']
    cursor.execute("DELETE FROM Canciones WHERE id_cancion = %s", (song_id,))
    conn.commit()
    return redirect(url_for('songs'))

# ---------------------- Rutas de Álbumes ----------------------

@app.route('/albums')
def albums():
    cursor.execute("SELECT * FROM Albumes")
    albums = cursor.fetchall()
    return render_template('albums.html', albums=albums)

@app.route('/albums/add', methods=['POST'])
def add_album():
    titulo = request.form['title']
    autor_id = request.form['author_id']
    cursor.execute(
        "INSERT INTO Albumes (titulo, id_autor) VALUES (%s, %s)", (titulo, autor_id)
    )
    conn.commit()
    return redirect(url_for('albums'))

# ---------------------- Rutas de Autores ----------------------

@app.route('/authors')
def authors():
    cursor.execute("SELECT * FROM Autores")
    authors = cursor.fetchall()
    return render_template('authors.html', authors=authors)

@app.route('/authors/add', methods=['POST'])
def add_author():
    nombre = request.form['name']
    cursor.execute("INSERT INTO Autores (nombre) VALUES (%s)", (nombre,))
    conn.commit()
    return redirect(url_for('authors'))

# ---------------------- Rutas de Listas de Reproducción ----------------------

@app.route('/playlists')
def playlists():
    cursor.execute("SELECT * FROM playlists")
    playlists = cursor.fetchall()
    return render_template('playlists.html', playlists=playlists)

@app.route('/playlists/add', methods=['POST'])
def add_playlist():
    nombre_playlist = request.form['name']  # Asegúrate de que el formulario tenga un campo "name"
    duracion_inicial = "00:00:00"  # Valor inicial para la duración
    cursor.execute(
        "INSERT INTO Playlists (nombre_playlist, duracion) VALUES (%s, %s)", 
        (nombre_playlist, duracion_inicial)
    )
    conn.commit()
    return redirect(url_for('playlists'))  # Asegúrate de usar el nombre correcto de la función para redirigir

@app.route('/playlists/delete', methods=['POST'])
def delete_playlist():
    playlist_id = request.form['id']
    cursor.execute("DELETE FROM playlists WHERE id_lista = %s", (playlist_id,))
    conn.commit()
    return redirect(url_for('playlists'))

@app.route('/playlists/remove_song', methods=['POST'])
def remove_song_from_playlist():
    playlist_id = request.form['playlist_id']
    song_id = request.form['song_id']
    cursor.execute(
        "DELETE FROM Playlist_Cancion WHERE id_ = %s AND id_cancion = %s",
        (playlist_id, song_id)
    )
    conn.commit()
    return redirect(url_for('playlists'))

if __name__ == '__main__':
    app.run(debug=True)