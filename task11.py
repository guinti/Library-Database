from sqlalchemy import create_engine, func, update, delete
from sqlalchemy.orm import sessionmaker

from ORM import Base, Client, Book, Author, Genre, BookXGenre, Review, Transaction

# change this for your local address, username and password
# 'postgresql://{username}:{password}@localhost:5432/{db_name}'
DB_URL = 'postgresql://postgres:postgres@localhost:5432/postgres'


def main():
    engine = create_engine(DB_URL)
    Base.metadata.create_all(engine)
    session = sessionmaker(bind=engine)()

    # CREATE
    new_client = Client(clientemail='new@example.com', firstname='John', lastname='Smith', password='simple_password')
    session.add(new_client)

    # READ
    book_query = session.query(Book.title)

    print("Book titles:")
    for title in book_query:
        print(f"{title.title}")
    print()

    # UPDATE
    update_query = update(Author).values(lastname='Brown').where(Author.authorid == 8)
    session.execute(update_query)

    # DELETE
    delete_query = delete(Genre).where(Genre.genrename == 'History')
    session.execute(delete_query)

    # SELECTS
    
    query_result = session.query(Genre.genrename.label('GenreName'), func.count(Review.bookid).label('ReviewCount')) \
                          .outerjoin(BookXGenre, Genre.genreid == BookXGenre.genreid) \
                          .outerjoin(Review, BookXGenre.bookid == Review.bookid) \
                          .group_by(Genre.genrename) \
                          .order_by(func.count(Review.bookid).desc())

    print("Review count for every genre:")
    print(f"| {'Genre':<25} | {'ReviewCount':<15} |")
    for result in query_result:
        print(f"| {result.GenreName:<25} | {result.ReviewCount:<15} |")
    print()

    query_result = session.query(func.dense_rank().over(order_by=func.count(Book.bookid).desc()).label("Rank"),
                                 Book.title.label('Title'),
                                 func.count(Book.bookid).label('BorrowingsNumber')) \
                          .outerjoin(Transaction, Transaction.bookid == Book.bookid) \
                          .filter(Transaction.type == 'Borrow') \
                          .group_by(Book.bookid)

    print("Book rankings by number of borrowings:")
    print(f"| {'Rank':<10} | {'Title':<40} | {'BorrowingsNumber':<20} |")
    for result in query_result:
        print(f"| {result.Rank:<10} | {result.Title:<40} | {result.BorrowingsNumber:<20} |")
    print()

    session.commit()


if __name__ == '__main__':
    main()
