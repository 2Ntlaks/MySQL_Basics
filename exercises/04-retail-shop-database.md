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
