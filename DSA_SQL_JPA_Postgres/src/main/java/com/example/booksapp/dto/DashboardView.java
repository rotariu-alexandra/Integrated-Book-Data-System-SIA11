package com.example.booksapp.dto;

import java.util.List;

public class DashboardView {

    private List<BookRatingStats> topBooks;
    private List<UserRatingStats> topUsers;
    private List<BookWithRatingsView> booksWithRatings;
    private List<UserWithRatingsView> usersWithRatings;

    public DashboardView(List<BookRatingStats> topBooks,
                         List<UserRatingStats> topUsers,
                         List<BookWithRatingsView> booksWithRatings,
                         List<UserWithRatingsView> usersWithRatings) {
        this.topBooks = topBooks;
        this.topUsers = topUsers;
        this.booksWithRatings = booksWithRatings;
        this.usersWithRatings = usersWithRatings;
    }

    public List<BookRatingStats> getTopBooks() { return topBooks; }
    public List<UserRatingStats> getTopUsers() { return topUsers; }
    public List<BookWithRatingsView> getBooksWithRatings() { return booksWithRatings; }
    public List<UserWithRatingsView> getUsersWithRatings() { return usersWithRatings; }
}