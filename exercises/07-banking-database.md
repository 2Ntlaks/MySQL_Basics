# Exercise 07: Banking Database

## Scenario

A bank needs a database to manage customers, accounts, transactions (deposits/withdrawals/transfers), branches, and staff. Accuracy is non-negotiable — every cent must be accounted for, and the system must handle concurrent operations safely.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. Atomicity
2. `ROLLBACK`
3. `DECIMAL(10,2)`
4. Referential integrity
5. `SAVEPOINT`

---

## Part B: Table Design (25 marks)

Design the following tables with columns, datatypes, and constraints:

1. **branch** — branch code, name, city, address, phone
2. **customer** — ID number, first name, last name, date of birth, phone, email, address
3. **account** — account number, customer (FK), branch (FK), account type (savings/cheque/fixed deposit), balance, opened date, status (active/frozen/closed)
4. **staff** — employee number, first name, last name, branch (FK), role (teller/manager), hire date
5. **transaction** — account (FK), transaction type (deposit/withdrawal/transfer), amount, transaction date, description, reference number
6. **transfer** — from account (FK), to account (FK), amount, transfer date, status (pending/completed/failed)

### Questions

1. Why must `balance` use `DECIMAL` and not `FLOAT`?
2. What `CHECK` constraints are critical for the `account` table?
3. Why does `transfer` need its own table when `transaction` already exists?
4. How would you ensure an account balance never goes negative?
5. What is the relationship between `customer` and `account`? Can one customer have multiple accounts?

---

## Part C: SQL Implementation (40 marks)

### C1. Create all tables

```sql
-- Write your CREATE TABLE statements here
-- Pay special attention to DECIMAL for all money columns
```

### C2. Insert sample data

- At least 3 branches
- At least 6 customers
- At least 10 accounts (multiple types, some customers with multiple accounts)
- At least 4 staff across branches
- At least 15 transactions
- At least 4 transfers

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. Show all accounts with their customer name and branch name (`JOIN`).
2. Find the total balance held at each branch.
3. List the top 5 customers by total balance across all their accounts.
4. Show all transactions for a specific account, ordered by date (newest first).
5. Calculate total deposits and total withdrawals per account.
6. Find customers who have accounts at more than one branch.
7. Show all frozen or closed accounts with customer details.
8. Find the average balance per account type (savings vs cheque).
9. Show monthly transaction volume (count and total amount) for the current year.
10. Find accounts with no transactions in the last 90 days (dormant accounts — use `DATEDIFF`).
11. List all transfers that failed.
12. Show a bank summary: total customers, total accounts, total balance, total transactions.

### C4. Balance verification

Write a query that compares:

- The account's stored `balance`
- The calculated balance from summing all transactions

These should match. If they don't, there's a data integrity problem.

---

## Part D: Transaction Exercise (15 marks)

### D1. Transfer between accounts

Write a transaction that transfers R1000 from Account A to Account B:

1. Check that Account A has sufficient balance.
2. Deduct R1000 from Account A.
3. Add R1000 to Account B.
4. Record both transactions in the `transaction` table.
5. Record the transfer in the `transfer` table.
6. If Account A has insufficient funds, `ROLLBACK`.

```sql
-- Write your transaction here
```

### D2. Explain

1. Why must this be atomic?
2. What would happen if the system crashed after step 2 but before step 3?
3. How does `COMMIT` protect against this?

---

## Part E: Reflection (10 marks)

1. Why are banking databases the classic example for learning transactions?
2. What is the danger of using `FLOAT` for Rand amounts?
3. How would you add support for interest calculation on savings accounts?
4. What audit trail features would a real bank need that this exercise does not cover?

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
