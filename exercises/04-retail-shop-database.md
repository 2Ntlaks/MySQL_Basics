# Exercise 04: Retail Shop Database

## Scenario

A retail shop (clothing and accessories) needs a database to manage products, customers, staff, and sales. The manager wants to track inventory, record every sale, know which staff member handled each transaction, and analyze which products sell best.

---

## Part A: Terminology (10 marks)

Define each term using **one simple sentence** and **one technical sentence**:

1. `DECIMAL` vs `FLOAT`
2. `DEFAULT` constraint
3. Aggregate function
4. `HAVING`
5. `ORDER BY DESC`

---

## Part B: Table Design (25 marks)

Design the following tables with columns, datatypes, and constraints:

1. **category** — product categories (e.g., Shirts, Pants, Accessories)
2. **product** — product name, category (FK), price, stock quantity, size, colour
3. **customer** — first name, last name, email, phone, registration date
4. **staff** — first name, last name, role (cashier/manager), hire date
5. **sale** — sale date, customer (FK), staff member (FK), total amount
6. **sale_item** — sale (FK), product (FK), quantity, unit price, line total

### Questions

1. What is the relationship between `sale` and `sale_item`?
2. Why store `unit_price` in `sale_item` when it already exists in `product`?
3. What `CHECK` constraints would you add to `product`?
4. Should `customer_id` in `sale` allow `NULL`? Why or why not?

---

## Part C: SQL Implementation (40 marks)

### C1. Create all tables

```sql
-- Write your CREATE TABLE statements here
```

### C2. Insert sample data

- At least 4 categories
- At least 10 products across categories
- At least 5 customers
- At least 3 staff members
- At least 8 sales with multiple items each

```sql
-- Write your INSERT statements here
```

### C3. Queries

Write queries for:

1. List all products sorted by price (most expensive first).
2. Show all products with stock quantity below 5 (low stock alert).
3. Find total revenue per category.
4. Show the top 5 best-selling products by quantity sold.
5. Find customers who have spent more than R1000 in total.
6. Show monthly sales totals for the current year (use `MONTH()` and `YEAR()`).
7. List all products that have **never been sold** (use `LEFT JOIN`).
8. Find the staff member with the most sales.
9. Show average sale value per staff member.
10. Find products where the name contains "jacket" (use `LIKE`).
11. Calculate the profit if each product has a 40% markup: show product name, cost, and selling price.
12. Show a summary: total products, total customers, total sales, total revenue.

### C4. Inventory Management

1. Write an `UPDATE` to reduce stock when a sale is made.
2. Write a query to find all products that are out of stock (`stock_quantity = 0`).
3. Write a query to show the value of current inventory (stock × price per product).

---

## Part D: Transaction Exercise (15 marks)

Write a transaction that processes a sale:

1. Insert a new row into `sale`.
2. Insert 2 items into `sale_item`.
3. Update stock quantity for each product.
4. If any product has insufficient stock, `ROLLBACK` the entire transaction.

```sql
-- Write your transaction here
```

Explain why this must be a transaction (not individual statements).

---

## Part E: Reflection (10 marks)

1. Why is storing price as `DECIMAL(10,2)` better than `FLOAT`?
2. Why do we need both `sale` and `sale_item` tables instead of one combined table?
3. How would you extend this database to support online orders with delivery addresses?

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

1. **DECIMAL vs FLOAT**
   - Simple: DECIMAL stores exact numbers (good for money). FLOAT stores approximate numbers (good for science).
   - Technical: DECIMAL uses fixed-point arithmetic with exact precision; FLOAT uses binary floating-point which can introduce rounding errors.

2. **DEFAULT constraint**
   - Simple: A DEFAULT gives a column an automatic value if you don't provide one during insert.
   - Technical: A constraint that supplies a predefined value for a column when no explicit value is specified in an INSERT statement.

3. **Aggregate function**
   - Simple: A function that takes many rows and returns one summary value (like COUNT, SUM, AVG).
   - Technical: A function that operates on a set of rows and returns a single computed result, typically used with GROUP BY.

4. **HAVING**
   - Simple: HAVING filters groups after GROUP BY, similar to how WHERE filters rows before grouping.
   - Technical: A clause that applies conditions to aggregated groups; unlike WHERE, it can reference aggregate functions.

5. **ORDER BY DESC**
   - Simple: Sorts query results from highest to lowest (or Z to A).
   - Technical: A clause that orders the result set in descending sequence based on specified column(s).

</details>

<details>
<summary><strong>Part B: Design Answers</strong></summary>

1. **sale → sale_item** = One-to-Many (one sale can contain many items).
2. **Why store unit_price in sale_item:** Prices change over time. The sale_item records what the customer actually paid at the time of purchase. If you only reference the product table, historical sale records would show today's price, not the original price.
3. **CHECK constraints on product:** `CHECK (price > 0)`, `CHECK (stock_quantity >= 0)`.
4. **customer_id NULL in sale:** It could allow NULL for walk-in customers who aren't registered, but if the shop requires membership, it should be NOT NULL. Both answers are valid with justification.

</details>

<details>
<summary><strong>Part C: SQL Solutions</strong></summary>

### C1. Create tables

```sql
CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

CREATE TABLE category (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE product (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  category_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price > 0),
  stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
  size VARCHAR(10),
  colour VARCHAR(30),
  FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(120) UNIQUE,
  phone VARCHAR(20),
  registered_at DATE DEFAULT (CURDATE())
);

CREATE TABLE staff (
  staff_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('cashier', 'manager')),
  hire_date DATE NOT NULL
);

CREATE TABLE sale (
  sale_id INT PRIMARY KEY AUTO_INCREMENT,
  sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  customer_id INT,
  staff_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE sale_item (
  sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
  sale_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL,
  line_total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (sale_id) REFERENCES sale(sale_id),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);
```

### C2. Insert sample data

```sql
INSERT INTO category (name) VALUES
  ('Shirts'), ('Pants'), ('Shoes'), ('Accessories');

INSERT INTO product (name, category_id, price, stock_quantity, size, colour) VALUES
  ('Cotton T-Shirt', 1, 149.99, 25, 'M', 'White'),
  ('Formal Shirt', 1, 349.99, 15, 'L', 'Blue'),
  ('Slim Jeans', 2, 499.99, 20, '32', 'Black'),
  ('Chino Pants', 2, 399.99, 18, '34', 'Khaki'),
  ('Running Shoes', 3, 899.99, 10, '9', 'Grey'),
  ('Leather Belt', 4, 199.99, 30, NULL, 'Brown'),
  ('Denim Jacket', 1, 699.99, 8, 'L', 'Blue'),
  ('Sports Shorts', 2, 249.99, 22, 'M', 'Navy'),
  ('Canvas Sneakers', 3, 549.99, 12, '10', 'White'),
  ('Wool Beanie', 4, 129.99, 40, NULL, 'Grey');

INSERT INTO customer (first_name, last_name, email, phone) VALUES
  ('Amahle', 'Mokoena', 'amahle@mail.com', '0712345678'),
  ('Lebo', 'Ncube', 'lebo@mail.com', '0723456789'),
  ('Sipho', 'Dlamini', 'sipho@mail.com', '0734567890'),
  ('Thandi', 'Nkosi', 'thandi@mail.com', '0745678901'),
  ('Kagiso', 'Molefe', 'kagiso@mail.com', '0756789012');

INSERT INTO staff (first_name, last_name, role, hire_date) VALUES
  ('Zanele', 'Mahlangu', 'manager', '2022-01-15'),
  ('Bongani', 'Sithole', 'cashier', '2023-06-01'),
  ('Palesa', 'Khumalo', 'cashier', '2024-03-10');

INSERT INTO sale (sale_date, customer_id, staff_id, total_amount) VALUES
  ('2026-01-15 10:30:00', 1, 2, 649.98),
  ('2026-01-18 14:00:00', 2, 2, 899.99),
  ('2026-02-01 11:15:00', 1, 3, 1099.98),
  ('2026-02-05 09:45:00', 3, 2, 449.98),
  ('2026-02-10 16:00:00', 4, 3, 199.99),
  ('2026-02-14 12:30:00', 2, 2, 549.99),
  ('2026-02-20 15:00:00', 5, 3, 1399.98),
  ('2026-02-25 10:00:00', 1, 2, 129.99);

INSERT INTO sale_item (sale_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 2, 149.99, 299.98),
  (1, 6, 1, 199.99, 199.99),
  (1, 10, 1, 129.99, 129.99),
  (2, 5, 1, 899.99, 899.99),
  (3, 3, 1, 499.99, 499.99),
  (3, 4, 1, 399.99, 399.99),
  (3, 6, 1, 199.99, 199.99),
  (4, 8, 1, 249.99, 249.99),
  (4, 6, 1, 199.99, 199.99),
  (5, 6, 1, 199.99, 199.99),
  (6, 9, 1, 549.99, 549.99),
  (7, 7, 1, 699.99, 699.99),
  (7, 2, 2, 349.99, 699.98),
  (8, 10, 1, 129.99, 129.99);
```

### C3. Queries

**1. All products sorted by price (most expensive first):**

```sql
SELECT * FROM product ORDER BY price DESC;
```

**Expected output:**

| product_id | name | category_id | price | stock_quantity | size | colour |
|---:|---|---:|---:|---:|---|---|
| 5 | Running Shoes | 3 | 899.99 | 10 | 9 | Grey |
| 7 | Denim Jacket | 1 | 699.99 | 8 | L | Blue |
| 9 | Canvas Sneakers | 3 | 549.99 | 12 | 10 | White |
| 3 | Slim Jeans | 2 | 499.99 | 20 | 32 | Black |
| 4 | Chino Pants | 2 | 399.99 | 18 | 34 | Khaki |
| 2 | Formal Shirt | 1 | 349.99 | 15 | L | Blue |
| 8 | Sports Shorts | 2 | 249.99 | 22 | M | Navy |
| 6 | Leather Belt | 4 | 199.99 | 30 | NULL | Brown |
| 1 | Cotton T-Shirt | 1 | 149.99 | 25 | M | White |
| 10 | Wool Beanie | 4 | 129.99 | 40 | NULL | Grey |

**2. Low stock alert (below 5):**

```sql
SELECT name, stock_quantity FROM product WHERE stock_quantity < 5;
```

**Expected output:**

```
Empty set (0 rows)
```

> All products have stock ≥ 8, so no low-stock alerts.

**3. Total revenue per category:**

```sql
SELECT
  cat.name AS category,
  SUM(si.line_total) AS total_revenue
FROM sale_item si
INNER JOIN product p ON si.product_id = p.product_id
INNER JOIN category cat ON p.category_id = cat.category_id
GROUP BY cat.category_id, cat.name
ORDER BY total_revenue DESC;
```

**Expected output:**

| category | total_revenue |
|---|---:|
| Shirts | 1699.95 |
| Shoes | 1449.98 |
| Pants | 1149.97 |
| Accessories | 1059.94 |

> Shirts lead because of the Denim Jacket (R699.99) and 2× Formal Shirt (R699.98).

**4. Top 5 best-selling products by quantity:**

```sql
SELECT
  p.name,
  SUM(si.quantity) AS total_sold
FROM sale_item si
INNER JOIN product p ON si.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;
```

**Expected output:**

| name | total_sold |
|---|---:|
| Leather Belt | 4 |
| Cotton T-Shirt | 2 |
| Formal Shirt | 2 |
| Wool Beanie | 2 |
| Running Shoes | 1 |

> Leather Belt is the best seller — it appeared in 4 separate sale items.

**5. Customers who spent more than R1000:**

```sql
SELECT
  c.first_name,
  c.last_name,
  SUM(s.total_amount) AS total_spent
FROM sale s
INNER JOIN customer c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_amount) > 1000;
```

**Expected output:**

| first_name | last_name | total_spent |
|---|---|---:|
| Amahle | Mokoena | 1879.95 |
| Lebo | Ncube | 1449.98 |
| Kagiso | Molefe | 1399.98 |

> Amahle is the biggest spender with 3 purchases totalling R1879.95.

**6. Monthly sales totals for current year:**

```sql
SELECT
  MONTH(sale_date) AS month,
  COUNT(*) AS total_sales,
  SUM(total_amount) AS monthly_revenue
FROM sale
WHERE YEAR(sale_date) = 2026
GROUP BY MONTH(sale_date)
ORDER BY month;
```

**Expected output:**

| month | total_sales | monthly_revenue |
|---:|---:|---:|
| 1 | 2 | 1549.97 |
| 2 | 6 | 3829.91 |

> February has 3× more sales than January.

**7. Products never sold:**

```sql
SELECT p.name
FROM product p
LEFT JOIN sale_item si ON p.product_id = si.product_id
WHERE si.sale_item_id IS NULL;
```

**Expected output:**

```
Empty set (0 rows)
```

> Every product has been sold at least once.

**8. Staff member with most sales:**

```sql
SELECT
  st.first_name,
  st.last_name,
  COUNT(*) AS sale_count
FROM sale s
INNER JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.staff_id, st.first_name, st.last_name
ORDER BY sale_count DESC
LIMIT 1;
```

**Expected output:**

| first_name | last_name | sale_count |
|---|---|---:|
| Bongani | Sithole | 5 |

> Bongani handled 5 of the 8 total sales.

**9. Average sale value per staff member:**

```sql
SELECT
  st.first_name,
  st.last_name,
  ROUND(AVG(s.total_amount), 2) AS avg_sale
FROM sale s
INNER JOIN staff st ON s.staff_id = st.staff_id
GROUP BY st.staff_id, st.first_name, st.last_name;
```

**Expected output:**

| first_name | last_name | avg_sale |
|---|---|---:|
| Bongani | Sithole | 535.99 |
| Palesa | Khumalo | 899.98 |

> Palesa has a higher average because she processed the R1399.98 sale.

**10. Products with "jacket" in the name:**

```sql
SELECT * FROM product WHERE name LIKE '%jacket%';
```

**Expected output:**

| product_id | name | category_id | price | stock_quantity | size | colour |
|---:|---|---:|---:|---:|---|---|
| 7 | Denim Jacket | 1 | 699.99 | 8 | L | Blue |

> LIKE is case-insensitive — 'jacket' matches 'Jacket'.

**11. Profit with 40% markup:**

```sql
SELECT
  name,
  ROUND(price / 1.40, 2) AS cost,
  price AS selling_price,
  ROUND(price - (price / 1.40), 2) AS profit
FROM product;
```

**Expected output:**

| name | cost | selling_price | profit |
|---|---:|---:|---:|
| Cotton T-Shirt | 107.14 | 149.99 | 42.85 |
| Formal Shirt | 249.99 | 349.99 | 100.00 |
| Slim Jeans | 357.14 | 499.99 | 142.85 |
| Chino Pants | 285.71 | 399.99 | 114.28 |
| Running Shoes | 642.85 | 899.99 | 257.14 |
| Leather Belt | 142.85 | 199.99 | 57.14 |
| Denim Jacket | 499.99 | 699.99 | 200.00 |
| Sports Shorts | 178.56 | 249.99 | 71.43 |
| Canvas Sneakers | 392.85 | 549.99 | 157.14 |
| Wool Beanie | 92.85 | 129.99 | 37.14 |

**12. Summary report:**

```sql
SELECT
  (SELECT COUNT(*) FROM product) AS total_products,
  (SELECT COUNT(*) FROM customer) AS total_customers,
  (SELECT COUNT(*) FROM sale) AS total_sales,
  (SELECT SUM(total_amount) FROM sale) AS total_revenue;
```

**Expected output:**

| total_products | total_customers | total_sales | total_revenue |
|---:|---:|---:|---:|
| 10 | 5 | 8 | 5379.88 |

### C4. Inventory Management

**1. Reduce stock when a sale is made:**

```sql
UPDATE product
SET stock_quantity = stock_quantity - 1
WHERE product_id = 5;
```

**2. Out of stock products:**

```sql
SELECT name FROM product WHERE stock_quantity = 0;
```

**Expected output:**

```
Empty set (0 rows)
```

> No products are out of stock. Stock was not reduced in this sample.

**3. Current inventory value:**

```sql
SELECT
  name,
  stock_quantity,
  price,
  (stock_quantity * price) AS inventory_value
FROM product
ORDER BY inventory_value DESC;
```

**Expected output:**

| name | stock_quantity | price | inventory_value |
|---|---:|---:|---:|
| Slim Jeans | 20 | 499.99 | 9999.80 |
| Running Shoes | 10 | 899.99 | 8999.90 |
| Chino Pants | 18 | 399.99 | 7199.82 |
| Canvas Sneakers | 12 | 549.99 | 6599.88 |
| Leather Belt | 30 | 199.99 | 5999.70 |
| Denim Jacket | 8 | 699.99 | 5599.92 |
| Sports Shorts | 22 | 249.99 | 5499.78 |
| Formal Shirt | 15 | 349.99 | 5249.85 |
| Wool Beanie | 40 | 129.99 | 5199.60 |
| Cotton T-Shirt | 25 | 149.99 | 3749.75 |

</details>

<details>
<summary><strong>Part D: Transaction Solution</strong></summary>

```sql
START TRANSACTION;

-- Insert the sale
INSERT INTO sale (sale_date, customer_id, staff_id, total_amount)
VALUES (NOW(), 3, 2, 1149.98);

SET @new_sale_id = LAST_INSERT_ID();

-- Insert item 1: Running Shoes (product_id = 5)
INSERT INTO sale_item (sale_id, product_id, quantity, unit_price, line_total)
VALUES (@new_sale_id, 5, 1, 899.99, 899.99);

-- Insert item 2: Sports Shorts (product_id = 8)
INSERT INTO sale_item (sale_id, product_id, quantity, unit_price, line_total)
VALUES (@new_sale_id, 8, 1, 249.99, 249.99);

-- Update stock for product 5
UPDATE product SET stock_quantity = stock_quantity - 1 WHERE product_id = 5;

-- Update stock for product 8
UPDATE product SET stock_quantity = stock_quantity - 1 WHERE product_id = 8;

-- Verify no negative stock
SELECT stock_quantity INTO @stock5 FROM product WHERE product_id = 5;
SELECT stock_quantity INTO @stock8 FROM product WHERE product_id = 8;

-- If either is negative, ROLLBACK; otherwise COMMIT
-- In a stored procedure you'd use: IF @stock5 < 0 OR @stock8 < 0 THEN ROLLBACK; ELSE COMMIT;
COMMIT;
```

**Why must this be a transaction?** If the sale is recorded but stock isn't updated (or vice versa), the data becomes inconsistent. The sale would show items sold, but inventory wouldn't reflect it. Transactions ensure all-or-nothing.

</details>

<details>
<summary><strong>Part E: Reflection Guidance</strong></summary>

1. **DECIMAL(10,2) vs FLOAT:** FLOAT can introduce tiny rounding errors (e.g., R99.99 stored as R99.9900000001). For financial data, exact precision is required — DECIMAL guarantees this.

2. **Why sale + sale_item:** A sale is one transaction event; sale_items are the individual products in that sale. This is a 1:N relationship. Combining them would mean repeating sale-level data (date, customer, staff) for every item — violating 2NF.

3. **Online orders extension:** Add a `delivery_address` table with FK to customer, and add an `order_type` column ('in-store'/'online') and `delivery_status` column to the sale table.

</details>
