DROP DATABASE IF EXISTS prueba_diagnostico;
CREATE DATABASE prueba_diagnostico

-- ========== CATÁLOGOS ==========
CREATE TABLE estados_vacante (
    estado_vacante_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE fuentes_postulacion (
    fuente_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE estados_postulacion (
    estado_postulacion_id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    es_final BOOLEAN NOT NULL,
    es_activo BOOLEAN NOT NULL
) ENGINE=InnoDB;

CREATE TABLE prioridades (
    prioridad_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    puntaje_min TINYINT UNSIGNED NOT NULL,
    puntaje_max TINYINT UNSIGNED NOT NULL,
    CONSTRAINT chk_prioridad_rango CHECK (puntaje_min <= puntaje_max)
) ENGINE=InnoDB;

-- ========== ENTIDADES ==========
CREATE TABLE empresas (
    empresa_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE candidatos (
    candidato_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    experiencia_anios TINYINT UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT chk_candidato_experiencia CHECK (experiencia_anios <= 60)
) ENGINE=InnoDB;

CREATE TABLE vacantes (
    vacante_id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    titulo_cargo VARCHAR(150) NOT NULL,
    experiencia_minima TINYINT UNSIGNED NOT NULL DEFAULT 0,
    estado_vacante_id INT NOT NULL,
    FOREIGN KEY (empresa_id) REFERENCES empresas (empresa_id),
    FOREIGN KEY (estado_vacante_id) REFERENCES estados_vacante (estado_vacante_id)
) ENGINE=InnoDB;

CREATE TABLE postulaciones (
    postulacion_id INT PRIMARY KEY AUTO_INCREMENT,
    candidato_id INT NOT NULL,
    vacante_id INT NOT NULL,
    carta_presentacion TEXT NOT NULL,
    fuente_id INT NOT NULL,
    puntaje TINYINT UNSIGNED NOT NULL,
    prioridad_id TINYINT UNSIGNED NOT NULL,
    estado_postulacion_id INT NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion_estado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_candidato_vacante UNIQUE (candidato_id, vacante_id),
    CONSTRAINT chk_puntaje CHECK (puntaje <= 100),
    FOREIGN KEY (candidato_id) REFERENCES candidatos (candidato_id),
    FOREIGN KEY (vacante_id) REFERENCES vacantes (vacante_id),
    FOREIGN KEY (fuente_id) REFERENCES fuentes_postulacion (fuente_id),
    FOREIGN KEY (prioridad_id) REFERENCES prioridades (prioridad_id),
    FOREIGN KEY (estado_postulacion_id) REFERENCES estados_postulacion (estado_postulacion_id),
    INDEX idx_prioridad_puntaje (prioridad_id, puntaje DESC),
    INDEX idx_estado (estado_postulacion_id)
) ENGINE=InnoDB;

-- ========== DATOS INICIALES ==========
INSERT INTO estados_vacante (codigo) VALUES ('ABIERTA'), ('PAUSADA'), ('CERRADA');

INSERT INTO fuentes_postulacion (codigo, descripcion) VALUES
 ('LINKEDIN', 'Postulación desde LinkedIn'),
 ('PORTAL',   'Portal web de la empresa'),
 ('REFERIDO', 'Referido por un empleado'),
 ('OTRO',     'Otra fuente');

INSERT INTO estados_postulacion (codigo, es_final, es_activo) VALUES
 ('RECIBIDA',    FALSE, TRUE),
 ('EN_REVISION', FALSE, TRUE),
 ('ENTREVISTA',  FALSE, TRUE),
 ('CONTRATADO',  TRUE,  FALSE),
 ('RECHAZADA',   TRUE,  FALSE),
 ('RETIRADA',    TRUE,  FALSE);

INSERT INTO prioridades (codigo, puntaje_min, puntaje_max) VALUES
 ('BAJA',  0,  39),
 ('MEDIA', 40, 69),
 ('ALTA',  70, 100);