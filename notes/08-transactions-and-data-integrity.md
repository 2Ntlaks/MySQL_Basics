# 08. Transactions and Data Integrity

## Learning Outcomes

After this lesson, you should be able to:

- Explain why transactions are needed.
- Use `START TRANSACTION`, `COMMIT`, and `ROLLBACK`.
- Understand data integrity in multi-step operations.

---

## 1. What is a Transaction?

### Definition

A transaction is a sequence of SQL operations treated as one logical unit.

### Plain-language meaning

Either all steps happen, or none happen.

This is important for:

- Fee payments
- Inventory updates
- Multi-table inserts

---

## 2. Core Commands

```sql
START TRANSACTION;

-- SQL statements here

COMMIT;   -- save changes permanently
-- or
ROLLBACK; -- undo all changes in this transaction
```

---

## 3. Example: Transfer Scenario

```sql
START TRANSACTION;

UPDATE account SET balance = balance - 500 WHERE account_id = 1;
UPDATE account SET balance = balance + 500 WHERE account_id = 2;

COMMIT;
```

If one update fails and you still commit partially, data becomes inconsistent.

---

## 4. Data Integrity

Data integrity means data remains accurate, valid, and consistent over time.

It is supported by:

- Correct datatypes
- Constraints
- Keys and relationships
- Transactions

---

## 5. Practical Safety Pattern

1. Start transaction
2. Run all related statements
3. Verify affected rows/results
4. Commit only if valid
5. Rollback on any error

---

## Remember

> [!TIP]
> Transactions protect you from half-completed operations.

---

## Checkpoint Questions

1. What problem does `ROLLBACK` solve?
2. Give one real-world scenario where transaction is required.
3. Why is integrity important in academic records?

