package com.example.booksapp.repository;

import com.example.booksapp.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, String> {
}