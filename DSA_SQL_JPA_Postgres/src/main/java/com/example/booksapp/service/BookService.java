package com.example.booksapp.service;


import com.example.booksapp.dto.BookRatingView;
import com.example.booksapp.repository.BookRatingRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookService {

    private final BookRatingRepository repository;

    public BookService(BookRatingRepository repository) {
        this.repository = repository;
    }

    public List<BookRatingView> getTopBooks() {
        return repository.findTop10ByOrderByAvgRatingDesc();
    }

    public List<BookRatingView> getAllBooks() {
        return repository.findAll();
    }
}