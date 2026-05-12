package com.example.booksapp.dto;

public class TopUserRatingsView {

    private Integer userId;
    private Long totalRatings;
    private Double avgRating;

    public TopUserRatingsView(Integer userId, Long totalRatings, Double avgRating) {
        this.userId = userId;
        this.totalRatings = totalRatings;
        this.avgRating = avgRating;
    }

    public Integer getUserId() { return userId; }
    public Long getTotalRatings() { return totalRatings; }
    public Double getAvgRating() { return avgRating; }
}