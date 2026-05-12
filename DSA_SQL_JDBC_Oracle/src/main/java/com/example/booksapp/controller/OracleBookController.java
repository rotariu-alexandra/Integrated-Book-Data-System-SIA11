package com.example.booksapp.controller;

import com.example.booksapp.model.Book;
import com.example.booksapp.service.OracleBookService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/oracle")
public class OracleBookController {

    private final OracleBookService service;

    public OracleBookController(OracleBookService service) {
        this.service = service;
    }

    @GetMapping("/books")
    public List<Book> getBooks() {
        return service.getBooks();
    }

    @GetMapping("/books/year/{year}")
    public List<Book> getBooksByYear(@PathVariable String year) {
        return service.getBooksByYear(year);
    }

    @GetMapping("/books/publisher")
    public List<Book> getBooksByPublisher(@RequestParam String value) {
        return service.getBooksByPublisher(value);
    }

    @GetMapping("/books/title")
    public List<Book> getBooksByTitle(@RequestParam String value) {
        return service.getBooksByTitle(value);
    }
}