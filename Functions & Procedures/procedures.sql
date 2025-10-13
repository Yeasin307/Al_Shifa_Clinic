-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- procedure create_random_appointments
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`create_random_appointments`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_random_appointments`(IN p_count INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE v_pid BINARY(16);
    DECLARE v_did BINARY(16);
    DECLARE v_appt_dt DATETIME;
    DECLARE v_status VARCHAR(20);

    WHILE i < p_count DO
        -- pick random patient and doctor
        SELECT patient_id INTO v_pid FROM Patient ORDER BY RAND() LIMIT 1;
        SELECT doctor_id INTO v_did FROM Doctor ORDER BY RAND() LIMIT 1;

        -- random date between 2024-01-01 and 2025-10-01
        SET v_appt_dt = ADDDATE('2024-01-01', INTERVAL FLOOR(RAND() * 640) DAY);
        -- add random time
        SET v_appt_dt = ADDTIME(v_appt_dt, SEC_TO_TIME(FLOOR(RAND() * 28800))); -- up to 8 hours in seconds

        -- status random
        IF RAND() < 0.7 THEN
            SET v_status = 'Completed';
        ELSEIF RAND() < 0.85 THEN
            SET v_status = 'Scheduled';
        ELSE
            SET v_status = 'Cancelled';
        END IF;

        INSERT INTO Appointment (
            appointment_id, patient_id, doctor_id, appointment_date, status, create_time, update_time
        ) VALUES (
            gen_uuid(), v_pid, v_did, v_appt_dt, v_status, NOW(), NOW()
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure create_random_treatment_diagnosis
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`create_random_treatment_diagnosis`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_random_treatment_diagnosis`(IN p_count INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE v_tid BINARY(16);
    DECLARE v_did BINARY(16);

    WHILE i < p_count DO
        SELECT treatment_id INTO v_tid FROM Treatment ORDER BY RAND() LIMIT 1;
        SELECT diagnosis_id INTO v_did FROM Diagnosis ORDER BY RAND() LIMIT 1;

        -- avoid duplicate pair
        IF NOT EXISTS (SELECT 1 FROM TreatmentDiagnosis WHERE treatment_id = v_tid AND diagnosis_id = v_did) THEN
            INSERT INTO TreatmentDiagnosis (
                treatment_id, diagnosis_id, create_time, update_time
            ) VALUES (
                v_tid, v_did, NOW(), NOW()
            );
            SET i = i + 1;
        END IF;
    END WHILE;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure create_random_treatment_medicine
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`create_random_treatment_medicine`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_random_treatment_medicine`(IN p_count INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE v_tid BINARY(16);
    DECLARE v_mid BINARY(16);
    DECLARE v_qty INT;

    WHILE i < p_count DO
        SELECT treatment_id INTO v_tid FROM Treatment ORDER BY RAND() LIMIT 1;
        SELECT medicine_id INTO v_mid FROM Medicine ORDER BY RAND() LIMIT 1;
        SET v_qty = FLOOR(1 + RAND() * 10);

        IF NOT EXISTS (SELECT 1 FROM TreatmentMedicine WHERE treatment_id = v_tid AND medicine_id = v_mid) THEN
            INSERT INTO TreatmentMedicine (
                treatment_id, medicine_id, quantity, create_time, update_time
            ) VALUES (
                v_tid, v_mid, v_qty, NOW(), NOW()
            );
            SET i = i + 1;
        END IF;
    END WHILE;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure create_random_treatments
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`create_random_treatments`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_random_treatments`(IN p_count INT)
BEGIN
	DECLARE i INT DEFAULT 0;
    DECLARE v_appt_id BINARY(16);
    DECLARE v_summary TEXT;
    DECLARE v_tdate DATETIME;
    DECLARE done INT DEFAULT 0;

    treatment_loop: WHILE i < p_count DO
        -- Random appointment without a treatment
        SELECT appointment_id INTO v_appt_id
        FROM Appointment a
        WHERE NOT EXISTS (
            SELECT 1 FROM Treatment t WHERE t.appointment_id = a.appointment_id
        )
        ORDER BY RAND()
        LIMIT 1;

        IF v_appt_id IS NULL THEN
            SET done = 1;
        END IF;

        IF done = 1 THEN
            LEAVE treatment_loop;
        END IF;

        -- Random date within ~2 years from 2024-01-01
        SET v_tdate = ADDDATE('2024-01-01', INTERVAL FLOOR(RAND() * 640) DAY);

        -- Randomized diagnosis summary
        SET v_summary = CONCAT(
            'Clinical visit for ',
            ELT(
                FLOOR(RAND()*15)+1,
                'fever and cough',
                'chest pain',
                'dizziness',
                'ear pain',
                'joint pain',
                'hypertension follow-up',
                'diabetes check-up',
                'abdominal pain',
                'skin rash',
                'allergic rhinitis',
                'migraine',
                'back pain',
                'asthma exacerbation',
                'sore throat',
                'urinary tract infection'
            )
        );

        -- Insert new treatment
        INSERT INTO Treatment (
            treatment_id, appointment_id, diagnosis_summary, treatment_date, create_time, update_time
        ) VALUES (
            gen_uuid(), v_appt_id, v_summary, v_tdate, NOW(), NOW()
        );

        SET i = i + 1;
    END WHILE treatment_loop;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure generate_bill
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`generate_bill`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_bill`(
    IN p_treatment_id BINARY(16),
    IN p_force_update BOOLEAN -- TRUE = Update if exists, FALSE = Skip update
)
BEGIN
	DECLARE v_doctor_fee DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_diagnosis_fee DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_medicine_fee DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_total_fee DECIMAL(10,2) DEFAULT 0.00;

    -- Fetch doctor's consultation fee (via Treatment -> Appointment -> Doctor)
    SELECT IFNULL(d.consultation_fee, 0.00)
    INTO v_doctor_fee
    FROM Treatment t
    JOIN Appointment a ON t.appointment_id = a.appointment_id
    JOIN Doctor d ON a.doctor_id = d.doctor_id
    WHERE t.treatment_id = p_treatment_id
    LIMIT 1;

    -- Calculate total diagnosis fee
    SELECT IFNULL(SUM(di.diagnosis_fee), 0.00)
    INTO v_diagnosis_fee
    FROM TreatmentDiagnosis td
    JOIN Diagnosis di ON td.diagnosis_id = di.diagnosis_id
    WHERE td.treatment_id = p_treatment_id;

    -- Calculate total medicine cost
    SELECT IFNULL(SUM(m.unit_price * tm.quantity), 0.00)
    INTO v_medicine_fee
    FROM TreatmentMedicine tm
    JOIN Medicine m ON tm.medicine_id = m.medicine_id
    WHERE tm.treatment_id = p_treatment_id;

    -- Compute total
    SET v_total_fee = v_doctor_fee + v_diagnosis_fee + v_medicine_fee;

    -- Insert new bill or update existing one conditionally
    IF EXISTS (SELECT 1 FROM Bill WHERE treatment_id = p_treatment_id) THEN
        IF p_force_update THEN
            -- Update existing bill
            UPDATE Bill
            SET 
                doctor_fee = v_doctor_fee,
                diagnosis_fee = v_diagnosis_fee,
                medicine_fee = v_medicine_fee,
                total_fee = v_total_fee,
                update_time = NOW()
            WHERE treatment_id = p_treatment_id;
        END IF;
    ELSE
        -- Insert new bill
        INSERT INTO Bill (
            bill_id, treatment_id, doctor_fee, diagnosis_fee, medicine_fee, total_fee, billing_date, create_time, update_time
        ) VALUES (
            gen_uuid(), p_treatment_id, v_doctor_fee, v_diagnosis_fee, v_medicine_fee, v_total_fee, NOW(), NOW(), NOW()
        );
    END IF;
END$$

DELIMITER ;
SHOW WARNINGS;

-- -----------------------------------------------------
-- procedure generate_bills_for_all_treatments
-- -----------------------------------------------------

USE `al_shifa_clinic`;
DROP procedure IF EXISTS `al_shifa_clinic`.`generate_bills_for_all_treatments`;
SHOW WARNINGS;

DELIMITER $$
USE `al_shifa_clinic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_bills_for_all_treatments`(IN p_force_update BOOLEAN)
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE v_treatment_id BINARY(16);
    DECLARE cur CURSOR FOR SELECT treatment_id FROM Treatment;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_treatment_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- call generate_bill for each treatment
        CALL generate_bill(v_treatment_id, p_force_update);
    END LOOP;
    CLOSE cur;
END$$

DELIMITER ;
SHOW WARNINGS;