SET SEARCH_PATH = Library;

--Clients Table
INSERT INTO Clients (ClientEmail, FirstName, LastName, Password) VALUES ('john.doe@email.com', 'John', 'Doe', 'password123');
INSERT INTO Clients (ClientEmail, FirstName, LastName, Password) VALUES ('jane.smith@email.com', 'Jane', 'Smith', 'password456');
INSERT INTO Clients (ClientEmail, FirstName, LastName, Password) VALUES ('alex.jones@email.com', 'Alex', 'Jones', 'password789');
INSERT INTO Clients (ClientEmail, Password) VALUES ('lisa.white@email.com', 'password321');
INSERT INTO Clients (ClientEmail, FirstName, LastName, Password) VALUES ('mike.brown@email.com', 'Mike', 'Brown', 'password654');


--Books Table
INSERT INTO Books (Title, PublishedDate, CopiesAvailable) VALUES ('1984', '1949-06-08', 10);
INSERT INTO Books (Title, CopiesAvailable) VALUES ('To Kill a Mockingbird', 5);
INSERT INTO Books (Title, PublishedDate, CopiesAvailable) VALUES ('War and Peace', '1867-01-09', 12);
INSERT INTO Books (Title, PublishedDate, CopiesAvailable) VALUES ('Pride and Prejudice', '1813-01-28', 7);
INSERT INTO Books (Title, PublishedDate, CopiesAvailable) VALUES ('The Da Vinci Code', '2003-03-18', 30);


--Authors Table
INSERT INTO Authors (FirstName, LastName) VALUES ('George', 'Orwell');
INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES ('Harper', 'Lee', '1926-04-28');
INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES ('Leo', 'Tolstoy', '1828-09-09');
INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES ('Jane', 'Austen', '1775-12-16');
INSERT INTO Authors (FirstName, LastName, BirthDate) VALUES ('Dan', 'Brown', '1964-06-22');


--Genres Table
INSERT INTO Genres (GenreName) VALUES ('Social Science Fiction');
INSERT INTO Genres (GenreName) VALUES ('Fiction');
INSERT INTO Genres (GenreName) VALUES ('Novel');
INSERT INTO Genres (GenreName) VALUES ('Fantasy');
INSERT INTO Genres (GenreName) VALUES ('Mystery');

--Books_X_Authors Table
--Linking books to authors:
INSERT INTO Books_X_Authors (BookID, AuthorID) VALUES (1, 1);
INSERT INTO Books_X_Authors (BookID, AuthorID) VALUES (2, 2);
INSERT INTO Books_X_Authors (BookID, AuthorID) VALUES (3, 3);
INSERT INTO Books_X_Authors (BookID, AuthorID) VALUES (4, 4);
INSERT INTO Books_X_Authors (BookID, AuthorID) VALUES (5, 5);


--Books_X_Genres Table
--Linking books to genres:
INSERT INTO Books_X_Genres (BookID, GenreID) VALUES (1, 1);
INSERT INTO Books_X_Genres (BookID, GenreID) VALUES (2, 2);
INSERT INTO Books_X_Genres (BookID, GenreID) VALUES (3, 3);
INSERT INTO Books_X_Genres (BookID, GenreID) VALUES (4, 4);
INSERT INTO Books_X_Genres (BookID, GenreID) VALUES (5, 5);

--Transactions Table
--Sample transactions:
INSERT INTO Transactions (BookID, ClientEmail, TransactionTime, Type) VALUES (1, 'john.doe@email.com', '2023-01-01', 'Borrow');
INSERT INTO Transactions (BookID, ClientEmail, TransactionTime, Type) VALUES (2, 'jane.smith@email.com', '2023-02-02', 'Return');
INSERT INTO Transactions (BookID, ClientEmail, TransactionTime, Type) VALUES (3, 'alex.jones@email.com', '2023-03-03', 'Borrow');
INSERT INTO Transactions (BookID, ClientEmail, TransactionTime, Type) VALUES (4, 'lisa.white@email.com', '2023-04-04', 'Borrow');
INSERT INTO Transactions (BookID, ClientEmail, TransactionTime, Type) VALUES (5, 'mike.brown@email.com', '2023-05-05', 'Return');


--Reviews Table
--Clients reviewing books:
INSERT INTO Reviews (BookID, ClientEmail, Rating, Comment) VALUES (1, 'john.doe@email.com', 8, 'Great book!');
INSERT INTO Reviews (BookID, ClientEmail, Rating, Comment) VALUES (2, 'jane.smith@email.com', 7, 'Very informative.');
INSERT INTO Reviews (BookID, ClientEmail, Rating, Comment) VALUES (3, 'alex.jones@email.com', 9, 'Loved it!');
INSERT INTO Reviews (BookID, ClientEmail, Rating, Comment) VALUES (4, 'lisa.white@email.com', 6, 'Interesting read.');
INSERT INTO Reviews (BookID, ClientEmail, Rating, Comment) VALUES (5, 'mike.brown@email.com', 10, 'Best book ever!');


--ReviewsHistory Table
--History of reviews made by clients:
INSERT INTO ReviewsHistory (BookID, ClientEmail, ReviewTime, Rating, Comment) VALUES (1, 'john.doe@email.com', '2023-01-10 10:00:00', 8, 'Great book!');
INSERT INTO ReviewsHistory (BookID, ClientEmail, ReviewTime, Rating, Comment) VALUES (2, 'jane.smith@email.com', '2023-02-20 11:00:00', 7, 'Very informative.');
INSERT INTO ReviewsHistory (BookID, ClientEmail, ReviewTime, Rating, Comment) VALUES (3, 'alex.jones@email.com', '2023-03-30 12:00:00', 9, 'Loved it!');
INSERT INTO ReviewsHistory (BookID, ClientEmail, ReviewTime, Rating, Comment) VALUES (4, 'lisa.white@email.com', '2023-04-15 13:00:00', 6, 'Interesting read.');
INSERT INTO ReviewsHistory (BookID, ClientEmail, ReviewTime, Rating, Comment) VALUES (5, 'mike.brown@email.com', '2023-05-25 14:00:00', 10, 'Best book ever!');
