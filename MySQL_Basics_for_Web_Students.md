# MySQL Basics for Web Development Students

This guide teaches the core MySQL skills you need to build beginner web applications.

## Learning Goals

By the end of this lesson, students should be able to:

- Explain what a relational database is
- Create databases and tables
- Insert, read, update, and delete data (CRUD)
- Use filters, sorting, grouping, and joins
- Apply keys and constraints correctly
- Use transactions for safe multi-step updates
- Design a simple schema for a web app

---

## 1. What Is MySQL?

MySQL is a relational database management system (RDBMS).  
In web development, it is commonly used to store and retrieve app data such as users, posts, products, and orders.

Core ideas:

- **Database**: A container for tables
- **Table**: A collection of rows and columns
- **Row**: One record (for example, one user)
- **Column**: One field (for example, email)
- **Primary Key**: Unique ID for each row
- **Foreign Key**: Links rows across tables

---

## 2. Basic Setup

```sql
-- Create a new database
CREATE DATABASE school_app;

-- Select it
USE school_app;
```

Create a first table:

```sql
CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE NOT NULL,
  age INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 3. CRUD Operations

### Create (INSERT)

```sql
INSERT INTO students (full_name, email, age)
VALUES
  ('Lerato Nkosi', 'lerato@example.com', 20),
  ('Sipho Dlamini', 'sipho@example.com', 22);
```

### Read (SELECT)

```sql
-- All students
SELECT * FROM students;

-- Only certain columns
SELECT full_name, email FROM students;
```

### Update (UPDATE)

```sql
UPDATE students
SET age = 21
WHERE email = 'lerato@example.com';
```

### Delete (DELETE)

```sql
DELETE FROM students
WHERE id = 2;
```

---

## 4. Filtering, Sorting, and Limiting

```sql
-- Students older than 20
SELECT * FROM students
WHERE age > 20;

-- Sort by name A-Z
SELECT * FROM students
ORDER BY full_name ASC;

-- First 5 rows
SELECT * FROM students
LIMIT 5;
```

Useful operators:

- `=`, `!=`, `>`, `<`, `>=`, `<=`
- `AND`, `OR`, `NOT`
- `LIKE` (pattern matching)
- `IN` (match list of values)
- `BETWEEN` (range)

---

## 5. Aggregate Functions and GROUP BY

```sql
-- Count all students
SELECT COUNT(*) AS total_students
FROM students;

-- Average age
SELECT AVG(age) AS average_age
FROM students;
```

Example with grouping:

```sql
CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (course_id) REFERENCES courses(id)
);

SELECT course_id, COUNT(*) AS total_enrolled
FROM enrollments
GROUP BY course_id;
```

---

## 6. Joins (Very Important for Web Apps)

Joins combine data from related tables.

```sql
CREATE TABLE posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id)
);
```

Get posts with student names:

```sql
SELECT
  posts.id,
  posts.title,
  students.full_name AS author
FROM posts
INNER JOIN students ON posts.student_id = students.id;
```

Common joins:

- `INNER JOIN`: only matching rows
- `LEFT JOIN`: all left table rows + matches on right

---

## 7. Keys and Constraints

Use constraints to keep data clean and valid:

- `PRIMARY KEY`: unique identifier
- `FOREIGN KEY`: relationship between tables
- `NOT NULL`: value is required
- `UNIQUE`: no duplicate values
- `DEFAULT`: fallback value

Good schema rules:

- Every table should have a primary key
- Use foreign keys for relationships
- Store one type of data per column

---

## 8. Transactions

A transaction groups statements so they succeed or fail together.

```sql
START TRANSACTION;

UPDATE students SET age = age + 1 WHERE id = 1;
UPDATE students SET age = age + 1 WHERE id = 3;

COMMIT;
-- Use ROLLBACK instead of COMMIT if something is wrong
```

Use transactions for payments, stock updates, and other sensitive multi-step operations.

---

## 9. Security Basics

- Never build SQL with direct string concatenation from user input
- Use parameterized queries in your backend code
- Give apps least privilege database users (not admin)
- Backup data regularly

---

## 10. Mini Project: Blog Database

Build this schema for a beginner blog app:

1. `users` table (id, name, email, password_hash, created_at)
2. `posts` table (id, user_id, title, body, created_at)
3. `comments` table (id, post_id, user_id, body, created_at)

Tasks:

1. Create the 3 tables with proper keys
2. Insert sample data
3. Write a query to show each post with author name
4. Write a query to count comments per post
5. Write a query to show the latest 5 posts

---

## 11. Quick Practice Questions

1. What is the difference between `WHERE` and `HAVING`?
2. Why do we use foreign keys?
3. What does `LEFT JOIN` return?
4. What problem does `AUTO_INCREMENT` solve?
5. Why are parameterized queries important?

---

## 12. Next Step for Web Development

After SQL basics, connect MySQL to a backend framework:

- Node.js (`mysql2`, `sequelize`, or `prisma`)
- PHP (`PDO` or Laravel Eloquent)
- Python (`mysql-connector`, `SQLAlchemy`, or Django ORM)

Start with raw SQL first, then move to an ORM.
