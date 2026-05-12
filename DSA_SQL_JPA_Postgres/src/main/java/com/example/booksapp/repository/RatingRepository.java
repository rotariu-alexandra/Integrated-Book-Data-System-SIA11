package com.example.booksapp.repository;

import com.example.booksapp.model.Rating;
import com.example.booksapp.model.RatingId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RatingRepository extends JpaRepository<Rating, RatingId> {
}