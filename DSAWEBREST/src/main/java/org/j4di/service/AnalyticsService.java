package org.j4di.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AnalyticsService {

    private final JdbcTemplate jdbcTemplate;

    public AnalyticsService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> getDashboardSummary() {

        String sql = """
                SELECT
                    COUNT(DISTINCT user_id) AS total_users,
                    COUNT(DISTINCT isbn) AS total_books,
                    COUNT(DISTINCT publisher) AS total_publishers,
                    COUNT(*) AS total_ratings,
                    ROUND(AVG(rating), 2) AS avg_rating,
                    MAX(rating) AS max_rating,
                    MIN(rating) AS min_rating
                FROM VW_BOOK_RATINGS_FULL
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getBooksPreview() {

        String sql = """
                SELECT
                    isbn,
                    title,
                    author,
                    year,
                    publisher
                FROM VW_BOOK_RATINGS_FULL
                WHERE title IS NOT NULL
                LIMIT 500
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getTopRatedBooks() {

        String sql = """
                SELECT
                    title,
                    author,
                    publisher,
                    ROUND(AVG(rating),2) AS average_rating,
                    COUNT(*) AS rating_count
                FROM VW_BOOK_RATINGS_FULL
                WHERE title IS NOT NULL
                GROUP BY title, author, publisher
                ORDER BY average_rating DESC
                LIMIT 20
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getUsersPreview() {

        String sql = """
                SELECT
                    user_id,
                    age,
                    location
                FROM VW_BOOK_RATINGS_FULL
                WHERE user_id IS NOT NULL
                  AND location IS NOT NULL
                LIMIT 100
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getUserActivityAnalytics() {

        String sql = """
                SELECT
                    user_id,
                    MAX(location) AS location,
                    COUNT(*) AS total_ratings,
                    ROUND(AVG(rating), 2) AS avg_rating
                FROM VW_BOOK_RATINGS_FULL
                WHERE user_id IS NOT NULL
                  AND location IS NOT NULL
                GROUP BY user_id
                ORDER BY total_ratings DESC
                LIMIT 200
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getRatingsPreview() {

        String sql = """
                SELECT
                    user_id,
                    isbn,
                    rating
                FROM VW_BOOK_RATINGS_FULL
                LIMIT 200
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getRecommendationScores() {

        String sql = """
                SELECT
                    title,
                    author,
                    publisher,
                    ROUND(AVG(rating),2) AS recommendation_score,
                    COUNT(*) AS rating_count
                FROM VW_BOOK_RATINGS_FULL
                WHERE title IS NOT NULL
                GROUP BY title, author, publisher
                ORDER BY recommendation_score DESC
                LIMIT 20
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getBooksByAgeGroups() {

        String sql = """
                SELECT
                    CASE
                        WHEN age IS NULL OR age = 0 THEN 'Necunoscut'
                        WHEN age < 18 THEN 'Sub 18'
                        WHEN age BETWEEN 18 AND 25 THEN '18-25'
                        WHEN age BETWEEN 26 AND 35 THEN '26-35'
                        WHEN age BETWEEN 36 AND 50 THEN '36-50'
                        ELSE '50+'
                    END AS age_group,
                    title,
                    ROUND(AVG(rating),2) AS average_rating
                FROM VW_BOOK_RATINGS_FULL
                WHERE title IS NOT NULL
                GROUP BY
                    CASE
                        WHEN age IS NULL OR age = 0 THEN 'Necunoscut'
                        WHEN age < 18 THEN 'Sub 18'
                        WHEN age BETWEEN 18 AND 25 THEN '18-25'
                        WHEN age BETWEEN 26 AND 35 THEN '26-35'
                        WHEN age BETWEEN 36 AND 50 THEN '36-50'
                        ELSE '50+'
                    END,
                    title
                ORDER BY average_rating DESC
                LIMIT 30
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getPublisherPerformance() {

        String sql = """
                SELECT
                    publisher,
                    COUNT(*) AS total_ratings,
                    ROUND(AVG(rating),2) AS avg_rating
                FROM VW_BOOK_RATINGS_FULL
                WHERE publisher IS NOT NULL
                GROUP BY publisher
                ORDER BY avg_rating DESC
                LIMIT 20
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getPublisherRecommendationScore() {

        String sql = """
                SELECT
                    publisher,
                    ROUND(AVG(rating),2) AS recommendation_score,
                    COUNT(*) AS total_ratings
                FROM VW_BOOK_RATINGS_FULL
                WHERE publisher IS NOT NULL
                GROUP BY publisher
                ORDER BY recommendation_score DESC
                LIMIT 20
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getYearsAnalytics() {

        String sql = """
                SELECT
                    year,
                    COUNT(*) AS total_ratings,
                    ROUND(AVG(rating),2) AS avg_rating
                FROM VW_BOOK_RATINGS_FULL
                WHERE year IS NOT NULL
                GROUP BY year
                ORDER BY year
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getRecommendationSegments() {

        String sql = """
                SELECT
                    CASE
                        WHEN rating >= 8 THEN 'Foarte apreciată'
                        WHEN rating BETWEEN 5 AND 7 THEN 'Apreciere medie'
                        ELSE 'Scăzută'
                    END AS segment,
                    COUNT(*) AS total_books
                FROM VW_BOOK_RATINGS_FULL
                GROUP BY
                    CASE
                        WHEN rating >= 8 THEN 'Foarte apreciată'
                        WHEN rating BETWEEN 5 AND 7 THEN 'Apreciere medie'
                        ELSE 'Scăzută'
                    END
                """;

        return jdbcTemplate.queryForList(sql);
    }

    public List<Map<String, Object>> getHighPotentialBooks() {

        String sql = """
                SELECT
                    title,
                    author,
                    publisher,
                    ROUND(AVG(rating),2) AS avg_rating,
                    COUNT(*) AS total_ratings
                FROM VW_BOOK_RATINGS_FULL
                WHERE title IS NOT NULL
                GROUP BY title, author, publisher
                HAVING AVG(rating) >= 8
                ORDER BY total_ratings DESC
                LIMIT 20
                """;

        return jdbcTemplate.queryForList(sql);
    }
}