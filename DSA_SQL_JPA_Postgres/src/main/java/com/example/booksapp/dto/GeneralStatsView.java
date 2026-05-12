package com.example.booksapp.dto;

public class GeneralStatsView {

    private Long totalBooks;
    private Long totalUsers;
    private Long totalRatings;
    private Double averageRating;

    public GeneralStatsView(Long totalBooks, Long totalUsers, Long totalRatings, Double averageRating) {
        this.totalBooks = totalBooks;
        this.totalUsers = totalUsers;
        this.totalRatings = totalRatings;
        this.averageRating = averageRating;
    }

    public Long getTotalBooks() { return totalBooks; }
    public Long getTotalUsers() { return totalUsers; }
    public Long getTotalRatings() { return totalRatings; }
    public Double getAverageRating() { return averageRating; }
}