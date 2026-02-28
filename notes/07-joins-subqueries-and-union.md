# 07. Joins, Subqueries, and UNION

## Learning Outcomes

After this lesson, you should be able to:

- Join related tables correctly.
- Use subqueries with `IN` and `EXISTS`.
- Combine results using `UNION`.

---

## 1. JOIN Basics

### Why joins matter

In relational databases, data is split into multiple tables. Joins let you bring related data together.

---

## 2. INNER JOIN

Returns only matching rows from both tables.

```sql
SELECT
  s.student_id,
  s.name AS student_name,
  m.name AS module_name
FROM enrollment e
INNER JOIN student s ON e.student_id = s.student_id
INNER JOIN module m ON e.module_id = m.module_id;
```

---

## 3. LEFT JOIN

Returns all rows from the left table, and matches from the right table (if any).

```sql
SELECT
  d.department_id,
  d.name AS department_name,
  l.name AS lecturer_name
FROM department d
LEFT JOIN lecturer l ON d.department_id = l.department_id;
```

Use this when you want to keep rows even if related data is missing.

---

## 4. Subqueries

A subquery is a query inside another query.

### Example: "Common values" idea using `IN`

```sql
SELECT student_id
FROM student
WHERE student_id IN (
  SELECT student_id FROM enrollment
);
```

Meaning:

- Return students who appear in enrollment records.

### Example using `EXISTS`

```sql
SELECT s.student_id, s.name
FROM student s
WHERE EXISTS (
  SELECT 1
  FROM enrollment e
  WHERE e.student_id = s.student_id
);
```

---

## 5. UNION

`UNION` combines results from two `SELECT` statements and removes duplicates by default.

```sql
SELECT email FROM student
UNION
SELECT email FROM lecturer;
```

Rules:

1. Same number of columns in each query
2. Compatible datatypes
3. Column order must correspond

> [!NOTE]
> Use `UNION ALL` if you want to keep duplicates.

---

## Optional: INTERSECT Note

Some SQL systems support `INTERSECT` directly. In MySQL learning contexts, students often achieve intersection logic with `IN`, `EXISTS`, or joins.

---

## Remember

> [!TIP]
> JOIN links tables by keys. Subquery nests logic. UNION stacks compatible results.

---

## Checkpoint Questions

1. Difference between `INNER JOIN` and `LEFT JOIN`?
2. When would you use `EXISTS`?
3. Why must `UNION` queries have matching column counts?

