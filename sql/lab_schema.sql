-- Database Systems Lab Schema
-- Beginner-friendly script for practice

DROP DATABASE IF EXISTS dbs101_lab;
CREATE DATABASE dbs101_lab;
USE dbs101_lab;

-- 1:N example: department -> lecturer
CREATE TABLE department (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE lecturer (
  lecturer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(120) UNIQUE,
  department_id INT NOT NULL,
  FOREIGN KEY (department_id) REFERENCES department(department_id)
);

-- N:N example: student <-> module through enrollment
CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_number VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(60) NOT NULL,
  email VARCHAR(120) UNIQUE,
  date_of_birth DATE,
  age INT CHECK (age >= 16)
);

CREATE TABLE module (
  module_id INT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(80) NOT NULL
);

CREATE TABLE enrollment (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  module_id INT NOT NULL,
  enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES student(student_id),
  FOREIGN KEY (module_id) REFERENCES module(module_id)
);

-- 1:1 example: person <-> passport
CREATE TABLE person (
  person_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE passport (
  passport_id INT PRIMARY KEY AUTO_INCREMENT,
  person_id INT UNIQUE,
  passport_number VARCHAR(30) UNIQUE NOT NULL,
  FOREIGN KEY (person_id) REFERENCES person(person_id)
);

-- Seed data
INSERT INTO department (department_id, name) VALUES
  (1, 'Computer Science'),
  (2, 'Mathematics');

INSERT INTO lecturer (lecturer_id, name, email, department_id) VALUES
  (1, 'Dr. Khumalo', 'khumalo@uni.ac.za', 1),
  (2, 'Ms. Naidoo', 'naidoo@uni.ac.za', 1),
  (3, 'Dr. Ndlovu', 'ndlovu@uni.ac.za', 2);

INSERT INTO student (student_id, student_number, name, email, age) VALUES
  (1, '2026001', 'Amahle Mokoena', 'amahle@uni.ac.za', 20),
  (2, '2026002', 'Lebo Ncube', 'lebo@uni.ac.za', 19),
  (3, '2026003', 'Sipho Dlamini', 'sipho@uni.ac.za', 21);

INSERT INTO module (module_id, code, name) VALUES
  (1, 'DBS101', 'Database Systems'),
  (2, 'WBG101', 'Web Basics'),
  (3, 'PRG101', 'Programming Fundamentals');

INSERT INTO enrollment (enrollment_id, student_id, module_id) VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 2, 1),
  (4, 3, 1),
  (5, 3, 3);

INSERT INTO person (person_id, name) VALUES
  (1, 'Lerato'),
  (2, 'Thabo');

INSERT INTO passport (passport_id, person_id, passport_number) VALUES
  (1, 1, 'A00112233'),
  (2, 2, 'B00445566');

-- Practice query samples
SELECT * FROM student;
-- Expected output:
-- +------------+----------------+----------------+------------------+------+
-- | student_id | student_number | name           | email            | age  |
-- +------------+----------------+----------------+------------------+------+
-- |          1 | 2026001        | Amahle Mokoena | amahle@uni.ac.za |   20 |
-- |          2 | 2026002        | Lebo Ncube     | lebo@uni.ac.za   |   19 |
-- |          3 | 2026003        | Sipho Dlamini  | sipho@uni.ac.za  |   21 |
-- +------------+----------------+----------------+------------------+------+

SELECT department_id, COUNT(*) AS lecturer_count
FROM lecturer
GROUP BY department_id
HAVING COUNT(*) >= 1;
-- Expected output:
-- +---------------+-----------------+
-- | department_id | lecturer_count  |
-- +---------------+-----------------+
-- |             1 |               2 |
-- |             2 |               1 |
-- +---------------+-----------------+

SELECT s.name AS student_name, m.name AS module_name
FROM enrollment e
INNER JOIN student s ON e.student_id = s.student_id
INNER JOIN module m ON e.module_id = m.module_id;
-- Expected output:
-- +----------------+---------------------------+
-- | student_name   | module_name               |
-- +----------------+---------------------------+
-- | Amahle Mokoena | Database Systems          |
-- | Amahle Mokoena | Web Basics                |
-- | Lebo Ncube     | Database Systems          |
-- | Sipho Dlamini  | Database Systems          |
-- | Sipho Dlamini  | Programming Fundamentals  |
-- +----------------+---------------------------+
