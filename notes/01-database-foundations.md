# 01. Database Foundations

## Learning Outcomes

After this lesson, you should be able to:

- Define database, DBMS, and RDBMS.
- Explain why applications need databases.
- Distinguish between data and information.
- Understand schema vs data instance.

---

## Key Terms

| Term | Plain-language meaning | Technical meaning |
|---|---|---|
| Data | Raw facts | Values stored for later use |
| Information | Useful data | Data processed into meaning |
| Database | Organized storage | Structured collection of related data |
| DBMS | Database software | System used to create/manage/query databases |
| RDBMS | Table-based DBMS | DBMS that stores data in related tables |
| Schema | Blueprint | Logical structure of tables, columns, relationships |
| Instance | Current data | Actual rows currently stored in the database |

---

## 1. What is a Database?

### Definition

A database is an organized collection of related data.

### Plain-language meaning

A database is like a digital filing system where information is kept in a structured way so it can be searched quickly.

### Example

For a university system:

- Students
- Modules
- Lecturers
- Enrollments

All of this is stored in a database.

---

## 2. What is a DBMS?

### Definition

A DBMS (Database Management System) is software used to create, manage, and query databases.

### Plain-language meaning

A DBMS is the tool that lets you work with the database. Without a DBMS, managing data manually becomes slow and error-prone.

Examples:

- MySQL
- PostgreSQL
- SQL Server
- Oracle

---

## 3. Why not store everything in Excel files?

Databases are better for large, shared, and changing data because they provide:

1. Multi-user access
2. Security and permissions
3. Data consistency rules
4. Fast querying
5. Backup and recovery

---

## 4. Schema vs Instance

### Schema

The design (table names, columns, datatypes, keys).

### Instance

The actual records at a specific time.

> [!NOTE]
> Schema changes rarely. Data instance changes every time you insert, update, or delete rows.

---

## 5. First SQL Commands

```sql
CREATE DATABASE university_db;
USE university_db;
SHOW DATABASES;
```

What each does:

- `CREATE DATABASE`: creates a container
- `USE`: selects active database
- `SHOW DATABASES`: lists available databases

---

## Remember

- A database stores data.
- A DBMS manages data.
- MySQL is an RDBMS.
- Schema is structure; instance is content.

---

## Checkpoint Questions

1. What is the difference between DBMS and database?
2. Give one example of schema and one example of instance.
3. Why are databases preferred over random text files for university systems?

