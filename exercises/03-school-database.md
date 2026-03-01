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

---

## Solutions

> [!WARNING]
> Try to complete the exercise on your own before looking at the solutions below.

<details>
<summary><strong>Part A: Terminology Solutions</strong></summary>

1. **Primary Key**
   - Simple: A primary key is a column that uniquely identifies each row in a table.
   - Technical: A NOT NULL, UNIQUE constraint that serves as the unique row identifier for a relation.

2. **Many-to-Many relationship**
   - Simple: Records in table A can relate to many records in table B, and vice versa.
   - Technical: A cardinality where multiple instances of entity A associate with multiple instances of entity B, resolved via a junction table.

3. **Junction table**
   - Simple: A middle table that connects two tables that have a many-to-many relationship.
   - Technical: An associative entity that holds foreign keys referencing both parent tables, decomposing an M:N relationship into two 1:N relationships.

4. **CHECK constraint**
   - Simple: A rule that checks whether a value meets a condition before allowing it into the database.
   - Technical: A declarative constraint that evaluates a Boolean expression on column values; rows that fail the check are rejected.

5. **GROUP BY**
   - Simple: Groups rows that share the same value in a column so you can count or sum them.
   - Technical: A clause that partitions rows into groups based on column values, allowing aggregate functions to operate on each group independently.

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **Many-to-Many:** `student` ↔ `class` (through `student_class`) and `student` ↔ `subject` (through class and enrollment).
2. **Why `grade` references both:** A grade is earned by a specific student in a specific class. Both FKs together identify whose grade it is and for which class.
3. **CHECK constraints on grade:** `CHECK (mark >= 0 AND mark <= 100)`, `CHECK (assessment_type IN ('test', 'exam', 'assignment'))`, `CHECK (term BETWEEN 1 AND 4)` on class table.
4. **UNIQUE on student_number/employee_number:** These are real-world identifiers that must not be duplicated — two students cannot share the same student number.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS school_db;
USE school_db;

CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  grade_level INT NOT NULL CHECK (grade_level BETWEEN 8 AND 12),
  gender CHAR(1) CHECK (gender IN ('M', 'F'))
);

CREATE TABLE teacher (
  teacher_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(120) UNIQUE,
  hire_date DATE NOT NULL
);

CREATE TABLE subject (
  subject_id INT PRIMARY KEY AUTO_INCREMENT,
  subject_code VARCHAR(20) UNIQUE NOT NULL,
  subject_name VARCHAR(80) NOT NULL,
  grade_level INT NOT NULL CHECK (grade_level BETWEEN 8 AND 12)
);

CREATE TABLE class (
  class_id INT PRIMARY KEY AUTO_INCREMENT,
  subject_id INT NOT NULL,
  teacher_id INT NOT NULL,
  year INT NOT NULL,
  term INT NOT NULL CHECK (term BETWEEN 1 AND 4),
  FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
  FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

CREATE TABLE student_class (
  student_class_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  class_id INT NOT NULL,
  FOREIGN KEY (student_id) REFERENCES student(student_id),
  FOREIGN KEY (class_id) REFERENCES class(class_id)
);

CREATE TABLE grade (
  grade_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  class_id INT NOT NULL,
  assessment_type VARCHAR(20) NOT NULL CHECK (assessment_type IN ('test', 'exam', 'assignment')),
  mark INT NOT NULL CHECK (mark >= 0 AND mark <= 100),
  grade_date DATE NOT NULL,
  FOREIGN KEY (student_id) REFERENCES student(student_id),
  FOREIGN KEY (class_id) REFERENCES class(class_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO student (student_number, first_name, last_name, date_of_birth, grade_level, gender) VALUES
  ('S2026001', 'Amahle', 'Mokoena', '2010-03-14', 10, 'F'),
  ('S2026002', 'Lebo', 'Ncube', '2010-11-02', 10, 'M'),
  ('S2026003', 'Sipho', 'Dlamini', '2009-07-22', 11, 'M'),
  ('S2026004', 'Thandi', 'Nkosi', '2011-01-15', 9, 'F'),
  ('S2026005', 'Kagiso', 'Molefe', '2008-05-30', 12, 'M'),
  ('S2026006', 'Zanele', 'Mahlangu', '2009-09-10', 11, 'F');

INSERT INTO teacher (employee_number, first_name, last_name, email, hire_date) VALUES
  ('T001', 'Mr.', 'Moyo', 'moyo@school.ac.za', '2018-01-15'),
  ('T002', 'Ms.', 'Van Wyk', 'vanwyk@school.ac.za', '2020-06-01'),
  ('T003', 'Dr.', 'Pillay', 'pillay@school.ac.za', '2015-03-10');

INSERT INTO subject (subject_code, subject_name, grade_level) VALUES
  ('MATH10', 'Mathematics', 10),
  ('ENG10', 'English', 10),
  ('SCI11', 'Physical Science', 11),
  ('MATH12', 'Mathematics', 12);

INSERT INTO class (subject_id, teacher_id, year, term) VALUES
  (1, 1, 2026, 1),
  (2, 2, 2026, 1),
  (3, 3, 2026, 1),
  (4, 1, 2026, 1),
  (1, 1, 2026, 2);

INSERT INTO student_class (student_id, class_id) VALUES
  (1, 1), (1, 2),
  (2, 1), (2, 2),
  (3, 3),
  (4, 1),
  (5, 4),
  (6, 3),
  (3, 5), (6, 5);

INSERT INTO grade (student_id, class_id, assessment_type, mark, grade_date) VALUES
  (1, 1, 'test', 78, '2026-02-10'),
  (1, 1, 'assignment', 85, '2026-02-15'),
  (1, 2, 'test', 65, '2026-02-12'),
  (2, 1, 'test', 55, '2026-02-10'),
  (2, 1, 'assignment', 60, '2026-02-15'),
  (2, 2, 'test', 72, '2026-02-12'),
  (3, 3, 'test', 88, '2026-02-14'),
  (3, 3, 'exam', 92, '2026-02-28'),
  (4, 1, 'test', 35, '2026-02-10'),
  (5, 4, 'test', 90, '2026-02-11'),
  (5, 4, 'exam', 87, '2026-02-28'),
  (6, 3, 'test', 45, '2026-02-14'),
  (6, 3, 'assignment', 52, '2026-02-20'),
  (1, 1, 'exam', 74, '2026-02-28'),
  (2, 2, 'exam', 68, '2026-02-28');
```

### C3. Queries

**1. All students in Grade 10, sorted by last name:**

```sql
SELECT * FROM student
WHERE grade_level = 10
ORDER BY last_name ASC;
```

**2. Subjects taught by a specific teacher (e.g., teacher_id = 1):**

```sql
SELECT DISTINCT s.subject_code, s.subject_name
FROM class c
INNER JOIN subject s ON c.subject_id = s.subject_id
WHERE c.teacher_id = 1;
```

**3. Student name with class and subject name:**

```sql
SELECT
  st.first_name,
  st.last_name,
  sub.subject_name,
  c.year,
  c.term
FROM student_class sc
INNER JOIN student st ON sc.student_id = st.student_id
INNER JOIN class c ON sc.class_id = c.class_id
INNER JOIN subject sub ON c.subject_id = sub.subject_id;
```

**4. Average mark per subject:**

```sql
SELECT
  sub.subject_name,
  ROUND(AVG(g.mark), 1) AS avg_mark
FROM grade g
INNER JOIN class c ON g.class_id = c.class_id
INNER JOIN subject sub ON c.subject_id = sub.subject_id
GROUP BY sub.subject_id, sub.subject_name;
```

**5. Top 3 students by overall average mark:**

```sql
SELECT
  st.first_name,
  st.last_name,
  ROUND(AVG(g.mark), 1) AS overall_avg
FROM grade g
INNER JOIN student st ON g.student_id = st.student_id
GROUP BY st.student_id, st.first_name, st.last_name
ORDER BY overall_avg DESC
LIMIT 3;
```

**6. Student count per grade level:**

```sql
SELECT grade_level, COUNT(*) AS student_count
FROM student
GROUP BY grade_level
ORDER BY grade_level;
```

**7. At-risk students (scored below 40):**

```sql
SELECT DISTINCT
  st.first_name,
  st.last_name,
  g.mark,
  sub.subject_name
FROM grade g
INNER JOIN student st ON g.student_id = st.student_id
INNER JOIN class c ON g.class_id = c.class_id
INNER JOIN subject sub ON c.subject_id = sub.subject_id
WHERE g.mark < 40;
```

**8. Teachers with more than 2 classes:**

```sql
SELECT
  t.first_name,
  t.last_name,
  COUNT(*) AS class_count
FROM class c
INNER JOIN teacher t ON c.teacher_id = t.teacher_id
GROUP BY t.teacher_id, t.first_name, t.last_name
HAVING COUNT(*) > 2;
```

**9. Subjects where class average is above 70:**

```sql
SELECT
  sub.subject_name,
  ROUND(AVG(g.mark), 1) AS class_avg
FROM grade g
INNER JOIN class c ON g.class_id = c.class_id
INNER JOIN subject sub ON c.subject_id = sub.subject_id
GROUP BY sub.subject_id, sub.subject_name
HAVING AVG(g.mark) > 70;
```

**10. Students NOT enrolled in any class:**

```sql
SELECT st.first_name, st.last_name
FROM student st
LEFT JOIN student_class sc ON st.student_id = sc.student_id
WHERE sc.student_class_id IS NULL;
```

### C4. Update and Delete

**1. Delete a student (order matters due to foreign keys):**

```sql
-- Delete grades first (references student and class)
DELETE FROM grade WHERE student_id = 4;
-- Delete class enrollments
DELETE FROM student_class WHERE student_id = 4;
-- Finally delete the student
DELETE FROM student WHERE student_id = 4;
```

> Order matters because `grade` and `student_class` have foreign keys referencing `student`. You must remove child rows before the parent row.

**2. Update teacher email:**

```sql
UPDATE teacher SET email = 'moyo.new@school.ac.za' WHERE teacher_id = 1;
```

**3. Adjust Grade 12 test marks by +5:**

```sql
UPDATE grade g
INNER JOIN class c ON g.class_id = c.class_id
INNER JOIN subject sub ON c.subject_id = sub.subject_id
SET g.mark = g.mark + 5
WHERE sub.grade_level = 12 AND g.assessment_type = 'test';
```

</details>

<details>
<summary><strong>Part D: Normalization Solution</strong></summary>

**1.** The table violates **1NF** (repeating groups: subject1/mark1, subject2/mark2 are repeating columns) and **2NF/3NF** (teacher_name depends on the subject, not on the student).

**2. Redesign into 3NF:**

**student:**

| student_number | student_name |
|---|---|
| S001 | Thabo |

**subject:**

| subject_id | subject_name |
|---|---|
| 1 | Maths |
| 2 | English |

**teacher:**

| teacher_id | teacher_name |
|---|---|
| 1 | Mr. Moyo |

**subject_teacher:** (which teacher teaches which subject)

| subject_id | teacher_id |
|---|---|
| 1 | 1 |
| 2 | 1 |

**student_mark:**

| student_number | subject_id | mark |
|---|---|---:|
| S001 | 1 | 72 |
| S001 | 2 | 65 |

**3.** With 500 students × 8 subjects, the original format would need 16 subject/mark columns and repeat teacher_name 500 times. The normalized version stores each fact once, making updates, additions, and queries far more efficient.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **Why `term` as a column:** Using a column avoids creating nearly identical table structures per term. Terms are a property of a class, not a separate entity requiring its own table.

2. **Marks as VARCHAR problems:** You couldn't do arithmetic (AVG, SUM, comparison with < or >). Sorting would be alphabetical ("9" > "85"). CHECK constraints on ranges wouldn't work properly.

3. **Extending for attendance:** Add an `attendance` table with columns: `student_id` (FK), `class_id` (FK), `date`, `status` (present/absent/late). This links to existing student and class tables.

</details>
