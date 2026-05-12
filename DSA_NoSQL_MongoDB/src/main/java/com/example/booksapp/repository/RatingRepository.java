package com.example.booksapp.repository;

import com.example.booksapp.model.Rating;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface RatingRepository extends MongoRepository<Rating, String> {

    List<Rating> findByUserId(Integer userId);

    List<Rating> findByIsbn(String isbn);
}