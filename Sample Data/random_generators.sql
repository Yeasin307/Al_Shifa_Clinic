-- ----------------------------------------------
-- Create 120 random appointments (call procedure)
-- ----------------------------------------------
CALL create_random_appointments(120);

-- ----------------------------------------------
-- Create 60 random treatments (call procedure) (random appointments without treatment)
-- ----------------------------------------------
CALL create_random_treatments(60);

-- ----------------------------------------------
-- Create 60 random treatment diagnosis (call procedure)
-- ----------------------------------------------
CALL create_random_treatment_diagnosis(60);

-- ----------------------------------------------
-- Create 60 random treatment medicine (call procedure)
-- ----------------------------------------------
CALL create_random_treatment_medicine(60);

-- ----------------------------------------------
-- Generate bills for all treatments (call generate_bill procedure for each)
-- ----------------------------------------------

-- ➤ Generate bills for all treatments (insert only if not exists)
CALL generate_bills_for_all_treatments(FALSE);

-- ➤ Force regenerate (update existing bills with new fees)
CALL generate_bills_for_all_treatments(TRUE);
