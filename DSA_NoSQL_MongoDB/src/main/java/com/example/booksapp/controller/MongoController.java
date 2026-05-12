package com.example.booksapp.controller;

import com.example.booksapp.model.Rating;
import com.example.booksapp.repository.RatingRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mongo")
public class MongoController {

    private final RatingRepository repository;

    public MongoController(RatingRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/ratings")
    public List<Rating> getRatings() {
        return repository.findAll().stream().limit(10000).toList();
    }

    @GetMapping("/ratings/user/{userId}")
    public List<Rating> getRatingsByUser(@PathVariable Integer userId) {
        return repository.findByUserId(userId);
    }

    @GetMapping("/ratings/book/{isbn}")
    public List<Rating> getRatingsByBook(@PathVariable String isbn) {
        return repository.findByIsbn(isbn);
    }
}