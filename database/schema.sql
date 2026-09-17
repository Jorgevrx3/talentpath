-- ===========================================================================
--  schema.sql — TalentPath
--  Esquema de base de datos derivado del modelo entidad-relacion
--  del apartado 1.8 del informe.
--
--  Motor: MySQL 8 / MariaDB 10
--  Uso:   mysql -u root -p < schema.sql
-- ===========================================================================

DROP DATABASE IF EXISTS db_talentpath;

CREATE DATABASE db_talentpath
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE db_talentpath;


-- ---------------------------------------------------------------------------
-- 1. Usuarios y perfil profesional
-- ---------------------------------------------------------------------------

CREATE TABLE usuario (
    id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
    correo         VARCHAR(120) NOT NULL UNIQUE,
    contrasena     VARCHAR(255) NOT NULL,
    nombres        VARCHAR(80)  NOT NULL,
    apellidos      VARCHAR(80)  NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;


CREATE TABLE perfil_profesional (
    id_perfil          INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario         INT NOT NULL,
    titulo             VARCHAR(150) NOT NULL,
    resumen            TEXT,
    anios_experiencia  TINYINT UNSIGNED DEFAULT 0,
    CONSTRAINT fk_perfil_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE,
    -- un usuario tiene un solo perfil profesional
    CONSTRAINT uq_perfil_usuario UNIQUE (id_usuario)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------------
-- 2. Habilidades
-- ---------------------------------------------------------------------------

CREATE TABLE habilidad (
    id_habilidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL UNIQUE,
    categoria    VARCHAR(100) NOT NULL
) ENGINE = InnoDB;


CREATE TABLE perfil_habilidad (
    id_perfil    INT NOT NULL,
    id_habilidad INT NOT NULL,
    -- 1 = mencionada, 2 = basica, 3 = intermedia, 4 = solida, 5 = avanzada
    -- El motor Prolog considera "evidenciado" a partir del nivel 3.
    nivel        TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_perfil, id_habilidad),
    CONSTRAINT fk_ph_perfil
        FOREIGN KEY (id_perfil) REFERENCES perfil_profesional (id_perfil)
        ON DELETE CASCADE,
    CONSTRAINT fk_ph_habilidad
        FOREIGN KEY (id_habilidad) REFERENCES habilidad (id_habilidad),
    CONSTRAINT ck_ph_nivel CHECK (nivel BETWEEN 1 AND 5)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------------
-- 3. Curriculums y sus versiones
-- ---------------------------------------------------------------------------

CREATE TABLE curriculum (
    id_curriculum   INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT NOT NULL,
    nombre          VARCHAR(100) NOT NULL,
    fecha_creacion  DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_curriculum_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
) ENGINE = InnoDB;


CREATE TABLE version_curriculum (
    id_version    INT AUTO_INCREMENT PRIMARY KEY,
    id_curriculum INT NOT NULL,
    numero        INT NOT NULL,
    contenido     TEXT NOT NULL,
    fecha         DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_version_curriculum
        FOREIGN KEY (id_curriculum) REFERENCES curriculum (id_curriculum)
        ON DELETE CASCADE,
    -- no puede haber dos versiones con el mismo numero en un mismo CV
    CONSTRAINT uq_version_numero UNIQUE (id_curriculum, numero)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------------
-- 4. Empresas, ofertas y requisitos
-- ---------------------------------------------------------------------------

CREATE TABLE empresa (
    id_empresa   INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    sector       VARCHAR(100) NOT NULL
) ENGINE = InnoDB;


CREATE TABLE oferta_laboral (
    id_oferta         INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa        INT NOT NULL,
    puesto            VARCHAR(150) NOT NULL,
    descripcion       TEXT NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_oferta_empresa
        FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa)
) ENGINE = InnoDB;


CREATE TABLE requisito_oferta (
    id_requisito INT AUTO_INCREMENT PRIMARY KEY,
    id_oferta    INT NOT NULL,
    id_habilidad INT NOT NULL,
    obligatorio  TINYINT(1) NOT NULL,   -- 1 = obligatorio, 0 = deseable
    CONSTRAINT fk_requisito_oferta
        FOREIGN KEY (id_oferta) REFERENCES oferta_laboral (id_oferta)
        ON DELETE CASCADE,
    CONSTRAINT fk_requisito_habilidad
        FOREIGN KEY (id_habilidad) REFERENCES habilidad (id_habilidad),
    -- una oferta no puede exigir dos veces la misma habilidad
    CONSTRAINT uq_requisito UNIQUE (id_oferta, id_habilidad)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------------
-- 5. Postulaciones y entrevistas simuladas
-- ---------------------------------------------------------------------------

CREATE TABLE postulacion (
    id_postulacion INT AUTO_INCREMENT PRIMARY KEY,
    id_version     INT NOT NULL,
    id_oferta      INT NOT NULL,
    fecha          DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado         VARCHAR(50) NOT NULL,
    CONSTRAINT fk_postulacion_version
        FOREIGN KEY (id_version) REFERENCES version_curriculum (id_version),
    CONSTRAINT fk_postulacion_oferta
        FOREIGN KEY (id_oferta) REFERENCES oferta_laboral (id_oferta)
) ENGINE = InnoDB;


CREATE TABLE entrevista_simulada (
    id_entrevista  INT AUTO_INCREMENT PRIMARY KEY,
    id_postulacion INT NOT NULL,
    fecha          DATETIME DEFAULT CURRENT_TIMESTAMP,
    puntaje_global DECIMAL(5,2),
    CONSTRAINT fk_entrevista_postulacion
        FOREIGN KEY (id_postulacion) REFERENCES postulacion (id_postulacion)
        ON DELETE CASCADE
) ENGINE = InnoDB;


CREATE TABLE pregunta_respuesta (
    id_pregunta   INT AUTO_INCREMENT PRIMARY KEY,
    id_entrevista INT NOT NULL,
    pregunta      TEXT NOT NULL,
    respuesta     TEXT,
    puntaje       TINYINT UNSIGNED,
    CONSTRAINT fk_pregunta_entrevista
        FOREIGN KEY (id_entrevista) REFERENCES entrevista_simulada (id_entrevista)
        ON DELETE CASCADE,
    CONSTRAINT ck_pregunta_puntaje CHECK (puntaje BETWEEN 0 AND 10)
) ENGINE = InnoDB;


-- ---------------------------------------------------------------------------
-- 6. Suscripciones y pagos
-- ---------------------------------------------------------------------------

CREATE TABLE suscripcion (
    id_suscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT NOT NULL,
    plan           VARCHAR(50) NOT NULL,
    fecha_inicio   DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin      DATETIME,
    estado         VARCHAR(20) NOT NULL,
    CONSTRAINT fk_suscripcion_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
        ON DELETE CASCADE
) ENGINE = InnoDB;


CREATE TABLE pago (
    id_pago        INT AUTO_INCREMENT PRIMARY KEY,
    id_suscripcion INT NOT NULL,
    monto          DECIMAL(10,2) NOT NULL,
    fecha          DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo         VARCHAR(50),
    CONSTRAINT fk_pago_suscripcion
        FOREIGN KEY (id_suscripcion) REFERENCES suscripcion (id_suscripcion)
) ENGINE = InnoDB;


-- ===========================================================================
-- FIN DEL ESQUEMA
-- ===========================================================================
