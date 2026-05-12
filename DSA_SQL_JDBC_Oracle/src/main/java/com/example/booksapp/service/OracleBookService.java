package com.example.booksapp.service;

import com.example.booksapp.model.Book;
import com.example.booksapp.repository.BookRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Stream;

@Service
public class OracleBookService {

    private final BookRepository bookRepository;

    public OracleBookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public List<Book> getBooks() {

        return bookRepository.findAll()
                .stream()
                .limit(500)
                .toList();
    }

    public List<Book> getBooksByYear(String year) {

        return bookRepository.findAll()
                .stream()
                .filter(book ->
                        book.getYearOfPublication() != null &&
                                book.getYearOfPublication().equalsIgnoreCase(year))
                .limit(200)
                .toList();
    }

    public List<Book> getBooksByPublisher(String publisher) {

        return bookRepository.findAll()
                .stream()
                .filter(book ->
                        book.getPublisher() != null &&
                                book.getPublisher().toLowerCase()
                                        .contains(publisher.toLowerCase()))
                .limit(200)
                .toList();
    }

    public List<Book> getBooksByTitle(String title) {

        return bookRepository.findAll()
                .stream()
                .filter(book ->
                        book.getBookTitle() != null &&
                                book.getBookTitle().toLowerCase()
                                        .contains(title.toLowerCase()))
                .limit(200)
                .toList();
    }
}