CREATE DATABASE VideoGamesDB;

use VideoGamesDB;

-- Tabla de desarrolladores
CREATE TABLE developers (
    developer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    founded_year INT
);

-- Tabla de géneros
CREATE TABLE genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

-- Tabla de plataformas
CREATE TABLE platforms (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manufacturer VARCHAR(100)
);

-- Tabla de videojuegos
CREATE TABLE games (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    release_date DATE,
    developer_id INT,
    genre_id INT,
    description TEXT,
    FOREIGN KEY (developer_id) REFERENCES developers(developer_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Tabla intermedia para relación muchos a muchos entre juegos y plataformas
CREATE TABLE game_platforms (
    game_id INT,
    platform_id INT,
    PRIMARY KEY (game_id, platform_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (platform_id) REFERENCES platforms(platform_id)
);

INSERT INTO developers (name, country, founded_year) VALUES
('Naughty Dog', 'USA', 1984),
('CD Projekt Red', 'Polonia', 2002),
('FromSoftware', 'Japón', 1986),
('Rockstar Games', 'USA', 1998),
('Ubisoft Montreal', 'Canadá', 1997),
('343 Industries', 'USA', 2007),
('Bungie', 'USA', 1991),
('Valve Corporation', 'USA', 1996),
('Game Freak', 'Japón', 1989),
('Insomniac Games', 'USA', 1994),
('Bethesda Game Studios', 'USA', 2001),
('Mojang Studios', 'Suecia', 2009),
('Team Cherry', 'Australia', 2015);

INSERT INTO genres (name) VALUES
('RPG'),
('Acción'),
('Aventura'),
('Shooter'),
('Estrategia'),
('Simulación'),
('Puzzle'),
('Deportes'),
('Carreras'),
('Terror'),
('Plataformas');

INSERT INTO platforms (name, manufacturer) VALUES
('Nintendo Switch', 'Nintendo'),
('PlayStation 4', 'Sony'),
('PlayStation 5', 'Sony'),
('Xbox One', 'Microsoft'),
('Xbox Series X', 'Microsoft'),
('PC', 'Varios'),
('Steam Deck', 'Valve'),
('Epic Games Launcher', 'Epic Games'),
('Google Stadia', 'Google'),
('iOS', 'Apple'),
('Android', 'Google'),
('Wii U', 'Nintendo'),
('PS Vita', 'Sony');

INSERT INTO games (title, release_date, developer_id, genre_id, description) VALUES
('The Witcher 3: Wild Hunt', '2015-05-19', 2, 1, 'RPG de mundo abierto.'),
('Dark Souls III', '2016-04-12', 3, 2, 'RPG de acción desafiante.'),
('The Last of Us Part II', '2020-06-19', 1, 3, 'Drama postapocalíptico.'),
('Red Dead Redemption 2', '2018-10-26', 4, 3, 'Western con narrativa profunda.'),
('Assassins Creed Valhalla', '2020-11-10', 5, 3, 'RPG vikingo de acción.'),
('Halo Infinite', '2021-12-08', 6, 4, 'Shooter futurista.'),
('Destiny 2', '2017-09-06', 7, 4, 'Shooter MMO online.'),
('Half-Life: Alyx', '2020-03-23', 8, 2, 'Shooter VR.'),
('Pokémon Legends: Arceus', '2022-01-28', 9, 1, 'Precuela Pokémon con mecánicas nuevas.'),
('Marvels Spider-Man', '2018-09-07', 10, 2, 'Aventura de superhéroes.'),
('Skyrim', '2011-11-11', 11, 1, 'RPG de fantasía inmenso.'),
('Minecraft', '2011-11-18', 12, 3, 'Construcción y supervivencia.'),
('Hollow Knight', '2017-02-24', 13, 2, 'Metroidvania desafiante.');

INSERT INTO game_platforms (game_id, platform_id) VALUES
(1, 2),
(1, 3),
(2, 2),
(2, 1),
(3, 1),
(3, 2),
(4, 1),
(4, 3),
(5, 1),
(5, 4),
(6, 4),
(6, 3),
(7, 2),
(7, 4),
(8, 6),
(9, 5),
(10, 1),
(11, 2),
(11, 4),
(12, 2),
(12, 6),
(13, 6);

CREATE VIEW view_games_details AS
SELECT 
    g.game_id,
    g.title,
    g.release_date,
    d.name AS developer,
    d.country,
    g.description,
    ge.name AS genre
FROM games g
JOIN developers d ON g.developer_id = d.developer_id
JOIN genres ge ON g.genre_id = ge.genre_id;

CREATE VIEW view_games_platforms AS
SELECT 
    g.title AS game,
    p.name AS platform,
    p.manufacturer
FROM games g
JOIN game_platforms gp ON g.game_id = gp.game_id
JOIN platforms p ON gp.platform_id = p.platform_id
ORDER BY g.title, p.name;

CREATE VIEW view_developer_game_count AS
SELECT 
    d.name AS developer,
    COUNT(g.game_id) AS total_games
FROM developers d
LEFT JOIN games g ON d.developer_id = g.developer_id
GROUP BY d.developer_id
ORDER BY total_games DESC;

CREATE VIEW view_genre_distribution AS
SELECT 
    ge.name AS genre,
    COUNT(g.game_id) AS total_games
FROM genres ge
LEFT JOIN games g ON ge.genre_id = g.genre_id
GROUP BY ge.genre_id
ORDER BY total_games DESC;

CREATE VIEW view_platform_game_count AS
SELECT 
    p.name AS platform,
    COUNT(gp.game_id) AS total_games
FROM platforms p
LEFT JOIN game_platforms gp ON p.platform_id = gp.platform_id
GROUP BY p.platform_id
ORDER BY total_games DESC;

CREATE VIEW view_recent_games AS
SELECT 
    g.title,
    g.release_date,
    d.name AS developer
FROM games g
JOIN developers d ON g.developer_id = d.developer_id
WHERE g.release_date >= '2018-01-01'
ORDER BY g.release_date DESC;
