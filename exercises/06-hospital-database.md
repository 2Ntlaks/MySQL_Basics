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
