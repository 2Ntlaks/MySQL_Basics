# 02. Tables, Rows, and Columns

## Learning Outcomes

After this lesson, you should be able to:

- Explain table, row, and column using both simple and technical language.
- Read a table structure and describe each field.
- Create a basic table in MySQL.

---

## Core Jargon

| Jargon | Also called | Meaning |
|---|---|---|
| Table | Relation | A set of related records with same structure |
| Row | Record, Tuple | One complete item in a table |
| Column | Field, Attribute | One property of every row |

---

## 1. Table

### Definition

A table is a structured set of data arranged in rows and columns.

### Plain-language meaning

Think of a table like a class register sheet: every student appears as one line, and each line has the same fields (student number, name, email).

### Example

`Student` table can contain:

- `student_id`
- `full_name`
- `email`
- `date_of_birth`

---

## 2. Row

### Definition

A row is a single record in a table.

### Plain-language meaning

A row is one full "thing" you are storing.

Example:

- One row in `Student` = one student
- One row in `Module` = one module

---

## 3. Column

### Definition

A column is a named field that stores one type of data for all rows.

### Plain-language meaning

A column is one question you ask for every record.

Examples:

- Student name?
- Student email?
- Date of birth?

---

## Visual Example

| student_id | full_name | email | date_of_birth |
|---:|---|---|---|
| 1 | Amahle Mokoena | amahle@uni.ac.za | 2005-03-14 |
| 2 | Lebo Ncube | lebo@uni.ac.za | 2004-11-02 |

Reading the table:

- There are `2 rows`.
- There are `4 columns`.
- `student_id` is a column.
- "Amahle Mokoena" row is one record.

---

## 4. Create a Table in MySQL

```sql
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  date_of_birth DATE
);
```

Breakdown:

- `student_id`: integer ID
- `full_name`: text up to 100 characters
- `NOT NULL`: must have a value
- `UNIQUE`: no duplicates
- `DATE`: date only (YYYY-MM-DD)

---

## 5. Naming Conventions

Recommended beginner rules:

1. Use lowercase table/column names.
2. Use underscore `_` instead of spaces.
3. Use singular table names (`student`, `module`) or plural consistently.
4. Use clear names (`date_of_birth`, not `dob2`).

---

## Common Mistakes

- Mixing different meanings in one column (e.g., name + phone in same column)
- Storing numbers as text unnecessarily
- Using vague column names like `value`, `data`, `info`
- Forgetting a primary key

---

## Remember

> [!TIP]
> Table = collection, Row = one item, Column = one property.

> [!TIP]
> Every column should have one clear purpose and one datatype.

---

## See Also

- [01 - Database Foundations](01-database-foundations.md) — what a database is
- [03 - Datatypes and Constraints](03-datatypes-and-constraints.md) — choosing types for each column

---

## Checkpoint Questions

1. What is the difference between row and column?
2. In a `module` table, what could be three useful columns?
3. Why should column names be clear and specific?

