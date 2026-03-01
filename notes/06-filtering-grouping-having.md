# 06. Filtering, Grouping, and Having

## Learning Outcomes

After this lesson, you should be able to:

- Filter rows with `WHERE`.
- Group data using `GROUP BY`.
- Filter grouped results using `HAVING`.
- Use aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`).

---

## 1. WHERE Clause

Use `WHERE` to filter rows before grouping.

```sql
SELECT * FROM student
WHERE age >= 20;
```

Useful operators:

- `=`, `!=`, `>`, `<`, `>=`, `<=`
- `AND`, `OR`, `NOT`
- `IN (...)`
- `BETWEEN ... AND ...`
- `LIKE`

### Combining conditions

```sql
SELECT * FROM student
WHERE age >= 18 AND age <= 25;

-- Same thing using BETWEEN:
SELECT * FROM student
WHERE age BETWEEN 18 AND 25;

-- Multiple specific values:
SELECT * FROM student
WHERE department_id IN (1, 2, 5);
```

---

## 1.5 LIKE and Wildcards

`LIKE` is used for pattern matching on text columns.

| Wildcard | Meaning | Example |
|---|---|---|
| `%` | Any sequence of characters (including none) | `'A%'` matches "Amahle", "Aiden" |
| `_` | Exactly one character | `'L_bo'` matches "Lebo", "Lobo" |

### Examples

```sql
-- Names starting with 'A'
SELECT * FROM student
WHERE name LIKE 'A%';

-- Emails ending with '@uni.ac.za'
SELECT * FROM student
WHERE email LIKE '%@uni.ac.za';

-- Names containing 'mo' anywhere
SELECT * FROM student
WHERE name LIKE '%mo%';

-- Student numbers with exactly 7 characters
SELECT * FROM student
WHERE student_number LIKE '_______';
```

> [!NOTE]
> `LIKE` is case-insensitive in MySQL by default (depends on collation).

---

## 1.6 NULL Handling

`NULL` means "unknown" or "missing". It is **not** the same as zero or empty string.

### Checking for NULL

```sql
-- Find students with no email
SELECT * FROM student
WHERE email IS NULL;

-- Find students who have an email
SELECT * FROM student
WHERE email IS NOT NULL;
```

> [!WARNING]
> Never use `= NULL` or `!= NULL`. These do not work in SQL. Always use `IS NULL` / `IS NOT NULL`.

### NULL-safe functions

```sql
-- IFNULL: replace NULL with a default
SELECT name, IFNULL(email, 'no email') AS email
FROM student;

-- COALESCE: return first non-NULL value
SELECT COALESCE(email, phone, 'no contact') AS contact_info
FROM student;
```

---

## 2. GROUP BY

Use `GROUP BY` to combine rows that share a value.

Formula:

```sql
SELECT column_to_group, AGGREGATE_FUNCTION(...)
FROM table_name
GROUP BY column_to_group;
```

Example:

```sql
SELECT department_id, COUNT(*) AS total_lecturers
FROM lecturer
GROUP BY department_id;
```

---

## 3. HAVING Clause

Use `HAVING` to filter grouped results.

Formula:

```sql
SELECT column_to_group, AGGREGATE_FUNCTION(...)
FROM table_name
GROUP BY column_to_group
HAVING AGGREGATE_FUNCTION(...) condition;
```

Example:

```sql
SELECT department_id, COUNT(*) AS total_lecturers
FROM lecturer
GROUP BY department_id
HAVING COUNT(*) >= 3;
```

---

## WHERE vs HAVING

| Clause | Filters | Applied stage |
|---|---|---|
| `WHERE` | Individual rows | Before grouping |
| `HAVING` | Grouped rows | After grouping |

---

## 4. Aggregate Functions

| Function | Purpose |
|---|---|
| `COUNT()` | Number of rows |
| `SUM()` | Total numeric sum |
| `AVG()` | Average numeric value |
| `MIN()` | Minimum value |
| `MAX()` | Maximum value |

Example:

```sql
SELECT
  COUNT(*) AS total_students,
  AVG(age) AS average_age,
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM student;
```

---

## 5. Full Query Execution Order

MySQL processes clauses in this order (not the order you write them):

```text
1. FROM        — choose the table(s)
2. WHERE       — filter individual rows
3. GROUP BY    — group remaining rows
4. HAVING      — filter groups
5. SELECT      — choose columns / calculate
6. ORDER BY    — sort the result
7. LIMIT       — restrict number of rows returned
```

> [!IMPORTANT]
> You write `SELECT` first, but MySQL runs `FROM` first. Understanding this order prevents many common errors.

---

## Remember

> [!TIP]
> `WHERE` filters records, `GROUP BY` groups them, `HAVING` filters the groups.

> [!TIP]
> Use `IS NULL` / `IS NOT NULL` to check for missing values — never `= NULL`.

---

## See Also

- [05 - CRUD and Basic SELECT](05-crud-and-basic-select.md) — `SELECT`, `ORDER BY`, `LIMIT`
- [07 - Joins, Subqueries, UNION](07-joins-subqueries-and-union.md) — combining tables

---

## Checkpoint Questions

1. Why can `HAVING` use aggregate functions directly?
2. Which runs first: `WHERE` or `GROUP BY`?
3. Write a query to show modules with more than 50 students.
4. What is the difference between `%` and `_` in a `LIKE` pattern?
5. Why does `WHERE email = NULL` not work?
6. What is the correct execution order of a full SELECT query?

