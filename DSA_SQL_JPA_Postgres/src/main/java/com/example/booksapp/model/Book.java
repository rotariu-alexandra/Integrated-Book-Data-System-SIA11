package com.example.booksapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "books")
public class Book {

    @Id
    private String isbn;

    @Column(name = "book_title")
    private String bookTitle;

    @Column(name = "book_author")
    private String bookAuthor;

    @Column(name = "year_of_publication")
    private String yearOfPublication;

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