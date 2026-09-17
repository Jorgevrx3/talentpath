-- ===========================================================================
--  seed.sql — TalentPath
--  Datos de prueba. Reproducen exactamente los hechos de
--  prolog/base_conocimiento.pl, de modo que la base de datos y el motor
--  de reglas trabajen sobre la misma informacion.
--
--  Uso: mysql -u root -p < seed.sql
--       (ejecutar despues de schema.sql)
-- ===========================================================================

USE db_talentpath;


-- ---------------------------------------------------------------------------
-- Usuarios
-- Las contrasenas se guardan cifradas. Los valores de abajo son de ejemplo:
-- el backend debe generarlas con bcrypt, nunca guardarlas en texto plano.
-- ---------------------------------------------------------------------------
INSERT INTO usuario (correo, contrasena, nombres, apellidos) VALUES
('juan.perez@correo.com',  '$2b$10$EJEMPLO.NO.USAR.EN.PRODUCCION.HASH1', 'Juan',  'Pérez Ramos'),
('maria.quispe@correo.com','$2b$10$EJEMPLO.NO.USAR.EN.PRODUCCION.HASH2', 'María', 'Quispe Loayza');


-- ---------------------------------------------------------------------------
-- Perfiles profesionales
-- ---------------------------------------------------------------------------
INSERT INTO perfil_profesional (id_usuario, titulo, resumen, anios_experiencia) VALUES
(1, 'Estudiante de Ingeniería de Sistemas',
    'Estudiante de Ingeniería de Sistemas con experiencia en desarrollo web y bases de datos.', 1),
(2, 'Bachiller en Ingeniería de Sistemas',
    'Interés en análisis de datos y automatización de reportes.', 2);


-- ---------------------------------------------------------------------------
-- Catálogo de habilidades
-- ---------------------------------------------------------------------------
INSERT INTO habilidad (nombre, categoria) VALUES
('HTML',       'frontend'),      -- 1
('CSS',        'frontend'),      -- 2
('JavaScript', 'frontend'),      -- 3
('React',      'frontend'),      -- 4
('Git',        'herramienta'),   -- 5
('MySQL',      'base_datos'),    -- 6
('Python',     'backend'),       -- 7
('SQL',        'base_datos'),    -- 8
('Excel',      'ofimatica'),     -- 9
('Node.js',    'backend');       -- 10


-- ---------------------------------------------------------------------------
-- Habilidades declaradas por cada perfil
-- Nivel: 1 mencionada · 2 básica · 3 intermedia · 4 sólida · 5 avanzada
-- El motor Prolog considera "evidenciado" a partir del nivel 3.
-- ---------------------------------------------------------------------------
INSERT INTO perfil_habilidad (id_perfil, id_habilidad, nivel) VALUES
(1, 1, 4),   -- Juan · HTML       · sólida
(1, 2, 4),   -- Juan · CSS        · sólida
(1, 3, 3),   -- Juan · JavaScript · intermedia
(1, 4, 1),   -- Juan · React      · solo mencionada
(1, 6, 3),   -- Juan · MySQL      · intermedia
(2, 7, 4),   -- María · Python
(2, 8, 4),   -- María · SQL
(2, 9, 5);   -- María · Excel


-- ---------------------------------------------------------------------------
-- Currículums y versiones
-- ---------------------------------------------------------------------------
INSERT INTO curriculum (id_usuario, nombre) VALUES
(1, 'Frontend Junior'),      -- 1
(1, 'General 2026'),         -- 2
(2, 'Analista de datos');    -- 3

INSERT INTO version_curriculum (id_curriculum, numero, contenido) VALUES
(1, 1, 'Versión inicial orientada a puestos de frontend.'),
(1, 2, 'Se agregó la práctica en SoftLima y se reordenaron las habilidades.'),
(2, 1, 'Versión general, sin orientación a un puesto específico.'),
(3, 1, 'Versión orientada a análisis de datos y reportes.');


-- ---------------------------------------------------------------------------
-- Empresas
-- ---------------------------------------------------------------------------
INSERT INTO empresa (razon_social, sector) VALUES
('Innova Perú', 'Tecnología'),   -- 1
('Grupo Andes', 'Retail'),       -- 2
('SoftLima',    'Software'),     -- 3
('Netcom',      'Tecnología'),   -- 4
('DataSur',     'Consultoría');  -- 5


-- ---------------------------------------------------------------------------
-- Ofertas laborales
-- ---------------------------------------------------------------------------
INSERT INTO oferta_laboral (id_empresa, puesto, descripcion) VALUES
(1, 'Desarrollador Frontend Junior',
    'Desarrollo de interfaces web. Lima, modalidad híbrida.'),            -- 1
(2, 'Analista de Sistemas',
    'Soporte y análisis de sistemas internos. Ica, presencial.'),         -- 2
(3, 'Practicante de Desarrollo Web',
    'Prácticas en desarrollo web. Remoto.'),                              -- 3
(4, 'Desarrollador Full Stack',
    'Desarrollo de aplicaciones web completas. Lima, remoto.'),           -- 4
(5, 'Ingeniero de Datos Junior',
    'Preparación y carga de datos para reportes. Lima, presencial.');     -- 5


-- ---------------------------------------------------------------------------
-- Requisitos de cada oferta  (1 = obligatorio, 0 = deseable)
-- ---------------------------------------------------------------------------
INSERT INTO requisito_oferta (id_oferta, id_habilidad, obligatorio) VALUES
-- Desarrollador Frontend Junior
(1, 1,  1),   -- HTML
(1, 2,  1),   -- CSS
(1, 3,  1),   -- JavaScript
(1, 4,  1),   -- React
(1, 5,  0),   -- Git (deseable)
-- Analista de Sistemas
(2, 8,  1),   -- SQL
(2, 6,  1),   -- MySQL
(2, 9,  0),   -- Excel (deseable)
-- Practicante de Desarrollo Web
(3, 1,  1),   -- HTML
(3, 2,  1),   -- CSS
(3, 3,  0),   -- JavaScript (deseable)
-- Desarrollador Full Stack
(4, 3,  1),   -- JavaScript
(4, 4,  1),   -- React
(4, 10, 1),   -- Node.js
(4, 6,  1),   -- MySQL
(4, 5,  0),   -- Git (deseable)
-- Ingeniero de Datos Junior
(5, 7,  1),   -- Python
(5, 8,  1),   -- SQL
(5, 6,  1),   -- MySQL
(5, 9,  0);   -- Excel (deseable)


-- ---------------------------------------------------------------------------
-- Postulaciones
-- ---------------------------------------------------------------------------
INSERT INTO postulacion (id_version, id_oferta, estado) VALUES
(2, 1, 'en_revision'),   -- Juan  · Frontend Junior
(3, 2, 'entrevista'),    -- Juan  · Analista de Sistemas
(4, 2, 'en_revision');   -- María · Analista de Sistemas


-- ---------------------------------------------------------------------------
-- Entrevistas simuladas y sus preguntas
-- ---------------------------------------------------------------------------
INSERT INTO entrevista_simulada (id_postulacion, puntaje_global) VALUES
(2, 8.00),
(2, 7.50);

INSERT INTO pregunta_respuesta (id_entrevista, pregunta, respuesta, puntaje) VALUES
(1, 'Cuéntame sobre un proyecto en React en el que hayas trabajado y cuál fue tu aporte concreto.',
    'En el curso de Desarrollo Web construimos una aplicación de reservas. Me encargué de los componentes del formulario y de la conexión con la API.', 8),
(1, '¿Cómo organizas tu trabajo cuando participas en un equipo?',
    'Dividimos las tareas por módulo y revisamos avances dos veces por semana.', 7),
(2, 'Describe una situación en la que tuviste que aprender una tecnología nueva en poco tiempo.',
    'Aprendí MySQL en dos semanas para el proyecto del curso de base de datos.', 8);


-- ---------------------------------------------------------------------------
-- Suscripciones y pagos
-- ---------------------------------------------------------------------------
INSERT INTO suscripcion (id_usuario, plan, fecha_inicio, fecha_fin, estado) VALUES
(1, 'premium',  '2026-09-06 00:00:00', '2026-10-06 00:00:00', 'activa'),
(2, 'gratuito', '2026-08-15 00:00:00', NULL,                  'activa');

INSERT INTO pago (id_suscripcion, monto, fecha, metodo) VALUES
(1, 29.90, '2026-07-06 10:12:00', 'tarjeta'),
(1, 29.90, '2026-08-06 10:08:00', 'tarjeta'),
(1, 29.90, '2026-09-06 10:15:00', 'tarjeta');


-- ===========================================================================
-- CONSULTA DE VERIFICACION
-- Debe devolver el mismo resultado que la regla compatibilidad_ponderada/3
-- del motor Prolog: Frontend Junior = 78 % para Juan.
-- ===========================================================================
--
-- SELECT o.puesto,
--        ROUND( SUM( CASE WHEN ph.nivel >= 3 THEN 1.0
--                         WHEN ph.nivel IS NOT NULL THEN 0.5
--                         ELSE 0 END
--                    * CASE WHEN r.obligatorio = 1 THEN 2 ELSE 1 END )
--               * 100
--               / SUM( CASE WHEN r.obligatorio = 1 THEN 2 ELSE 1 END )
--             ) AS compatibilidad
-- FROM oferta_laboral o
-- JOIN requisito_oferta r  ON r.id_oferta = o.id_oferta
-- LEFT JOIN perfil_habilidad ph
--        ON ph.id_habilidad = r.id_habilidad AND ph.id_perfil = 1
-- GROUP BY o.id_oferta, o.puesto
-- ORDER BY compatibilidad DESC;
--
-- ===========================================================================
