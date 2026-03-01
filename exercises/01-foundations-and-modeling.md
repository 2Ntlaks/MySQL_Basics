# Exercises 01: Foundations and Modeling

## Instructions

1. Do not copy from classmates.
2. Write both explanation and SQL.
3. Test every SQL statement before submission.

---

## Part A: Terminology (Short Answers)

Define each term in:

1. One simple sentence
2. One technical sentence

Terms:

1. Database
2. Table
3. Row
4. Column
5. Datatype
6. Primary key
7. Foreign key
8. Relationship
9. Constraint
10. Transaction

---

## Part B: Table Design

Design a database for a small library system with:

- Readers
- Books
- Loans

Tasks:

1. List required tables.
2. List columns and datatypes for each table.
3. Mark primary keys.
4. Mark foreign keys.
5. Identify relationship type between each pair of tables.

---

## Part C: SQL Implementation

Write SQL to:

1. Create your tables.
2. Insert at least 5 rows into each table.
3. Show all loans with reader name and book title.
4. Count loans per reader.
5. Show readers with more than 1 loan.

---

## Part D: Reflection

Answer:

1. Which datatype choices were difficult and why?
2. Which relationship was easiest to model and why?
3. What error did you meet while writing SQL, and how did you fix it?

---

## Marking Guide (For Lecturer/Tutor)

| Criterion | Marks |
|---|---:|
| Correct term definitions | 20 |
| Correct schema design | 30 |
| SQL correctness | 30 |
| Query quality and readability | 10 |
| Reflection clarity | 10 |
| **Total** | **100** |

---

## Solutions

> [!WARNING]
> Try to complete the exercise on your own before looking at the solutions below.

<details>
<summary><strong>Part A: Terminology Solutions</strong></summary>

1. **Database**
   - Simple: A database is a place where related data is stored in an organized way.
   - Technical: A structured collection of related data managed by a DBMS.

2. **Table**
   - Simple: A table is a grid of data where each row is one item and each column is one property.
   - Technical: A relation consisting of rows (tuples) and columns (attributes) with a defined schema.

3. **Row**
   - Simple: A row is one complete record in a table.
   - Technical: A tuple representing a single instance of the entity described by the table.

4. **Column**
   - Simple: A column is one piece of information collected for every row.
   - Technical: An attribute with a specific name and datatype that stores one property per record.

5. **Datatype**
   - Simple: A datatype tells the database what kind of value a column can hold (text, number, date, etc.).
   - Technical: A classification that specifies the storage format and valid operations for column values.

6. **Primary Key**
   - Simple: A primary key is the unique identifier for each row in a table.
   - Technical: A column (or combination of columns) that uniquely identifies each row; must be unique and NOT NULL.

7. **Foreign Key**
   - Simple: A foreign key is a column that links one table to another.
   - Technical: A column that references the primary key of another table, enforcing referential integrity.

8. **Relationship**
   - Simple: A relationship is a logical connection between two tables.
   - Technical: An association between entities, classified as one-to-one, one-to-many, or many-to-many.

9. **Constraint**
   - Simple: A constraint is a rule that limits what data can go into a column.
   - Technical: A declarative rule enforced by the DBMS to maintain data integrity (e.g., NOT NULL, UNIQUE, CHECK).

10. **Transaction**
    - Simple: A transaction is a group of SQL statements that either all succeed or all fail.
    - Technical: A logical unit of work consisting of one or more SQL operations that are committed or rolled back atomically.

</details>

<details>
<summary><strong>Part B: Table Design Solution</strong></summary>

**Required tables:** `reader`, `book`, `loan`

**reader table:**

| Column | Datatype | Constraints |
|---|---|---|
| reader_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| full_name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(120) | UNIQUE |
| phone | VARCHAR(20) | |
| registered_at | DATE | DEFAULT (CURDATE()) |

**book table:**

| Column | Datatype | Constraints |
|---|---|---|
| book_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| title | VARCHAR(150) | NOT NULL |
| author | VARCHAR(100) | NOT NULL |
| isbn | VARCHAR(20) | UNIQUE |
| genre | VARCHAR(50) | |
| copies_available | INT | DEFAULT 1, CHECK (copies_available >= 0) |

**loan table:**

| Column | Datatype | Constraints |
|---|---|---|
| loan_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| reader_id | INT | NOT NULL, FOREIGN KEY → reader |
| book_id | INT | NOT NULL, FOREIGN KEY → book |
| loan_date | DATE | NOT NULL, DEFAULT (CURDATE()) |
| due_date | DATE | NOT NULL |
| return_date | DATE | NULL (not yet returned) |

**Relationships:**

- `reader` → `loan` = **One-to-Many** (one reader can have many loans)
- `book` → `loan` = **One-to-Many** (one book can appear in many loans)
- `reader` ↔ `book` through `loan` = **Many-to-Many** (resolved by junction table `loan`)

</details>

<details>
<summary><strong>Part C: SQL Implementation Solution</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE reader (
  reader_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  phone VARCHAR(20),
  registered_at DATE DEFAULT (CURDATE())
);

CREATE TABLE book (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  author VARCHAR(100) NOT NULL,
  isbn VARCHAR(20) UNIQUE,
  genre VARCHAR(50),
  copies_available INT DEFAULT 1 CHECK (copies_available >= 0)
);

CREATE TABLE loan (
  loan_id INT PRIMARY KEY AUTO_INCREMENT,
  reader_id INT NOT NULL,
  book_id INT NOT NULL,
  loan_date DATE NOT NULL DEFAULT (CURDATE()),
  due_date DATE NOT NULL,
  return_date DATE,
  FOREIGN KEY (reader_id) REFERENCES reader(reader_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO reader (full_name, email, phone) VALUES
  ('Amahle Mokoena', 'amahle@mail.com', '0712345678'),
  ('Lebo Ncube', 'lebo@mail.com', '0723456789'),
  ('Sipho Dlamini', 'sipho@mail.com', '0734567890'),
  ('Thandi Nkosi', 'thandi@mail.com', '0745678901'),
  ('Kagiso Molefe', 'kagiso@mail.com', '0756789012');

INSERT INTO book (title, author, isbn, genre, copies_available) VALUES
  ('Things Fall Apart', 'Chinua Achebe', '978-0385474542', 'Fiction', 3),
  ('Long Walk to Freedom', 'Nelson Mandela', '978-0316548182', 'Biography', 2),
  ('Cry, the Beloved Country', 'Alan Paton', '978-0743262170', 'Fiction', 4),
  ('Born a Crime', 'Trevor Noah', '978-0399588174', 'Memoir', 2),
  ('The Alchemist', 'Paulo Coelho', '978-0062315007', 'Fiction', 5);

INSERT INTO loan (reader_id, book_id, loan_date, due_date, return_date) VALUES
  (1, 1, '2026-01-10', '2026-01-24', '2026-01-20'),
  (1, 2, '2026-02-01', '2026-02-15', NULL),
  (2, 1, '2026-01-15', '2026-01-29', '2026-01-28'),
  (2, 3, '2026-02-05', '2026-02-19', NULL),
  (3, 4, '2026-02-10', '2026-02-24', NULL),
  (4, 5, '2026-01-20', '2026-02-03', '2026-02-01'),
  (4, 1, '2026-02-12', '2026-02-26', NULL);
```

### C3. Show all loans with reader name and book title

```sql
SELECT
  l.loan_id,
  r.full_name AS reader_name,
  b.title AS book_title,
  l.loan_date,
  l.due_date,
  l.return_date
FROM loan l
INNER JOIN reader r ON l.reader_id = r.reader_id
INNER JOIN book b ON l.book_id = b.book_id;
```

**Expected output:**

| loan_id | reader_name | book_title | loan_date | due_date | return_date |
|---:|---|---|---|---|---|
| 1 | Amahle Mokoena | Things Fall Apart | 2026-01-10 | 2026-01-24 | 2026-01-20 |
| 2 | Amahle Mokoena | Long Walk to Freedom | 2026-02-01 | 2026-02-15 | NULL |
| 3 | Lebo Ncube | Things Fall Apart | 2026-01-15 | 2026-01-29 | 2026-01-28 |
| 4 | Lebo Ncube | Cry, the Beloved Country | 2026-02-05 | 2026-02-19 | NULL |
| 5 | Sipho Dlamini | Born a Crime | 2026-02-10 | 2026-02-24 | NULL |
| 6 | Thandi Nkosi | The Alchemist | 2026-01-20 | 2026-02-03 | 2026-02-01 |
| 7 | Thandi Nkosi | Things Fall Apart | 2026-02-12 | 2026-02-26 | NULL |

> The JOIN replaces IDs with readable names. `NULL` in return_date means the book is still on loan.

### C4. Count loans per reader

```sql
SELECT
  r.full_name,
  COUNT(*) AS total_loans
FROM loan l
INNER JOIN reader r ON l.reader_id = r.reader_id
GROUP BY r.reader_id, r.full_name;
```

**Expected output:**

| full_name | total_loans |
|---|---:|
| Amahle Mokoena | 2 |
| Lebo Ncube | 2 |
| Sipho Dlamini | 1 |
| Thandi Nkosi | 2 |

> Kagiso Molefe doesn't appear because he has 0 loans (INNER JOIN excludes him).

### C5. Show readers with more than 1 loan

```sql
SELECT
  r.full_name,
  COUNT(*) AS total_loans
FROM loan l
INNER JOIN reader r ON l.reader_id = r.reader_id
GROUP BY r.reader_id, r.full_name
HAVING COUNT(*) > 1;
```

**Expected output:**

| full_name | total_loans |
|---|---:|
| Amahle Mokoena | 2 |
| Lebo Ncube | 2 |
| Thandi Nkosi | 2 |

> Sipho (1 loan) is filtered out by `HAVING COUNT(*) > 1`.

</details>

<details>
<summary><strong>Part D: Reflection Guidance</strong></summary>

1. **Difficult datatype choices:** Choosing between `VARCHAR` and `TEXT` for author names or descriptions, deciding on the length for ISBN, and whether `copies_available` should have a CHECK constraint.

2. **Easiest relationship:** Reader-to-Loan (one-to-many) is straightforward because each loan clearly belongs to one reader.

3. **Common errors:** Foreign key errors if tables are created in wrong order (loan before reader/book), or inserting a `reader_id` that doesn't exist in `reader`.

</details>

