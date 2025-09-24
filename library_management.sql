CREATE DATABASE librarydb;
USE librarydb;

DROP TABLE members;
-- STEP 1: We are creating a members table 
CREATE TABLE members(
	member_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(300) NOT NULL UNIQUE,
    phone_no VARCHAR(20),
    DOB DATE NOT NULL,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('active','inactive') NOT NULL DEFAULT 'active'
);

-- STEP 2: CREATING THE STAFF TABLE 
CREATE TABLE staff(
	staff_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(300) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    staff_category ENUM('librarian','cleaner','guard') NOT NULL DEFAULT 'librarian'
    );
    
-- STEP3: CREATING AUTHORS TABLE
CREATE TABLE authors(
	author_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    biography TEXT 
);

-- STEP 4: CREATING PUBLISHERS TABLE 
CREATE TABLE publishers(
	publisher_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL UNIQUE,
    contact_email VARCHAR(300),
    contact_phone VARCHAR(100)
);

-- STEP 5: CREATING CATEGORIES TABLE
CREATE TABLE categories(
	category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- STEP 6: CREATING THE BOOKS TABLE
CREATE TABLE books(
	book_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    publisher_id INT UNSIGNED,
    category_id INT UNSIGNED,
    publication_year YEAR,
    total_copies INT NOT NULL DEFAULT 1,
	available_copies INT  NOT NULL DEFAULT 1 ,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    CHECK (total_copies >= 0 AND available_copies >=0)

);

-- STEP 7: CREATING BOOK AUTHORS TABLE Many to many(books <->authors) 
CREATE TABLE book_authors (
	book_id INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, author_id),
	FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE ON UPDATE CASCADE
    
);
-- STEP 8: CREATING TABLE book cataegories (many to many)
CREATE TABLE book_categories(
	book_id INT UNSIGNED NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY(book_id) REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- STEP 9: BORROWING SYSTEM
CREATE TABLE loans(
    loan_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    book_id INT UNSIGNED NOT NULL,
    member_id INT UNSIGNED NOT NULL,
    staff_id INT UNSIGNED ,  
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    status ENUM('ongoing', 'returned', 'overdue') NOT NULL DEFAULT 'ongoing',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- STEP 10: CREATING THE FINES TABLE FOR LATE RETURNS
CREATE TABLE fines(
	fine_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    loan_id INT UNSIGNED NOT NULL,
    amount DECIMAL(8,2) NOT NULL CHECK (amount >= 0),
    paid BOOLEAN NOT NULL DEFAULT FALSE,
    issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- STEP 11: CREATING INDEXES FOR EASIER SEARCHING
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_loans_status ON loans(status);



-- INSERTING DATA 
-- ====================================================================
-- Insert Members
INSERT INTO members (first_name, last_name, email, phone_no, DOB, membership_date, status)
VALUES
('Alice', 'Johnson', 'alice@example.com', '0712345678', '1995-06-15', '2023-01-10', 'active'),
('Brian', 'Otieno', 'brian@example.com', '0722123456', '1990-04-20', '2023-02-05', 'active'),
('Cynthia', 'Wambui', 'cynthia@example.com', '0733123456', '1988-11-05', '2023-03-01', 'inactive');

-- Insert Staff
INSERT INTO staff (first_name, last_name, email, hire_date, staff_category)
VALUES
('David', 'Kamau', 'david.librarian@example.com', '2022-09-01', 'librarian'),
('Emily', 'Njeri', 'emily.cleaner@example.com', '2023-01-15', 'cleaner'),
('Felix', 'Mwangi', 'felix.guard@example.com', '2021-05-20', 'guard');

-- Insert Authors
INSERT INTO authors (first_name, last_name, biography)
VALUES
('Chinua', 'Achebe', 'Nigerian novelist, poet, and critic.'),
('Ngugi', 'wa Thiong\'o', 'Kenyan writer and academic.'),
('J.K.', 'Rowling', 'British author, best known for the Harry Potter series.');

-- Insert Publishers
INSERT INTO publishers (publisher_name, contact_email, contact_phone)
VALUES
('East African Publishing', 'info@eapub.com', '0700123456'),
('Oxford Press', 'contact@oxfordpress.com', '0711223344');

-- Insert Categories
INSERT INTO categories (category_name)
VALUES
('Fiction'),
('Non-fiction'),
('Science'),
('Children'),
('History');

-- Insert Books
INSERT INTO books (title, ISBN, publisher_id, category_id, publication_year, total_copies, available_copies)
VALUES
('Things Fall Apart', '9780435905255', 1, 1, 1958, 5, 5),
('The River Between', '9780435905484', 1, 1, 1965, 3, 3),
('Harry Potter and the Sorcerer\'s Stone', '9780439708180', 2, 4, 1997, 10, 10);

-- Book-Authors (many-to-many links)
INSERT INTO book_authors (book_id, author_id)
VALUES
(1, 1),  -- Things Fall Apart -> Chinua Achebe
(2, 2),  -- The River Between -> Ngugi wa Thiong'o
(3, 3);  -- Harry Potter -> J.K. Rowling

-- Book-Categories (extra categorization)
INSERT INTO book_categories (book_id, category_id)
VALUES
(1, 1), -- Things Fall Apart -> Fiction
(2, 1), -- The River Between -> Fiction
(3, 4); -- Harry Potter -> Children

-- Loans
INSERT INTO loans (book_id, member_id, staff_id, loan_date, due_date, return_date, status)
VALUES
(1, 1, 1, '2023-09-01', '2023-09-15', NULL, 'ongoing'),
(2, 2, 1, '2023-09-05', '2023-09-20', '2023-09-18', 'returned'),
(3, 3, 1, '2023-09-10', '2023-09-25', NULL, 'overdue');

-- Fines
INSERT INTO fines (loan_id, amount, paid, issued_at)
VALUES
(3, 500.00, FALSE, '2023-09-26 10:00:00');


