SET SEARCH_PATH = Library;


CREATE OR REPLACE VIEW BooksView AS
SELECT
    Title,
    FirstName || LastName AS Author,
    PublishedDate,
    CopiesAvailable
FROM Books
LEFT JOIN Books_X_Authors ON Books.BookID = Books_X_Authors.BookID
LEFT JOIN Authors ON Books_X_Authors.AuthorID = Authors.AuthorID;


CREATE OR REPLACE VIEW AuthorsView AS
SELECT
    FirstName,
    LastName,
    BirthDate
FROM Authors;


CREATE OR REPLACE VIEW GenresView AS
SELECT
    GenreName
FROM Genres;


CREATE OR REPLACE VIEW ClientsView AS
SELECT
    REPEAT('*', POSITION('@' IN ClientEmail) - 1) || '@' ||
        RIGHT(ClientEmail, LENGTH(ClientEmail) - POSITION('@' IN ClientEmail)) AS ClientEmail,
    FirstName,
    LastName,
    REPEAT('*', LENGTH(Password)) AS Password
FROM Clients;


CREATE OR REPLACE VIEW ReviewsView AS
SELECT
    REPEAT('*', POSITION('@' IN ClientEmail) - 1) || '@' ||
        RIGHT(ClientEmail, LENGTH(ClientEmail) - POSITION('@' IN ClientEmail)) AS ReviewAuthor,
    Title,
    Rating,
    Comment
FROM Reviews
LEFT JOIN Books on Reviews.BookID = Books.BookID;


CREATE OR REPLACE VIEW ReviewsHistoryView AS
SELECT
    REPEAT('*', POSITION('@' IN ClientEmail) - 1) || '@' ||
        RIGHT(ClientEmail, LENGTH(ClientEmail) - POSITION('@' IN ClientEmail)) AS ReviewAuthor,
    Title,
    DATE(ReviewTime) AS ReviewDate,
    Rating,
    Comment
FROM ReviewsHistory
LEFT JOIN Books ON ReviewsHistory.BookID = Books.BookID;


CREATE OR REPLACE VIEW TransactionsView AS
SELECT
    REPEAT('*', POSITION('@' IN ClientEmail) - 1) || '@' ||
        RIGHT(ClientEmail, LENGTH(ClientEmail) - POSITION('@' IN ClientEmail)) AS ClientEmail,
    Title,
    DATE(TransactionTime) AS TransationDate,
    Type
FROM Transactions
LEFT JOIN Books ON Books.BookID = Transactions.BookID;

