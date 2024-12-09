USE AdventureWorks2022;

-- Insert Categories
INSERT INTO [Library].[Category] (category_id, category_name, category_description)
VALUES
(1, 'Data Science', 'Books about data science topics.'),
(2, 'Artificial Intelligence', 'Books about AI and related topics.'),
(3, 'Database Systems', 'Books about databases and SQL.');

-- Insert Books
INSERT INTO [Library].[Book] (book_id, isbn, category_id, book_title, book_description) 
VALUES 
(1, '9781234567890', 3,  'The Art of SQL', 'A guide to writing efficient SQL queries.'),
(2, '9780987654321', 3, 'Database Design Principles', 'Designing robust databases effectively.'),
(3, '9781112223334', 1, 'Mastering Data Science', 'Insights into the field of data science.'),
(4, '9782223334445', NULL, 'Advanced Analytics', 'Techniques for advanced data analytics.'),
(5, '9783334445556', NULL, 'Intro to Machine Learning', 'Introduction to machine learning concepts.'),
(6, '9784445556667', 1, 'Collaborative Analytics', 'A book on teamwork and data analytics.'),              -- Book with many authors
(7, '9785556667778', NULL, 'Data Visualization Mastery', 'A guide to mastering data visualization.'),
(8, '9786667778889', 2, 'AI for Everyone', 'An introduction to artificial intelligence for all audiences.');

-- Insert Authors
INSERT INTO [Library].[Author] (author_id, first_name, last_name) 
VALUES
(1, 'Stephane', 'Faroult'),        -- Author of 'The Art of SQL'
(2, 'Jan', 'L. Harrington'),       -- Author of 'Database Design Principles'
(3, 'Jake', 'VanderPlas'),         -- Author of 'Mastering Data Science'
(4, 'Thomas', 'Davenport'),        -- Author of 'Advanced Analytics'
(5, 'Andriy', 'Burkov'),           -- Author of 'Intro to Machine Learning'
(6, 'Jane', 'Doe'),				   -- Author of 'Collaborative Analytics'
(7, 'John', 'Smith');			   -- Author of 'Collaborative Analytics'

-- Map Book to Author
INSERT INTO [Library].[Book_by_author] (book_id, author_id) 
VALUES
(1, 1), -- 'The Art of SQL' by 'Stephane Faroult'
(2, 2), -- 'Database Design Principles' by 'Jan L. Harrington'
(3, 3), -- 'Mastering Data Science' by 'Jake VanderPlas'
(4, 4), -- 'Advanced Analytics' by 'Thomas Davenport'
(5, 5), -- 'Intro to Machine Learning' by 'Andriy Burkov'
(6, 6), -- 'Collaborative Analytics' by Jane Doe
(6, 7), -- 'Collaborative Analytics' by John Smith
(7, 6), -- "Data Visualization Mastery" by Jane Doe
(8, 6); -- "AI for Everyone" by Jane Doe

-- Add Library adresses
INSERT INTO [Library].[Library_address] (address_id, country, city, address_line, postcode)
VALUES
(1, 'Ukraine', 'Lviv', '123 Shevchenko Avenue', '79000'),
(2, 'Ukraine', 'Lviv', '456 Franko Street', '79001'),
(3, 'Ukraine', 'Lviv', '789 Halytska Square', '79002');

-- Add Libraries
INSERT INTO [Library].[Library] (library_id, address_id, library_name, library_description)
VALUES
(1, 1, 'Library 1', 'Lviv Central Library'),
(2, 2, 'Library 2', 'Lviv City Library Nr 2'),
(3, 3, 'Library 3', NULL);

-- Map books to libraries and specify number of items
INSERT INTO [Library].[Books_at_library] (books_at_library_id, library_id, book_id, nr_books_available)
VALUES
-- Books at Library 1 (library_id = 1)
(1, 1, 1, 2), -- The Art of SQL: 2 copies
(2, 1, 2, 1), -- Database Design Principles: 1 copy
(3, 1, 3, 0), -- Mastering Data Science: registered but no items
(4, 1, 4, 3), -- Advanced Analytics: 3 copies

-- Books at Library 2 (library_id = 2)
(5, 2, 1, 1), -- The Art of SQL: 1 copy
(6, 2, 5, 2), -- Intro to Machine Learning: 2 copies
(7, 2, 6, 0), -- Collaborative Analytics: registered but no items
(8, 2, 7, 5), -- Data Visualization Mastery: 5 copies

-- Books at Library 3 (library_id = 3)
(9, 3, 2, 1), -- Database Design Principles: 1 copy
(10, 3, 4, 1), -- Advanced Analytics: 1 copy
(11, 3, 8, 2), -- AI for Everyone: 2 copies
(12, 3, 6, 1); -- Collaborative Analytics: 1 copy

-- Insert Members adresses
INSERT INTO [Library].[Member_address] (address_id, country, city, address_line, postcode)
VALUES
(1, 'Ukraine', 'Lviv', '12 Kotlyarevskoho Street', '79010'),
(2, 'Ukraine', 'Kyiv', '45 Lesi Ukrainky Boulevard', '03127'),
(3, 'Ukraine', 'Odesa', '78 Pushkinska Street', '65011'),
(4, 'Ukraine', 'Lviv', '34 Ivana Franka Street', '79011'),
(5, 'Ukraine', 'Kharkiv', '19 Svobody Avenue', '61000'),
(6, 'Ukraine', 'Dnipro', '56 Gagarina Avenue', '49005'),
(7, 'Ukraine', 'Lviv', '89 Chornovola Avenue', '79020'),
(8, 'Ukraine', 'Kyiv', '23 Khreshchatyk Street', '03150'),
(9, 'Ukraine', 'Lviv', '5 Pekarska Street', '79012'),
(10, 'Ukraine', 'Odesa', '15 Deribasivska Street', '65020');

-- Insert Library Members
INSERT INTO [Library].[Library_member] (member_id, address_id, first_name, last_name, phone_number, email)
VALUES
(1, 1, 'Ivan', 'Shevchenko', '+380123456789', 'ivan.shevchenko@example.com'),
(2, 2, 'Olena', 'Kovalenko', '+380987654321', 'olena.kovalenko@example.com'),
(3, 3, 'Mykola', 'Ivanov', '+380501234567', NULL),
(4, 4, 'Anna', 'Petrenko', '+380671234567', 'anna.petrenko@example.com'),
(5, 5, 'Dmytro', 'Sydorenko', '+380931234567', 'dmytro.sydorenko@example.com'),
(6, 6, 'Viktoriya', 'Bondarenko', '+380991234567', 'viktoriya.bondarenko@example.com'),
(7, 7, 'Oleksandr', 'Tkachenko', '+380661234567', NULL),
(8, 8, 'Natalia', 'Marchenko', '+380731234567', NULL),
(9, 9, 'Yulia', 'Zinchenko', '+380951234567', NULL),
(10, 10, 'Andriy', 'Melnyk', '+380681234567', 'andriy.melnyk@example.com');

INSERT INTO [Library].[Member_ownership] (member_ownership_id, member_id, book_id, start_rent_date, end_rent_date, overdue_days)
VALUES
-- Book 1: Rented and returned without overdue
(1, 1, 2, '2024-11-01', '2024-11-07', 0), -- "Database Design Principles"

-- Book 2: Still rented, overdue
(2, 2, 3, '2024-10-20', NULL, 10), -- "Mastering Data Science" (no items available in library)

-- Book 3: Rented and returned with overdue
(3, 3, 6, '2024-10-10', '2024-10-25', 5); -- "Intro to Machine Learning"

-- Check insertion
SELECT *
FROM [AdventureWorks2022].[Library].Book;

SELECT *
FROM [AdventureWorks2022].[Library].Author;

-- If the view was created
-- Select books by Authors
SELECT * FROM [Library].[vBookAuthor];

-- Select books by categories
SELECT * FROM [Library].[vBookCategory];

-- Collaborative Analytics has 2 authors
SELECT * FROM [Library].[vBookAuthor] as ba
WHERE ba.Title = 'Collaborative Analytics';

-- Jane Doe has written 3 books
SELECT * FROM [Library].[vBookAuthor] as ba
WHERE ba.Author = 'Jane Doe';

-- List all libraries
SELECT * from [Library].[Library];
SELECT *
FROM [AdventureWorks2022].[Library].Book;

-- List all libraries with it's adresses
SELECT * FROM [Library].[vLibraryAdresses];

-- Search for book Mastering Data Science
SELECT * FROM [Library].[vLibraryBook] as lb
WHERE lb.BookTitle = 'Mastering Data Science';

SELECT * FROM [Library].[Library_member];

-- List all members with their adresses
SELECT * FROM [Library].[vMembersAddress];

SELECT * from [Library].[Member_ownership];

