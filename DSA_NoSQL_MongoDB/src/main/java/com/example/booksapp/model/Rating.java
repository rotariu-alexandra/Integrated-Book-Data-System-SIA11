package com.example.booksapp.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document(collection = "ratings")
public class Rating {

    @Id
    private String id;

    @Field("User-ID")
    private Integer userId;

    @Field("ISBN")
    private String isbn;

    @Field("Book-Rating")
    private Integer bookRating;

    public Rating() {
    }

    public String getId() {
        return id;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getIsbn() {
        return isbn;
    }

    public Integer getBookRating() {
        return bookRating;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public void setBookRating(Integer bookRating) {
        this.bookRating = bookRating;
    }
}