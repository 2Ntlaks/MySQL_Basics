# 03. Datatypes and Constraints

## Learning Outcomes

After this lesson, you should be able to:

- Choose suitable datatypes for common fields.
- Explain why constraints are needed.
- Create tables with validation rules.

---

## 1. What is a Datatype?

### Definition

A datatype defines what kind of value a column can store.

### Plain-language meaning

A datatype is a rule that says what format is allowed in a column.

Examples:

- Age should be number
- Name should be text
- Birth date should be date

---

## 2. Common MySQL Datatypes

| Category | Datatype | Use case | Example |
|---|---|---|---|
| Integer | `INT` | IDs, counts | `25` |
| Decimal | `DECIMAL(10,2)` | Money values | `1250.50` |
| Text short | `VARCHAR(n)` | Names, emails | `Lerato` |
| Text long | `TEXT` | Descriptions, comments | Paragraph text |
| Date | `DATE` | Birthdays, deadlines | `2026-02-28` |
| Date-time | `DATETIME` | Timestamp events | `2026-02-28 10:30:00` |
| Boolean-like | `BOOLEAN` | True/false flags | `1` or `0` |

> [!NOTE]
> In MySQL, `BOOLEAN` is stored internally as tiny integer (`1` or `0`).

---

## 3. What are Constraints?

### Definition

Constraints are rules applied to columns to protect data quality.

### Plain-language meaning

Constraints prevent bad or invalid data from entering your table.

---

## 4. Most Important Constraints

| Constraint | Meaning | Why it matters |
|---|---|---|
| `PRIMARY KEY` | Unique identity per row | Prevents duplicate row identity |
| `NOT NULL` | Value required | Stops empty important fields |
| `UNIQUE` | No repeated values | Good for email, student number |
| `FOREIGN KEY` | Must exist in parent table | Preserves relationships |
| `DEFAULT` | Automatic fallback value | Reduces missing values |
| `CHECK` | Logical condition | Enforces custom rules |

---

## 5. SQL Example

```sql
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  student_number VARCHAR(20) UNIQUE NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE,
  age INT CHECK (age >= 16),
  registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

What this enforces:

- Each student has unique ID and student number.
- Name cannot be empty.
- Age cannot be less than 16.
- Registration time is auto-filled if omitted.

---

## 6. Datatype Selection Strategy

Before adding a column, ask:

1. What kind of value is this?
2. Maximum size needed?
3. Can it ever be empty?
4. Must it be unique?
5. Should there be a default value?

---

## Common Mistakes

- Using `VARCHAR(255)` for every text column without reason
- Storing money in `FLOAT` instead of `DECIMAL`
- Forgetting `NOT NULL` for required fields
- Not using `UNIQUE` where duplicates are invalid

---

## Remember

> [!TIP]
> Datatype controls format. Constraint controls validity.

> [!TIP]
> Good schema design prevents many application bugs later.

---

## Checkpoint Questions

1. Why is `DECIMAL(10,2)` better than `FLOAT` for money?
2. When should you use `NOT NULL`?
3. What problem does `UNIQUE` solve?

