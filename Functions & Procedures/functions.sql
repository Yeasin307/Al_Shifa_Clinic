-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- function gen_uuid
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP function IF EXISTS `al_shifa_clinic`.`gen_uuid`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `gen_uuid`() RETURNS binary(16)
    NO SQL
    SQL SECURITY INVOKER
BEGIN
	RETURN UUID_TO_BIN(UUID(), 1);
END$$

DELIMITER ;
SHOW WARNINGS;
