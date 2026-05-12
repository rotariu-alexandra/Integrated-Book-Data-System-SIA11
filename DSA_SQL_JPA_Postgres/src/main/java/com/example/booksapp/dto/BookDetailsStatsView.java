package com.example.booksapp.dto;

public class BookDetailsStatsView {

    private String isbn;
    private String bookTitle;
    private String bookAuthor;
    private String yearOfPublication;
    private String publisher;
    private Double avgRating;
    private Long totalRatings;

    public BookDetailsStatsView(String isbn, String bookTitle, String bookAuthor,
                                String yearOfPublication, String publisher,
                                Double avgRating, Long totalRatings) {
        this.isbn = isbn;
        this.bookTitle = bookTitle;
        this.bookAuthor = bookAuthor;
        this.yearOfPublication = yearOfPublication;
        this.publisher = publisher;
        this.avgRating = avgRating;
        this.totalRatings = totalRatings;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public String getYearOfPublication() {
        return yearOfPublication;
    }

    public String getPublisher() {
        return publisher;
    }

    public Double getAvgRating() {
        return avgRating;
    }

    public Long getTotalRatings() {
        return totalRatings;
    }
}