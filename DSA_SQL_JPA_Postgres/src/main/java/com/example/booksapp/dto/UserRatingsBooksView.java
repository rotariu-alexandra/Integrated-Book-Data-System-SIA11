package com.example.booksapp.dto;

import java.util.List;

public class UserRatingsBooksView {

    private Integer userId;
    private Long totalRatings;
    private Double avgRating;
    private List<UserRatingBookItem> books;

    public UserRatingsBooksView(Integer userId, Long totalRatings, Double avgRating, List<UserRatingBookItem> books) {
        this.userId = userId;
        this.totalRatings = totalRatings;
        this.avgRating = avgRating;
        this.books = books;
    }

    public Integer getUserId() {
        return userId;
    }

    public Long getTotalRatings() {
        return totalRatings;
    }

    public Double getAvgRating() {
        return avgRating;
    }

    public List<UserRatingBookItem> getBooks() {
        return books;
    }
}