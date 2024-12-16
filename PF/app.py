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

@app.route('/', methods=['GET', 'POST'])
def index():
    rows = None  # Por defecto no mostramos ninguna tabla
    table = None  # No seleccionamos ninguna tabla al inicio
    columns = []

    if request.method == 'POST':
        # Obtener la tabla seleccionada
        table = request.form['table']
        
        # Consultar los datos de la tabla seleccionada
        if table == 'Usuarios':
            cursor.execute("SELECT * FROM Usuarios")
            rows = cursor.fetchall()
            columns = ['ID', 'Name', 'Surname', 'Nickname', 'Email']
        elif table == 'Playlists':
            cursor.execute("SELECT * FROM Playlists")
            rows = cursor.fetchall()
            columns = ['ID', 'Playlist Name', 'Duration']
        elif table == 'Canciones':
            cursor.execute("SELECT * FROM Canciones")
            rows = cursor.fetchall()
            columns = ['ID', 'Song Name', 'Duration', 'Release Year']
        elif table == 'Podcast':
            cursor.execute("SELECT * FROM Podcast")
            rows = cursor.fetchall()
            columns = ['ID', 'Podcast Name', 'Duration', 'Reproductions', 'Release Date']
        elif table == 'Albumes':
            cursor.execute("SELECT * FROM Albumes")
            rows = cursor.fetchall()
            columns = ['ID', 'Album Name', 'Duration', 'Reproductions', 'Release Year']
        elif table == 'Generos':
            cursor.execute("SELECT * FROM Generos")
            rows = cursor.fetchall()
            columns = ['ID', 'Genre Name']
        elif table == 'Autores':
            cursor.execute("SELECT * FROM Autores")
            rows = cursor.fetchall()
            columns = ['ID', 'Author Name', 'Discography']
        elif table == 'Grupos':
            cursor.execute("SELECT * FROM Grupos")
            rows = cursor.fetchall()
            columns = ['ID', 'Group Name']
        elif table == 'Artista':
            cursor.execute("SELECT * FROM Artista")
            rows = cursor.fetchall()
            columns = ['ID', 'Artist Name']
        elif table == 'Hosts':
            cursor.execute("SELECT * FROM Hosts")
            rows = cursor.fetchall()
            columns = ['ID', 'Host Name']
        elif table == 'Discograficas':
            cursor.execute("SELECT * FROM Discograficas")
            rows = cursor.fetchall()
            columns = ['ID', 'Record Label Name', 'Location']

    return render_template('index.html', table=table, columns=columns, rows=rows)

# ---------------------- Rutas de Usuarios ----------------------


@app.route('/users')
def users():
    # Obtener los usuarios ordenados por id_usuario
    cursor.execute("SELECT * FROM Usuarios ORDER BY id_usuario ASC")
    usuarios = cursor.fetchall()

    # Obtener todas las canciones disponibles ordenadas por id_cancion
    cursor.execute("SELECT * FROM Canciones ORDER BY id_cancion ASC")
    canciones = cursor.fetchall()

    # Obtener canciones asociadas a cada usuario, ordenadas por id_cancion
    usuarios_con_canciones = []
    for user in usuarios:
        cursor.execute("""
            SELECT c.nombre_cancion
            FROM Canciones c
            JOIN Usuarios_Canciones uc ON c.id_cancion = uc.id_cancion
            WHERE uc.id_usuario = %s
            ORDER BY c.id_cancion ASC;
        """, (user[0],))
        canciones_usuario = cursor.fetchall()
        usuarios_con_canciones.append({
            'usuario': user,
            'canciones': [c[0] for c in canciones_usuario]  # Solo obtener el nombre de la canción
        })

    return render_template('users.html', usuarios_con_canciones=usuarios_con_canciones, canciones=canciones)

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

@app.route('/usuarios/update', methods=['POST'])
def update_user():
    # Obtener datos del formulario
    user_id = request.form['id_usuario']
    nombre = request.form.get('nombre')  # Usamos get() para que los campos puedan ser vacíos
    apellido = request.form.get('apellido')
    nickname = request.form.get('nickname')
    email = request.form.get('email')

    # Actualizar el usuario en la base de datos (solo los campos proporcionados)
    query = "UPDATE Usuarios SET "
    values = []
    if nombre:
        query += "nombre = %s, "
        values.append(nombre)
    if apellido:
        query += "apellido = %s, "
        values.append(apellido)
    if nickname:
        query += "nickname = %s, "
        values.append(nickname)
    if email:
        query += "email = %s, "
        values.append(email)

    # Eliminar la última coma y espacio en la cadena de la query
    query = query.rstrip(", ")  
    query += " WHERE id_usuario = %s"
    values.append(user_id)

    # Ejecutar la consulta de actualización
    cursor.execute(query, tuple(values))
    conn.commit()

    return redirect(url_for('users'))
    
@app.route('/users/add_song', methods=['POST'])
def add_song_to_user():
    id_usuario = request.form['id_usuario']
    id_cancion = request.form['id_cancion']
    cursor.execute(
        "INSERT INTO Usuarios_Canciones (id_usuario, id_cancion) VALUES (%s, %s)",
        (id_usuario, id_cancion)
    )
    conn.commit()
    return redirect(url_for('users'))
# ---------------------- Rutas de Canciones ----------------------

@app.route('/songs')
def songs():
    # Obtener todas las canciones junto con sus valoraciones (si existen), ordenadas por el ID de la canción
    cursor.execute("""
        SELECT c.id_cancion, c.nombre_cancion, c.duracion, c.ano_salida, c.n_reproducciones, 
               AVG(v.puntuacion) AS promedio_puntuacion
        FROM Canciones c
        LEFT JOIN Valora v ON c.id_cancion = v.id_cancion
        GROUP BY c.id_cancion
        ORDER BY c.id_cancion
    """)
    canciones = cursor.fetchall()
    return render_template('songs.html', canciones=canciones)


@app.route('/songs/create', methods=['POST'])
def create_song():
    # Obtener datos del formulario
    nombre_cancion = request.form['nombre_cancion']
    duracion = request.form['duracion']
    ano_salida = request.form['ano_salida']

    # Insertar la nueva canción en la base de datos
    cursor.execute("""
        INSERT INTO Canciones (nombre_cancion, duracion, ano_salida)
        VALUES (%s, %s, %s)
    """, (nombre_cancion, duracion, ano_salida))
    conn.commit()

    return redirect(url_for('songs')) 

@app.route('/songs/delete', methods=['POST'])
def delete_song():
    # Obtener el ID de la canción a eliminar
    id_cancion = request.form['id_cancion']

    # Eliminar la canción de la base de datos
    cursor.execute("DELETE FROM Canciones WHERE id_cancion = %s", (id_cancion,))
    conn.commit()

    return redirect(url_for('songs')) 

@app.route('/songs/update', methods=['POST'])
def update_song():
    # Obtener los datos del formulario
    id_cancion = request.form['id_cancion']
    nombre_cancion = request.form.get('nombre_cancion')
    duracion = request.form.get('duracion')
    ano_salida = request.form.get('ano_salida')

    # Generar la consulta para actualizar solo los campos proporcionados
    query = "UPDATE Canciones SET "
    values = []
    if nombre_cancion:
        query += "nombre_cancion = %s, "
        values.append(nombre_cancion)
    if duracion:
        query += "duracion = %s, "
        values.append(duracion)
    if ano_salida:
        query += "ano_salida = %s, "
        values.append(ano_salida)

    # Eliminar la última coma y espacio en la cadena de la query
    query = query.rstrip(", ")
    query += " WHERE id_cancion = %s"
    values.append(id_cancion)

    # Ejecutar la consulta de actualización
    cursor.execute(query, tuple(values))
    conn.commit()

    return redirect(url_for('songs'))

@app.route('/valorar', methods=['POST'])
def valorar_cancion():
    # Obtener los datos del formulario
    id_usuario = 1  # Esto debe cambiar a obtener el ID del usuario logueado en tu sistema, por ejemplo, con sesiones
    id_cancion = request.form['id_cancion']
    puntuacion = request.form['puntuacion']

    # Verificar si el usuario ya ha valorado esta canción
    cursor.execute("""
        SELECT * FROM Valora WHERE id_usuario = %s AND id_cancion = %s
    """, (id_usuario, id_cancion))
    existing_rating = cursor.fetchone()

    if existing_rating:
        # Si ya existe una valoración, actualizarla
        cursor.execute("""
            UPDATE Valora SET puntuacion = %s WHERE id_usuario = %s AND id_cancion = %s
        """, (puntuacion, id_usuario, id_cancion))
    else:
        # Si no existe una valoración, insertar una nueva
        cursor.execute("""
            INSERT INTO Valora (id_usuario, id_cancion, puntuacion)
            VALUES (%s, %s, %s)
        """, (id_usuario, id_cancion, puntuacion))

    conn.commit()
    return redirect(url_for('songs'))
# ---------------------- Rutas de Podcasts ----------------------
@app.route('/podcast', methods=['GET'])
def podcasts_page():
    cursor.execute("SELECT * FROM Podcast")
    podcasts = cursor.fetchall()

    return render_template('podcast.html', podcasts=podcasts)

@app.route('/podcast/create', methods=['POST'])
def create_podcast():
    nombre_podcast = request.form['nombre_podcast']
    duracion = request.form['duracion']
    fecha_salida = request.form['fecha_salida']
    reproducciones = request.form['reproducciones']

    cursor.execute("""
        INSERT INTO Podcast (nombre_podcast, duracion, fecha_salida, reproducciones)
        VALUES (%s, %s, %s, %s)
    """, (nombre_podcast, duracion, fecha_salida, reproducciones))
    conn.commit()

    return redirect(url_for('podcasts_page'))

@app.route('/podcast/delete', methods=['POST'])
def delete_podcast():
    id_podcast = request.form['id_podcast']
    
    cursor.execute("DELETE FROM Podcast WHERE id_podcast = %s", (id_podcast,))
    conn.commit()

    return redirect(url_for('podcasts_page'))

@app.route('/podcast/update', methods=['POST'])
def update_podcast():
    id_podcast = request.form['id_podcast']
    nombre_podcast = request.form['nombre_podcast']
    duracion = request.form['duracion']
    fecha_salida = request.form['fecha_salida']
    reproducciones = request.form['reproducciones']

    cursor.execute("""
        UPDATE Podcast
        SET nombre_podcast = %s, duracion = %s, fecha_salida = %s, reproducciones = %s
        WHERE id_podcast = %s
    """, (nombre_podcast, duracion, fecha_salida, reproducciones, id_podcast))
    conn.commit()

    return redirect(url_for('podcasts_page'))


# ---------------------- Rutas de Listas de Reproducción ----------------------
@app.route('/playlists', methods=['GET', 'POST'])
def playlists_page():
    if request.method == 'POST':
        if 'name' in request.form:
            # Agregar nueva playlist
            nombre_playlist = request.form['name']
            duracion_inicial = "00:00:00"  # Valor inicial para la duración
            cursor.execute(
                "INSERT INTO Playlists (nombre_playlist, duracion) VALUES (%s, %s) RETURNING id_playlist",
                (nombre_playlist, duracion_inicial)
            )
            playlist_id = cursor.fetchone()[0]  # Obtener el ID de la nueva playlist
            conn.commit()

            # Obtener canciones seleccionadas
            selected_songs = request.form.getlist('songs')  # Es una lista de IDs de canciones seleccionadas
            for song_id in selected_songs:
                cursor.execute(
                    "INSERT INTO Playlist_Cancion (id_playlist, id_cancion) VALUES (%s, %s)",
                    (playlist_id, song_id)
                )
            conn.commit()
            
            return redirect(url_for('playlists_page'))

        elif 'id' in request.form:
            # Eliminar playlist
            playlist_id = request.form['id']
            cursor.execute("DELETE FROM Playlist_Cancion WHERE id_playlist = %s", (playlist_id,))
            cursor.execute("DELETE FROM Playlists WHERE id_playlist = %s", (playlist_id,))
            conn.commit()
            return redirect(url_for('playlists_page'))

        elif 'playlist_id' in request.form and 'song_id' in request.form:
            # Quitar canción de una playlist
            playlist_id = request.form['playlist_id']
            song_id = request.form['song_id']
            cursor.execute(
                "DELETE FROM Playlist_Cancion WHERE id_playlist = %s AND id_cancion = %s",
                (playlist_id, song_id)
            )
            conn.commit()
            return redirect(url_for('playlists_page'))

    # Lógica para mostrar las playlists con canciones y usuarios (solo en GET)
    cursor.execute("""
        SELECT p.id_playlist, p.nombre_playlist, c.id_cancion, c.nombre_cancion
        FROM Playlists p
        LEFT JOIN Playlist_Cancion pc ON p.id_playlist = pc.id_playlist
        LEFT JOIN Canciones c ON pc.id_cancion = c.id_cancion
        ORDER BY p.id_playlist;
    """)
    data = cursor.fetchall()
    playlists = {}
    for row in data:
        playlist_id = row[0]
        playlist_name = row[1]
        song_id = row[2]
        song_name = row[3]

        if playlist_id not in playlists:
            playlists[playlist_id] = {"name": playlist_name, "songs": [], "users": []}
        if song_id and song_name:  # Evita añadir canciones nulas
            playlists[playlist_id]["songs"].append({"id": song_id, "name": song_name})

    # Obtener los usuarios asociados a las playlists
    cursor.execute("""
        SELECT up.id_playlist, u.id_usuario, u.nombre, u.apellido
        FROM Usuarios_Playlist up
        JOIN Usuarios u ON up.id_usuario = u.id_usuario
    """)
    user_data = cursor.fetchall()
    for row in user_data:
        playlist_id = row[0]
        user_id = row[1]
        user_name = f"{row[2]} {row[3]}"  # Nombre completo del usuario

        if playlist_id in playlists:
            playlists[playlist_id]["users"].append({"id": user_id, "name": user_name})

    # Obtener todas las canciones para el formulario
    cursor.execute("SELECT id_cancion, nombre_cancion FROM Canciones")
    all_songs = cursor.fetchall()

    return render_template('playlists.html', playlists=playlists, all_songs=all_songs)
@app.route('/playlists/add', methods=['POST'])
def add_playlist():
    if request.method == 'POST':
        # Obtener el nombre de la playlist
        nombre_playlist = request.form['name']
        duracion_inicial = "00:00:00"  # Valor inicial para la duración

        # Insertar la playlist en la base de datos
        cursor.execute(
            "INSERT INTO Playlists (nombre_playlist, duracion) VALUES (%s, %s) RETURNING id_playlist",
            (nombre_playlist, duracion_inicial)
        )
        playlist_id = cursor.fetchone()[0]  # Obtener el ID de la nueva playlist
        conn.commit()

        # Obtener las canciones seleccionadas desde el formulario
        selected_songs_input = request.form['songs']
        
        # Dividir las canciones por coma (', ')
        selected_songs = [song.strip() for song in selected_songs_input.split(',')]

        # Buscar los IDs de las canciones basados en sus nombres
        for song_name in selected_songs:
            cursor.execute(
                "SELECT id_cancion FROM Canciones WHERE nombre_cancion = %s",
                (song_name,)
            )
            song_row = cursor.fetchone()
            if song_row:
                song_id = song_row[0]
                # Insertar la canción en la tabla Playlist_Cancion
                cursor.execute(
                    "INSERT INTO Playlist_Cancion (id_playlist, id_cancion) VALUES (%s, %s)",
                    (playlist_id, song_id)
                )
            else:
                print(f"Song '{song_name}' not found in the database.")

        conn.commit()

        return redirect(url_for('playlists_page'))

@app.route('/playlists/delete', methods=['POST'])
def del_playlist():
    # Obtener el nombre de la playlist desde el formulario
    nombre_playlist = request.form['nombre_playlist']
    print(f"Nombre de la playlist a eliminar: '{nombre_playlist}'")  # Verifica que el nombre esté bien

    try:
        # Verificar si la playlist existe antes de intentar eliminarla
        cursor.execute("SELECT * FROM Playlists WHERE nombre_playlist = %s", (nombre_playlist,))
        playlist = cursor.fetchone()

        if playlist:
            # Eliminar las relaciones en playlist_cancion primero
            cursor.execute("DELETE FROM Playlist_Cancion WHERE id_playlist = %s", (playlist[0],))
            # Ahora eliminar la playlist de la tabla Playlists
            cursor.execute("DELETE FROM Playlists WHERE nombre_playlist = %s", (nombre_playlist,))
            conn.commit()  # Confirmar la eliminación en la base de datos

            # Verificar si se eliminó alguna fila
            if cursor.rowcount > 0:
                message = "Playlist eliminada correctamente."
            else:
                message = "No se encontró ninguna playlist con ese nombre."
        else:
            message = "No se encontró ninguna playlist con ese nombre."

    except Exception as e:
        # En caso de error, hacer rollback y manejar el error
        conn.rollback()  # Deshacer cualquier cambio realizado en la transacción
        message = f"Hubo un error: {e}"

    print(f"Resultado: {message}")  # Verifica el mensaje resultante
    return redirect(url_for('playlists_page'))
    
@app.route('/playlists/remove_song', methods=['POST'])
def remove_song_from_playlist():
    # Obtener los datos del formulario
    playlist_id = request.form['playlist_id']
    song_id = request.form['song_id']

    print(f"Playlist ID: {playlist_id}, Song ID: {song_id}")  # Para depuración

    try:
        # Eliminar la relación entre la canción y la playlist
        cursor.execute("DELETE FROM Playlist_Cancion WHERE id_playlist = %s AND id_cancion = %s", (playlist_id, song_id))
        conn.commit()

        # Verificar si se eliminó la relación
        if cursor.rowcount > 0:
            message = "Canción eliminada de la playlist correctamente."
        else:
            message = "No se encontró la canción en esta playlist."

    except Exception as e:
        # En caso de error
        message = f"Hubo un error: {e}"

    # Redirigir a la página de playlists, mostrando el mensaje en la URL
    return redirect(url_for('playlists_page', message=message))

@app.route('/playlists/remove_user', methods=['POST'])
def remove_user_from_playlist():
    # Obtener los datos del formulario
    playlist_id = request.form['playlist_id']
    user_id = request.form['user_id']

    try:
        # Eliminar la relación entre el usuario y la playlist
        cursor.execute("DELETE FROM Usuarios_Playlist WHERE id_playlist = %s AND id_usuario = %s", (playlist_id, user_id))
        if cursor.rowcount == 0:
            return redirect(url_for('playlists_page', message="El usuario no está asociado a esta playlist."))
        conn.commit()

        # Verificar si se eliminó la relación
        if cursor.rowcount > 0:
            message = "Usuario eliminado de la playlist correctamente."
        else:
            message = "No se encontró al usuario en esta playlist."

    except Exception as e:
        # En caso de error
        message = f"Hubo un error: {e}"

    # Redirigir a la página principal o renderizar un mensaje
    return redirect(url_for('playlists_page', message=message))

@app.route('/playlists/add_user', methods=['POST'])
def add_user_to_playlist():
    # Obtener los datos del formulario
    playlist_id = request.form['playlist_id']
    user_id = request.form['user_id']

    # Insertar la relación en la tabla Usuarios_Playlist
    cursor.execute(
        "INSERT INTO Usuarios_Playlist (id_playlist, id_usuario) VALUES (%s, %s)",
        (playlist_id, user_id)
    )
    conn.commit()

    return redirect(url_for('playlists_page'))  # Redirigir a la página de playlists

# ---------------------- Rutas de Álbumes ----------------------

@app.route('/albums')
def albums():
    cursor.execute("SELECT * FROM Albumes")
    albums = cursor.fetchall()
    cursor.execute("SELECT * FROM Generos")
    generos = cursor.fetchall()
    cursor.execute("SELECT * FROM Canciones")
    canciones = cursor.fetchall()

    # Obtener los géneros asociados a cada álbum
    albumes_generos = {}
    for album in albums:
        cursor.execute("""
            SELECT g.nombre_genero
            FROM Generos g
            JOIN Albumes_Genero ag ON g.id_genero = ag.id_genero
            WHERE ag.id_album = %s
        """, (album[0],))
        albumes_generos[album[0]] = [g[0] for g in cursor.fetchall()]

    # Obtener las canciones asociadas a cada álbum
    albumes_canciones = {}
    for album in albums:
        cursor.execute("""
            SELECT c.nombre_cancion
            FROM Canciones c
            JOIN Cancion_Albums ca ON c.id_cancion = ca.id_cancion
            WHERE ca.id_album = %s
        """, (album[0],))
        albumes_canciones[album[0]] = [c[0] for c in cursor.fetchall()]

    return render_template('albums.html', albums=albums, generos=generos, canciones=canciones,
                           albumes_generos=albumes_generos, albumes_canciones=albumes_canciones)

@app.route('/albums/create', methods=['POST'])
def create_album():
    nombre_album = request.form['nombre_album']
    duracion = request.form['duracion']
    reproduccion = request.form['reproduccion']
    ano_salida = request.form['ano_salida']

    cursor.execute("""
        INSERT INTO Albumes (nombre_album, duracion, reproduccion, ano_salida)
        VALUES (%s, %s, %s, %s)
    """, (nombre_album, duracion, reproduccion, ano_salida))
    conn.commit()
    return redirect(url_for('albums'))

@app.route('/albums/delete', methods=['POST'])
def delete_album():
    id_album = request.form['id_album']

    cursor.execute("DELETE FROM Albumes WHERE id_album = %s", (id_album,))
    conn.commit()
    return redirect(url_for('albums'))

@app.route('/albums/update', methods=['POST'])
def update_album():
    id_album = request.form['id_album']
    nombre_album = request.form.get('nombre_album')
    duracion = request.form.get('duracion')
    reproduccion = request.form.get('reproduccion')
    ano_salida = request.form.get('ano_salida')

    query = "UPDATE Albumes SET "
    values = []
    if nombre_album:
        query += "nombre_album = %s, "
        values.append(nombre_album)
    if duracion:
        query += "duracion = %s, "
        values.append(duracion)
    if reproduccion:
        query += "reproduccion = %s, "
        values.append(reproduccion)
    if ano_salida:
        query += "ano_salida = %s, "
        values.append(ano_salida)

    query = query.rstrip(", ")
    query += " WHERE id_album = %s"
    values.append(id_album)

    cursor.execute(query, tuple(values))
    conn.commit()
    return redirect(url_for('albums'))

@app.route('/albums/add_song', methods=['POST'])
def add_song_to_album():
    id_album = request.form['id_album']
    nombre_cancion = request.form['nombre_cancion']

    # Obtener el ID de la canción por su nombre
    cursor.execute("SELECT id_cancion FROM Canciones WHERE nombre_cancion = %s", (nombre_cancion,))
    song = cursor.fetchone()

    if song:
        # Si la canción existe, asociarla al álbum
        cursor.execute("""
            INSERT INTO Cancion_Albums (id_album, id_cancion)
            VALUES (%s, %s)
        """, (id_album, song[0]))
        conn.commit()
    else:
        flash("Song not found", "error")

    return redirect(url_for('albums'))
    
@app.route('/albums/add_genre', methods=['POST'])
def add_genre_to_album():
    id_album = request.form['id_album']
    nombre_genero = request.form['nombre_genero']

    # Obtener el ID del género por su nombre
    cursor.execute("SELECT id_genero FROM Generos WHERE nombre_genero = %s", (nombre_genero,))
    genero = cursor.fetchone()

    if genero:
        # Si el género existe, asociarlo al álbum
        cursor.execute("""
            INSERT INTO Albumes_Genero (id_album, id_genero)
            VALUES (%s, %s)
        """, (id_album, genero[0]))
        conn.commit()
    else:
        flash("Genre not found", "error")

    return redirect(url_for('albums'))
# ---------------------- Rutas de Autores ----------------------

@app.route('/authors')
def authors():
    # Obtener todos los autores
    cursor.execute("SELECT * FROM Autores")
    authors = cursor.fetchall()

    # Obtener las canciones asociadas a cada autor
    authors_with_songs_and_genres = []
    for author in authors:
        cursor.execute("""
            SELECT c.nombre_cancion
            FROM Canciones c
            JOIN Canciones_Autores ca ON c.id_cancion = ca.id_cancion
            WHERE ca.id_autor = %s
        """, (author[0],))
        songs = cursor.fetchall()

        # Obtener los géneros asociados a este autor
        cursor.execute("""
            SELECT g.nombre_genero
            FROM Generos g
            JOIN Genero_Autores ga ON g.id_genero = ga.id_genero
            WHERE ga.id_autor = %s
        """, (author[0],))
        genres = cursor.fetchall()

        authors_with_songs_and_genres.append({
            'author': author,
            'songs': [song[0] for song in songs],  # Solo obtener el nombre de la canción
            'genres': [genre[0] for genre in genres]  # Solo obtener el nombre del género
        })

    # Obtener todos los géneros disponibles
    cursor.execute("SELECT * FROM Generos")
    generos = cursor.fetchall()

    # Obtener todas las canciones disponibles
    cursor.execute("SELECT * FROM Canciones")
    canciones = cursor.fetchall()

    return render_template('authors.html',  authors_with_songs_and_genres=authors_with_songs_and_genres, generos=generos, canciones=canciones)

@app.route('/authors/add', methods=['POST'])
def add_author():
    nombre_autor = request.form['nombre_autor']
    discografia = request.form.get('discografia')  # Es opcional, puede estar vacío

    # Inserta el nuevo autor en la tabla
    cursor.execute(
        "INSERT INTO Autores (nombre_autor, discografia) VALUES (%s, %s)",
        (nombre_autor, discografia)
    )
    conn.commit()
    return redirect(url_for('authors'))

@app.route('/authors/delete', methods=['POST'])
def delete_author():
    author_id = request.form['id_autor']
    
    # Eliminar el autor de la base de datos
    cursor.execute("DELETE FROM Autores WHERE id_autor = %s", (author_id,))
    conn.commit()
    return redirect(url_for('authors'))

@app.route('/authors/update', methods=['POST'])
def update_author():
    author_id = request.form['id_autor']
    nuevo_nombre = request.form.get('nombre_autor')  # Puede ser vacío si no se cambia
    nueva_discografia = request.form.get('discografia')  # Puede ser vacío

    query = "UPDATE Autores SET "
    values = []

    if nuevo_nombre:
        query += "nombre_autor = %s, "
        values.append(nuevo_nombre)
    
    if nueva_discografia:
        query += "discografia = %s, "
        values.append(nueva_discografia)
    
    # Eliminar la última coma y espacio en la cadena de la query
    query = query.rstrip(", ")
    query += " WHERE id_autor = %s"
    values.append(author_id)

    cursor.execute(query, tuple(values))
    conn.commit()
    
    return redirect(url_for('authors'))

@app.route('/authors/add_song', methods=['POST'])
def add_song_to_author():
    id_autor = request.form['id_autor']
    id_cancion = request.form['id_cancion']
    # Insertar la nueva canción en la relación
    cursor.execute("""
        INSERT INTO Canciones_Autores (id_cancion, id_autor) VALUES (%s, %s)
    """, (id_cancion, id_autor))
    conn.commit()

    return redirect(url_for('authors'))

@app.route('/authors/add_genre', methods=['POST'])
def add_genre_to_author():
    id_autor = request.form['id_autor']
    id_genero = request.form['id_genero']

    # Insertar la relación entre autor y género en la tabla Genero_Autores
    cursor.execute("""
        INSERT INTO Genero_Autores (id_autor, id_genero) VALUES (%s, %s)
    """, (id_autor, id_genero))
    conn.commit()

    return redirect(url_for('authors'))


# ---------------------- Rutas de Grupos ----------------------
@app.route('/grupos')
def grupos():
    cursor.execute("""
        SELECT g.id_autor, g.nombre_grupo, a.nombre_autor
        FROM Grupos g
        JOIN Autores a ON g.id_autor = a.id_autor
    """)
    grupos = cursor.fetchall()
    return render_template('group.html', grupos=grupos)

@app.route('/grupos/add_author', methods=['POST'])
def add_author_to_group():
    id_autor = request.form['id_autor']
    nombre_grupo = request.form['nombre_grupo']

    # Verificar si el autor y el grupo existen y si no agregar
    cursor.execute("""
        INSERT INTO Grupos (id_autor, nombre_grupo) 
        VALUES (%s, %s)
    """, (id_autor, nombre_grupo))
    conn.commit()
    return redirect(url_for('grupos'))

# ---------------------- Rutas de Artistas ----------------------
@app.route('/artistas')
def artistas():
    cursor.execute("""
        SELECT a.id_autor, a.nombre_artista, b.nombre_autor
        FROM Artista a
        JOIN Autores b ON a.id_autor = b.id_autor
    """)
    artistas = cursor.fetchall()
    return render_template('artist.html', artistas=artistas)

@app.route('/artistas/add_author', methods=['POST'])
def add_author_to_artist():
    id_autor = request.form['id_autor']
    nombre_artista = request.form['nombre_artista']

    # Verificar si el autor y el artista existen y si no agregar
    cursor.execute("""
        INSERT INTO Artista (id_autor, nombre_artista) 
        VALUES (%s, %s)
    """, (id_autor, nombre_artista))
    conn.commit()
    return redirect(url_for('artistas'))


# ---------------------- Rutas de Hosts ----------------------
@app.route('/hosts')
def hosts():
    cursor.execute("""
        SELECT h.id_autor, h.nombre_host, a.nombre_autor
        FROM Hosts h
        JOIN Autores a ON h.id_autor = a.id_autor
    """)
    hosts = cursor.fetchall()
    return render_template('host.html', hosts=hosts)


@app.route('/hosts/add_author', methods=['POST'])
def add_author_to_host():
    id_autor = request.form['id_autor']
    nombre_host = request.form['nombre_host']

    # Verificar si el autor y el host existen y si no agregar
    cursor.execute("""
        INSERT INTO Hosts (id_autor, nombre_host) 
        VALUES (%s, %s)
    """, (id_autor, nombre_host))
    conn.commit()
    return redirect(url_for('hosts'))