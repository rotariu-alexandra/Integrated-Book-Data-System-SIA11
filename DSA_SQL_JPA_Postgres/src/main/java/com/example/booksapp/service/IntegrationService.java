package com.example.booksapp.service;

import com.example.booksapp.dto.UserRatingBookItem;
import com.example.booksapp.dto.UserRatingStats;
import com.example.booksapp.dto.UserRatingsBooksView;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IntegrationService {

    private final JdbcTemplate jdbcTemplate;

    public IntegrationService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<UserRatingStats> getTopUsers() {
        String sql = """
                SELECT user_id,
                       COUNT(*) AS total_ratings,
                       AVG(book_rating) AS avg_rating
                FROM ratings
                GROUP BY user_id
                ORDER BY total_ratings DESC
                LIMIT 20
                """;

        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new UserRatingStats(
                        rs.getInt("user_id"),
                        rs.getLong("total_ratings"),
                        rs.getDouble("avg_rating")
                )
        );
    }

    public List<UserRatingBookItem> getUserRatingItems(Integer userId) {
        String sql = """
                SELECT isbn,
                       book_rating
                FROM ratings
                WHERE user_id = ?
                LIMIT 50
                """;

        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new UserRatingBookItem(
                        rs.getString("isbn"),
                        null,
                        rs.getInt("book_rating")
                ), userId);
    }

    public UserRatingsBooksView getUserRatingsBooks(Integer userId) {
        String statsSql = """
                SELECT user_id,
                       COUNT(*) AS total_ratings,
                       AVG(book_rating) AS avg_rating
                FROM ratings
                WHERE user_id = ?
                GROUP BY user_id
                """;

        UserRatingStats stats = jdbcTemplate.queryForObject(statsSql, (rs, rowNum) ->
                new UserRatingStats(
                        rs.getInt("user_id"),
                        rs.getLong("total_ratings"),
                        rs.getDouble("avg_rating")
                ), userId);

        List<UserRatingBookItem> ratings = getUserRatingItems(userId);

        return new UserRatingsBooksView(
                stats.getUserId(),
                stats.getTotalRatings(),
                stats.getAvgRating(),
                ratings
        );
    }
}