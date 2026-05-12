package com.example.booksapp.dto;

public class BookWithRatingsView {

    private String isbn;
    private String bookTitle;
    private String bookAuthor;
    private Double avgRating;
    private Long totalRatings;

    public BookWithRatingsView(String isbn, String bookTitle, String bookAuthor, Double avgRating, Long totalRatings) {
        this.isbn = isbn;
        this.bookTitle = bookTitle;
        this.bookAuthor = bookAuthor;
        this.avgRating = avgRating;
        this.totalRatings = totalRatings;
    }

    public String getIsbn() { return isbn; }
    public String getBookTitle() { return bookTitle; }
    public String getBookAuthor() { return bookAuthor; }
    public Double getAvgRating() { return avgRating; }
    public Long getTotalRatings() { return totalRatings; }
}