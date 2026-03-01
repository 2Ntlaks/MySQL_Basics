# Exercise 06: Hospital / Clinic Database

## Scenario

A community clinic needs a database to manage patients, doctors, appointments, diagnoses, prescriptions, and billing. The clinic must track patient medical history, ensure appointments don't overlap, and keep accurate billing records.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. Composite key
2. `FOREIGN KEY ... REFERENCES`
3. `BETWEEN ... AND ...`
4. `CASE` expression
5. Normalization (3NF)

---

## Part B: Table Design (25 marks)

Design the following tables with columns, datatypes, and constraints:

1. **patient** — patient number, first name, last name, ID number, date of birth, gender, phone, email, blood type, allergies (text)
2. **doctor** — doctor number, first name, last name, specialization, phone, email, consultation fee
3. **appointment** — patient (FK), doctor (FK), appointment date, appointment time, status (scheduled/completed/cancelled), notes
4. **diagnosis** — appointment (FK), diagnosis code (e.g., ICD-10), description, severity (mild/moderate/severe)
5. **prescription** — diagnosis (FK), medication name, dosage, frequency, duration days, instructions
6. **billing** — appointment (FK), total amount, payment method (cash/card/medical aid), paid (boolean), payment date

### Questions

1. What is the relationship between `appointment` and `diagnosis`?
2. Why should `diagnosis` link to `appointment` rather than directly to `patient`?
3. What `CHECK` constraints are appropriate for `billing`?
4. How would you prevent double-booking a doctor at the same date and time?
5. Why store `consultation_fee` in `doctor` AND `total_amount` in `billing` separately?

---

## Part C: SQL Implementation (40 marks)

### C1. Create all tables

```sql
-- Write your CREATE TABLE statements here
```

### C2. Insert sample data

- At least 8 patients
- At least 4 doctors with different specializations
- At least 12 appointments (mix of statuses)
- At least 8 diagnoses
- At least 10 prescriptions
- At least 10 billing records (some paid, some unpaid)

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. List all appointments for today, sorted by time.
2. Show all appointments with patient name and doctor name (`JOIN`).
3. Find all unpaid bills (`paid = FALSE`).
4. Calculate total revenue per doctor.
5. Find the doctor with the most appointments.
6. Show patients who have more than 3 appointments (frequent visitors).
7. List all diagnoses marked as "severe".
8. Find all prescriptions for a specific patient (through appointment → diagnosis → prescription chain).
9. Calculate the average consultation fee per specialization.
10. Show all patients who have **never** visited (no appointments — use `LEFT JOIN`).
11. Count appointments per month for the current year (use `MONTH()`).
12. Show a billing summary: total billed, total paid, total outstanding.

### C4. Advanced: Multi-level JOIN

Write a single query that shows:

- Patient name
- Appointment date
- Doctor name
- Diagnosis description
- Medication prescribed

This requires joining 5 tables. Explain the join path.

### C5. Conditional logic

Write a query that categorises patients by visit frequency:

```sql
-- 0 visits: 'New'
-- 1-3 visits: 'Occasional'
-- 4+ visits: 'Regular'
-- Use CASE expression
```

---

## Part D: Transaction Exercise (15 marks)

Write a transaction for completing an appointment:

1. Update appointment status to `'completed'`.
2. Insert a diagnosis record.
3. Insert a prescription record.
4. Insert a billing record.
5. If any step fails, roll back everything.

```sql
-- Write your transaction here
```

Explain: Why is it dangerous to have a billing record without a diagnosis?

---

## Part E: Reflection (10 marks)

1. What is the difference between storing allergies as a `TEXT` column vs. a separate `allergy` table?
2. Why might you need date functions like `DATEDIFF` in a hospital database?
3. How would you extend this system to track medicine stock (pharmacy)?
4. What ethical considerations exist for medical databases that don't apply to shop databases?

---

## Marking Guide

| Criterion | Marks |
|---|---:|
| Term definitions | 10 |
| Table design quality | 25 |
| SQL correctness and completeness | 40 |
| Transaction logic | 15 |
| Reflection clarity | 10 |
| **Total** | **100** |

---

## Solutions

> [!WARNING]
> Try to complete the exercise on your own before looking at the solutions below.

<details>
<summary><strong>Part A: Terminology Solutions</strong></summary>

1. **Composite key**
   - Simple: A primary key made up of two or more columns together.
   - Technical: A key consisting of multiple attributes whose combination uniquely identifies each row; no single column in the composite is sufficient alone.

2. **FOREIGN KEY ... REFERENCES**
   - Simple: A rule that says a column's values must match values in another table's primary key.
   - Technical: A referential integrity constraint that links a column (or columns) to the primary key of a referenced table, preventing orphaned records.

3. **BETWEEN ... AND ...**
   - Simple: A shortcut for checking if a value falls within a range (inclusive on both ends).
   - Technical: A comparison operator equivalent to `value >= low AND value <= high`, applicable to numeric, date, and string types.

4. **CASE expression**
   - Simple: An IF-THEN-ELSE inside a SQL query that returns different values based on conditions.
   - Technical: A conditional expression that evaluates conditions sequentially and returns the result corresponding to the first true condition, or an ELSE default.

5. **Normalization (3NF)**
   - Simple: Organizing tables so each column depends only on the primary key, reducing duplicate data.
   - Technical: Third Normal Form requires that a relation is in 2NF and that every non-key attribute depends only on the primary key (no transitive dependencies).

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **appointment → diagnosis** = One-to-Many (one appointment can result in multiple diagnoses).
2. **Why diagnosis links to appointment, not patient:** A diagnosis is made at a specific point in time during a specific visit. Linking directly to patient would lose the context of when and by whom the diagnosis was made.
3. **CHECK constraints on billing:** `CHECK (total_amount >= 0)`, `CHECK (payment_method IN ('cash', 'card', 'medical aid'))`.
4. **Prevent double-booking:** Add a UNIQUE constraint on `(doctor_id, appointment_date, appointment_time)` so the same doctor can't have two appointments at the same date and time.
5. **Why both consultation_fee and total_amount:** The consultation fee is the base rate. The total_amount on a bill may include additional charges (lab tests, prescriptions, procedures). They serve different purposes.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;

CREATE TABLE patient (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  id_number VARCHAR(13) UNIQUE,
  date_of_birth DATE NOT NULL,
  gender CHAR(1) CHECK (gender IN ('M', 'F')),
  phone VARCHAR(20),
  email VARCHAR(120),
  blood_type VARCHAR(5),
  allergies TEXT
);

CREATE TABLE doctor (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  doctor_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  specialization VARCHAR(60) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(120) UNIQUE,
  consultation_fee DECIMAL(10,2) NOT NULL CHECK (consultation_fee >= 0)
);

CREATE TABLE appointment (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
  notes TEXT,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
  UNIQUE (doctor_id, appointment_date, appointment_time)
);

CREATE TABLE diagnosis (
  diagnosis_id INT PRIMARY KEY AUTO_INCREMENT,
  appointment_id INT NOT NULL,
  diagnosis_code VARCHAR(20),
  description VARCHAR(200) NOT NULL,
  severity VARCHAR(20) CHECK (severity IN ('mild', 'moderate', 'severe')),
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
);

CREATE TABLE prescription (
  prescription_id INT PRIMARY KEY AUTO_INCREMENT,
  diagnosis_id INT NOT NULL,
  medication_name VARCHAR(100) NOT NULL,
  dosage VARCHAR(50) NOT NULL,
  frequency VARCHAR(50) NOT NULL,
  duration_days INT,
  instructions TEXT,
  FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id)
);

CREATE TABLE billing (
  billing_id INT PRIMARY KEY AUTO_INCREMENT,
  appointment_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
  payment_method VARCHAR(20) CHECK (payment_method IN ('cash', 'card', 'medical aid')),
  paid BOOLEAN DEFAULT FALSE,
  payment_date DATE,
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO patient (patient_number, first_name, last_name, id_number, date_of_birth, gender, phone, blood_type, allergies) VALUES
  ('P001', 'Amahle', 'Mokoena', '9001015800081', '1990-01-01', 'F', '0712345678', 'A+', NULL),
  ('P002', 'Lebo', 'Ncube', '8805125800082', '1988-05-12', 'M', '0723456789', 'O+', 'Penicillin'),
  ('P003', 'Sipho', 'Dlamini', '7503085800083', '1975-03-08', 'M', '0734567890', 'B-', NULL),
  ('P004', 'Thandi', 'Nkosi', '9512205800084', '1995-12-20', 'F', '0745678901', 'AB+', 'Aspirin'),
  ('P005', 'Kagiso', 'Molefe', '0003145800085', '2000-03-14', 'M', '0756789012', 'O-', NULL),
  ('P006', 'Zanele', 'Mahlangu', '8511225800086', '1985-11-22', 'F', '0767890123', 'A+', NULL),
  ('P007', 'Bongani', 'Sithole', '9208115800087', '1992-08-11', 'M', '0778901234', 'B+', 'Sulfa drugs'),
  ('P008', 'Naledi', 'Van Wyk', '0510015800088', '2005-10-01', 'F', '0789012345', 'O+', NULL);

INSERT INTO doctor (doctor_number, first_name, last_name, specialization, phone, email, consultation_fee) VALUES
  ('D001', 'Dr. James', 'Khumalo', 'General Practice', '0811111111', 'khumalo@clinic.co.za', 550.00),
  ('D002', 'Dr. Sarah', 'Pillay', 'Pediatrics', '0822222222', 'pillay@clinic.co.za', 650.00),
  ('D003', 'Dr. Mark', 'Botha', 'Cardiology', '0833333333', 'botha@clinic.co.za', 900.00),
  ('D004', 'Dr. Fatima', 'Ahmed', 'Dermatology', '0844444444', 'ahmed@clinic.co.za', 700.00);

INSERT INTO appointment (patient_id, doctor_id, appointment_date, appointment_time, status, notes) VALUES
  (1, 1, '2026-02-01', '09:00', 'completed', 'Routine checkup'),
  (2, 1, '2026-02-01', '10:00', 'completed', 'Flu symptoms'),
  (3, 3, '2026-02-03', '11:00', 'completed', 'Chest pain'),
  (4, 2, '2026-02-05', '09:30', 'completed', 'Skin rash on arm'),
  (1, 1, '2026-02-10', '09:00', 'completed', 'Follow-up'),
  (5, 1, '2026-02-12', '14:00', 'completed', 'Headaches'),
  (6, 4, '2026-02-15', '10:00', 'completed', 'Acne treatment'),
  (2, 3, '2026-02-18', '11:30', 'completed', 'Blood pressure check'),
  (7, 1, '2026-02-20', '09:00', 'cancelled', 'Patient no-show'),
  (1, 1, '2026-03-01', '09:00', 'scheduled', 'Annual checkup'),
  (3, 3, '2026-03-05', '11:00', 'scheduled', 'Follow-up ECG'),
  (8, 2, '2026-03-10', '10:00', 'scheduled', 'Vaccination');

INSERT INTO diagnosis (appointment_id, diagnosis_code, description, severity) VALUES
  (1, 'Z00.0', 'General examination', 'mild'),
  (2, 'J06.9', 'Upper respiratory infection', 'moderate'),
  (3, 'R07.9', 'Chest pain, unspecified', 'severe'),
  (4, 'L30.9', 'Dermatitis, unspecified', 'mild'),
  (5, 'Z00.0', 'Follow-up examination', 'mild'),
  (6, 'R51', 'Headache', 'moderate'),
  (7, 'L70.0', 'Acne vulgaris', 'mild'),
  (8, 'I10', 'Essential hypertension', 'moderate');

INSERT INTO prescription (diagnosis_id, medication_name, dosage, frequency, duration_days, instructions) VALUES
  (2, 'Amoxicillin', '500mg', '3 times daily', 7, 'Take with food'),
  (2, 'Paracetamol', '500mg', 'Every 6 hours', 5, 'As needed for fever'),
  (3, 'Aspirin', '100mg', 'Once daily', 30, 'Take in morning'),
  (3, 'Atorvastatin', '20mg', 'Once daily', 90, 'Take at bedtime'),
  (4, 'Hydrocortisone cream', '1%', 'Twice daily', 14, 'Apply to affected area'),
  (6, 'Ibuprofen', '400mg', 'Twice daily', 7, 'Take after meals'),
  (7, 'Benzoyl peroxide', '5%', 'Once daily', 30, 'Apply to clean skin at night'),
  (8, 'Amlodipine', '5mg', 'Once daily', 90, 'Take in morning'),
  (8, 'Enalapril', '10mg', 'Once daily', 90, 'Monitor blood pressure'),
  (1, 'Vitamin D', '1000IU', 'Once daily', 60, 'Take with meal');

INSERT INTO billing (appointment_id, total_amount, payment_method, paid, payment_date) VALUES
  (1, 550.00, 'medical aid', TRUE, '2026-02-01'),
  (2, 750.00, 'cash', TRUE, '2026-02-01'),
  (3, 1500.00, 'medical aid', TRUE, '2026-02-03'),
  (4, 650.00, 'card', TRUE, '2026-02-05'),
  (5, 550.00, 'medical aid', TRUE, '2026-02-10'),
  (6, 550.00, 'cash', FALSE, NULL),
  (7, 700.00, 'card', TRUE, '2026-02-15'),
  (8, 900.00, 'medical aid', FALSE, NULL),
  (9, 0.00, 'cash', FALSE, NULL),
  (10, 550.00, 'medical aid', FALSE, NULL);
```

### C3. Queries

**1. All appointments for today, sorted by time:**

```sql
SELECT * FROM appointment
WHERE appointment_date = CURDATE()
ORDER BY appointment_time ASC;
```

**2. Appointments with patient and doctor names:**

```sql
SELECT
  a.appointment_id,
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  a.appointment_date,
  a.appointment_time,
  a.status
FROM appointment a
INNER JOIN patient p ON a.patient_id = p.patient_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id;
```

**3. All unpaid bills:**

```sql
SELECT
  b.billing_id,
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  b.total_amount,
  a.appointment_date
FROM billing b
INNER JOIN appointment a ON b.appointment_id = a.appointment_id
INNER JOIN patient p ON a.patient_id = p.patient_id
WHERE b.paid = FALSE;
```

**4. Total revenue per doctor:**

```sql
SELECT
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  SUM(b.total_amount) AS total_revenue
FROM billing b
INNER JOIN appointment a ON b.appointment_id = a.appointment_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
WHERE b.paid = TRUE
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY total_revenue DESC;
```

**5. Doctor with most appointments:**

```sql
SELECT
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  COUNT(*) AS appointment_count
FROM appointment a
INNER JOIN doctor d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY appointment_count DESC
LIMIT 1;
```

**6. Frequent visitors (more than 3 appointments):**

```sql
SELECT
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  COUNT(*) AS visit_count
FROM appointment a
INNER JOIN patient p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(*) > 3;
```

**7. Severe diagnoses:**

```sql
SELECT
  di.description,
  di.diagnosis_code,
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  a.appointment_date
FROM diagnosis di
INNER JOIN appointment a ON di.appointment_id = a.appointment_id
INNER JOIN patient p ON a.patient_id = p.patient_id
WHERE di.severity = 'severe';
```

**8. Prescriptions for a specific patient (full chain):**

```sql
SELECT
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  a.appointment_date,
  di.description AS diagnosis,
  pr.medication_name,
  pr.dosage,
  pr.frequency
FROM prescription pr
INNER JOIN diagnosis di ON pr.diagnosis_id = di.diagnosis_id
INNER JOIN appointment a ON di.appointment_id = a.appointment_id
INNER JOIN patient p ON a.patient_id = p.patient_id
WHERE p.patient_id = 2;
```

**9. Average consultation fee per specialization:**

```sql
SELECT
  specialization,
  ROUND(AVG(consultation_fee), 2) AS avg_fee
FROM doctor
GROUP BY specialization;
```

**10. Patients who have never visited:**

```sql
SELECT p.first_name, p.last_name
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;
```

**11. Appointments per month (current year):**

```sql
SELECT
  MONTH(appointment_date) AS month,
  COUNT(*) AS total_appointments
FROM appointment
WHERE YEAR(appointment_date) = 2026
GROUP BY MONTH(appointment_date)
ORDER BY month;
```

**12. Billing summary:**

```sql
SELECT
  SUM(total_amount) AS total_billed,
  SUM(CASE WHEN paid = TRUE THEN total_amount ELSE 0 END) AS total_paid,
  SUM(CASE WHEN paid = FALSE THEN total_amount ELSE 0 END) AS total_outstanding
FROM billing;
```

### C4. Multi-level JOIN (5 tables)

```sql
SELECT
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  a.appointment_date,
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  di.description AS diagnosis,
  pr.medication_name
FROM prescription pr
INNER JOIN diagnosis di ON pr.diagnosis_id = di.diagnosis_id
INNER JOIN appointment a ON di.appointment_id = a.appointment_id
INNER JOIN patient p ON a.patient_id = p.patient_id
INNER JOIN doctor d ON a.doctor_id = d.doctor_id;
```

> **Join path:** prescription → diagnosis → appointment → patient AND appointment → doctor. The appointment table is the central link connecting everything.

### C5. Conditional logic (CASE)

```sql
SELECT
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  COUNT(a.appointment_id) AS visit_count,
  CASE
    WHEN COUNT(a.appointment_id) = 0 THEN 'New'
    WHEN COUNT(a.appointment_id) BETWEEN 1 AND 3 THEN 'Occasional'
    ELSE 'Regular'
  END AS patient_category
FROM patient p
LEFT JOIN appointment a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY visit_count DESC;
```

</details>

<details>
<summary><strong>Part D: Transaction Solution</strong></summary>

```sql
START TRANSACTION;

-- Step 1: Update appointment status
UPDATE appointment
SET status = 'completed'
WHERE appointment_id = 6;

-- Step 2: Insert diagnosis
INSERT INTO diagnosis (appointment_id, diagnosis_code, description, severity)
VALUES (6, 'R51', 'Headache', 'moderate');

SET @diag_id = LAST_INSERT_ID();

-- Step 3: Insert prescription
INSERT INTO prescription (diagnosis_id, medication_name, dosage, frequency, duration_days, instructions)
VALUES (@diag_id, 'Ibuprofen', '400mg', 'Twice daily', 7, 'Take after meals');

-- Step 4: Insert billing
INSERT INTO billing (appointment_id, total_amount, payment_method, paid)
VALUES (6, 550.00, 'cash', FALSE);

-- If any error occurred, ROLLBACK; otherwise:
COMMIT;
```

**Why is a billing record without a diagnosis dangerous?** It means the patient was charged for something undocumented. There's no medical justification for the bill, which is a compliance/audit risk. The transaction ensures that if the diagnosis fails to insert, no billing record is created either.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **TEXT column vs separate allergy table:** TEXT is simpler but makes searching/filtering allergies hard (you'd need LIKE). A separate `patient_allergy` table (patient_id, allergy_name) is better for querying (e.g., "find all patients allergic to Penicillin") and enforcing standardized allergy names.

2. **Why DATEDIFF is useful:** To calculate patient age, days since last visit, prescription duration tracking, overdue appointment follow-ups, and billing payment aging.

3. **Pharmacy extension:** Add `medicine` table (medicine_id, name, stock, unit_price) and link `prescription` to it. Add stock tracking similar to the retail shop exercise — decrease stock when a prescription is dispensed.

4. **Medical ethics:** Patient data is protected by law (NHA in SA, HIPAA in US). Access must be role-based (receptionist vs doctor). Audit logs must track who viewed/modified records. Data breaches can cause discrimination, insurance denial, or social harm. Retail databases don't carry the same personal health risks.

</details>
