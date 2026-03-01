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

## 4. ACID Properties

Transactions follow four guarantees known as **ACID**:

| Property | Meaning | Example |
|---|---|---|
| **Atomicity** | All or nothing | If one UPDATE fails, the whole transaction rolls back |
| **Consistency** | Database stays valid | Constraints, keys, and rules are always satisfied |
| **Isolation** | Transactions don't interfere | Two users transferring money at the same time don't corrupt balances |
| **Durability** | Committed data survives crashes | Once `COMMIT` runs, the data is permanently saved |

> [!IMPORTANT]
> ACID is a core exam concept. Be able to define each letter and give a practical example.

---

## 5. Data Integrity

Data integrity means data remains accurate, valid, and consistent over time.

It is supported by:

- Correct datatypes
- Constraints
- Keys and relationships
- Transactions (ACID)

---

## 6. Practical Safety Pattern

1. Start transaction
2. Run all related statements
3. Verify affected rows/results
4. Commit only if valid
5. Rollback on any error

```sql
START TRANSACTION;

UPDATE account SET balance = balance - 500 WHERE account_id = 1;
UPDATE account SET balance = balance + 500 WHERE account_id = 2;

-- Check: did both rows update?
-- If yes:
COMMIT;
-- If something went wrong:
-- ROLLBACK;
```

---

## 7. SAVEPOINT (Advanced)

A `SAVEPOINT` lets you partially rollback inside a transaction.

```sql
START TRANSACTION;

INSERT INTO orders (order_id, customer_id) VALUES (101, 5);
SAVEPOINT after_order;

INSERT INTO order_items (order_id, product_id, qty) VALUES (101, 1, 2);
-- Oops, wrong product:
ROLLBACK TO after_order;

-- Fix and re-insert:
INSERT INTO order_items (order_id, product_id, qty) VALUES (101, 3, 2);

COMMIT;
```

---

## Remember

> [!TIP]
> Transactions protect you from half-completed operations.

> [!TIP]
> ACID = Atomicity, Consistency, Isolation, Durability. Memorize this.

---

## See Also

- [03 - Datatypes and Constraints](03-datatypes-and-constraints.md) — constraints that support integrity
- [04 - Keys and Relationships](04-keys-and-relationships.md) — foreign keys enforce referential integrity

---

## Checkpoint Questions

1. What problem does `ROLLBACK` solve?
2. Give one real-world scenario where transaction is required.
3. Why is integrity important in academic records?
4. What does each letter in ACID stand for?
5. What is the difference between `ROLLBACK` and `ROLLBACK TO SAVEPOINT`?

