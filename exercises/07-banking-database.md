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

---

## Solutions

> [!WARNING]
> Try to complete the exercise on your own before looking at the solutions below.

<details>
<summary><strong>Part A: Terminology Solutions</strong></summary>

1. **Atomicity**
   - Simple: All steps in a transaction happen together, or none of them happen.
   - Technical: The property of a transaction ensuring that all operations within it are treated as a single indivisible unit — either fully committed or fully rolled back.

2. **ROLLBACK**
   - Simple: Undo all changes made during the current transaction.
   - Technical: A command that reverses all modifications made since the last START TRANSACTION (or SAVEPOINT), restoring the database to its previous consistent state.

3. **DECIMAL(10,2)**
   - Simple: A number with up to 10 total digits and exactly 2 decimal places — perfect for money.
   - Technical: A fixed-point numeric type with precision 10 (total digits) and scale 2 (digits after decimal point), providing exact arithmetic without floating-point rounding errors.

4. **Referential integrity**
   - Simple: Every foreign key value must match an existing primary key in the referenced table.
   - Technical: A constraint ensuring that relationships between tables remain consistent — no orphan rows can exist where a foreign key points to a non-existent parent row.

5. **SAVEPOINT**
   - Simple: A bookmark inside a transaction that lets you undo part of the work without undoing all of it.
   - Technical: A named marker within a transaction that allows partial rollback to that point using ROLLBACK TO SAVEPOINT, without aborting the entire transaction.

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **DECIMAL not FLOAT:** FLOAT uses binary approximation — R99.99 could be stored as R99.9900000001. In banking, even a fraction of a cent matters. DECIMAL stores exact values.
2. **CHECK constraints on account:** `CHECK (balance >= 0)` (or allow negative for overdraft accounts), `CHECK (account_type IN ('savings', 'cheque', 'fixed deposit'))`, `CHECK (status IN ('active', 'frozen', 'closed'))`.
3. **Why transfer needs its own table:** A transfer involves two accounts. The `transaction` table records individual account-level movements. The `transfer` table captures the relationship between two transactions (debit from A, credit to B) and tracks the transfer status as a whole.
4. **Prevent negative balance:** Use `CHECK (balance >= 0)` on the account table. In a stored procedure, check the balance before deducting.
5. **Customer ↔ Account:** One-to-Many. One customer can have multiple accounts (savings + cheque). Each account belongs to one customer.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS bank_db;
USE bank_db;

CREATE TABLE branch (
  branch_id INT PRIMARY KEY AUTO_INCREMENT,
  branch_code VARCHAR(10) UNIQUE NOT NULL,
  name VARCHAR(60) NOT NULL,
  city VARCHAR(50) NOT NULL,
  address VARCHAR(150),
  phone VARCHAR(20)
);

CREATE TABLE customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  id_number VARCHAR(13) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(120) UNIQUE,
  address VARCHAR(150)
);

CREATE TABLE account (
  account_id INT PRIMARY KEY AUTO_INCREMENT,
  account_number VARCHAR(20) UNIQUE NOT NULL,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('savings', 'cheque', 'fixed deposit')),
  balance DECIMAL(15,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
  opened_date DATE NOT NULL DEFAULT (CURDATE()),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'frozen', 'closed')),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE staff (
  staff_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  branch_id INT NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('teller', 'manager')),
  hire_date DATE NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE transaction (
  transaction_id INT PRIMARY KEY AUTO_INCREMENT,
  account_id INT NOT NULL,
  transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer')),
  amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
  transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  description VARCHAR(200),
  reference_number VARCHAR(30) UNIQUE,
  FOREIGN KEY (account_id) REFERENCES account(account_id)
);

CREATE TABLE transfer (
  transfer_id INT PRIMARY KEY AUTO_INCREMENT,
  from_account_id INT NOT NULL,
  to_account_id INT NOT NULL,
  amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
  transfer_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  CHECK (from_account_id <> to_account_id),
  FOREIGN KEY (from_account_id) REFERENCES account(account_id),
  FOREIGN KEY (to_account_id) REFERENCES account(account_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO branch (branch_code, name, city, address, phone) VALUES
  ('JHB001', 'Johannesburg Central', 'Johannesburg', '100 Commissioner St', '0110001111'),
  ('CPT001', 'Cape Town Waterfront', 'Cape Town', '50 Dock Rd', '0210002222'),
  ('DBN001', 'Durban Beach', 'Durban', '25 Marine Parade', '0310003333');

INSERT INTO customer (id_number, first_name, last_name, date_of_birth, phone, email, address) VALUES
  ('9001015800081', 'Lerato', 'Mokoena', '1990-01-01', '0712345678', 'lerato@mail.com', '12 Mandela St, JHB'),
  ('8805125800082', 'Thabo', 'Ndlovu', '1988-05-12', '0723456789', 'thabo@mail.com', '45 Sisulu Ave, PTA'),
  ('7503085800083', 'Nomsa', 'Khumalo', '1975-03-08', '0734567890', 'nomsa@mail.com', '78 Biko Rd, DBN'),
  ('9512205800084', 'Zanele', 'Dlamini', '1995-12-20', '0745678901', 'zanele@mail.com', '23 Hani Cres, CPT'),
  ('0003145800085', 'Kabelo', 'Sithole', '2000-03-14', '0756789012', 'kabelo@mail.com', '10 Tambo Lane, BFN'),
  ('8511225800086', 'Palesa', 'Molefe', '1985-11-22', '0767890123', 'palesa@mail.com', '5 Luthuli St, JHB');

INSERT INTO account (account_number, customer_id, branch_id, account_type, balance, opened_date, status) VALUES
  ('ACC-001-SAV', 1, 1, 'savings', 15000.00, '2022-03-15', 'active'),
  ('ACC-001-CHQ', 1, 1, 'cheque', 5200.50, '2022-03-15', 'active'),
  ('ACC-002-SAV', 2, 1, 'savings', 8500.00, '2023-01-10', 'active'),
  ('ACC-003-SAV', 3, 3, 'savings', 32000.00, '2020-06-01', 'active'),
  ('ACC-003-FD', 3, 3, 'fixed deposit', 100000.00, '2021-01-01', 'active'),
  ('ACC-004-SAV', 4, 2, 'savings', 2100.75, '2024-07-20', 'active'),
  ('ACC-004-CHQ', 4, 2, 'cheque', 500.00, '2024-07-20', 'frozen'),
  ('ACC-005-SAV', 5, 1, 'savings', 750.00, '2025-11-01', 'active'),
  ('ACC-006-SAV', 6, 1, 'savings', 18500.00, '2021-09-14', 'active'),
  ('ACC-006-CHQ', 6, 2, 'cheque', 4200.00, '2023-05-10', 'active');

INSERT INTO staff (employee_number, first_name, last_name, branch_id, role, hire_date) VALUES
  ('E001', 'Bongani', 'Mahlangu', 1, 'manager', '2018-01-15'),
  ('E002', 'Sipho', 'Nkosi', 1, 'teller', '2022-06-01'),
  ('E003', 'Fatima', 'Ahmed', 2, 'teller', '2023-03-10'),
  ('E004', 'James', 'Botha', 3, 'manager', '2019-08-20');

INSERT INTO transaction (account_id, transaction_type, amount, transaction_date, description, reference_number) VALUES
  (1, 'deposit', 5000.00, '2026-01-05 09:15:00', 'Salary deposit', 'REF-001'),
  (1, 'withdrawal', 1500.00, '2026-01-10 14:30:00', 'ATM withdrawal', 'REF-002'),
  (2, 'deposit', 2000.00, '2026-01-15 10:00:00', 'Transfer from savings', 'REF-003'),
  (3, 'deposit', 3000.00, '2026-01-20 08:45:00', 'Salary deposit', 'REF-004'),
  (3, 'withdrawal', 500.00, '2026-01-25 16:00:00', 'POS purchase', 'REF-005'),
  (4, 'deposit', 10000.00, '2026-02-01 09:00:00', 'Investment return', 'REF-006'),
  (6, 'deposit', 1500.00, '2026-02-05 11:30:00', 'Cash deposit', 'REF-007'),
  (1, 'transfer', 1000.00, '2026-02-10 13:00:00', 'Transfer to Thabo', 'REF-008'),
  (3, 'transfer', 1000.00, '2026-02-10 13:00:00', 'Transfer from Lerato', 'REF-009'),
  (9, 'deposit', 8000.00, '2026-02-12 10:15:00', 'Salary deposit', 'REF-010'),
  (9, 'withdrawal', 2500.00, '2026-02-15 15:45:00', 'Bill payment', 'REF-011'),
  (8, 'deposit', 500.00, '2026-02-18 09:30:00', 'Birthday money', 'REF-012'),
  (4, 'withdrawal', 3000.00, '2026-02-20 14:00:00', 'Medical expenses', 'REF-013'),
  (10, 'deposit', 1200.00, '2026-02-22 11:00:00', 'Freelance payment', 'REF-014'),
  (6, 'withdrawal', 800.00, '2026-02-25 16:30:00', 'Grocery shopping', 'REF-015');

INSERT INTO transfer (from_account_id, to_account_id, amount, transfer_date, status) VALUES
  (1, 3, 1000.00, '2026-02-10 13:00:00', 'completed'),
  (9, 10, 500.00, '2026-02-15 10:00:00', 'completed'),
  (6, 8, 200.00, '2026-02-20 09:00:00', 'completed'),
  (8, 1, 5000.00, '2026-02-25 14:00:00', 'failed');
```

### C3. Queries

**1. All accounts with customer and branch names:**

```sql
SELECT
  a.account_number,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  a.account_type,
  a.balance,
  b.name AS branch_name,
  a.status
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
INNER JOIN branch b ON a.branch_id = b.branch_id;
```

**Expected output (10 rows):**

| account_number | customer_name | account_type | balance | branch_name | status |
|---|---|---|---:|---|---|
| ACC-001-SAV | Lerato Mokoena | savings | 15000.00 | Johannesburg Central | active |
| ACC-001-CHQ | Lerato Mokoena | cheque | 5200.50 | Johannesburg Central | active |
| ACC-002-SAV | Thabo Ndlovu | savings | 8500.00 | Johannesburg Central | active |
| ACC-003-SAV | Nomsa Khumalo | savings | 32000.00 | Durban Beach | active |
| ACC-003-FD | Nomsa Khumalo | fixed deposit | 100000.00 | Durban Beach | active |
| ACC-004-SAV | Zanele Dlamini | savings | 2100.75 | Cape Town Waterfront | active |
| ACC-004-CHQ | Zanele Dlamini | cheque | 500.00 | Cape Town Waterfront | frozen |
| ACC-005-SAV | Kabelo Sithole | savings | 750.00 | Johannesburg Central | active |
| ACC-006-SAV | Palesa Molefe | savings | 18500.00 | Johannesburg Central | active |
| ACC-006-CHQ | Palesa Molefe | cheque | 4200.00 | Cape Town Waterfront | active |

> Lerato, Nomsa, Zanele, and Palesa each have 2 accounts.

**2. Total balance per branch:**

```sql
SELECT
  b.name AS branch_name,
  SUM(a.balance) AS total_balance
FROM account a
INNER JOIN branch b ON a.branch_id = b.branch_id
WHERE a.status = 'active'
GROUP BY b.branch_id, b.name
ORDER BY total_balance DESC;
```

**Expected output:**

| branch_name | total_balance |
|---|---:|
| Durban Beach | 132000.00 |
| Johannesburg Central | 47950.50 |
| Cape Town Waterfront | 6300.75 |

> Durban leads because of Nomsa's R100,000 fixed deposit. Zanele's frozen cheque (R500) is excluded.

**3. Top 5 customers by total balance:**

```sql
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  SUM(a.balance) AS total_balance
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
WHERE a.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_balance DESC
LIMIT 5;
```

**Expected output:**

| customer_name | total_balance |
|---|---:|
| Nomsa Khumalo | 132000.00 |
| Palesa Molefe | 22700.00 |
| Lerato Mokoena | 20200.50 |
| Thabo Ndlovu | 8500.00 |
| Zanele Dlamini | 2100.75 |

**4. Transactions for a specific account, newest first:**

```sql
SELECT * FROM transaction
WHERE account_id = 1
ORDER BY transaction_date DESC;
```

**Expected output:**

| transaction_id | account_id | transaction_type | amount | transaction_date | description | reference_number |
|---:|---:|---|---:|---|---|---|
| 8 | 1 | transfer | 1000.00 | 2026-02-10 13:00:00 | Transfer to Thabo | REF-008 |
| 2 | 1 | withdrawal | 1500.00 | 2026-01-10 14:30:00 | ATM withdrawal | REF-002 |
| 1 | 1 | deposit | 5000.00 | 2026-01-05 09:15:00 | Salary deposit | REF-001 |

> Three transactions for Account 1 (Lerato's savings), newest first.

**5. Total deposits and withdrawals per account:**

```sql
SELECT
  a.account_number,
  SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) AS total_deposits,
  SUM(CASE WHEN t.transaction_type = 'withdrawal' THEN t.amount ELSE 0 END) AS total_withdrawals
FROM transaction t
INNER JOIN account a ON t.account_id = a.account_id
GROUP BY a.account_id, a.account_number;
```

**Expected output:**

| account_number | total_deposits | total_withdrawals |
|---|---:|---:|
| ACC-001-SAV | 5000.00 | 1500.00 |
| ACC-001-CHQ | 2000.00 | 0.00 |
| ACC-002-SAV | 3000.00 | 500.00 |
| ACC-003-SAV | 10000.00 | 3000.00 |
| ACC-004-SAV | 1500.00 | 800.00 |
| ACC-005-SAV | 500.00 | 0.00 |
| ACC-006-SAV | 8000.00 | 2500.00 |
| ACC-006-CHQ | 1200.00 | 0.00 |

> Transfer-type transactions don't appear in either column — only deposits and withdrawals.

**6. Customers with accounts at more than one branch:**

```sql
SELECT
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  COUNT(DISTINCT a.branch_id) AS branch_count
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT a.branch_id) > 1;
```

**Expected output:**

| customer_name | branch_count |
|---|---:|
| Palesa Molefe | 2 |

> Palesa has accounts at both Johannesburg Central and Cape Town Waterfront.

**7. Frozen or closed accounts with customer details:**

```sql
SELECT
  a.account_number,
  a.account_type,
  a.status,
  a.balance,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
WHERE a.status IN ('frozen', 'closed');
```

**Expected output:**

| account_number | account_type | status | balance | customer_name |
|---|---|---|---:|---|
| ACC-004-CHQ | cheque | frozen | 500.00 | Zanele Dlamini |

> Only one account is frozen. No accounts are closed.

**8. Average balance per account type:**

```sql
SELECT
  account_type,
  ROUND(AVG(balance), 2) AS avg_balance
FROM account
WHERE status = 'active'
GROUP BY account_type;
```

**Expected output:**

| account_type | avg_balance |
|---|---:|
| savings | 12808.46 |
| cheque | 4700.25 |
| fixed deposit | 100000.00 |

> Fixed deposit has the highest average because it's a long-term investment product.

**9. Monthly transaction volume (current year):**

```sql
SELECT
  MONTH(transaction_date) AS month,
  COUNT(*) AS transaction_count,
  SUM(amount) AS total_amount
FROM transaction
WHERE YEAR(transaction_date) = 2026
GROUP BY MONTH(transaction_date)
ORDER BY month;
```

**Expected output:**

| month | transaction_count | total_amount |
|---:|---:|---:|
| 1 | 5 | 12000.00 |
| 2 | 10 | 29500.00 |

> February is busier with double the transactions.

**10. Dormant accounts (no transactions in last 90 days):**

```sql
SELECT
  a.account_number,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  MAX(t.transaction_date) AS last_transaction
FROM account a
INNER JOIN customer c ON a.customer_id = c.customer_id
LEFT JOIN transaction t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_number, c.first_name, c.last_name
HAVING MAX(t.transaction_date) IS NULL
   OR DATEDIFF(CURDATE(), MAX(t.transaction_date)) > 90;
```

**Expected output (depends on current date — if run in mid-2026):**

| account_number | customer_name | last_transaction |
|---|---|---|
| ACC-003-FD | Nomsa Khumalo | NULL |
| ACC-004-CHQ | Zanele Dlamini | NULL |

> These two accounts have zero transactions. Other accounts may appear if >90 days have passed since their last transaction.

**11. Failed transfers:**

```sql
SELECT
  t.transfer_id,
  a1.account_number AS from_account,
  a2.account_number AS to_account,
  t.amount,
  t.transfer_date,
  t.status
FROM transfer t
INNER JOIN account a1 ON t.from_account_id = a1.account_id
INNER JOIN account a2 ON t.to_account_id = a2.account_id
WHERE t.status = 'failed';
```

**Expected output:**

| transfer_id | from_account | to_account | amount | transfer_date | status |
|---:|---|---|---:|---|---|
| 4 | ACC-005-SAV | ACC-001-SAV | 5000.00 | 2026-02-25 14:00:00 | failed |

> Kabelo's account (ACC-005-SAV) only has R750 — insufficient for a R5000 transfer.

**12. Bank summary:**

```sql
SELECT
  (SELECT COUNT(*) FROM customer) AS total_customers,
  (SELECT COUNT(*) FROM account) AS total_accounts,
  (SELECT SUM(balance) FROM account WHERE status = 'active') AS total_balance,
  (SELECT COUNT(*) FROM transaction) AS total_transactions;
```

**Expected output:**

| total_customers | total_accounts | total_balance | total_transactions |
|---:|---:|---:|---:|
| 6 | 10 | 186251.25 | 15 |

### C4. Balance verification

```sql
SELECT
  a.account_number,
  a.balance AS stored_balance,
  COALESCE(SUM(CASE
    WHEN t.transaction_type = 'deposit' THEN t.amount
    WHEN t.transaction_type IN ('withdrawal', 'transfer') THEN -t.amount
    ELSE 0
  END), 0) AS calculated_net_change
FROM account a
LEFT JOIN transaction t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_number, a.balance;
```

> **Note:** The calculated_net_change shows the net effect of transactions. The stored balance should equal the opening balance plus this net change. If they don't match, there's a data integrity issue.

</details>

<details>
<summary><strong>Part D: Transaction Solutions</strong></summary>

### D1. Transfer between accounts

```sql
START TRANSACTION;

-- Check Account A's balance (account_id = 1)
SELECT balance INTO @balance_a FROM account WHERE account_id = 1 FOR UPDATE;

-- Check sufficient funds
-- In a stored procedure: IF @balance_a < 1000 THEN ROLLBACK;

-- Step 1: Deduct from Account A
UPDATE account SET balance = balance - 1000 WHERE account_id = 1;

-- Step 2: Add to Account B
UPDATE account SET balance = balance + 1000 WHERE account_id = 3;

-- Step 3: Record withdrawal transaction for Account A
INSERT INTO transaction (account_id, transaction_type, amount, description, reference_number)
VALUES (1, 'transfer', 1000.00, 'Transfer to ACC-002-SAV', 'TRF-001-OUT');

-- Step 4: Record deposit transaction for Account B
INSERT INTO transaction (account_id, transaction_type, amount, description, reference_number)
VALUES (3, 'transfer', 1000.00, 'Transfer from ACC-001-SAV', 'TRF-001-IN');

-- Step 5: Record the transfer
INSERT INTO transfer (from_account_id, to_account_id, amount, status)
VALUES (1, 3, 1000.00, 'completed');

COMMIT;
```

### D2. Explanations

1. **Why atomic:** The debit and credit are two halves of one operation. If only the debit succeeds, R1000 disappears — the sender loses money that the receiver never gets.

2. **Crash after step 2 but before step 3:** Account A has R1000 less, but Account B hasn't received it. The total money in the bank has decreased by R1000. This is a catastrophic integrity failure.

3. **How COMMIT protects:** Until COMMIT is called, none of the changes are permanently saved. If the system crashes before COMMIT, the ROLLBACK happens automatically on recovery, restoring both accounts to their original balances.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **Why banking is the classic transaction example:** Because financial operations are naturally paired (every debit has a corresponding credit). Partial completion means money is created or destroyed, which is the clearest illustration of why atomicity matters.

2. **Danger of FLOAT for Rands:** FLOAT uses binary representation. `0.1` in binary is a repeating fraction, so `0.1 + 0.2` might equal `0.30000000000000004`. Over millions of transactions, these tiny errors accumulate into real financial discrepancies.

3. **Interest calculation:** Add columns `interest_rate DECIMAL(5,4)` and `last_interest_date DATE` to the account table. Create a scheduled job or stored procedure that calculates `balance * (interest_rate / 12)` monthly and inserts a deposit transaction.

4. **Audit trail features:** Real banks need: who performed each transaction (staff_id), IP address/terminal, timestamp with timezone, before/after balances, approval chains for large transactions, and immutable audit logs that cannot be deleted or modified.

</details>
