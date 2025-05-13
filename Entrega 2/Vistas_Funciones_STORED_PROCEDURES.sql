-- ============================================
-- VISTAS
-- ============================================

-- Vista: vw_juegos_por_genero
-- Descripción: Lista los juegos junto con su género.
-- Objetivo: Facilita el análisis de distribución de juegos por género.
-- Tablas utilizadas: games, genres
CREATE VIEW vw_juegos_por_genero AS
SELECT 
    g.game_id,
    g.title,
    gen.name AS genero
FROM games g
JOIN genres gen ON g.genre_id = gen.genre_id;


-- Vista: vw_juegos_por_plataforma
-- Descripción: Muestra los juegos disponibles por plataforma.
-- Objetivo: Consultar fácilmente qué juegos están disponibles en cada plataforma.
-- Tablas utilizadas: games, game_platforms, platforms
CREATE VIEW vw_juegos_por_plataforma AS
SELECT 
    g.title AS juego,
    p.name AS plataforma,
    p.manufacturer AS fabricante
FROM games g
JOIN game_platforms gp ON g.game_id = gp.game_id
JOIN platforms p ON gp.platform_id = p.platform_id;


-- Vista: vw_desarrolladores_activos
-- Descripción: Muestra los desarrolladores que tienen al menos un juego publicado.
-- Objetivo: Identificar los desarrolladores que han lanzado juegos.
-- Tablas utilizadas: developers, games
CREATE VIEW vw_desarrolladores_activos AS
SELECT DISTINCT d.developer_id, d.name, d.country
FROM developers d
JOIN games g ON d.developer_id = g.developer_id;


-- ============================================
-- FUNCIONES
-- ============================================

-- Función: fn_cantidad_juegos_por_genero
-- Descripción: Devuelve la cantidad de juegos que existen para un género específico.
-- Objetivo: Obtener métricas rápidas de contenido por categoría.
-- Tablas utilizadas: games
DELIMITER //
CREATE FUNCTION fn_cantidad_juegos_por_genero(idGenero INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM games
    WHERE genre_id = idGenero;
    RETURN total;
END //
DELIMITER ;

-- Función: fn_total_juegos_por_desarrollador
-- Descripción: Devuelve cuántos juegos ha desarrollado un desarrollador específico.
-- Objetivo: Medir productividad por estudio.
-- Tablas utilizadas: games
DELIMITER //
CREATE FUNCTION fn_total_juegos_por_desarrollador(idDev INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM games
    WHERE developer_id = idDev;
    RETURN total;
END //
DELIMITER ;

-- ============================================
-- STORED PROCEDURES
-- ============================================

-- Procedimiento: sp_insertar_juego
-- Descripción: Inserta un nuevo juego en la base de datos.
-- Objetivo: Centralizar la lógica de inserción y asegurar integridad.
-- Tablas utilizadas: games
DELIMITER //
CREATE PROCEDURE sp_insertar_juego (
    IN p_title VARCHAR(150),
    IN p_release_date DATE,
    IN p_developer_id INT,
    IN p_genre_id INT,
    IN p_description TEXT
)
BEGIN
    INSERT INTO games (title, release_date, developer_id, genre_id, description)
    VALUES (p_title, p_release_date, p_developer_id, p_genre_id, p_description);
END //
DELIMITER ;


-- Procedimiento: sp_asociar_juego_plataforma
-- Descripción: Relaciona un juego con una plataforma específica.
-- Objetivo: Facilitar la asociación de juegos multiplataforma.
-- Tablas utilizadas: game_platforms
DELIMITER //
CREATE PROCEDURE sp_asociar_juego_plataforma (
    IN p_game_id INT,
    IN p_platform_id INT
)
BEGIN
    INSERT INTO game_platforms (game_id, platform_id)
    VALUES (p_game_id, p_platform_id);
END //
DELIMITER ;
