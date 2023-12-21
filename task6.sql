SET SEARCH_PATH = Library;


-- Клиенты, которые написали не менее 2 отзывов (возможно на одну книгу) --
SELECT Clients.ClientEmail, Clients.FirstName, Clients.LastName, COUNT(ReviewsHistory.ClientEmail) AS NumberOfReviews
FROM Clients
LEFT JOIN ReviewsHistory ON Clients.ClientEmail = ReviewsHistory.ClientEmail
GROUP BY Clients.ClientEmail
HAVING COUNT(ReviewsHistory.ClientEmail) >= 2
ORDER BY NumberOfReviews DESC;


-- Список книг, находящихся в аренде в данный момент времени --
SELECT Books.Title
FROM Books
JOIN Transactions ON Books.BookID = Transactions.BookID
JOIN Clients ON Transactions.ClientEmail = Clients.ClientEmail
WHERE Transactions.Type IN ('Borrow', 'Extension')
      AND NOW() BETWEEN Transactions.TransactionTime AND Transactions.TransactionTime + INTERVAL '14 days'
GROUP BY Books.Title;


-- 3 клиента, которые взяли наибольшее число книг (возможно одинаковых) --
SELECT Clients.ClientEmail, Clients.FirstName, Clients.LastName, COUNT(Clients.ClientEmail) AS NumberOfBorrowings
FROM Clients
JOIN Transactions ON Clients.ClientEmail = Transactions.ClientEmail
WHERE Transactions.Type = 'Borrow'
GROUP BY Clients.ClientEmail
ORDER BY NumberOfBorrowings DESC
LIMIT 3;


-- Выборка из 3 книг с наивысшим средним рейтингом --
SELECT
    DENSE_RANK() OVER (ORDER BY AVG(Reviews.Rating) DESC) AS Rank,
    Books.Title,
    AVG(Reviews.Rating) AS Rating
FROM Books
JOIN Reviews ON Books.BookID = Reviews.BookID
GROUP BY Books.BookId
ORDER BY Rank
LIMIT 3;


-- Распределение отзывов клиентов по месяцам  --
SELECT
    ClientEmail,
    TO_CHAR(ReviewTime, 'Month YYYY') AS MonthYear,
    COUNT(ClientEmail) AS ReviewCount
FROM ReviewsHistory
GROUP BY ClientEmail, MonthYear
ORDER BY ClientEmail, MonthYear;

