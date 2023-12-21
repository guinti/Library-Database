from sqlalchemy import Column, Integer, String, Date, DateTime, Text, ForeignKey, CheckConstraint
from sqlalchemy.orm import declarative_base


Base = declarative_base()
Base.__table_args__ = {'schema': 'library'}


class Client(Base):
    __tablename__ = 'clients'

    clientemail = Column(String(320), CheckConstraint('client_email ~ \'^.{1,64}@(\\S{1,255})$'), primary_key=True, nullable=False)
    firstname = Column(String(100))
    lastname = Column(String(100))
    password = Column(String(100), nullable=False)


class Book(Base):
    __tablename__ = 'books'

    bookid = Column(Integer, primary_key=True)
    title = Column(Text, nullable=False)
    publisheddate = Column(Date)
    copiesavailable = Column(Integer, CheckConstraint('copiesavailable >= 0'),  nullable=False)


class Author(Base):
    __tablename__ = 'authors'

    authorid = Column(Integer, primary_key=True)
    firstname = Column(String(100))
    lastname = Column(String(100))
    birthdate = Column(Date)


class Genre(Base):
    __tablename__ = 'genres'

    genreid = Column(Integer, primary_key=True)
    genrename = Column(String(100), nullable=False)


class BookXAuthor(Base):
    __tablename__ = 'books_x_authors'

    bookid = Column(Integer, ForeignKey('library.books.bookid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    authorid = Column(Integer, ForeignKey('library.authors.authorid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class BookXGenre(Base):
    __tablename__ = 'books_x_genres'

    bookid = Column(Integer, ForeignKey('library.books.bookid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    genreid = Column(Integer, ForeignKey('library.genres.genreid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class Transaction(Base):
    __tablename__ = 'transactions'

    bookid = Column(Integer, ForeignKey('library.books.bookid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    clientemail = Column(String(320), ForeignKey('library.clients.clientemail', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    transactiontime = Column(DateTime)
    type = Column(String(100), nullable=False)


class Review(Base):
    __tablename__ = 'reviews'

    bookid = Column(Integer, ForeignKey('library.books.bookid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    clientemail = Column(String(320), ForeignKey('library.clients.clientemail', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    rating = Column(Integer, CheckConstraint('rating >= 0 AND rating <= 10'), nullable=False)
    comment = Column(Text)


class ReviewHistory(Base):
    __tablename__ = 'reviewshistory'

    bookid = Column(Integer, ForeignKey('books.bookid', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    clientemail = Column(String(320), ForeignKey('library.clients.clientemail', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    reviewtime = Column(DateTime, primary_key=True)
    rating = Column(Integer, CheckConstraint('rating >= 0 AND rating <= 10'), nullable=False)
    comment = Column(Text)
