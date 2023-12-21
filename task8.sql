SET SEARCH_PATH = Library;


--  Представление дает нам информацию о каждой книге:
--      1) позицию в рейтинге среди всег книг
--      2) название
--      3) жанры (выводим только один)
--      4) авторы (выводим только одного)
--      5) средний рейтинг отзывов
--      6) первый непустой комментарий с наивысшим рейтингом

CREATE OR REPLACE VIEW BookRatingsView AS
WITH
    Comments AS (
        SELECT
            BookId,
            Comment,
            ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY Rating DESC) AS RatingRank
        FROM Reviews
        WHERE Comment IS NOT NULL
    ),
    AuthorNames AS (
        SELECT AuthorID,
            CASE
                WHEN FirstName IS NULL AND LastName IS NULL THEN 'Unknown'
                ELSE
                    COALESCE(FirstName, '') ||
                    CASE WHEN FirstName IS NOT NULL AND LastName IS NOT NULL THEN ' ' ELSE '' END ||
                    COALESCE(LastName, '')
            END AS AuthorName
        FROM Authors
    )
SELECT
    RANK() OVER (ORDER BY AVG(R.Rating) DESC) AS Rank,
    B.Title,
    CASE
        WHEN COUNT(DISTINCT G.GenreID) = 1 THEN MAX(G.GenreName)
        ELSE MAX(G.GenreName) || ', etc.'
    END AS Genre,
    CASE
        WHEN COUNT(DISTINCT A.AuthorID) = 1 THEN MAX(A.AuthorName)
        ELSE MAX(A.AuthorName) || ', etc.'
    END AS Author,
    AVG(R.Rating) AS AverageRating,
    COALESCE(C.Comment, 'There is no comment yet!') as TopComment
FROM Books B
    JOIN Books_X_Genres BG ON B.BookID = BG.BookID
    JOIN Genres G ON BG.GenreID = G.GenreID
    JOIN Books_X_Authors BA ON B.BookID = BA.BookID
    JOIN Reviews R ON B.Bookid = R.Bookid
    JOIN AuthorNames A ON A.AuthorId = BA.AuthorID
    LEFT JOIN Comments C ON B.BookID = C.BookID AND C.RatingRank = 1
GROUP BY B.BookID, C.Comment
ORDER BY AverageRating DESC;


--  Представление дает статистику аренд на каждый месяц:
--      1) Самая популярная книга (наибольшее число аренд): название книги и ее автора
--      2) Самый активный клиент (наибольшее число аренд): если есть, то имя и замаскированная фамилия, иначе замаскированная почта
--      3) Количество книг, арендованных в этом месяце
--      4) Количество людей, делавших аренду в этом месяце

CREATE OR REPLACE VIEW TransactionStatsView AS
WITH
    BorrowedTransactions AS (
        SELECT
            BookID,
            ClientEmail,
            TransactionTime,
            TO_CHAR(TransactionTime, 'Month YYYY') AS MonthYear
        FROM Transactions
        WHERE Type = 'Borrow'
    ),
    ActiveClients AS (
        SELECT
            C.ClientEmail,
            CASE
                WHEN C.FirstName IS NULL AND C.LastName IS NULL THEN
                    REPEAT('*', POSITION('@' IN C.ClientEmail) - 1) || '@' ||
                    RIGHT(C.ClientEmail, LENGTH(C.ClientEmail) - POSITION('@' IN C.ClientEmail))
                ELSE
                    COALESCE(C.FirstName, '') ||
                    CASE WHEN C.FirstName IS NOT NULL AND C.LastName IS NOT NULL THEN ' ' ELSE '' END ||
                    COALESCE(LEFT(C.LastName, 1) || '.', '')
            END AS ClientName,
            T.Monthyear,
            COUNT(C.ClientEmail) AS ClientActivity,
            ROW_NUMBER() OVER (PARTITION BY T.Monthyear ORDER BY COUNT(C.ClientEmail) DESC) as ActivityRank
        FROM Clients C
            JOIN BorrowedTransactions T ON C.ClientEmail = T.ClientEmail
        GROUP BY C.ClientEmail, T.MonthYear
    ),
    SummaryActivity AS (
        SELECT
            Monthyear,
            COUNT(ClientEmail) AS SummaryActivity
        FROM ActiveClients
        GROUP BY MonthYear
    ),
    AuthorNames AS (
        SELECT AuthorID,
            CASE
                WHEN FirstName IS NULL AND LastName IS NULL THEN 'Unknown'
                ELSE
                    COALESCE(FirstName, '') ||
                    CASE WHEN FirstName IS NOT NULL AND LastName IS NOT NULL THEN ' ' ELSE '' END ||
                    COALESCE(LastName, '')
            END AS AuthorName
        FROM Authors
    ),
    PopularBooks AS (
        SELECT
            B.BookID,
            B.Title || ' (' || (
                CASE
                    WHEN COUNT(DISTINCT A.AuthorName) = 1 THEN MAX(A.AuthorName)
                    ELSE MAX(A.AuthorName) || ' etc.'
                END
            ) || ')' AS BookName,
            T.MonthYear,
            COUNT(B.BookID) AS BookPopularity,
            ROW_NUMBER() OVER (PARTITION BY T.Monthyear ORDER BY COUNT(B.BookID) DESC) as PopularityRank
        FROM Books B
            JOIN BorrowedTransactions T ON B.BookID = T.BookID
            JOIN Books_X_Authors BA ON B.BookID = BA.BookID
            JOIN AuthorNames A ON A.AuthorID = BA.AuthorID
        GROUP BY B.BookID, T.MonthYear
    ),
    SummaryPopularity AS (
        SELECT
            Monthyear,
            COUNT(BookID) AS SummaryPopularity
        FROM PopularBooks
        GROUP BY MonthYear
    )
SELECT
    T.MonthYear,
    MAX(B.BookName) AS PopularBook,
    MAX(C.ClientName) AS ActiveClient,
    MAX(P.SummaryPopularity) AS BookCount,
    MAX(A.SummaryActivity) AS ClientCount
FROM BorrowedTransactions T
    LEFT JOIN PopularBooks B ON T.BookID = B.BookID AND B.MonthYear = T.MonthYear AND B.PopularityRank = 1
    LEFT JOIN ActiveClients C ON T.ClientEmail = C.ClientEmail AND C.MonthYear = T.MonthYear  AND C.ActivityRank = 1
    LEFT JOIN SummaryActivity A ON T.MonthYear = A.MonthYear
    LEFT JOIN SummaryPopularity P ON T.MonthYear = P.MonthYear
GROUP BY T.MonthYear
ORDER BY MAX(T.TransactionTime);


--  Представление возвращает список основной информации о тех книгах, которые есть в наличии в данный момент времени:
--      1) Название
--      2) Жанр (выводим только один)
--      3) Автор (выводим только одного)
--      4) Количество книг в наличии

CREATE OR REPLACE VIEW AvailableBooksView AS
WITH
    RankedTransactions AS (
        SELECT
            BookID,
            ClientEmail,
            TransactionTime,
            Type,
            ROW_NUMBER() OVER (PARTITION BY BookID, ClientEmail ORDER BY TransactionTime DESC) AS Rank
        FROM Transactions
    ),
    BorrowedBooks AS (
        SELECT
            BookID,
            COUNT(ClientEmail) as CopiesTaken
        FROM RankedTransactions T
        WHERE T.Rank = 1 AND (Type = 'Borrow' OR Type = 'Reserve' OR Type = 'Expansion')
        GROUP BY BookID
    ),
    AvailableBooks as (
        SELECT
            B.CopiesAvailable - COALESCE(BB.CopiesTaken, 0) as AvailableCount,
            B.BookID,
            B.Title
        FROM Books B
            LEFT JOIN BorrowedBooks BB ON B.BookID = BB.BookID
    ),
    AuthorNames AS (
        SELECT AuthorID,
            CASE
                WHEN FirstName IS NULL AND LastName IS NULL THEN 'Unknown'
                ELSE
                    COALESCE(FirstName, '') ||
                    CASE WHEN FirstName IS NOT NULL AND LastName IS NOT NULL THEN ' ' ELSE '' END ||
                    COALESCE(LastName, '')
            END AS AuthorName
        FROM Authors
    )
SELECT
    MAX(B.Title) as Title,
    CASE
        WHEN COUNT(DISTINCT G.GenreID) = 1 THEN MAX(G.GenreName)
        ELSE MAX(G.GenreName) || ', etc.'
    END AS Genre,
    CASE
        WHEN COUNT(DISTINCT A.AuthorID) = 1 THEN MAX(A.AuthorName)
        ELSE MAX(A.AuthorName) || ', etc.'
    END AS Author,
    MAX(B.AvailableCount) as CurrentBookNumber
FROM AvailableBooks B
    LEFT JOIN Books_X_Genres BG ON B.BookID = BG.BookID
    LEFT JOIN Genres G ON BG.GenreID = G.GenreID
    LEFT JOIN Books_X_Authors BA ON B.BookID = BA.BookID
    LEFT JOIN AuthorNames A ON BA.AuthorID = A.AuthorID
WHERE B.AvailableCount > 0
GROUP BY B.BookID
ORDER BY MAX(B.Title);

