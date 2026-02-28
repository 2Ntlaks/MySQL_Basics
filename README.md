# Database Systems with MySQL

Lecturer-style notes for undergraduate students with no database background.

> [!IMPORTANT]
> This repository starts from zero knowledge. Jargon is used, but every term is explained in plain language.

---

## Course Navigation

| Week | Topic | Notes |
|---|---|---|
| 0 | How to use this repo | [00 - How To Study](./notes/00-how-to-study.md) |
| 1 | Database foundations | [01 - Database Foundations](./notes/01-database-foundations.md) |
| 2 | Tables, rows, and columns | [02 - Tables, Rows, Columns](./notes/02-tables-rows-columns.md) |
| 3 | Datatypes and constraints | [03 - Datatypes and Constraints](./notes/03-datatypes-and-constraints.md) |
| 4 | Keys and relationships | [04 - Keys and Relationships](./notes/04-keys-and-relationships.md) |
| 5 | CRUD and basic SELECT | [05 - CRUD and Basic SELECT](./notes/05-crud-and-basic-select.md) |
| 6 | WHERE, GROUP BY, HAVING | [06 - Filtering and Grouping](./notes/06-filtering-grouping-having.md) |
| 7 | Joins, subqueries, UNION | [07 - Joins, Subqueries, UNION](./notes/07-joins-subqueries-and-union.md) |
| 8 | Transactions and integrity | [08 - Transactions and Integrity](./notes/08-transactions-and-data-integrity.md) |

Practice:

- [Exercises](./exercises/01-foundations-and-modeling.md)
- [Lab SQL Script](./sql/lab_schema.sql)

---

## Repository Structure

```text
MySQL_Basics/
|-- notes/
|   |-- 00-how-to-study.md
|   |-- 01-database-foundations.md
|   |-- 02-tables-rows-columns.md
|   |-- 03-datatypes-and-constraints.md
|   |-- 04-keys-and-relationships.md
|   |-- 05-crud-and-basic-select.md
|   |-- 06-filtering-grouping-having.md
|   |-- 07-joins-subqueries-and-union.md
|   |-- 08-transactions-and-data-integrity.md
|-- exercises/
|   |-- 01-foundations-and-modeling.md
|-- sql/
|   |-- lab_schema.sql
|-- README.md
```

---

## Learning Outcomes

By the end of this content, students should be able to:

1. Explain core database terms correctly.
2. Design basic tables with valid datatypes and constraints.
3. Build relationships using primary and foreign keys.
4. Write SQL for CRUD, filtering, grouping, joins, and subqueries.
5. Apply transactions to keep data consistent and safe.

---

## Teaching Style

Each lesson follows this pattern:

1. `Definition` (formal term)
2. `Plain-language meaning` (easy explanation)
3. `Example` (real-world context)
4. `SQL table structure/query`
5. `Remember` box

---

## Recommended Study Workflow

1. Read one notes file at a time.
2. Run SQL snippets in MySQL Workbench or CLI.
3. Complete exercises immediately after each topic.
4. Keep a glossary notebook of new jargon.

<details>
<summary><strong>Minimum software setup</strong></summary>

- MySQL Server 8.x
- MySQL Workbench (optional, but useful for beginners)
- A text editor (VS Code, Notepad++, or similar)

</details>
