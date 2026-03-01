# Exercise 02: Library Database

## Scenario

A community library needs a database to manage its books, members, and loans. The library wants to track which members have borrowed which books, when books are due back, and which books are currently available.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. Foreign Key
2. One-to-Many relationship
3. `AUTO_INCREMENT`
4. `NOT NULL`
5. `LEFT JOIN`

---

## Part B: Table Design (25 marks)

Design the following tables. For each table, list:

- Column name
- Datatype
- Constraints (PK, FK, NOT NULL, UNIQUE, DEFAULT, CHECK)

### Required tables

1. **member** — library members (name, email, phone, membership date)
2. **author** — book authors (name, country)
3. **book** — library books (title, ISBN, genre, published year, number of copies)
4. **loan** — book loans (which member, which book, loan date, due date, return date)

### Questions

1. What is the relationship between `member` and `loan`?
2. What is the relationship between `book` and `loan`?
3. What is the relationship between `author` and `book`? How would you model it if a book can have multiple authors?
4. Should `ISBN` have a `UNIQUE` constraint? Why?

---

## Part C: SQL Implementation (40 marks)

Write SQL to:

### C1. Create all tables (with proper keys and constraints)

```sql
-- Write your CREATE TABLE statements here
```

### C2. Insert sample data

- At least 4 members
- At least 3 authors
- At least 6 books
- At least 8 loans (some returned, some not yet returned)

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. Show all books sorted by title alphabetically.
2. Show all books published after 2015.
3. Find all currently active loans (where `return_date IS NULL`).
4. Show loan details with member name and book title (use `JOIN`).
5. Count how many books each member has borrowed.
6. Find members who have borrowed more than 2 books.
7. Show all members who have **never** borrowed a book (use `LEFT JOIN`).
8. Find the most popular book (most loans).
9. List all books with the word "the" in the title (use `LIKE`).
10. Show the average number of loans per member.

---

## Part D: Transactions (15 marks)

Write a transaction that:

1. Records a new loan (member borrows a book).
2. Decreases the book's available copies by 1.
3. If the book has 0 copies available, the transaction should be rolled back.

```sql
-- Write your transaction here
```

---

## Part E: Reflection (10 marks)

1. Why is `return_date` allowed to be `NULL`?
2. How would you handle a book with multiple authors?
3. What would happen if you deleted a member who has active loans? How would you prevent data loss?

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

1. **Foreign Key**
   - Simple: A foreign key is a column in one table that points to a row in another table.
   - Technical: A column that references the primary key of another table, enforcing referential integrity between the two relations.

2. **One-to-Many relationship**
   - Simple: One record in table A can relate to many records in table B, but each record in B relates to only one in A.
   - Technical: A cardinality constraint where one entity instance maps to multiple instances of another entity; modeled by placing the foreign key on the "many" side.

3. **AUTO_INCREMENT**
   - Simple: The database automatically gives each new row the next number as its ID.
   - Technical: A MySQL column attribute that generates a unique, sequential integer value for each new row inserted.

4. **NOT NULL**
   - Simple: This column must always have a value — it cannot be left empty.
   - Technical: A constraint that prohibits NULL values in a column, ensuring every row has a defined value for that attribute.

5. **LEFT JOIN**
   - Simple: Returns all rows from the left table, plus matching data from the right table (or NULL if no match).
   - Technical: An outer join that preserves all rows from the left relation and fills unmatched right-side columns with NULL.

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **member → loan** = One-to-Many (one member can have many loans).
2. **book → loan** = One-to-Many (one book can appear in many loans).
3. **author → book** = If a book can have multiple authors, this is Many-to-Many. Model it with a junction table `book_author(book_id, author_id)`.
4. **ISBN UNIQUE** — Yes. Every book has a globally unique ISBN; duplicates would mean data error.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE member (
  member_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  phone VARCHAR(20),
  membership_date DATE DEFAULT (CURDATE())
);

CREATE TABLE author (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(60)
);

CREATE TABLE book (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(150) NOT NULL,
  isbn VARCHAR(20) UNIQUE NOT NULL,
  genre VARCHAR(50),
  published_year INT,
  copies INT DEFAULT 1 CHECK (copies >= 0),
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE loan (
  loan_id INT PRIMARY KEY AUTO_INCREMENT,
  member_id INT NOT NULL,
  book_id INT NOT NULL,
  loan_date DATE NOT NULL DEFAULT (CURDATE()),
  due_date DATE NOT NULL,
  return_date DATE,
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  FOREIGN KEY (book_id) REFERENCES book(book_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO member (full_name, email, phone) VALUES
  ('Amahle Mokoena', 'amahle@mail.com', '0712345678'),
  ('Lebo Ncube', 'lebo@mail.com', '0723456789'),
  ('Sipho Dlamini', 'sipho@mail.com', '0734567890'),
  ('Thandi Nkosi', 'thandi@mail.com', '0745678901');

INSERT INTO author (name, country) VALUES
  ('Chinua Achebe', 'Nigeria'),
  ('Alan Paton', 'South Africa'),
  ('Trevor Noah', 'South Africa');

INSERT INTO book (title, isbn, genre, published_year, copies, author_id) VALUES
  ('Things Fall Apart', '978-0385474542', 'Fiction', 1958, 3, 1),
  ('Cry, the Beloved Country', '978-0743262170', 'Fiction', 1948, 4, 2),
  ('Born a Crime', '978-0399588174', 'Memoir', 2016, 2, 3),
  ('The Beautiful Ones', '978-0063076075', 'Fiction', 2020, 3, 1),
  ('No Longer at Ease', '978-0385474559', 'Fiction', 1960, 2, 1),
  ('Too Late the Phalarope', '978-0684818948', 'Fiction', 1953, 1, 2);

INSERT INTO loan (member_id, book_id, loan_date, due_date, return_date) VALUES
  (1, 1, '2026-01-10', '2026-01-24', '2026-01-20'),
  (1, 3, '2026-02-01', '2026-02-15', NULL),
  (1, 5, '2026-02-10', '2026-02-24', '2026-02-22'),
  (2, 1, '2026-01-15', '2026-01-29', '2026-01-28'),
  (2, 2, '2026-02-05', '2026-02-19', NULL),
  (3, 4, '2026-02-10', '2026-02-24', NULL),
  (3, 6, '2026-02-12', '2026-02-26', NULL),
  (4, 3, '2026-01-20', '2026-02-03', '2026-02-01');
```

### C3. Queries

**1. All books sorted by title:**

```sql
SELECT * FROM book ORDER BY title ASC;
```

**Expected output:**

| book_id | title | isbn | genre | published_year | copies | author_id |
|---:|---|---|---|---:|---:|---:|
| 3 | Born a Crime | 978-0399588174 | Memoir | 2016 | 2 | 3 |
| 2 | Cry, the Beloved Country | 978-0743262170 | Fiction | 1948 | 4 | 2 |
| 5 | No Longer at Ease | 978-0385474559 | Fiction | 1960 | 2 | 1 |
| 4 | The Beautiful Ones | 978-0063076075 | Fiction | 2020 | 3 | 1 |
| 1 | Things Fall Apart | 978-0385474542 | Fiction | 1958 | 3 | 1 |
| 6 | Too Late the Phalarope | 978-0684818948 | Fiction | 1953 | 1 | 2 |

**2. Books published after 2015:**

```sql
SELECT * FROM book WHERE published_year > 2015;
```

**Expected output:**

| book_id | title | isbn | genre | published_year | copies | author_id |
|---:|---|---|---|---:|---:|---:|
| 3 | Born a Crime | 978-0399588174 | Memoir | 2016 | 2 | 3 |
| 4 | The Beautiful Ones | 978-0063076075 | Fiction | 2020 | 3 | 1 |

**3. Currently active loans:**

```sql
SELECT * FROM loan WHERE return_date IS NULL;
```

**Expected output:**

| loan_id | member_id | book_id | loan_date | due_date | return_date |
|---:|---:|---:|---|---|---|
| 2 | 1 | 3 | 2026-02-01 | 2026-02-15 | NULL |
| 5 | 2 | 2 | 2026-02-05 | 2026-02-19 | NULL |
| 6 | 3 | 4 | 2026-02-10 | 2026-02-24 | NULL |
| 7 | 3 | 6 | 2026-02-12 | 2026-02-26 | NULL |

> Books with `NULL` in return_date have not been returned yet.

**4. Loan details with member name and book title:**

```sql
SELECT
  l.loan_id,
  m.full_name AS member_name,
  b.title AS book_title,
  l.loan_date,
  l.due_date,
  l.return_date
FROM loan l
INNER JOIN member m ON l.member_id = m.member_id
INNER JOIN book b ON l.book_id = b.book_id;
```

**Expected output:**

| loan_id | member_name | book_title | loan_date | due_date | return_date |
|---:|---|---|---|---|---|
| 1 | Amahle Mokoena | Things Fall Apart | 2026-01-10 | 2026-01-24 | 2026-01-20 |
| 2 | Amahle Mokoena | Born a Crime | 2026-02-01 | 2026-02-15 | NULL |
| 3 | Amahle Mokoena | No Longer at Ease | 2026-02-10 | 2026-02-24 | 2026-02-22 |
| 4 | Lebo Ncube | Things Fall Apart | 2026-01-15 | 2026-01-29 | 2026-01-28 |
| 5 | Lebo Ncube | Cry, the Beloved Country | 2026-02-05 | 2026-02-19 | NULL |
| 6 | Sipho Dlamini | The Beautiful Ones | 2026-02-10 | 2026-02-24 | NULL |
| 7 | Sipho Dlamini | Too Late the Phalarope | 2026-02-12 | 2026-02-26 | NULL |
| 8 | Thandi Nkosi | Born a Crime | 2026-01-20 | 2026-02-03 | 2026-02-01 |

> The JOIN replaced `member_id` and `book_id` with human-readable names.

**5. Count books borrowed per member:**

```sql
SELECT
  m.full_name,
  COUNT(*) AS books_borrowed
FROM loan l
INNER JOIN member m ON l.member_id = m.member_id
GROUP BY m.member_id, m.full_name;
```

**Expected output:**

| full_name | books_borrowed |
|---|---:|
| Amahle Mokoena | 3 |
| Lebo Ncube | 2 |
| Sipho Dlamini | 2 |
| Thandi Nkosi | 1 |

**6. Members who borrowed more than 2 books:**

```sql
SELECT
  m.full_name,
  COUNT(*) AS books_borrowed
FROM loan l
INNER JOIN member m ON l.member_id = m.member_id
GROUP BY m.member_id, m.full_name
HAVING COUNT(*) > 2;
```

**Expected output:**

| full_name | books_borrowed |
|---|---:|
| Amahle Mokoena | 3 |

> Only Amahle has more than 2 loans.

**7. Members who never borrowed a book:**

```sql
SELECT m.full_name
FROM member m
LEFT JOIN loan l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL;
```

**Expected output:**

```
Empty set (0 rows)
```

> All 4 members have at least one loan. If a 5th member existed with no loans, they'd appear here.

**8. Most popular book:**

```sql
SELECT
  b.title,
  COUNT(*) AS times_borrowed
FROM loan l
INNER JOIN book b ON l.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC
LIMIT 1;
```

**Expected output:**

| title | times_borrowed |
|---|---:|
| Born a Crime | 2 |

> "Born a Crime" and "Things Fall Apart" both have 2 loans, but LIMIT 1 returns whichever MySQL finds first.

**9. Books with "the" in the title:**

```sql
SELECT * FROM book WHERE title LIKE '%the%';
```

**Expected output:**

| book_id | title | isbn | genre | published_year | copies | author_id |
|---:|---|---|---|---:|---:|---:|
| 2 | Cry, the Beloved Country | 978-0743262170 | Fiction | 1948 | 4 | 2 |
| 4 | The Beautiful Ones | 978-0063076075 | Fiction | 2020 | 3 | 1 |
| 6 | Too Late the Phalarope | 978-0684818948 | Fiction | 1953 | 1 | 2 |

> LIKE is case-insensitive in MySQL, so "The" and "the" both match.

**10. Average loans per member:**

```sql
SELECT AVG(loan_count) AS avg_loans_per_member
FROM (
  SELECT member_id, COUNT(*) AS loan_count
  FROM loan
  GROUP BY member_id
) AS member_loans;
```

**Expected output:**

| avg_loans_per_member |
|---:|
| 2.0000 |

> (3 + 2 + 2 + 1) / 4 = 2.0 average loans per member.

</details>

<details>
<summary><strong>Part D: Transaction Solution</strong></summary>

```sql
DELIMITER //

CREATE PROCEDURE borrow_book(IN p_member_id INT, IN p_book_id INT)
BEGIN
  DECLARE available INT;

  START TRANSACTION;

  -- Lock the row and check copies
  SELECT copies INTO available FROM book WHERE book_id = p_book_id FOR UPDATE;

  IF available <= 0 THEN
    ROLLBACK;
    SELECT 'ERROR: No copies available' AS result;
  ELSE
    -- Record the loan
    INSERT INTO loan (member_id, book_id, loan_date, due_date)
    VALUES (p_member_id, p_book_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));

    -- Decrease copies
    UPDATE book SET copies = copies - 1 WHERE book_id = p_book_id;

    COMMIT;
    SELECT 'SUCCESS: Book borrowed' AS result;
  END IF;
END //

DELIMITER ;

-- Usage:
CALL borrow_book(2, 1);
```

> [!TIP]
> The `IF ... ELSE` logic only works inside a **stored procedure** — you cannot use it in a plain SQL script. `DELIMITER //` lets us use `;` inside the procedure body without ending the CREATE statement early.

> [!NOTE]
> `FOR UPDATE` locks the book row so no other session can borrow the last copy at the same time.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **Why `return_date` allows NULL:** A loan that hasn't been returned yet has no return date. NULL means "not yet known" — it's the correct representation for an unreturned book.

2. **Book with multiple authors:** Create a junction table `book_author(book_id, author_id)` to model the many-to-many relationship, instead of storing author directly in the book table.

3. **Deleting a member with active loans:** The foreign key constraint would block the delete (or cascade it). To prevent data loss, you should either return all loans first, or use `ON DELETE RESTRICT` to block the deletion until loans are resolved.

</details>
