CREATE SCHEMA Library;

SET SEARCH_PATH = Library;

CREATE TABLE Clients (
    ClientEmail VARCHAR(320) PRIMARY KEY CHECK (ClientEmail ~ '^.{1,64}@(\S{1,255})$'),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Password VARCHAR(100) NOT NULL
);

CREATE TABLE Books (
    BookID SERIAL PRIMARY KEY,
    Title TEXT NOT NULL,
    PublishedDate DATE,
    CopiesAvailable INT NOT NULL CHECK (CopiesAvailable >= 0)
);

CREATE TABLE Authors (
    AuthorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    BirthDate DATE
);

CREATE TABLE Genres (
    GenreID SERIAL PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL
);

CREATE TABLE Books_X_Authors (
    BookID INT REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    AuthorID INT REFERENCES Authors(AuthorID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (BookID, AuthorID)
);


CREATE TABLE Books_X_Genres (
    BookID INT REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    GenreID INT REFERENCES Genres(GenreID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (BookID, GenreID)
);

CREATE TABLE Transactions (
    BookID INT REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    ClientEmail VARCHAR(320) REFERENCES Clients(ClientEmail) ON DELETE CASCADE ON UPDATE CASCADE,
    TransactionTime DATE,
    Type VARCHAR(100) NOT NULL,
    PRIMARY KEY (BookID, ClientEmail, TransactionTime)
);

CREATE TABLE Reviews (
    BookID INT REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    ClientEmail VARCHAR(320) REFERENCES Clients(ClientEmail) ON DELETE CASCADE ON UPDATE CASCADE,
    Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 10),
    Comment TEXT,
    PRIMARY KEY (BookID, ClientEmail)
);

CREATE TABLE ReviewsHistory (
    BookID INT REFERENCES Books(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    ClientEmail VARCHAR(320) REFERENCES Clients(ClientEmail) ON DELETE CASCADE ON UPDATE CASCADE,
    ReviewTime TIMESTAMP,
    Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 10),
    Comment TEXT,
    PRIMARY KEY (BookID, ClientEmail, ReviewTime)
);

