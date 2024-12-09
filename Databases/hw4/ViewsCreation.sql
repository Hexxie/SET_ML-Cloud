USE AdventureWorks2022;
GO

-- View books by Authors
CREATE VIEW [Library].[vBookAuthor] AS
	SELECT 
		b.isbn as ISBN,
		b.book_title as Title,
		a.first_name + ' ' + a.last_name as Author
	FROM [Library].[Book] AS b
	INNER JOIN [Library].[Book_by_author] AS ba ON b.book_id = ba.book_id
	INNER JOIN [Library].[Author] AS a ON ba.author_id = a.author_id
GO

-- View books by Categories
CREATE VIEW [Library].[vBookCategory] AS
	SELECT 
		c.category_name AS Category,
		b.book_title AS Title,
		b.isbn AS ISBN
	FROM 
		[Library].[Book] b
	LEFT JOIN 
		[Library].[Category] c ON c.category_id = b.category_id
GO

-- List all libraries with it's adresses
CREATE VIEW [Library].[vLibraryAdresses] AS
	SELECT 
		l.library_name AS Name,
		l.library_description AS Description,
		la.country + ', ' + la.city + ', ' + la.address_line + ', ' + la.postcode AS LibraryAddress
	FROM 
		[Library].[Library] AS l
	INNER JOIN 
		[Library].[Library_address] AS la ON l.address_id = la.address_id;
GO

-- Search which library can offer particular book
CREATE VIEW [Library].[vLibraryBook] AS
	SELECT 
		b.book_title AS BookTitle,
		bl.nr_books_available AS BooksAvailable,
		l.library_name AS LibraryName,
		la.country + ', ' + la.city + ', ' + la.address_line + ', ' + la.postcode AS LibraryAddress
	FROM 
		[Library].[Books_at_library] AS bl
	INNER JOIN 
		[Library].[Book] AS b ON bl.book_id = b.book_id
	INNER JOIN 
		[Library].[Library] AS l ON bl.library_id = l.library_id
	INNER JOIN 
		[Library].[Library_address] AS la ON l.address_id = la.address_id;
GO

-- List all members with it's adresses
CREATE VIEW [Library].[vMembersAddress] AS
	SELECT 
		m.first_name + ' ' + m.last_name AS Name,
		m.phone_number AS Phone,
		m.email AS Email,
		ma.country + ', ' + ma.city + ', ' + ma.address_line + ', ' + ma.postcode AS MemberAddress
	FROM 
		[Library].[Library_member] AS m
	INNER JOIN 
		[Library].[Member_address] AS ma ON m.address_id = ma.address_id;
GO

-- Who and which book has rent
CREATE VIEW [Library].[vBookByOwner] AS
	SELECT 
		mo.member_ownership_id AS OwnershipID,
		m.first_name + ' ' + m.last_name AS MemberName,
		m.phone_number AS MemberPhone,
		b.book_title AS BookTitle,
		mo.start_rent_date AS StartDate,
		mo.end_rent_date AS EndDate,
		mo.overdue_days AS OverdueDays
	FROM 
		[Library].[Member_ownership] AS mo
	INNER JOIN 
		[Library].[Library_member] AS m ON mo.member_id = m.member_id
	INNER JOIN 
		[Library].[Book] AS b ON mo.book_id = b.book_id;
GO

-- Who and which book has rent from particular Library
CREATE VIEW [Library].[vRentedBookByLibrary] AS
	SELECT 
		mo.member_ownership_id AS OwnershipID,
		m.first_name + ' ' + m.last_name AS MemberName,
		b.book_title AS BookTitle,
		l.library_name AS LibraryName,
		la.country + ', ' + la.city + ', ' + la.address_line + ', ' + la.postcode AS LibraryAddress,
		mo.start_rent_date AS StartDate,
		mo.end_rent_date AS EndDate,
		mo.overdue_days AS OverdueDays
	FROM 
		[Library].[Member_ownership] AS mo
	INNER JOIN 
		[Library].[Library_member] AS m ON mo.member_id = m.member_id
	INNER JOIN 
		[Library].[Book] AS b ON mo.book_id = b.book_id
	INNER JOIN 
		[Library].[Books_at_library] AS bal ON b.book_id = bal.book_id
	INNER JOIN 
		[Library].[Library] AS l ON bal.library_id = l.library_id
	INNER JOIN 
		[Library].[Library_address] AS la ON l.address_id = la.address_id
GO