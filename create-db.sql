-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema altascapacidades
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema altascapacidades
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `altascapacidades` DEFAULT CHARACTER SET utf8 ;
USE `altascapacidades` ;

-- -----------------------------------------------------
-- Table `altascapacidades`.`estado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`estado` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`estado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `estado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `estado_UNIQUE` (`estado` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`rol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`rol` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`rol` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `rol_UNIQUE` (`rol` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`usuario` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `apellidos` VARCHAR(200) NULL,
  `dni` VARCHAR(25) NOT NULL,
  `telefono` VARCHAR(20) NULL,
  `fecha_nacimiento` DATE NULL,
  `estado_civil` VARCHAR(100) NULL,
  `genero` VARCHAR(100) NULL,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_id` INT NOT NULL,
  `rol_id` INT NOT NULL,
  PRIMARY KEY (`id`, `estado_id`, `rol_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_user_estado_idx` (`estado_id` ASC) VISIBLE,
  INDEX `fk_user_rol1_idx` (`rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_estado`
    FOREIGN KEY (`estado_id`)
    REFERENCES `altascapacidades`.`estado` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_rol1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `altascapacidades`.`rol` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `altascapacidades`.`expediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`expediente` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`expediente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nombre_niño` VARCHAR(45) NULL,
  `apellidos_niño` VARCHAR(150) NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `dni_niño` VARCHAR(25) NULL,
  `fechanacimiento_niño` DATE NULL,
  `genero` VARCHAR(100) NULL,
  `curso_escolar` VARCHAR(200) NULL,
  `ciudad_natal` VARCHAR(200) NULL,
  `ciudad_residencia` VARCHAR(200) NULL,
  `lengua_materna` VARCHAR(200) NULL,
  `tipo_familia` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`datos_adicionales_usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`datos_adicionales_usuario` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`datos_adicionales_usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL,
  `profesion` VARCHAR(200) NULL,
  `relacion_niño` VARCHAR(100) NULL,
  `fecha_conoce` DATE NULL,
  `colaboracion` LONGTEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`usuario_expediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`usuario_expediente` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`usuario_expediente` (
  `usuario_id` INT NOT NULL,
  `expediente_id` INT NOT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  `rol_id` INT NOT NULL,
  `usuario_eliminado` TINYINT NULL DEFAULT 0,
  `datos_adicionales_usuario_id` INT NULL,
  INDEX `fk_user_has_expediente_expediente1_idx` (`expediente_id` ASC) VISIBLE,
  INDEX `fk_user_has_expediente_user1_idx` (`usuario_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UNIQUE_usuarioid_expedienteid` (`expediente_id` ASC, `usuario_id` ASC) VISIBLE,
  INDEX `fk_usuario_expediente_rol1_idx` (`rol_id` ASC) VISIBLE,
  INDEX `fk_usuario_expediente_datos_adicionales_usuario1_idx` (`datos_adicionales_usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_expediente_user`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `altascapacidades`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_expediente_expediente`
    FOREIGN KEY (`expediente_id`)
    REFERENCES `altascapacidades`.`expediente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_expediente_rol1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `altascapacidades`.`rol` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_expediente_datos_adicionales_usuario1`
    FOREIGN KEY (`datos_adicionales_usuario_id`)
    REFERENCES `altascapacidades`.`datos_adicionales_usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `altascapacidades`.`Anotaciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`Anotaciones` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`Anotaciones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(200) NULL,
  `anotacion` TEXT NOT NULL,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` INT NOT NULL,
  `expediente_id` INT NOT NULL,
  PRIMARY KEY (`id`, `usuario_id`, `expediente_id`),
  INDEX `fk_Anotaciones_usuario1_idx` (`usuario_id` ASC) INVISIBLE,
  INDEX `fk_Anotaciones_expediente1_idx` (`expediente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Anotaciones_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `altascapacidades`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Anotaciones_expediente1`
    FOREIGN KEY (`expediente_id`)
    REFERENCES `altascapacidades`.`expediente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`cuestionario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`cuestionario` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`cuestionario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`cuestionarios_defecto_rol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`cuestionarios_defecto_rol` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`cuestionarios_defecto_rol` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rol_id` INT NOT NULL,
  `cuestionario_id` INT NOT NULL,
  PRIMARY KEY (`id`, `rol_id`, `cuestionario_id`),
  INDEX `fk_rol_has_cuestionario_cuestionario1_idx` (`cuestionario_id` ASC) INVISIBLE,
  INDEX `fk_rol_has_cuestionario_rol1_idx` (`rol_id` ASC) INVISIBLE,
  CONSTRAINT `fk_rol_has_cuestionario_rol1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `altascapacidades`.`rol` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_has_cuestionario_cuestionario1`
    FOREIGN KEY (`cuestionario_id`)
    REFERENCES `altascapacidades`.`cuestionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`cuestionario_usuario_expediente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`cuestionario_usuario_expediente` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`cuestionario_usuario_expediente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cuestionario_id` INT NOT NULL,
  `usuario_expediente_id` INT NOT NULL,
  `completado` TINYINT NULL DEFAULT 0,
  PRIMARY KEY (`id`, `cuestionario_id`, `usuario_expediente_id`),
  INDEX `fk_cuestionario_has_usuario_expediente_usuario_expediente1_idx` (`usuario_expediente_id` ASC) VISIBLE,
  INDEX `fk_cuestionario_has_usuario_expediente_cuestionario1_idx` (`cuestionario_id` ASC) VISIBLE,
  CONSTRAINT `fk_cuestionario_has_usuario_expediente_cuestionario1`
    FOREIGN KEY (`cuestionario_id`)
    REFERENCES `altascapacidades`.`cuestionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cuestionario_has_usuario_expediente_usuario_expediente1`
    FOREIGN KEY (`usuario_expediente_id`)
    REFERENCES `altascapacidades`.`usuario_expediente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`observaciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`observaciones` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`observaciones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `observacion` LONGTEXT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `rol_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_observaciones_rol1_idx` (`rol_id` ASC) VISIBLE,
  CONSTRAINT `fk_observaciones_rol1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `altascapacidades`.`rol` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `altascapacidades`.`respuesta_observacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `altascapacidades`.`respuesta_observacion` ;

CREATE TABLE IF NOT EXISTS `altascapacidades`.`respuesta_observacion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `respuesta` VARCHAR(200) NULL,
  `observaciones_id` INT NOT NULL,
  `expediente_id` INT NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_respuesta_observacion_observaciones1_idx` (`observaciones_id` ASC) VISIBLE,
  INDEX `fk_respuesta_observacion_expediente1_idx` (`expediente_id` ASC) VISIBLE,
  INDEX `fk_respuesta_observacion_usuario1_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_respuesta_observacion_observaciones1`
    FOREIGN KEY (`observaciones_id`)
    REFERENCES `altascapacidades`.`observaciones` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_respuesta_observacion_expediente1`
    FOREIGN KEY (`expediente_id`)
    REFERENCES `altascapacidades`.`expediente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_respuesta_observacion_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `altascapacidades`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
