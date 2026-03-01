# Exercise 03: School Database

## Scenario

A high school needs a database to manage students, teachers, subjects, classes, and grades. The principal wants to track which teachers teach which subjects, which students are in which classes, and how students perform in each subject.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. Primary Key
2. Many-to-Many relationship
3. Junction table
4. `CHECK` constraint
5. `GROUP BY`

---

## Part B: Table Design (25 marks)

Design the following tables with columns, datatypes, and constraints:

1. **student** — student number, first name, last name, date of birth, grade level (8–12), gender
2. **teacher** — employee number, first name, last name, email, hire date
3. **subject** — subject code, subject name, grade level
4. **class** — class ID, subject (FK), teacher (FK), year, term (1–4)
5. **student_class** — junction table linking students to classes
6. **grade** — student (FK), class (FK), assessment type (test/exam/assignment), mark (0–100), date

### Questions

1. Which tables have a Many-to-Many relationship?
2. Why does `grade` reference both `student` and `class`?
3. What `CHECK` constraints would be useful on the `grade` table?
4. Why should `student_number` and `employee_number` be `UNIQUE`?

---

## Part C: SQL Implementation (40 marks)

### C1. Create all tables

```sql
-- Write your CREATE TABLE statements here
```

### C2. Insert sample data

- At least 6 students across different grade levels
- At least 3 teachers
- At least 4 subjects
- At least 5 classes
- At least 10 student-class enrollments
- At least 15 grades

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. List all students in Grade 10, sorted by last name.
2. Find all subjects taught by a specific teacher.
3. Show each student's name with their class and subject name (multi-table `JOIN`).
4. Calculate the average mark per subject.
5. Find the top 3 students by overall average mark.
6. Count how many students are in each grade level.
7. Find students who scored below 40 in any assessment (at-risk students).
8. Show teachers who teach more than 2 classes.
9. Find subjects where the class average is above 70.
10. List all students who are NOT enrolled in any class (use `LEFT JOIN`).

### C4. Update and Delete

1. A student transfers out — delete their record and all related data. What order must you delete in? Why?
2. A teacher's email changes — write an `UPDATE` statement.
3. All Grade 12 test marks need a 5-point adjustment — write an `UPDATE` with `WHERE`.

---

## Part D: Normalization Check (15 marks)

Consider this unnormalized table:

| student_number | student_name | subject1 | mark1 | subject2 | mark2 | teacher_name |
|---|---|---|---:|---|---:|---|
| S001 | Thabo | Maths | 72 | English | 65 | Mr. Moyo |

1. Which normal form does this violate? Why?
2. Redesign it into 3NF. Show your resulting tables.
3. Why is the normalized version better for a school with 500 students and 8 subjects?

---

## Part E: Reflection (10 marks)

1. Why is `term` useful as a column instead of creating separate tables per term?
2. What problems arise if you store marks as `VARCHAR` instead of `INT`?
3. How would you extend this database to track attendance?

---

## Marking Guide

| Criterion | Marks |
|---|---:|
| Term definitions | 10 |
| Table design quality | 25 |
| SQL correctness and completeness | 40 |
| Normalization analysis | 15 |
| Reflection clarity | 10 |
| **Total** | **100** |
