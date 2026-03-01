# 10. Useful MySQL Functions

## Learning Outcomes

After this lesson, you should be able to:

- Use string functions to format and manipulate text.
- Use date functions for calculations and formatting.
- Use numeric functions for rounding and math.
- Combine functions in queries.

---

## 1. String Functions

| Function | Purpose | Example | Result |
|---|---|---|---|
| `CONCAT(a, b)` | Join strings together | `CONCAT('Hello', ' ', 'World')` | `Hello World` |
| `UPPER(s)` | Convert to uppercase | `UPPER('amahle')` | `AMAHLE` |
| `LOWER(s)` | Convert to lowercase | `LOWER('LEBO')` | `lebo` |
| `LENGTH(s)` | Character count | `LENGTH('MySQL')` | `5` |
| `TRIM(s)` | Remove leading/trailing spaces | `TRIM('  hi  ')` | `hi` |
| `SUBSTRING(s, start, len)` | Extract part of string | `SUBSTRING('Database', 1, 4)` | `Data` |
| `REPLACE(s, old, new)` | Replace text | `REPLACE('2026-01-01', '-', '/')` | `2026/01/01` |
| `LEFT(s, n)` | First n characters | `LEFT('Amahle', 3)` | `Ama` |
| `RIGHT(s, n)` | Last n characters | `RIGHT('Amahle', 3)` | `hle` |

### Practical examples

```sql
-- Full name from first and last name columns
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM lecturer;

-- Standardize email to lowercase
SELECT LOWER(email) AS clean_email
FROM student;

-- Extract year from a code like 'DBS2026'
SELECT LEFT(code, 3) AS prefix, RIGHT(code, 4) AS year_part
FROM module;
```

---

## 2. Date and Time Functions

| Function | Purpose | Example | Result |
|---|---|---|---|
| `NOW()` | Current date and time | `NOW()` | `2026-03-01 14:30:00` |
| `CURDATE()` | Current date only | `CURDATE()` | `2026-03-01` |
| `CURTIME()` | Current time only | `CURTIME()` | `14:30:00` |
| `YEAR(d)` | Extract year | `YEAR('2026-03-01')` | `2026` |
| `MONTH(d)` | Extract month | `MONTH('2026-03-01')` | `3` |
| `DAY(d)` | Extract day | `DAY('2026-03-01')` | `1` |
| `DATEDIFF(d1, d2)` | Days between two dates | `DATEDIFF('2026-03-15', '2026-03-01')` | `14` |
| `DATE_ADD(d, INTERVAL)` | Add time to a date | `DATE_ADD('2026-03-01', INTERVAL 30 DAY)` | `2026-03-31` |
| `DATE_FORMAT(d, fmt)` | Custom date format | `DATE_FORMAT(NOW(), '%d/%m/%Y')` | `01/03/2026` |

### Practical examples

```sql
-- Students born in 2005
SELECT * FROM student
WHERE YEAR(date_of_birth) = 2005;

-- How many days since enrollment
SELECT
  student_id,
  enrolled_at,
  DATEDIFF(CURDATE(), enrolled_at) AS days_enrolled
FROM enrollment;

-- Enrollments in the last 30 days
SELECT * FROM enrollment
WHERE enrolled_at >= DATE_ADD(CURDATE(), INTERVAL -30 DAY);

-- Format date for display
SELECT name, DATE_FORMAT(date_of_birth, '%d %M %Y') AS dob_display
FROM student;
```

### Common format codes for DATE_FORMAT

| Code | Meaning | Example |
|---|---|---|
| `%Y` | 4-digit year | 2026 |
| `%y` | 2-digit year | 26 |
| `%M` | Month name | March |
| `%m` | Month number (01-12) | 03 |
| `%d` | Day (01-31) | 01 |
| `%H` | Hour (00-23) | 14 |
| `%i` | Minute (00-59) | 30 |
| `%s` | Second (00-59) | 00 |

---

## 3. Numeric Functions

| Function | Purpose | Example | Result |
|---|---|---|---|
| `ROUND(n, d)` | Round to d decimal places | `ROUND(3.14159, 2)` | `3.14` |
| `CEIL(n)` | Round up to nearest integer | `CEIL(4.1)` | `5` |
| `FLOOR(n)` | Round down to nearest integer | `FLOOR(4.9)` | `4` |
| `ABS(n)` | Absolute value | `ABS(-15)` | `15` |
| `MOD(n, m)` | Remainder of division | `MOD(10, 3)` | `1` |

### Practical examples

```sql
-- Round average age to 1 decimal
SELECT ROUND(AVG(age), 1) AS avg_age
FROM student;

-- Calculate VAT (15%) on product prices
SELECT
  product_name,
  price,
  ROUND(price * 0.15, 2) AS vat,
  ROUND(price * 1.15, 2) AS total_with_vat
FROM product;
```

---

## 4. Conditional Functions

### IF

```sql
SELECT name, age,
  IF(age >= 21, 'Senior', 'Junior') AS category
FROM student;
```

### CASE

```sql
SELECT name, age,
  CASE
    WHEN age < 18 THEN 'Minor'
    WHEN age BETWEEN 18 AND 24 THEN 'Young Adult'
    ELSE 'Adult'
  END AS age_group
FROM student;
```

> [!TIP]
> `CASE` is more flexible than `IF` when you have multiple conditions.

---

## Common Mistakes

- Using `DATEDIFF` with arguments in wrong order (first argument should be the later date)
- Forgetting that `SUBSTRING` positions start at 1, not 0
- Using string functions on NULL values (result is NULL — wrap with `IFNULL` first)
- Over-formatting in SQL when the application layer should handle display

---

## Remember

> [!TIP]
> Functions transform data in the query. They don't change stored data unless used in `UPDATE`.

> [!TIP]
> Combine functions: `UPPER(TRIM(name))` both trims and uppercases.

---

## See Also

- [05 - CRUD and Basic SELECT](05-crud-and-basic-select.md) — basic SELECT queries
- [06 - Filtering, Grouping, HAVING](06-filtering-grouping-having.md) — aggregate functions `COUNT`, `SUM`, `AVG`

---

## Checkpoint Questions

1. How would you combine `first_name` and `last_name` into one column?
2. Write a query to find students born in a specific year.
3. What does `DATEDIFF` return and what is the argument order?
4. When would you use `CASE` over `IF`?
5. Why does `UPPER(NULL)` return `NULL`?
