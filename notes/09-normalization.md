# 09. Normalization

## Learning Outcomes

After this lesson, you should be able to:

- Explain why normalization matters.
- Identify 1NF, 2NF, and 3NF violations.
- Restructure a poorly designed table into normalized form.

---

## 1. What is Normalization?

### Definition

Normalization is the process of organizing tables to reduce data redundancy and improve data integrity.

### Plain-language meaning

Normalization means splitting messy, repeated data into clean, focused tables that link together using keys.

### Why it matters

Without normalization:

- Data gets duplicated (wasted storage, inconsistency risk)
- Updates must change many rows instead of one
- Deleting one fact can accidentally destroy another

---

## 2. Before Normalization (Bad Example)

Imagine storing everything in one table:

| student_id | student_name | module_code | module_name | lecturer_name |
|---:|---|---|---|---|
| 1 | Amahle | DBS101 | Database Systems | Dr. Khumalo |
| 1 | Amahle | WBG101 | Web Basics | Ms. Naidoo |
| 2 | Lebo | DBS101 | Database Systems | Dr. Khumalo |

Problems:

- "Amahle" is stored twice.
- "Database Systems" is stored twice.
- If Dr. Khumalo changes name, you must update every row.
- If Lebo drops the module, you lose the module info too.

---

## 3. First Normal Form (1NF)

### Rule

Every column must contain **atomic** (single, indivisible) values. No repeating groups.

### Violation example

| student_id | name | modules |
|---:|---|---|
| 1 | Amahle | DBS101, WBG101 |

The `modules` column has multiple values — this violates 1NF.

### Fix

Each fact gets its own row:

| student_id | name | module |
|---:|---|---|
| 1 | Amahle | DBS101 |
| 1 | Amahle | WBG101 |

> [!TIP]
> 1NF = No lists or comma-separated values in a single cell.

---

## 4. Second Normal Form (2NF)

### Rule

Must be in 1NF **and** every non-key column must depend on the **entire** primary key (not just part of it).

### Violation example

Table with composite key `(student_id, module_code)`:

| student_id | module_code | student_name | module_name |
|---:|---|---|---|
| 1 | DBS101 | Amahle | Database Systems |

- `student_name` depends only on `student_id` (not the full key).
- `module_name` depends only on `module_code` (not the full key).

These are **partial dependencies**.

### Fix

Split into three tables:

**student** table:

| student_id | student_name |
|---:|---|
| 1 | Amahle |

**module** table:

| module_code | module_name |
|---|---|
| DBS101 | Database Systems |

**enrollment** table:

| student_id | module_code |
|---:|---|
| 1 | DBS101 |

> [!TIP]
> 2NF = No column should depend on only *part* of a composite key.

---

## 5. Third Normal Form (3NF)

### Rule

Must be in 2NF **and** no non-key column should depend on another non-key column.

### Violation example

| student_id | student_name | department_id | department_name |
|---:|---|---:|---|
| 1 | Amahle | 10 | Computer Science |

- `department_name` depends on `department_id`, not on `student_id`.

This is a **transitive dependency** (student → department_id → department_name).

### Fix

**student** table:

| student_id | student_name | department_id |
|---:|---|---:|
| 1 | Amahle | 10 |

**department** table:

| department_id | department_name |
|---:|---|
| 10 | Computer Science |

> [!TIP]
> 3NF = Every non-key column depends on the key, the whole key, and nothing but the key.

---

## 6. Quick Reference

| Normal Form | Rule | Fix |
|---|---|---|
| 1NF | No repeating groups / multi-value cells | One value per cell; one fact per row |
| 2NF | No partial dependency on composite key | Move partially dependent columns to own table |
| 3NF | No transitive dependency | Move transitively dependent columns to own table |

---

## 7. Practical Strategy

When designing a database from scratch:

1. List all the facts you need to store.
2. Group related facts into tables.
3. Assign a primary key to each table.
4. Check: does every column depend on the **whole** key and **nothing else**?
5. If not, split the table.

---

## Common Mistakes

- Storing comma-separated lists in one column (breaks 1NF)
- Duplicating names/descriptions across rows instead of using a foreign key (breaks 2NF/3NF)
- Over-normalizing to the point of needing too many joins (balance is key)
- Confusing normalization with "fewer columns" — it's about dependency, not size

---

## Remember

> [!TIP]
> The mantra: "The key, the whole key, and nothing but the key."

> [!TIP]
> Normalization reduces redundancy. Foreign keys reconnect the pieces.

---

## See Also

- [02 - Tables, Rows, Columns](02-tables-rows-columns.md) — table design basics
- [04 - Keys and Relationships](04-keys-and-relationships.md) — keys that normalization relies on

---

## Checkpoint Questions

1. What problem does normalization solve?
2. Give an example of a 1NF violation.
3. What is a partial dependency and which normal form does it violate?
4. What is a transitive dependency and which normal form does it violate?
5. Recite the 3NF mantra.
