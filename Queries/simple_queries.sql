-- --------------------------------------------------
-- 1. Display all medicines that cost more than 500
-- --------------------------------------------------

SELECT medicine_name, unit_price
FROM Medicine
WHERE unit_price > 500
ORDER BY unit_price DESC;

-- --------------------------------------------------
-- 2. Show all doctors in the "Cardiology" department
-- --------------------------------------------------

SELECT d.doctor_name, dep.department_name, d.phone, d.email
FROM Doctor d
JOIN Department dep ON d.department_id = dep.department_id
WHERE dep.department_name = 'Cardiology';

-- --------------------------------------------------
-- 3. Find all appointments scheduled at '2025-01-01' with the patient's name
-- --------------------------------------------------

SELECT p.patient_name, a.appointment_date
FROM patient p
JOIN Appointment a
WHERE a.patient_id = p.patient_id AND DATE(a.appointment_date) = '2025-01-01'
ORDER BY appointment_date;

-- --------------------------------------------------
-- 4. Display all doctors who charge less than 500
-- --------------------------------------------------

SELECT doctor_name, consultation_fee
FROM Doctor
WHERE consultation_fee < 500
ORDER BY consultation_fee;

-- --------------------------------------------------
-- 5. Show all appointments for a specific doctor
-- --------------------------------------------------

SELECT a.appointment_date, p.patient_name
FROM Appointment a
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Patient p ON a.patient_id = p.patient_id
WHERE d.doctor_name = 'Dr. Farhana Rahman'
ORDER BY a.appointment_date;
