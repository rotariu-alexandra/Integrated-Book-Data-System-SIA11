package com.example.booksapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "ratings")
@IdClass(RatingId.class)
public class Rating {

    @Id
    @Column(name = "user_id")
    private Integer userId;

    @Id
    private String isbn;

    @Column(name = "book_rating")
    private Integer bookRating;

    public Integer getUserId() {
        return userId;
    }

    public String getIsbn() {
        return isbn;
    }

    public Integer getBookRating() {
        return bookRating;
    }
}