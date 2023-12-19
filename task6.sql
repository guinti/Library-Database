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
WHERE Transactions.Type IN ('Borrowed', 'Prolonged')
      AND NOW() BETWEEN Transactions.TransactionTime AND Transactions.TransactionTime + INTERVAL '14 days';

-- 3 клиента, которые взяли наибольшее число книг (возможно одинаковых) --
SELECT Clients.FirstName, Clients.LastName, Clients.ClientEmail, COUNT(Clients.ClientEmail) AS NumberOfBorrowings
FROM Clients
JOIN Transactions ON Clients.ClientEmail = Transactions.ClientEmail
WHERE Transactions.Type = 'Borrowed'
GROUP BY Clients.ClientEmail
ORDER BY NumberOfBorrowings DESC
LIMIT 3;

-- Выборка из 5 книг с наивысшим средним рейтингом --
SELECT
    Books.Title,
    AVG(Reviews.Rating) AS AvgRating,
    DENSE_RANK() OVER (ORDER BY AVG(Reviews.Rating) DESC) AS Rank
FROM Books
JOIN Reviews ON Books.BookID = Reviews.BookID
GROUP BY Books.BookId
ORDER BY Rank
LIMIT 5;

-- Распределение отзывов клиентов по месяцам  --
SELECT
    ClientEmail,
    TO_CHAR(ReviewTime, 'Month YYYY') AS MonthYear,
    COUNT(*) OVER (PARTITION BY ClientEmail, TO_CHAR(ReviewTime, 'Month YYYY')) AS ReviewCount
FROM ReviewsHistory
ORDER BY ClientEmail, MonthYear;

