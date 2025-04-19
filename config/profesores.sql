DROP DATABASE IF EXISTS profesores;
CREATE DATABASE IF NOT EXISTS profesores;
USE profesores;

CREATE TABLE genero (
  genero_id     INT AUTO_INCREMENT PRIMARY KEY,
  descripcion   VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE grado_academico (
  grado_id      INT AUTO_INCREMENT PRIMARY KEY,
  descripcion   VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE puesto (
  puesto_id     INT AUTO_INCREMENT PRIMARY KEY,
  descripcion   VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE asignatura (
  asignatura_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE estado_profesor (
  estado_id     INT AUTO_INCREMENT PRIMARY KEY,
  descripcion   VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE rol (
  rol_id        INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol    VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE profesor (
  profesor_id          INT AUTO_INCREMENT PRIMARY KEY,
  numero_trabajador    VARCHAR(20)    NOT NULL UNIQUE,
  nombre               VARCHAR(50)    NOT NULL,
  apellido_paterno     VARCHAR(50)    NOT NULL,
  apellido_materno     VARCHAR(50)    NOT NULL,
  genero_id            INT            NOT NULL,
  rfc                  CHAR(13)       NOT NULL UNIQUE,
  curp                 CHAR(18)       NOT NULL UNIQUE,
  grado_id             INT            NOT NULL,
  antiguedad_unam      INT            NOT NULL COMMENT 'Años laborando en la UNAM',
  antiguedad_carrera   INT            NOT NULL COMMENT 'Años de experiencia en la carrera',
  correo_institucional  VARCHAR(100)   NOT NULL UNIQUE,
  telefono_casa        VARCHAR(15),
  telefono_celular     VARCHAR(15),
  direccion            VARCHAR(255),
  estado_id            INT            NOT NULL DEFAULT 1,
  FOREIGN KEY (genero_id) REFERENCES genero(genero_id),
  FOREIGN KEY (grado_id)  REFERENCES grado_academico(grado_id),
  FOREIGN KEY (estado_id) REFERENCES estado_profesor(estado_id)
) ENGINE=InnoDB;

CREATE TABLE categoria_profesor (
  categoria_id    INT AUTO_INCREMENT PRIMARY KEY,
  profesor_id     INT NOT NULL,
  puesto_id       INT NOT NULL,
  asignatura_id   INT NOT NULL,
  fecha_inicio    DATE,
  fecha_fin       DATE,
  FOREIGN KEY (profesor_id)   REFERENCES profesor(profesor_id),
  FOREIGN KEY (puesto_id)     REFERENCES puesto(puesto_id),
  FOREIGN KEY (asignatura_id) REFERENCES asignatura(asignatura_id),
  UNIQUE(profesor_id, puesto_id, asignatura_id, fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE usuario_app (
  usuario_id      INT AUTO_INCREMENT PRIMARY KEY,
  username        VARCHAR(50)    NOT NULL UNIQUE,
  password_hash   CHAR(60)       NOT NULL,
  correo          VARCHAR(100)   NOT NULL UNIQUE,
  rol_id          INT            NOT NULL,
  fecha_creacion  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  activo          BOOLEAN        NOT NULL DEFAULT TRUE,
  FOREIGN KEY (rol_id) REFERENCES rol(rol_id)
) ENGINE=InnoDB;

INSERT INTO genero (descripcion) VALUES
  ('Masculino'),
  ('Femenino'),
  ('Otro');

INSERT INTO grado_academico (descripcion) VALUES
  ('Licenciatura'),
  ('Maestría'),
  ('Doctorado'),
  ('Posdoctorado');

INSERT INTO puesto (descripcion) VALUES
  ('Interino'),
  ('Definitivo'),
  ('Tiempo completo');

INSERT INTO asignatura (nombre) VALUES
  ('Asignatura A'),
  ('Asignatura B'),
  ('Asignatura C');

INSERT INTO estado_profesor (descripcion) VALUES
  ('Activo'),
  ('Retirado'),
  ('Incapacitado'),
  ('Otro');

INSERT INTO rol (nombre_rol) VALUES
  ('administrador'),
  ('visitante');

CREATE TABLE historico_profesor (
  historico_id          INT AUTO_INCREMENT PRIMARY KEY,
  profesor_id           INT            NOT NULL,
  numero_trabajador     VARCHAR(20)    NOT NULL,
  nombre                VARCHAR(50)    NOT NULL,
  apellido_paterno      VARCHAR(50)    NOT NULL,
  apellido_materno      VARCHAR(50)    NOT NULL,
  genero_id             INT            NOT NULL,
  rfc                   CHAR(13)       NOT NULL,
  curp                  CHAR(18)       NOT NULL,
  grado_id              INT            NOT NULL,
  antiguedad_unam       INT            NOT NULL,
  antiguedad_carrera    INT            NOT NULL,
  correo_institucional  VARCHAR(100)   NOT NULL,
  telefono_casa         VARCHAR(15),
  telefono_celular      VARCHAR(15),
  direccion             VARCHAR(255),
  estado_id             INT            NOT NULL,
  fecha_cambio          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (profesor_id) REFERENCES profesor(profesor_id),
  FOREIGN KEY (genero_id)    REFERENCES genero(genero_id),
  FOREIGN KEY (grado_id)     REFERENCES grado_academico(grado_id),
  FOREIGN KEY (estado_id)    REFERENCES estado_profesor(estado_id)
) ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER trg_profesor_after_update
AFTER UPDATE ON profesor
FOR EACH ROW
BEGIN
  INSERT INTO historico_profesor (
    profesor_id, numero_trabajador, nombre, apellido_paterno, apellido_materno,
    genero_id, rfc, curp, grado_id, antiguedad_unam, antiguedad_carrera,
    correo_institucional, telefono_casa, telefono_celular, direccion, estado_id
  ) VALUES (
    OLD.profesor_id, OLD.numero_trabajador, OLD.nombre, OLD.apellido_paterno, OLD.apellido_materno,
    OLD.genero_id, OLD.rfc, OLD.curp, OLD.grado_id, OLD.antiguedad_unam, OLD.antiguedad_carrera,
    OLD.correo_institucional, OLD.telefono_casa, OLD.telefono_celular, OLD.direccion,
    OLD.estado_id
  );
END$$

CREATE TRIGGER trg_profesor_before_delete
BEFORE DELETE ON profesor
FOR EACH ROW
BEGIN
  INSERT INTO historico_profesor (
    profesor_id, numero_trabajador, nombre, apellido_paterno, apellido_materno,
    genero_id, rfc, curp, grado_id, antiguedad_unam, antiguedad_carrera,
    correo_institucional, telefono_casa, telefono_celular, direccion, estado_id
  ) VALUES (
    OLD.profesor_id, OLD.numero_trabajador, OLD.nombre, OLD.apellido_paterno, OLD.apellido_materno,
    OLD.genero_id, OLD.rfc, OLD.curp, OLD.grado_id, OLD.antiguedad_unam, OLD.antiguedad_carrera,
    OLD.correo_institucional, OLD.telefono_casa, OLD.telefono_celular, OLD.direccion,
    OLD.estado_id
  );
END$$

DELIMITER ;

