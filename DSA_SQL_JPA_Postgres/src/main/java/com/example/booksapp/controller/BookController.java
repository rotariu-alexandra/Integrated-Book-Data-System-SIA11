package com.example.booksapp.controller;

import com.example.booksapp.dto.BookRatingView;
import com.example.booksapp.service.BookService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class BookController {

    private final BookService service;

    public BookController(BookService service) {
        this.service = service;
    }

    @GetMapping("/books/top")
    public List<BookRatingView> getTopBooks() {
        return service.getTopBooks();
    }

    @GetMapping("/books")
    public List<BookRatingView> getAllBooks() {
        return service.getAllBooks();
    }
}