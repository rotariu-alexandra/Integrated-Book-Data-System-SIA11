package com.example.booksapp.repository;

import com.example.booksapp.dto.BookRatingView;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BookRatingRepository extends JpaRepository<BookRatingView, String> {
    List<BookRatingView> findTop10ByOrderByAvgRatingDesc();
}