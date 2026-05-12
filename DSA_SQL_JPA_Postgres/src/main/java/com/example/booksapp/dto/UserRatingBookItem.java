package com.example.booksapp.dto;

public class UserRatingBookItem {

    private String isbn;
    private String bookTitle;
    private Integer rating;

    public UserRatingBookItem(String isbn, String bookTitle, Integer rating) {
        this.isbn = isbn;
        this.bookTitle = bookTitle;
        this.rating = rating;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public Integer getRating() {
        return rating;
    }
}