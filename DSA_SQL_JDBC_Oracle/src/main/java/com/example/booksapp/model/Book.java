package com.example.booksapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "BOOKS")
public class Book {

    @Id
    @Column(name = "ISBN")
    private String isbn;

    @Column(name = "BOOK_TITLE")
    private String bookTitle;

    @Column(name = "BOOK_AUTHOR")
    private String bookAuthor;

    @Column(name = "YEAR_OF_PUBLICATION")
    private String yearOfPublication;

    @Column(name = "PUBLISHER")
    private String publisher;

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getBookAuthor() { return bookAuthor; }
    public void setBookAuthor(String bookAuthor) { this.bookAuthor = bookAuthor; }

    public String getYearOfPublication() { return yearOfPublication; }
    public void setYearOfPublication(String yearOfPublication) { this.yearOfPublication = yearOfPublication; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
}