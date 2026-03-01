# 00. How To Study This Course

## Why this note exists

Database terms can feel heavy at first. This guide tells you how to study so you do not get lost.

---

## Study Method (Per Topic)

1. Read the `Definition` section slowly.
2. Re-read the `Plain-language meaning` section.
3. Copy the SQL into your own MySQL environment and run it.
4. Answer the checkpoint questions without looking at notes.
5. Explain the concept to a classmate in your own words.

---

## What to do when you see jargon

When you see a new term:

- Write the term exactly as is.
- Write one simple meaning.
- Write one technical meaning.
- Write one SQL example.

Template:

```text
Term:
Simple meaning:
Technical meaning:
SQL example:
```

---

## Learning Rules

> [!TIP]
> Never memorize SQL alone. Understand what problem the SQL is solving.

> [!TIP]
> Every table design decision should answer: "What real-world fact am I storing?"

> [!WARNING]
> If you skip fundamentals (table, row, column, datatype), joins and advanced queries will become confusing later.

---

## Progress Checklist

### Foundations (Weeks 1–4)

- [ ] I can explain what a database is.
- [ ] I can explain the difference between table, row, and column.
- [ ] I can choose an appropriate datatype for a field.
- [ ] I can explain and use constraints (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`).
- [ ] I can define primary key and foreign key.
- [ ] I can model 1:1, 1:N, and N:N relationships.

### Core SQL (Weeks 5–7)

- [ ] I can write `INSERT`, `UPDATE`, and `DELETE` with `WHERE`.
- [ ] I can write `SELECT` with `ORDER BY` and `LIMIT`.
- [ ] I can use `AUTO_INCREMENT` for primary keys.
- [ ] I can filter with `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL`.
- [ ] I can group data with `GROUP BY` and filter groups with `HAVING`.
- [ ] I can use aggregate functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.
- [ ] I can join tables using `INNER JOIN` and `LEFT JOIN`.
- [ ] I can write subqueries with `IN` and `EXISTS`.
- [ ] I can combine results with `UNION`.

### Advanced Topics (Weeks 8–10)

- [ ] I can use transactions: `START TRANSACTION`, `COMMIT`, `ROLLBACK`.
- [ ] I can define ACID and give examples.
- [ ] I can explain 1NF, 2NF, and 3NF.
- [ ] I can use string, date, and numeric functions.
- [ ] I can use `CASE` and `IF` for conditional logic.

