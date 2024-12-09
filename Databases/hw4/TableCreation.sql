USE AdventureWorks2022;

-- Table Category
CREATE TABLE [Library].[Category] (
[category_id] INT NOT NULL,
[category_name] VARCHAR (50) NOT NULL,
[category_description] VARCHAR (100),
CONSTRAINT PK_category_id PRIMARY KEY CLUSTERED (category_id),
);
GO

-- Table Book
CREATE TABLE [Library].[Book] (
[book_id] INT NOT NULL,
[category_id] INT,
[isbn] CHAR(13) UNIQUE,
[book_title] VARCHAR (50) NOT NULL,
[book_description] VARCHAR (100),
CONSTRAINT PK_book_id PRIMARY KEY CLUSTERED (book_id),
CONSTRAINT FK_book_category FOREIGN KEY (category_id) REFERENCES [Library].[Category](category_id)
);
GO

-- Table Author
CREATE TABLE [Library].[Author] (
[author_id] INT NOT NULL,
[first_name] VARCHAR (50) NOT NULL,
[last_name] VARCHAR (50) NOT NULL,
CONSTRAINT PK_author_id PRIMARY KEY CLUSTERED (author_id)
);
GO

-- Table Book_by_author
CREATE TABLE [Library].[Book_by_author] (
[book_id] INT NOT NULL,
[author_id] INT NOT NULL,
CONSTRAINT PK_book_by_author_id PRIMARY KEY CLUSTERED (book_id, author_id), -- Composit PK, no need an extra PK for this table
CONSTRAINT FK_book_by_author_book FOREIGN KEY (book_id) REFERENCES [Library].[Book](book_id),
CONSTRAINT FK_book_by_author_author FOREIGN KEY (author_id) REFERENCES [Library].[Author](author_id) 
);
GO

-- Table Library_address
CREATE TABLE [Library].[Library_address] (
[address_id] INT NOT NULL,
[country] VARCHAR (50) NOT NULL,
[city] VARCHAR (50) NOT NULL,
[address_line] VARCHAR (100) NOT NULL,
[postcode] VARCHAR (20) NOT NULL,
CONSTRAINT PK_library_address_id PRIMARY KEY CLUSTERED (address_id)
);
GO

-- Table Member_address
CREATE TABLE [Library].[Member_address] (
[address_id] INT NOT NULL,
[country] VARCHAR (50) NOT NULL,
[city] VARCHAR (50) NOT NULL,
[address_line] VARCHAR (100) NOT NULL,
[postcode] VARCHAR (20) NOT NULL,
CONSTRAINT PK_member_address_id PRIMARY KEY CLUSTERED (address_id)
);
GO

-- Table Library
CREATE TABLE [Library].[Library] (
[library_id] INT NOT NULL,
[address_id] INT NOT NULL,
[library_name] VARCHAR (50) NOT NULL,
[library_description] VARCHAR (100),
CONSTRAINT PK_library_id PRIMARY KEY CLUSTERED (library_id),
CONSTRAINT FK_library_address FOREIGN KEY (address_id) REFERENCES [Library].[Library_address](address_id) 
);
GO

-- Table Books_at_library
CREATE TABLE [Library].[Books_at_library] (
[books_at_library_id] INT NOT NULL,
[library_id] INT NOT NULL,
[book_id] INT NOT NULL,
[nr_books_available] INT NOT NULL,
CONSTRAINT PK_books_at_library_id PRIMARY KEY CLUSTERED (books_at_library_id),
CONSTRAINT FK_library_library FOREIGN KEY (library_id) REFERENCES [Library].[Library](library_id),
CONSTRAINT FK_library_book FOREIGN KEY (book_id) REFERENCES [Library].[Book](book_id) 
);
GO

-- Table LibraryMembers
CREATE TABLE [Library].[Library_member] (
[member_id] INT NOT NULL,
[address_id] INT NOT NULL,
[first_name] VARCHAR (50) NOT NULL,
[last_name] VARCHAR (50) NOT NULL,
[phone_number] VARCHAR (20) NOT NULL,
[email] VARCHAR (100),
CONSTRAINT PK_member_id PRIMARY KEY CLUSTERED (member_id),
CONSTRAINT FK_member_address FOREIGN KEY (address_id) REFERENCES [Library].[Member_address](address_id)
);
GO

-- Table MemberOwnership
CREATE TABLE [Library].[Member_ownership] (
[member_ownership_id] INT NOT NULL,
[member_id] INT NOT NULL,
[book_id] INT NOT NULL,
[start_rent_date] DATE,
[end_rent_date] DATE,
[overdue_days] INT,
CONSTRAINT PK_member_ownership_id PRIMARY KEY CLUSTERED (member_ownership_id),
CONSTRAINT FK_book_owner FOREIGN KEY (member_id) REFERENCES [Library].[Library_member](member_id),
CONSTRAINT FK_rented_book FOREIGN KEY (book_id) REFERENCES [Library].[Book](book_id),
CONSTRAINT CHK_overdue_days CHECK (overdue_days >= 0)
);
GO