package com.example.booksapp.model;

import java.io.Serializable;
import java.util.Objects;

public class RatingId implements Serializable {

    private Integer userId;
    private String isbn;

    public RatingId() {
    }

    public RatingId(Integer userId, String isbn) {
        this.userId = userId;
        this.isbn = isbn;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getIsbn() {
        return isbn;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RatingId ratingId)) return false;
        return Objects.equals(userId, ratingId.userId) &&
                Objects.equals(isbn, ratingId.isbn);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, isbn);
    }
}