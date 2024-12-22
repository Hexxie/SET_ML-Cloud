USE MyLibrary;
GO

-- 1. Search for book in the library
CREATE NONCLUSTERED INDEX IDX_Books_at_Library_BookID ON [Library].[Books_at_library](book_id);

CREATE NONCLUSTERED INDEX IDX_Book_Title ON [Library].[Book](book_title);

SELECT 
    vlb.BookTitle,
    vlb.BooksAvailable,
    vlb.LibraryName,
    vlb.LibraryAddress
FROM [Library].[vLibraryBook] vlb
WHERE vlb.BookTitle = 'The Art of SQL';

-- 2. Search for all books in certain category
CREATE NONCLUSTERED INDEX IDX_Book_Category ON [Library].[Book](category_id);

SELECT 
    vbc.Category,
    vbc.Title,
    vbc.ISBN
FROM [Library].[vBookCategory] vbc
WHERE vbc.Category = 'Data Science';

-- 3. Search for books by certain author
CREATE NONCLUSTERED INDEX IDX_Author_Name ON [Library].[Author](first_name, last_name);

CREATE NONCLUSTERED INDEX IDX_Book_by_Author_AuthorID ON [Library].[Book_by_author](author_id);

SELECT 
    vba.Title,
    vba.ISBN,
    vba.Author
FROM [Library].[vBookAuthor] vba
WHERE vba.Author = 'Jane Doe';

-- 4. Search for members with overdue book rent
CREATE NONCLUSTERED INDEX IDX_Member_Ownership_Overdue ON [Library].[Member_ownership](overdue_days);

SELECT 
    vbo.MemberName,
    vbo.MemberPhone,
    vbo.BookTitle,
    vbo.StartDate,
    vbo.EndDate,
    vbo.OverdueDays
FROM [Library].[vBookByOwner] vbo
WHERE vbo.OverdueDays > 0;

-- 5. Search for phone number of library member
CREATE NONCLUSTERED INDEX IDX_Library_Member_Name ON [Library].[Library_member](first_name, last_name);

SELECT 
    vma.Name,
    vma.Phone,
    vma.Email,
    vma.MemberAddress
FROM [Library].[vMembersAddress] vma
WHERE vma.Name = 'Ivan Shevchenko';

