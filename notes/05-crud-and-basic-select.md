# 05. CRUD and Basic SELECT

## Learning Outcomes

After this lesson, you should be able to:

- Perform CRUD operations in SQL.
- Query full tables and specific columns.
- Understand basic query flow.

---

## What is CRUD?

CRUD is the four basic operations on data:

| Letter | Operation | SQL command | Meaning |
|---|---|---|---|
| C | Create | `INSERT` | Add new data |
| R | Read | `SELECT` | Retrieve data |
| U | Update | `UPDATE` | Change existing data |
| D | Delete | `DELETE` | Remove data |

---

## Example Table

```sql
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  age INT
);
```

---

## 1. Create (INSERT)

```sql
INSERT INTO student (student_id, full_name, email, age)
VALUES
  (1, 'Amahle Mokoena', 'amahle@uni.ac.za', 20),
  (2, 'Lebo Ncube', 'lebo@uni.ac.za', 19);
```

---

## 2. Read (SELECT)

Get all columns:

```sql
SELECT * FROM student;
```

Get selected columns:

```sql
SELECT full_name, email FROM student;
```

---

## 3. Update (UPDATE)

```sql
UPDATE student
SET age = 21
WHERE student_id = 1;
```

> [!WARNING]
> Never run `UPDATE` without `WHERE` unless you intentionally want to update every row.

---

## 4. Delete (DELETE)

```sql
DELETE FROM student
WHERE student_id = 2;
```

> [!WARNING]
> Never run `DELETE` without `WHERE` unless you intentionally want to delete every row.

---

## Query Reading Order (Conceptual)

When you read a query, think:

1. Which table? (`FROM`)
2. Which rows? (`WHERE`)
3. Which columns? (`SELECT`)

---

## Common Mistakes

- Forgetting `WHERE` in `UPDATE`/`DELETE`
- Inserting wrong datatype values
- Copy-pasting `SELECT *` in every query when only a few columns are needed

---

## Remember

> [!TIP]
> First write a safe `SELECT ... WHERE ...` to confirm target rows before writing `UPDATE` or `DELETE`.

---

## Checkpoint Questions

1. What does CRUD stand for?
2. Why is `WHERE` critical in `UPDATE` and `DELETE`?
3. Why avoid `SELECT *` in production systems?

