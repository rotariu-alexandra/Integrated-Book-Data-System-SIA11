package com.example.booksapp.dto;

public class UserWithRatingsView {

    private Integer userId;
    private String location;
    private Integer age;
    private Long totalRatings;
    private Double avgRating;

    public UserWithRatingsView(Integer userId, String location, Integer age, Long totalRatings, Double avgRating) {
        this.userId = userId;
        this.location = location;
        this.age = age;
        this.totalRatings = totalRatings;
        this.avgRating = avgRating;
    }

    public Integer getUserId() { return userId; }
    public String getLocation() { return location; }
    public Integer getAge() { return age; }
    public Long getTotalRatings() { return totalRatings; }
    public Double getAvgRating() { return avgRating; }
}