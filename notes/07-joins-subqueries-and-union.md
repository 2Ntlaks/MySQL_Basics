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

**Expected output (using lab data):**

| student_id | student_name | module_name |
|---:|---|---|
| 1 | Amahle Mokoena | Database Systems |
| 1 | Amahle Mokoena | Web Basics |
| 2 | Lebo Ncube | Database Systems |
| 3 | Sipho Dlamini | Database Systems |
| 3 | Sipho Dlamini | Programming Fundamentals |

> Only students **with** enrollments appear. If a student isn't enrolled in anything, they won't show up.

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

**Expected output:**

| department_id | department_name | lecturer_name |
|---:|---|---|
| 1 | Computer Science | Dr. Khumalo |
| 1 | Computer Science | Ms. Naidoo |
| 2 | Mathematics | Dr. Ndlovu |

> If a department had no lecturers, it would still appear with `NULL` in the lecturer_name column. That's the power of LEFT JOIN.

Use this when you want to keep rows even if related data is missing.

---

## 3.5 RIGHT JOIN

Returns all rows from the right table, and matches from the left table (if any).

```sql
SELECT
  d.name AS department_name,
  l.name AS lecturer_name
FROM department d
RIGHT JOIN lecturer l ON d.department_id = l.department_id;
```

**Expected output:**

| department_name | lecturer_name |
|---|---|
| Computer Science | Dr. Khumalo |
| Computer Science | Ms. Naidoo |
| Mathematics | Dr. Ndlovu |

> With this data, RIGHT JOIN and LEFT JOIN produce similar results because every lecturer belongs to a department. RIGHT JOIN would show its difference if a lecturer had a NULL department_id.

> [!NOTE]
> `RIGHT JOIN` is the mirror of `LEFT JOIN`. Most developers prefer rewriting as `LEFT JOIN` by swapping table order, but you should recognise both forms.

---

## 3.6 CROSS JOIN

Returns every combination of rows from both tables (Cartesian product).

```sql
SELECT s.name, m.name
FROM student s
CROSS JOIN module m;
```

**Expected output (3 students × 3 modules = 9 rows):**

| name | name |
|---|---|
| Amahle Mokoena | Database Systems |
| Amahle Mokoena | Web Basics |
| Amahle Mokoena | Programming Fundamentals |
| Lebo Ncube | Database Systems |
| Lebo Ncube | Web Basics |
| Lebo Ncube | Programming Fundamentals |
| Sipho Dlamini | Database Systems |
| Sipho Dlamini | Web Basics |
| Sipho Dlamini | Programming Fundamentals |

If `student` has 3 rows and `module` has 3 rows, you get 9 result rows.

> [!WARNING]
> `CROSS JOIN` can produce very large result sets. Use it only when you intentionally need all combinations.

---

## Join Comparison Summary

| Join Type | Returns |
|---|---|
| `INNER JOIN` | Only matching rows from both tables |
| `LEFT JOIN` | All left rows + matching right rows (NULL if no match) |
| `RIGHT JOIN` | All right rows + matching left rows (NULL if no match) |
| `CROSS JOIN` | Every combination of rows (no condition needed) |

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

**Expected output:**

| student_id |
|---:|
| 1 |
| 2 |
| 3 |

> All three students have enrollment records. If a student wasn't enrolled, they'd be excluded.

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

**Expected output:**

| email |
|---|
| amahle@uni.ac.za |
| lebo@uni.ac.za |
| sipho@uni.ac.za |
| khumalo@uni.ac.za |
| naidoo@uni.ac.za |
| ndlovu@uni.ac.za |

> All 6 unique emails from both tables combined into one list. Duplicates (if any) are removed automatically.

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

> [!TIP]
> When in doubt between LEFT and RIGHT JOIN, pick one direction and be consistent.

---

## See Also

- [04 - Keys and Relationships](04-keys-and-relationships.md) — foreign keys that joins rely on
- [06 - Filtering, Grouping, HAVING](06-filtering-grouping-having.md) — `WHERE`, `GROUP BY` used with joins

---

## Checkpoint Questions

1. Difference between `INNER JOIN` and `LEFT JOIN`?
2. When would you use `EXISTS`?
3. Why must `UNION` queries have matching column counts?
4. What does `RIGHT JOIN` return that `INNER JOIN` does not?
5. Why is `CROSS JOIN` dangerous on large tables?

