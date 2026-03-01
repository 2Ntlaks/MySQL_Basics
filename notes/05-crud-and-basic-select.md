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

**Expected output:**

| student_id | full_name | email | age |
|---:|---|---|---:|
| 1 | Amahle Mokoena | amahle@uni.ac.za | 20 |
| 2 | Lebo Ncube | lebo@uni.ac.za | 19 |

Get selected columns:

```sql
SELECT full_name, email FROM student;
```

**Expected output:**

| full_name | email |
|---|---|
| Amahle Mokoena | amahle@uni.ac.za |
| Lebo Ncube | lebo@uni.ac.za |

---

## 3. Update (UPDATE)

```sql
UPDATE student
SET age = 21
WHERE student_id = 1;
```

**Verify the change:**

```sql
SELECT * FROM student WHERE student_id = 1;
```

**Expected output:**

| student_id | full_name | email | age |
|---:|---|---|---:|
| 1 | Amahle Mokoena | amahle@uni.ac.za | 21 |

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

## 5. ORDER BY

Use `ORDER BY` to sort results.

```sql
SELECT full_name, age FROM student
ORDER BY age ASC;
```

**Expected output (using lab data):**

| full_name | age |
|---|---:|
| Lebo Ncube | 19 |
| Amahle Mokoena | 20 |
| Sipho Dlamini | 21 |

- `ASC` = ascending (default, smallest first)
- `DESC` = descending (largest first)

Sort by multiple columns:

```sql
SELECT full_name, age FROM student
ORDER BY age DESC, full_name ASC;
```

---

## 6. LIMIT

Use `LIMIT` to restrict how many rows are returned.

```sql
SELECT * FROM student
ORDER BY age DESC
LIMIT 3;
```

**Expected output:**

| student_id | full_name | email | age |
|---:|---|---|---:|
| 3 | Sipho Dlamini | sipho@uni.ac.za | 21 |
| 1 | Amahle Mokoena | amahle@uni.ac.za | 20 |
| 2 | Lebo Ncube | lebo@uni.ac.za | 19 |

Get rows 4–6 (skip first 3):

```sql
SELECT * FROM student
ORDER BY student_id
LIMIT 3 OFFSET 3;
```

> [!TIP]
> `LIMIT` is invaluable for pagination and testing queries on large tables.

---

## 7. Column Aliases

Use `AS` to rename columns in output:

```sql
SELECT full_name AS student_name, age AS student_age
FROM student;
```

**Expected output:**

| student_name | student_age |
|---|---:|
| Amahle Mokoena | 20 |
| Lebo Ncube | 19 |
| Sipho Dlamini | 21 |

> Notice the column headers now say `student_name` and `student_age` instead of `full_name` and `age`.

Aliases make output more readable and are required when using aggregate functions.

---

## 8. AUTO_INCREMENT

### Definition

`AUTO_INCREMENT` tells MySQL to generate the next integer automatically when inserting a row.

### Why use it?

Manually tracking IDs is error-prone. Let MySQL handle it.

```sql
CREATE TABLE student (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  age INT
);
```

Now you can insert without specifying the ID:

```sql
INSERT INTO student (full_name, email, age)
VALUES ('Amahle Mokoena', 'amahle@uni.ac.za', 20);
```

MySQL will assign `student_id = 1` automatically, then `2`, `3`, etc.

> [!NOTE]
> `AUTO_INCREMENT` only works on integer columns that are a key (usually the primary key).

---

## Query Reading Order (Conceptual)

When you read a query, think:

1. Which table? (`FROM`)
2. Which rows? (`WHERE`)
3. Which columns? (`SELECT`)
4. What order? (`ORDER BY`)
5. How many? (`LIMIT`)

---

## Common Mistakes

- Forgetting `WHERE` in `UPDATE`/`DELETE`
- Inserting wrong datatype values
- Copy-pasting `SELECT *` in every query when only a few columns are needed
- Manually assigning IDs when `AUTO_INCREMENT` would be simpler
- Forgetting `ORDER BY` when using `LIMIT` (results may be unpredictable)

---

## Remember

> [!TIP]
> First write a safe `SELECT ... WHERE ...` to confirm target rows before writing `UPDATE` or `DELETE`.

> [!TIP]
> Use `AUTO_INCREMENT` for primary keys so you never worry about duplicate IDs.

---

## See Also

- [03 - Datatypes and Constraints](03-datatypes-and-constraints.md) — constraint rules
- [06 - Filtering, Grouping, HAVING](06-filtering-grouping-having.md) — `WHERE`, `GROUP BY`

---

## Checkpoint Questions

1. What does CRUD stand for?
2. Why is `WHERE` critical in `UPDATE` and `DELETE`?
3. Why avoid `SELECT *` in production systems?
4. What is the difference between `ORDER BY ASC` and `DESC`?
5. What does `AUTO_INCREMENT` do and when should you use it?
6. What happens if you use `LIMIT` without `ORDER BY`?

