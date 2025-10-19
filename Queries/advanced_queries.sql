-- --------------------------------------------------
-- 1. Find the top 5 patients who spent the most
-- --------------------------------------------------

SELECT p.patient_name,
       ROUND(SUM(b.total_fee), 2) AS total_spent
FROM Bill b
JOIN Treatment t ON b.treatment_id = t.treatment_id
JOIN Appointment a ON t.appointment_id = a.appointment_id
JOIN Patient p ON a.patient_id = p.patient_id
GROUP BY p.patient_id
ORDER BY total_spent DESC
LIMIT 5;

-- --------------------------------------------------
-- 2. Find patients who spent more than the average total spending
-- --------------------------------------------------

SELECT p.patient_name, ROUND(SUM(b.total_fee), 2) AS total_spent
FROM Patient p
JOIN Appointment a ON p.patient_id = a.patient_id
JOIN Treatment t ON a.appointment_id = t.appointment_id
JOIN Bill b ON t.treatment_id = b.treatment_id
GROUP BY p.patient_id
HAVING total_spent > (
    SELECT AVG(total_fee_sum)
    FROM (
        SELECT SUM(b2.total_fee) AS total_fee_sum
        FROM Patient p2
        JOIN Appointment a2 ON p2.patient_id = a2.patient_id
        JOIN Treatment t2 ON a2.appointment_id = t2.appointment_id
        JOIN Bill b2 ON t2.treatment_id = b2.treatment_id
        GROUP BY p2.patient_id
    ) AS avg_spending
)
ORDER BY total_spent DESC;

-- --------------------------------------------------
-- 3. Get average treatment cost per department
-- --------------------------------------------------

SELECT dep.department_name,
       FLOOR(AVG(b.total_fee)) AS avg_treatment_cost
FROM Bill b
JOIN Treatment t ON b.treatment_id = t.treatment_id
JOIN Appointment a ON t.appointment_id = a.appointment_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Department dep ON d.department_id = dep.department_id
GROUP BY dep.department_name
ORDER BY avg_treatment_cost DESC;

-- --------------------------------------------------
-- 4. Find the doctors who prescribed the most expensive medicine
-- --------------------------------------------------

SELECT d.doctor_name, m.medicine_name, m.unit_price
FROM Doctor d
JOIN Appointment a ON d.doctor_id = a.doctor_id
JOIN Treatment t ON a.appointment_id = t.appointment_id
JOIN TreatmentMedicine tm ON t.treatment_id = tm.treatment_id
JOIN Medicine m ON tm.medicine_id = m.medicine_id
WHERE m.unit_price = (
    SELECT MAX(m2.unit_price)
    FROM Medicine m2
    JOIN TreatmentMedicine tm2 ON m2.medicine_id = tm2.medicine_id
)
ORDER BY m.unit_price DESC;

-- --------------------------------------------------
-- 5. Find the top 3 doctors in each department by total earnings
-- --------------------------------------------------

WITH doctor_income AS (
    SELECT d.doctor_id, d.doctor_name, dep.department_name,
           (COUNT(d.doctor_id) * d.consultation_fee) AS total_fee,
           RANK() OVER (PARTITION BY dep.department_id ORDER BY (COUNT(d.doctor_id) * d.consultation_fee) DESC) AS rnk
    FROM Doctor d
    JOIN Department dep ON d.department_id = dep.department_id
    JOIN Appointment a ON d.doctor_id = a.doctor_id
    JOIN Treatment t ON a.appointment_id = t.appointment_id
    GROUP BY d.doctor_id, dep.department_id
)
SELECT department_name, doctor_name, total_fee
FROM doctor_income
WHERE rnk <= 3
ORDER BY department_name, total_fee DESC;
