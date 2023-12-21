SET SEARCH_PATH = Library;


-- Процедура удаляет все записи из таблиц Books, Authors, Genres, которые не удовлетворяют условию:
-- у каждой книги должен быть хотя бы один жанр и автор, у каждого автора и жанра хотя бы одна книга
CREATE OR REPLACE PROCEDURE delete_incorrect_entries()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Books
    WHERE BookID NOT IN (
        SELECT BookID
        FROM Books_X_Authors
    );

    DELETE FROM Authors
    WHERE AuthorID NOT IN (
        SELECT AuthorID
        FROM Books_X_Authors
    );

    DELETE FROM Books
    WHERE BookID NOT IN (
        SELECT BookID
        FROM Books_X_Genres
    );

    DELETE FROM Genres
    WHERE GenreID NOT IN (
        SELECT GenreID
        FROM Books_X_Genres
    );
END;
$$;


 -- Процедура удаляет недоступные книги, после чего устраняет все некорректные записи, возникшие в ходе удаления.
CREATE OR REPLACE PROCEDURE delete_unavailable_books()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Books
    WHERE CopiesAvailable = 0;

    CALL delete_incorrect_entries();
END;
$$;

