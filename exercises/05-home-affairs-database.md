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
2. List all citizens who live in a specific province (by residential address).
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

---

## Solutions

> [!WARNING]
> Try to complete the exercise on your own before looking at the solutions below.

<details>
<summary><strong>Part A: Terminology Solutions</strong></summary>

1. **Data integrity**
   - Simple: Data integrity means your data is correct, complete, and consistent at all times.
   - Technical: The assurance that data remains accurate and consistent throughout its lifecycle, enforced by constraints, keys, and transactions.

2. **UNIQUE constraint**
   - Simple: A UNIQUE constraint prevents duplicate values in a column.
   - Technical: A constraint that enforces distinct values across all rows for a given column (or combination of columns); NULLs may be allowed depending on the DBMS.

3. **One-to-One relationship**
   - Simple: One record in table A matches exactly one record in table B.
   - Technical: A relationship where each entity instance in A maps to at most one instance in B, implemented using a foreign key with a UNIQUE constraint.

4. **Transaction**
   - Simple: A transaction is a group of SQL operations that either all succeed or all fail together.
   - Technical: A logical unit of work that satisfies the ACID properties (Atomicity, Consistency, Isolation, Durability), committed or rolled back as a whole.

5. **ACID properties**
   - Simple: ACID is a set of four rules that guarantee database transactions are processed reliably.
   - Technical: Atomicity (all or nothing), Consistency (valid state to valid state), Isolation (concurrent transactions don't interfere), Durability (committed data survives crashes).

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **citizen → identity_document** = One-to-One (each citizen gets one active ID document; enforced by UNIQUE on citizen FK).
2. **birth_record has two FKs to citizen:** Because both the mother and father are citizens. Each FK references the same `citizen` table but represents a different role.
3. **When a death record is created:** The identity document status should be updated to 'expired'. This is best done inside a transaction.
4. **id_number UNIQUE:** Every South African citizen has a unique 13-digit ID number. No two people should share one.
5. **VARCHAR(13) vs BIGINT:** Use VARCHAR(13). ID numbers can have leading zeros, and you never do arithmetic on them. VARCHAR preserves format exactly.
6. **Prevent self-marriage:** Add a CHECK constraint: `CHECK (spouse1_citizen_id <> spouse2_citizen_id)`.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS home_affairs_db;
USE home_affairs_db;

CREATE TABLE citizen (
  citizen_id INT PRIMARY KEY AUTO_INCREMENT,
  id_number VARCHAR(13) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F')),
  nationality VARCHAR(50) DEFAULT 'South African',
  is_alive BOOLEAN DEFAULT TRUE
);

CREATE TABLE address (
  address_id INT PRIMARY KEY AUTO_INCREMENT,
  citizen_id INT NOT NULL,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  province VARCHAR(50) NOT NULL,
  postal_code VARCHAR(10),
  address_type VARCHAR(20) NOT NULL CHECK (address_type IN ('residential', 'postal')),
  FOREIGN KEY (citizen_id) REFERENCES citizen(citizen_id)
);

CREATE TABLE identity_document (
  document_id INT PRIMARY KEY AUTO_INCREMENT,
  citizen_id INT UNIQUE NOT NULL,
  document_number VARCHAR(30) UNIQUE NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'lost')),
  FOREIGN KEY (citizen_id) REFERENCES citizen(citizen_id)
);

CREATE TABLE birth_record (
  birth_id INT PRIMARY KEY AUTO_INCREMENT,
  child_citizen_id INT NOT NULL,
  mother_citizen_id INT,
  father_citizen_id INT,
  date_of_birth DATE NOT NULL,
  place_of_birth VARCHAR(100),
  hospital_name VARCHAR(100),
  FOREIGN KEY (child_citizen_id) REFERENCES citizen(citizen_id),
  FOREIGN KEY (mother_citizen_id) REFERENCES citizen(citizen_id),
  FOREIGN KEY (father_citizen_id) REFERENCES citizen(citizen_id)
);

CREATE TABLE marriage_record (
  marriage_id INT PRIMARY KEY AUTO_INCREMENT,
  spouse1_citizen_id INT NOT NULL,
  spouse2_citizen_id INT NOT NULL,
  marriage_date DATE NOT NULL,
  marriage_officer VARCHAR(100),
  venue VARCHAR(100),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'divorced')),
  CHECK (spouse1_citizen_id <> spouse2_citizen_id),
  FOREIGN KEY (spouse1_citizen_id) REFERENCES citizen(citizen_id),
  FOREIGN KEY (spouse2_citizen_id) REFERENCES citizen(citizen_id)
);

CREATE TABLE death_record (
  death_id INT PRIMARY KEY AUTO_INCREMENT,
  citizen_id INT NOT NULL,
  date_of_death DATE NOT NULL,
  cause_of_death VARCHAR(200),
  place_of_death VARCHAR(100),
  reported_by_citizen_id INT,
  FOREIGN KEY (citizen_id) REFERENCES citizen(citizen_id),
  FOREIGN KEY (reported_by_citizen_id) REFERENCES citizen(citizen_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO citizen (id_number, first_name, last_name, date_of_birth, gender, nationality, is_alive) VALUES
  ('9001015800081', 'Lerato', 'Mokoena', '1990-01-01', 'F', 'South African', TRUE),
  ('8805125800082', 'Thabo', 'Ndlovu', '1988-05-12', 'M', 'South African', TRUE),
  ('7503085800083', 'Nomsa', 'Khumalo', '1975-03-08', 'F', 'South African', TRUE),
  ('7008155800084', 'Sipho', 'Nkosi', '1970-08-15', 'M', 'South African', FALSE),
  ('9512205800085', 'Zanele', 'Dlamini', '1995-12-20', 'F', 'South African', TRUE),
  ('0003145800086', 'Kabelo', 'Sithole', '2000-03-14', 'M', 'South African', TRUE),
  ('0510015800087', 'Naledi', 'Mahlangu', '2005-10-01', 'F', 'South African', TRUE),
  ('5006205800088', 'Joseph', 'Moyo', '1950-06-20', 'M', 'South African', FALSE),
  ('9208115800089', 'Palesa', 'Molefe', '1992-08-11', 'F', 'South African', TRUE),
  ('8511225800090', 'Bongani', 'Van Wyk', '1985-11-22', 'M', 'South African', TRUE);

INSERT INTO address (citizen_id, street, city, province, postal_code, address_type) VALUES
  (1, '12 Mandela St', 'Johannesburg', 'Gauteng', '2001', 'residential'),
  (2, '45 Sisulu Ave', 'Pretoria', 'Gauteng', '0001', 'residential'),
  (3, '78 Biko Rd', 'Durban', 'KwaZulu-Natal', '4001', 'residential'),
  (5, '23 Hani Cres', 'Cape Town', 'Western Cape', '8001', 'residential'),
  (6, '10 Tambo Lane', 'Bloemfontein', 'Free State', '9301', 'residential'),
  (1, 'PO Box 1234', 'Johannesburg', 'Gauteng', '2000', 'postal');

INSERT INTO identity_document (citizen_id, document_number, issue_date, expiry_date, status) VALUES
  (1, 'ID-900101-001', '2016-03-15', '2026-03-15', 'active'),
  (2, 'ID-880512-002', '2014-07-20', '2024-07-20', 'expired'),
  (3, 'ID-750308-003', '2020-01-10', '2030-01-10', 'active'),
  (4, 'ID-700815-004', '2010-05-05', '2020-05-05', 'expired'),
  (5, 'ID-951220-005', '2021-12-01', '2031-12-01', 'active'),
  (6, 'ID-000314-006', '2026-01-20', '2036-01-20', 'active'),
  (9, 'ID-920811-009', '2018-09-14', '2028-09-14', 'active'),
  (10, 'ID-851122-010', '2019-04-30', '2029-04-30', 'active');

INSERT INTO birth_record (child_citizen_id, mother_citizen_id, father_citizen_id, date_of_birth, place_of_birth, hospital_name) VALUES
  (6, 1, 2, '2000-03-14', 'Johannesburg', 'Chris Hani Baragwanath'),
  (7, 3, 4, '2005-10-01', 'Durban', 'Inkosi Albert Luthuli'),
  (1, 3, 4, '1990-01-01', 'Durban', 'King Edward VIII'),
  (5, NULL, NULL, '1995-12-20', 'Cape Town', 'Groote Schuur');

INSERT INTO marriage_record (spouse1_citizen_id, spouse2_citizen_id, marriage_date, marriage_officer, venue, status) VALUES
  (1, 2, '2018-12-15', 'Rev. Moyo', 'Johannesburg City Hall', 'active'),
  (3, 4, '1998-06-22', 'Rev. Pillay', 'Durban Court', 'active'),
  (9, 10, '2022-03-01', 'Rev. Naidoo', 'Cape Town Gardens', 'divorced');

INSERT INTO death_record (citizen_id, date_of_death, cause_of_death, place_of_death, reported_by_citizen_id) VALUES
  (4, '2023-11-10', 'Natural causes', 'Durban', 3),
  (8, '2024-06-15', 'Natural causes', 'Johannesburg', 1);
```

### C3. Queries

**1. All living citizens sorted by last name:**

```sql
SELECT * FROM citizen WHERE is_alive = TRUE ORDER BY last_name ASC;
```

**Expected output:**

| citizen_id | id_number | first_name | last_name | date_of_birth | gender | nationality | is_alive |
|---:|---|---|---|---|---:|---|---:|
| 5 | 9512205800085 | Zanele | Dlamini | 1995-12-20 | F | South African | 1 |
| 3 | 7503085800083 | Nomsa | Khumalo | 1975-03-08 | F | South African | 1 |
| 7 | 0510015800087 | Naledi | Mahlangu | 2005-10-01 | F | South African | 1 |
| 1 | 9001015800081 | Lerato | Mokoena | 1990-01-01 | F | South African | 1 |
| 9 | 9208115800089 | Palesa | Molefe | 1992-08-11 | F | South African | 1 |
| 2 | 8805125800082 | Thabo | Ndlovu | 1988-05-12 | M | South African | 1 |
| 6 | 0003145800086 | Kabelo | Sithole | 2000-03-14 | M | South African | 1 |
| 10 | 8511225800090 | Bongani | Van Wyk | 1985-11-22 | M | South African | 1 |

> 8 of 10 citizens are alive. Sipho Nkosi and Joseph Moyo are excluded.

**2. Citizens who live in a specific province (by residential address):**

```sql
SELECT c.first_name, c.last_name, a.province
FROM citizen c
INNER JOIN address a ON c.citizen_id = a.citizen_id
WHERE a.province = 'Gauteng' AND a.address_type = 'residential';
```

**Expected output:**

| first_name | last_name | province |
|---|---|---|
| Lerato | Mokoena | Gauteng |
| Thabo | Ndlovu | Gauteng |

> Only residential addresses are counted. Lerato's postal address is also in Gauteng but filtered out.

**3. Each citizen with their ID document details:**

```sql
SELECT
  c.first_name,
  c.last_name,
  c.id_number,
  id.document_number,
  id.issue_date,
  id.expiry_date,
  id.status
FROM citizen c
INNER JOIN identity_document id ON c.citizen_id = id.citizen_id;
```

**Expected output:**

| first_name | last_name | id_number | document_number | issue_date | expiry_date | status |
|---|---|---|---|---|---|---|
| Lerato | Mokoena | 9001015800081 | ID-900101-001 | 2016-03-15 | 2026-03-15 | active |
| Thabo | Ndlovu | 8805125800082 | ID-880512-002 | 2014-07-20 | 2024-07-20 | expired |
| Nomsa | Khumalo | 7503085800083 | ID-750308-003 | 2020-01-10 | 2030-01-10 | active |
| Sipho | Nkosi | 7008155800084 | ID-700815-004 | 2010-05-05 | 2020-05-05 | expired |
| Zanele | Dlamini | 9512205800085 | ID-951220-005 | 2021-12-01 | 2031-12-01 | active |
| Kabelo | Sithole | 0003145800086 | ID-000314-006 | 2026-01-20 | 2036-01-20 | active |
| Palesa | Molefe | 9208115800089 | ID-920811-009 | 2018-09-14 | 2028-09-14 | active |
| Bongani | Van Wyk | 8511225800090 | ID-851122-010 | 2019-04-30 | 2029-04-30 | active |

> 8 rows — citizens 7 (Naledi) and 8 (Joseph) don't have ID documents.

**4. Citizens without an ID document:**

```sql
SELECT c.first_name, c.last_name, c.id_number
FROM citizen c
LEFT JOIN identity_document id ON c.citizen_id = id.citizen_id
WHERE id.document_id IS NULL;
```

**Expected output:**

| first_name | last_name | id_number |
|---|---|---|
| Naledi | Mahlangu | 0510015800087 |
| Joseph | Moyo | 5006205800088 |

> These two citizens need to apply for ID documents.

**5. Count citizens per province:**

```sql
SELECT
  a.province,
  COUNT(DISTINCT a.citizen_id) AS citizen_count
FROM address a
WHERE a.address_type = 'residential'
GROUP BY a.province
ORDER BY citizen_count DESC;
```

**Expected output:**

| province | citizen_count |
|---|---:|
| Gauteng | 2 |
| KwaZulu-Natal | 1 |
| Western Cape | 1 |
| Free State | 1 |

> Only 5 citizens have residential addresses. The other 5 citizens don't appear.

**6. Active marriages with both spouse names:**

```sql
SELECT
  c1.first_name AS spouse1_first,
  c1.last_name AS spouse1_last,
  c2.first_name AS spouse2_first,
  c2.last_name AS spouse2_last,
  m.marriage_date,
  m.venue
FROM marriage_record m
INNER JOIN citizen c1 ON m.spouse1_citizen_id = c1.citizen_id
INNER JOIN citizen c2 ON m.spouse2_citizen_id = c2.citizen_id
WHERE m.status = 'active';
```

**Expected output:**

| spouse1_first | spouse1_last | spouse2_first | spouse2_last | marriage_date | venue |
|---|---|---|---|---|---|
| Lerato | Mokoena | Thabo | Ndlovu | 2018-12-15 | Johannesburg City Hall |
| Nomsa | Khumalo | Sipho | Nkosi | 1998-06-22 | Durban Court |

> The Palesa-Bongani marriage is excluded because its status is 'divorced'.

**7. Citizens born between 1990 and 2000:**

```sql
SELECT * FROM citizen
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
```

**Expected output:**

| citizen_id | id_number | first_name | last_name | date_of_birth | gender | nationality | is_alive |
|---:|---|---|---|---|---:|---|---:|
| 1 | 9001015800081 | Lerato | Mokoena | 1990-01-01 | F | South African | 1 |
| 5 | 9512205800085 | Zanele | Dlamini | 1995-12-20 | F | South African | 1 |
| 6 | 0003145800086 | Kabelo | Sithole | 2000-03-14 | M | South African | 1 |
| 9 | 9208115800089 | Palesa | Molefe | 1992-08-11 | F | South African | 1 |

**8. Citizens with expired ID documents:**

```sql
SELECT c.first_name, c.last_name, id.document_number, id.expiry_date
FROM citizen c
INNER JOIN identity_document id ON c.citizen_id = id.citizen_id
WHERE id.expiry_date < CURDATE();
```

**Expected output (as of mid-2026):**

| first_name | last_name | document_number | expiry_date |
|---|---|---|---|
| Thabo | Ndlovu | ID-880512-002 | 2024-07-20 |
| Sipho | Nkosi | ID-700815-004 | 2020-05-05 |
| Lerato | Mokoena | ID-900101-001 | 2026-03-15 |

> Results depend on when you run the query. Lerato's document expires on 2026-03-15.

**9. Birth records with child, mother, and father names:**

```sql
SELECT
  child.first_name AS child_name,
  mother.first_name AS mother_name,
  father.first_name AS father_name,
  br.date_of_birth,
  br.hospital_name
FROM birth_record br
INNER JOIN citizen child ON br.child_citizen_id = child.citizen_id
LEFT JOIN citizen mother ON br.mother_citizen_id = mother.citizen_id
LEFT JOIN citizen father ON br.father_citizen_id = father.citizen_id;
```

**Expected output:**

| child_name | mother_name | father_name | date_of_birth | hospital_name |
|---|---|---|---|---|
| Kabelo | Lerato | Thabo | 2000-03-14 | Chris Hani Baragwanath |
| Naledi | Nomsa | Sipho | 2005-10-01 | Inkosi Albert Luthuli |
| Lerato | Nomsa | Sipho | 1990-01-01 | King Edward VIII |
| Zanele | NULL | NULL | 1995-12-20 | Groote Schuur |

> Zanele has NULL parents — parent details were not recorded.

**10. Province with most registered citizens:**

```sql
SELECT a.province, COUNT(DISTINCT a.citizen_id) AS citizen_count
FROM address a
WHERE a.address_type = 'residential'
GROUP BY a.province
ORDER BY citizen_count DESC
LIMIT 1;
```

**Expected output:**

| province | citizen_count |
|---|---:|
| Gauteng | 2 |

**11. Count marriages per year:**

```sql
SELECT YEAR(marriage_date) AS marriage_year, COUNT(*) AS total_marriages
FROM marriage_record
GROUP BY YEAR(marriage_date)
ORDER BY marriage_year;
```

**Expected output:**

| marriage_year | total_marriages |
|---:|---:|
| 1998 | 1 |
| 2018 | 1 |
| 2022 | 1 |

**12. Citizens whose last name starts with 'N':**

```sql
SELECT * FROM citizen WHERE last_name LIKE 'N%';
```

**Expected output:**

| citizen_id | id_number | first_name | last_name | date_of_birth | gender | nationality | is_alive |
|---:|---|---|---|---|---:|---|---:|
| 2 | 8805125800082 | Thabo | Ndlovu | 1988-05-12 | M | South African | 1 |
| 4 | 7008155800084 | Sipho | Nkosi | 1970-08-15 | M | South African | 0 |

### C4. Self-Join Challenge

```sql
SELECT
  child.first_name AS child_name,
  child.last_name AS child_surname,
  mother.first_name AS mother_name,
  father.first_name AS father_name
FROM birth_record br
INNER JOIN citizen child ON br.child_citizen_id = child.citizen_id
LEFT JOIN citizen mother ON br.mother_citizen_id = mother.citizen_id
LEFT JOIN citizen father ON br.father_citizen_id = father.citizen_id;
```

**Expected output:**

| child_name | child_surname | mother_name | father_name |
|---|---|---|---|
| Kabelo | Sithole | Lerato | Thabo |
| Naledi | Mahlangu | Nomsa | Sipho |
| Lerato | Mokoena | Nomsa | Sipho |
| Zanele | Dlamini | NULL | NULL |

> The `citizen` table is joined three times — once as `child`, once as `mother`, once as `father`. Without aliases, MySQL wouldn't know which instance of `citizen` you're referring to in each ON clause. Aliases give each join a distinct name.

</details>

<details>
<summary><strong>Part D: Transaction Solution</strong></summary>

```sql
DELIMITER //

CREATE PROCEDURE register_death(
  IN p_citizen_id INT,
  IN p_date_of_death DATE,
  IN p_cause VARCHAR(200),
  IN p_place VARCHAR(100),
  IN p_reported_by INT
)
BEGIN
  DECLARE alive_status BOOLEAN;

  START TRANSACTION;

  -- Check if citizen is already dead
  SELECT is_alive INTO alive_status FROM citizen WHERE citizen_id = p_citizen_id FOR UPDATE;

  IF alive_status = FALSE THEN
    ROLLBACK;
    SELECT 'ERROR: Citizen is already recorded as deceased' AS result;
  ELSE
    -- Step 1: Insert death record
    INSERT INTO death_record (citizen_id, date_of_death, cause_of_death, place_of_death, reported_by_citizen_id)
    VALUES (p_citizen_id, p_date_of_death, p_cause, p_place, p_reported_by);

    -- Step 2: Mark citizen as deceased
    UPDATE citizen SET is_alive = FALSE WHERE citizen_id = p_citizen_id;

    -- Step 3: Expire their identity document
    UPDATE identity_document SET status = 'expired' WHERE citizen_id = p_citizen_id;

    COMMIT;
    SELECT 'SUCCESS: Death registered' AS result;
  END IF;
END //

DELIMITER ;

-- Test the success path (citizen 5 = Zanele, alive):
CALL register_death(5, '2026-02-28', 'Natural causes', 'Cape Town', 1);
-- Expected: 'SUCCESS: Death registered'

-- Test the error path (citizen 4 = Sipho, already deceased in seed data):
CALL register_death(4, '2023-11-10', 'Natural causes', 'Durban', 3);
-- Expected: 'ERROR: Citizen is already recorded as deceased'
```

> [!TIP]
> The second call demonstrates the ROLLBACK path — Sipho (citizen_id 4) was already marked `is_alive = FALSE` in the seed data, so the procedure correctly rejects the duplicate death registration.

**What would go wrong without a transaction?** If the death record is inserted but the system crashes before updating `is_alive` or the ID document status, the data becomes inconsistent — the citizen would appear both dead (death_record exists) and alive (is_alive = TRUE) simultaneously. Government records with such inconsistency could cause legal problems.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **VARCHAR(13) not BIGINT:** SA ID numbers can start with 0 (e.g., "0003145800086"). BIGINT would strip the leading zero. Also, you never do math (+, -, AVG) on ID numbers — they are identifiers, not quantities.

2. **Consequences of poor data integrity:** Incorrect birth certificates, duplicate identity documents, false marriage records, wrong death declarations. These have direct legal and financial implications for citizens.

3. **Address history:** Add an `effective_date` and `end_date` column to the address table. Current address has `end_date IS NULL`. Previous addresses have both dates filled in.

4. **Why more sensitive:** This database contains personally identifiable information (PII) protected by law (POPIA in South Africa). Unauthorized access, inaccurate records, or data breaches can cause identity theft, fraud, or denial of government services.

</details>
