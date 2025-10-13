-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema al_shifa_clinic
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `al_shifa_clinic` ;

SHOW WARNINGS;

CREATE SCHEMA IF NOT EXISTS `al_shifa_clinic` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;

SHOW WARNINGS;

USE `al_shifa_clinic` ;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`patient` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`patient` (
  `patient_id` BINARY(16) NOT NULL,
  `patient_name` VARCHAR(100) NOT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NULL DEFAULT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `address` TEXT NULL DEFAULT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`department` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`department` (
  `department_id` BINARY(16) NOT NULL,
  `department_name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`doctor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`doctor` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`doctor` (
  `doctor_id` BINARY(16) NOT NULL,
  `doctor_name` VARCHAR(100) NOT NULL,
  `specialization` VARCHAR(100) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `department_id` BINARY(16) NULL DEFAULT NULL,
  `consultation_fee` DECIMAL(10,2) NULL DEFAULT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`doctor_id`),
  INDEX `department_id` (`department_id` ASC) VISIBLE,
  CONSTRAINT `doctor_ibfk_1`
    FOREIGN KEY (`department_id`)
    REFERENCES `al_shifa_clinic`.`department` (`department_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`appointment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`appointment` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`appointment` (
  `appointment_id` BINARY(16) NOT NULL,
  `patient_id` BINARY(16) NULL DEFAULT NULL,
  `doctor_id` BINARY(16) NULL DEFAULT NULL,
  `appointment_date` DATETIME NOT NULL,
  `status` ENUM('Scheduled', 'Completed', 'Cancelled') NULL DEFAULT 'Scheduled',
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `appointment_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `al_shifa_clinic`.`patient` (`patient_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `appointment_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `al_shifa_clinic`.`doctor` (`doctor_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`treatment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`treatment` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`treatment` (
  `treatment_id` BINARY(16) NOT NULL,
  `appointment_id` BINARY(16) NULL DEFAULT NULL,
  `diagnosis_summary` TEXT NULL DEFAULT NULL,
  `treatment_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`treatment_id`),
  INDEX `appointment_id` (`appointment_id` ASC) VISIBLE,
  CONSTRAINT `treatment_ibfk_1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `al_shifa_clinic`.`appointment` (`appointment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`bill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`bill` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`bill` (
  `bill_id` BINARY(16) NOT NULL,
  `treatment_id` BINARY(16) NULL DEFAULT NULL,
  `doctor_fee` DECIMAL(10,2) NULL DEFAULT '0.00',
  `diagnosis_fee` DECIMAL(10,2) NULL DEFAULT '0.00',
  `medicine_fee` DECIMAL(10,2) NULL DEFAULT '0.00',
  `total_fee` DECIMAL(10,2) NULL DEFAULT '0.00',
  `billing_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`bill_id`),
  INDEX `treatment_id` (`treatment_id` ASC) VISIBLE,
  CONSTRAINT `bill_ibfk_1`
    FOREIGN KEY (`treatment_id`)
    REFERENCES `al_shifa_clinic`.`treatment` (`treatment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`diagnosis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`diagnosis` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`diagnosis` (
  `diagnosis_id` BINARY(16) NOT NULL,
  `diagnosis_name` VARCHAR(100) NOT NULL,
  `diagnosis_fee` DECIMAL(10,2) NOT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`diagnosis_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`medicine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`medicine` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`medicine` (
  `medicine_id` BINARY(16) NOT NULL,
  `medicine_name` VARCHAR(100) NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`medicine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`treatmentdiagnosis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`treatmentdiagnosis` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`treatmentdiagnosis` (
  `treatment_id` BINARY(16) NOT NULL,
  `diagnosis_id` BINARY(16) NOT NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`treatment_id`, `diagnosis_id`),
  INDEX `diagnosis_id` (`diagnosis_id` ASC) VISIBLE,
  CONSTRAINT `treatmentdiagnosis_ibfk_1`
    FOREIGN KEY (`treatment_id`)
    REFERENCES `al_shifa_clinic`.`treatment` (`treatment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `treatmentdiagnosis_ibfk_2`
    FOREIGN KEY (`diagnosis_id`)
    REFERENCES `al_shifa_clinic`.`diagnosis` (`diagnosis_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `al_shifa_clinic`.`treatmentmedicine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `al_shifa_clinic`.`treatmentmedicine` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `al_shifa_clinic`.`treatmentmedicine` (
  `treatment_id` BINARY(16) NOT NULL,
  `medicine_id` BINARY(16) NOT NULL,
  `quantity` INT NULL DEFAULT '1',
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`treatment_id`, `medicine_id`),
  INDEX `medicine_id` (`medicine_id` ASC) VISIBLE,
  CONSTRAINT `treatmentmedicine_ibfk_1`
    FOREIGN KEY (`treatment_id`)
    REFERENCES `al_shifa_clinic`.`treatment` (`treatment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `treatmentmedicine_ibfk_2`
    FOREIGN KEY (`medicine_id`)
    REFERENCES `al_shifa_clinic`.`medicine` (`medicine_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SHOW WARNINGS;

USE `al_shifa_clinic` ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
