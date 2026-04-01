CREATE TABLE book (
    isbn VARCHAR2(20) PRIMARY KEY,
    title VARCHAR2(255),
    author VARCHAR2(255),
    year_of_publication VARCHAR2(20),
    publisher VARCHAR2(255)
);

DROP TABLE book;

CREATE TABLE book (
    isbn VARCHAR2(20) PRIMARY KEY,
    title VARCHAR2(1000),
    author VARCHAR2(500),
    year_of_publication VARCHAR2(20),
    publisher VARCHAR2(500)
);

SELECT * FROM book;