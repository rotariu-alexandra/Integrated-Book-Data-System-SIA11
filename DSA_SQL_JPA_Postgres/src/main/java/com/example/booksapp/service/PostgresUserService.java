package com.example.booksapp.service;

import com.example.booksapp.dto.UserWithRatingsView;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostgresUserService {

    private final JdbcTemplate jdbcTemplate;

    public PostgresUserService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<UserWithRatingsView> getUsersWithRatings() {
        String sql = """
                SELECT u.user_id,
                       u.location,
                       u.age,
                       COUNT(r.book_rating) AS total_ratings,
                       COALESCE(AVG(r.book_rating), 0) AS avg_rating
                FROM users u
                LEFT JOIN ratings r ON u.user_id = r.user_id
                GROUP BY u.user_id, u.location, u.age
                ORDER BY total_ratings DESC
                LIMIT 20
                """;

        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new UserWithRatingsView(
                        rs.getInt("user_id"),
                        rs.getString("location"),
                        rs.getInt("age"),
                        rs.getLong("total_ratings"),
                        rs.getDouble("avg_rating")
                )
        );
    }
}