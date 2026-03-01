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
