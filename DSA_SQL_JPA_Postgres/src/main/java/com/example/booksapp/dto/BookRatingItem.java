package com.example.booksapp.dto;

public class BookRatingItem {

    private Integer userId;
    private Integer rating;

    public BookRatingItem(Integer userId, Integer rating) {
        this.userId = userId;
        this.rating = rating;
    }

    public Integer getUserId() { return userId; }
    public Integer getRating() { return rating; }
}