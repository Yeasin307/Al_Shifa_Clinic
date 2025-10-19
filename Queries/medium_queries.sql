-- --------------------------------------------------
-- 1. Count the number of doctors in each department
-- --------------------------------------------------

SELECT dep.department_name, COUNT(d.doctor_id) AS total_doctors
FROM Department dep
LEFT JOIN Doctor d ON dep.department_id = d.department_id
GROUP BY dep.department_name
ORDER BY total_doctors DESC;

-- --------------------------------------------------
-- 2. Find the most common diagnosis given in the last 1 year
-- --------------------------------------------------

SELECT di.diagnosis_name, COUNT(*) AS times_used
FROM TreatmentDiagnosis td
JOIN Diagnosis di ON td.diagnosis_id = di.diagnosis_id
JOIN Treatment t ON td.treatment_id = t.treatment_id
WHERE t.treatment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY di.diagnosis_id
ORDER BY times_used DESC
LIMIT 1;

-- --------------------------------------------------
-- 3. List of the top ten most frequently prescribed medicines
-- --------------------------------------------------

SELECT m.medicine_name, COUNT(tm.treatment_id) AS times_prescribed
FROM Medicine m
JOIN TreatmentMedicine tm ON m.medicine_id = tm.medicine_id
GROUP BY m.medicine_name
ORDER BY times_prescribed DESC
LIMIT 10;

-- --------------------------------------------------
-- 4. List patients who have had more than 2 treatments
-- --------------------------------------------------

SELECT p.patient_name, COUNT(t.treatment_id) AS total_treatments
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
JOIN Treatment t ON a.appointment_id = t.appointment_id
GROUP BY p.patient_id
HAVING total_treatments > 2
ORDER BY total_treatments DESC;

-- --------------------------------------------------
-- 5. Get all medicines prescribed in "chest pain" treatments
-- --------------------------------------------------

SELECT DISTINCT m.medicine_name, m.unit_price
FROM Medicine m
JOIN TreatmentMedicine tm ON m.medicine_id = tm.medicine_id
JOIN Treatment t ON tm.treatment_id = t.treatment_id
WHERE t.diagnosis_summary LIKE '%chest pain%';

-- --------------------------------------------------
-- 6. Find the doctors who have more than 5 appointments in 2025
-- --------------------------------------------------

SELECT d.doctor_name, COUNT(a.appointment_id) AS total_appointments
FROM Doctor d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
WHERE YEAR(a.appointment_date) = 2025
GROUP BY d.doctor_name
HAVING COUNT(a.appointment_id) > 5
ORDER BY total_appointments DESC;
