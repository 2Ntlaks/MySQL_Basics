# Exercise 05: Home Affairs Database

## Scenario

The Department of Home Affairs needs a database to manage citizen records, identity documents, birth registrations, marriage records, and death records. Data integrity is critical — incorrect records can have legal consequences.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. Data integrity
2. `UNIQUE` constraint
3. One-to-One relationship
4. Transaction
5. ACID properties

---

## Part B: Table Design (25 marks)

Design the following tables with columns, datatypes, and constraints:

1. **citizen** — ID number (13 digits), first name, last name, date of birth, gender, nationality, is_alive (boolean)
2. **address** — citizen (FK), street, city, province, postal code, address type (residential/postal)
3. **identity_document** — citizen (FK), document number, issue date, expiry date, status (active/expired/lost)
4. **birth_record** — child citizen (FK), mother citizen (FK), father citizen (FK), date of birth, place of birth, hospital name
5. **marriage_record** — spouse 1 citizen (FK), spouse 2 citizen (FK), marriage date, marriage officer, venue, status (active/divorced)
6. **death_record** — citizen (FK), date of death, cause of death, place of death, reported by citizen (FK)

### Questions

1. What is the relationship between `citizen` and `identity_document`?
2. Why does `birth_record` have two foreign keys to `citizen` (mother and father)?
3. What should happen to the `identity_document` when a death record is created?
4. Why is `id_number` a good candidate for a `UNIQUE` constraint?
5. Should `id_number` be `VARCHAR` or `BIGINT`? Justify your choice.
6. How would you prevent a citizen from being married to themselves?

---

## Part C: SQL Implementation (40 marks)

### C1. Create all tables

```sql
-- Write your CREATE TABLE statements here
-- Pay special attention to constraints: CHECK, UNIQUE, NOT NULL, FK
```

### C2. Insert sample data

- At least 10 citizens (mix of alive and deceased)
- At least 8 identity documents
- At least 4 birth records
- At least 3 marriage records (at least one divorced)
- At least 2 death records
- At least 6 addresses

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. Find all living citizens sorted by last name.
2. List all citizens born in a specific province.
3. Show each citizen with their identity document details (use `JOIN`).
4. Find all citizens who do NOT have an identity document (use `LEFT JOIN`).
5. Count citizens per province.
6. Show all active marriages with both spouse names (requires joining `citizen` twice).
7. Find all citizens born between 1990 and 2000.
8. List citizens whose ID documents have expired (`expiry_date < CURDATE()`).
9. Show birth records with child name, mother name, and father name.
10. Find the province with the most registered citizens.
11. Count marriages per year (use `YEAR()` function).
12. Find all citizens whose last name starts with 'N' (use `LIKE`).

### C4. Self-Join Challenge

The `birth_record` table links children to parents. Write a query that shows:

- Child name
- Mother name
- Father name

This requires joining `citizen` three times. Explain how aliases help here.

---

## Part D: Transaction Exercise (15 marks)

Write a transaction for registering a death:

1. Insert a new `death_record`.
2. Update the citizen's `is_alive` to `FALSE`.
3. Update the citizen's identity document status to `'expired'`.
4. If the citizen is already recorded as dead, `ROLLBACK`.

```sql
-- Write your transaction here
```

Explain: What would go wrong if these were separate statements without a transaction?

---

## Part E: Reflection (10 marks)

1. Why is the South African ID number 13 digits, and why store it as `VARCHAR(13)` not `BIGINT`?
2. What are the consequences of poor data integrity in a Home Affairs system?
3. How would you redesign the `address` table to keep a history of previous addresses?
4. Why is this database more sensitive than a library or shop database?

---

## Marking Guide

| Criterion | Marks |
|---|---:|
| Term definitions | 10 |
| Table design quality | 25 |
| SQL correctness and completeness | 40 |
| Transaction logic | 15 |
| Reflection clarity | 10 |
| **Total** | **100** |
