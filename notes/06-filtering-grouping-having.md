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

## Remember

> [!TIP]
> `WHERE` filters records, `GROUP BY` groups them, `HAVING` filters the groups.

---

## Checkpoint Questions

1. Why can `HAVING` use aggregate functions directly?
2. Which runs first: `WHERE` or `GROUP BY`?
3. Write a query to show modules with more than 50 students.

