# 📚 Library Management System (MySQL Database)

## Overview
This project implements a **relational database management system (RDBMS)** for a Library using **MySQL**.  
The system allows tracking of members, staff, books, authors, publishers, categories, loans, and fines.  
It enforces **data integrity** through relationships, constraints, and indexes.

---

## 🎯 Features
- Manage **members** with contact info and membership status.
- Manage **staff** (librarians, guards, cleaners).
- Track **books**, their **authors**, **publishers**, and **categories**.
- Support for **many-to-many relationships**:
  - Books ↔ Authors
  - Books ↔ Categories
- Record **loans** (borrowing transactions), including due/return dates and status.
- Automatically track **fines** for overdue returns.
- Indexes for faster searching on:
  - Book titles
  - Member emails
  - Loan status

---

## 🗂 Database Schema
### Tables
1. **members** – stores library users.
2. **staff** – stores staff details (e.g., librarians).
3. **authors** – stores author details.
4. **publishers** – stores publisher information.
5. **categories** – stores book categories.
6. **books** – stores book details with publisher and category links.
7. **book_authors** – links books and authors (many-to-many).
8. **book_categories** – links books and categories (many-to-many).
9. **loans** – stores borrowing records (books borrowed by members, handled by staff).
10. **fines** – records fines issued for overdue returns.

---

## ⚙️ Setup Instructions
1. Open MySQL and create the database:
   ```sql
   CREATE DATABASE librarydb;
   USE librarydb;
