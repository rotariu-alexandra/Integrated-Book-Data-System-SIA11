package com.example.booksapp.dto;

public class BookSearchView {

    private String isbn;
    private String bookTitle;
    private String bookAuthor;
    private String yearOfPublication;
    private String publisher;

    public BookSearchView(String isbn, String bookTitle, String bookAuthor,
                          String yearOfPublication, String publisher) {
        this.isbn = isbn;
        this.bookTitle = bookTitle;
        this.bookAuthor = bookAuthor;
        this.yearOfPublication = yearOfPublication;
        this.publisher = publisher;
    }

    public String getIsbn() { return isbn; }
    public String getBookTitle() { return bookTitle; }
    public String getBookAuthor() { return bookAuthor; }
    public String getYearOfPublication() { return yearOfPublication; }
    public String getPublisher() { return publisher; }
}