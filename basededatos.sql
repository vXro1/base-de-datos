CREATE TABLE Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

CREATE TABLE Albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    id_artista INT,
    anio INT NOT NULL,
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Canciones (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    id_album INT,
    duracion INT NOT NULL, -- en segundos
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

CREATE TABLE Reproducciones (
    id_reproduccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_cancion INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Artistas (nombre, pais) VALUES
('Coldplay', 'Reino Unido'),
('Imagine Dragons', 'Estados Unidos'),
('Adele', 'Reino Unido');

INSERT INTO Albumes (titulo, id_artista, anio) VALUES
('Parachutes', 1, 2000),
('Evolve', 2, 2017),
('30', 3, 2021);

INSERT INTO Canciones (titulo, id_album, duracion) VALUES
('Yellow', 1, 267),
('Believer', 2, 204),
('Easy On Me', 3, 225);

INSERT INTO Usuarios (nombre, pais) VALUES
('Juan Perez', 'México'),
('Ana Gomez', 'Colombia'),
('Emily Smith', 'Estados Unidos');

INSERT INTO Reproducciones (id_usuario, id_cancion) VALUES
(1, 1), (1, 2), (2, 3), (3, 1), (3, 3), (2, 1);

select * from Reproducciones;

-- 1 
CREATE VIEW Vista_Albumes_por_Artista AS
SELECT 
    (SELECT nombre FROM Artistas WHERE id_artista = al.id_artista) AS nombre_artista,
    al.titulo AS titulo_album,
    al.anio AS anio_lanzamiento
FROM 
    Albumes al;
    
 select * from Vista_Albumes_por_Artista;
 
 -- 2
 CREATE VIEW Vista_Reproducciones_de_Canciones AS
SELECT 
    (SELECT nombre FROM Usuarios WHERE id_usuario = r.id_usuario) AS nombre_usuario,
    (SELECT titulo FROM Canciones WHERE id_cancion = r.id_cancion) AS titulo_cancion,
    r.fecha AS fecha_reproduccion
FROM 
    Reproducciones r;
    
select * from Vista_Reproducciones_de_Canciones;

-- 3
CREATE VIEW Vista_Canciones_Mas_Reproducidas AS
SELECT 
    c.titulo AS titulo_cancion,
    (SELECT COUNT(*) FROM Reproducciones r WHERE r.id_cancion = c.id_cancion) AS total_reproducciones
FROM 
    Canciones c
ORDER BY 
    total_reproducciones DESC;
    
select * from Vista_Canciones_Mas_Reproducidas;

-- 4 
CREATE VIEW Vista_Usuarios_Mas_Reproducciones AS
SELECT 
    u.nombre AS nombre_usuario,
    (SELECT COUNT(*) FROM Reproducciones r WHERE r.id_usuario = u.id_usuario) AS total_reproducciones
FROM 
    Usuarios u
ORDER BY 
    total_reproducciones DESC;
    
select * from Vista_Usuarios_Mas_Reproducciones;
CREATE VIEW Vista_Canciones_Mejor_Calificadas AS
SELECT 
    c.titulo AS titulo_cancion,
    COALESCE(AVG(cal.calificacion), 0) AS calificacion_promedio,
    COUNT(cal.id_calificacion) AS cantidad_calificaciones
FROM 
    Canciones c
LEFT JOIN 
    Calificaciones cal ON c.id_cancion = cal.id_cancion
GROUP BY 
    c.id_cancion
ORDER BY 
    calificacion_promedio DESC;

SELECT * FROM Vista_Canciones_Mejor_Calificadas;

CREATE VIEW Vista_Playlists_Con_Cantidad AS
SELECT 
    p.nombre AS nombre_playlist,
    u.nombre AS nombre_usuario,
    COUNT(pc.id_cancion) AS total_canciones
FROM 
    Playlists p
LEFT JOIN 
    Playlist_Cancion pc ON p.id_playlist = pc.id_playlist
LEFT JOIN 
    Usuarios u ON p.id_usuario = u.id_usuario
GROUP BY 
    p.id_playlist
ORDER BY 
    total_canciones DESC;
CREATE TABLE Registro_Actividad (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(255) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Registro_Actividad (id_usuario, accion) 
VALUES (1, 'Calificó la canción "Yellow" con 5 estrellas');
CREATE TABLE Suscripciones (
    id_suscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNIQUE,
    tipo ENUM('Gratis', 'Premium') DEFAULT 'Gratis',
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);
UPDATE Suscripciones 
SET tipo = 'Premium', fecha_fin = DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
WHERE id_usuario = 1;
