package com.example.booksapp.dto;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "book_ratings_avg")
public class BookRatingView {

    @Id
    private String isbn;

    private String bookTitle;
    private Double avgRating;
    private Long totalRatings;

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public Double getAvgRating() { return avgRating; }
    public void setAvgRating(Double avgRating) { this.avgRating = avgRating; }

    public Long getTotalRatings() { return totalRatings; }
    public void setTotalRatings(Long totalRatings) { this.totalRatings = totalRatings; }
}