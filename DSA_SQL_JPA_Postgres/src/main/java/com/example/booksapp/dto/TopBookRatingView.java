package com.example.booksapp.dto;

public class TopBookRatingView {

    private String isbn;
    private String bookTitle;
    private Double avgRating;
    private Long totalRatings;

    public TopBookRatingView(String isbn, String bookTitle, Double avgRating, Long totalRatings) {
        this.isbn = isbn;
        this.bookTitle = bookTitle;
        this.avgRating = avgRating;
        this.totalRatings = totalRatings;
    }

    public String getIsbn() { return isbn; }
    public String getBookTitle() { return bookTitle; }
    public Double getAvgRating() { return avgRating; }
    public Long getTotalRatings() { return totalRatings; }
}