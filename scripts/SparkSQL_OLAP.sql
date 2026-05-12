-- =========================================================
-- SparkSQL_OLAP.sql
-- Model analitic integrat pentru proiectul DSA
-- Surse:
-- PostgreSQL: PG_USERS_RAW
-- MongoDB: MONGO_RATINGS_RAW
-- Oracle: ORACLE_BOOKS_RAW
-- =========================================================


-- =========================================================
-- 1. VERIFICARE VIEW-URI RAW
-- =========================================================

SHOW TABLES;

SELECT * FROM PG_USERS_RAW LIMIT 10;

SELECT * FROM MONGO_RATINGS_RAW LIMIT 10;

SELECT * FROM ORACLE_BOOKS_RAW LIMIT 10;


-- =========================================================
-- 2. VIEW INTERMEDIAR: PostgreSQL + MongoDB
-- =========================================================

DROP VIEW IF EXISTS INTEGRATED_BOOK_DATA;

CREATE OR REPLACE VIEW INTEGRATED_BOOK_DATA AS
SELECT
    u.array AS users_data,
    r.array AS ratings_data
FROM PG_USERS_RAW u
CROSS JOIN MONGO_RATINGS_RAW r;

-- TEST VIEW INTERMEDIAR
SELECT * FROM INTEGRATED_BOOK_DATA LIMIT 1;

SELECT
    size(users_data) AS users_count,
    size(ratings_data) AS ratings_count
FROM INTEGRATED_BOOK_DATA;


-- =========================================================
-- 3. VIEW FINAL: PostgreSQL + MongoDB + Oracle
-- =========================================================

DROP VIEW IF EXISTS FINAL_BOOK_ANALYTICS;

CREATE OR REPLACE VIEW FINAL_BOOK_ANALYTICS AS
SELECT
    u.array AS users_data,
    r.array AS ratings_data,
    b.array AS books_data
FROM PG_USERS_RAW u
CROSS JOIN MONGO_RATINGS_RAW r
CROSS JOIN ORACLE_BOOKS_RAW b;

-- TEST VIEW FINAL
SELECT * FROM FINAL_BOOK_ANALYTICS LIMIT 1;

SELECT
    size(users_data) AS users_count,
    size(ratings_data) AS ratings_count,
    size(books_data) AS books_count
FROM FINAL_BOOK_ANALYTICS;


-- =========================================================
-- 4. TESTE STRUCTURĂ JSON
-- =========================================================

SELECT
    u.userId,
    u.age,
    u.location
FROM FINAL_BOOK_ANALYTICS f
LATERAL VIEW explode(f.users_data) users_table AS u
LIMIT 10;

SELECT
    r.userId,
    r.isbn,
    r.bookRating
FROM FINAL_BOOK_ANALYTICS f
LATERAL VIEW explode(f.ratings_data) ratings_table AS r
LIMIT 10;

SELECT
    b.isbn,
    b.bookTitle,
    b.bookAuthor,
    b.yearOfPublication,
    b.publisher
FROM FINAL_BOOK_ANALYTICS f
LATERAL VIEW explode(f.books_data) books_table AS b
LIMIT 10;


-- =========================================================
-- 5. ȘTERGERE VIEW-URI ANALITICE VECHI
-- =========================================================

DROP VIEW IF EXISTS VW_RECOMMENDATION_SEGMENTS;
DROP VIEW IF EXISTS VW_PUBLISHER_YEAR_PERFORMANCE;
DROP VIEW IF EXISTS VW_RATINGS_BY_AGE_GROUP;
DROP VIEW IF EXISTS VW_RATINGS_BY_LOCATION;
DROP VIEW IF EXISTS VW_RATINGS_BY_PUBLISHER;
DROP VIEW IF EXISTS VW_RATINGS_BY_YEAR;
DROP VIEW IF EXISTS VW_ACTIVE_USERS;
DROP VIEW IF EXISTS VW_TOP_RATED_BOOKS;
DROP VIEW IF EXISTS VW_BOOK_RATINGS_FULL;


-- =========================================================
-- 6. VIEW 1: DATE INTEGRATE COMPLET
-- =========================================================

CREATE OR REPLACE VIEW VW_BOOK_RATINGS_FULL AS
WITH users AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY CAST(u.userId AS INT)) AS rn,
        CAST(u.userId AS STRING) AS user_id,
        CAST(u.age AS INT) AS age,
        u.location AS location
    FROM FINAL_BOOK_ANALYTICS f
    LATERAL VIEW explode(f.users_data) users_table AS u
),
ratings AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY CAST(r.userId AS INT)) AS rn,
        CAST(r.userId AS STRING) AS rating_user_id,
        UPPER(TRIM(CAST(r.isbn AS STRING))) AS rating_isbn,
        CAST(r.bookRating AS INT) AS rating
    FROM FINAL_BOOK_ANALYTICS f
    LATERAL VIEW explode(f.ratings_data) ratings_table AS r
),
books AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY b.isbn) AS rn,
        UPPER(TRIM(CAST(b.isbn AS STRING))) AS book_isbn,
        b.bookTitle AS title,
        b.bookAuthor AS author,
        b.yearOfPublication AS year,
        b.publisher AS publisher
    FROM FINAL_BOOK_ANALYTICS f
    LATERAL VIEW explode(f.books_data) books_table AS b
)
SELECT
    r.rating_user_id AS user_id,
    u.age,
    u.location,
    r.rating_isbn AS isbn,
    b.title,
    b.author,
    b.year,
    b.publisher,
    r.rating
FROM ratings r
LEFT JOIN users u
    ON r.rn = u.rn
LEFT JOIN books b
    ON r.rn = b.rn;

-- TEST VIEW 1
SELECT * FROM VW_BOOK_RATINGS_FULL LIMIT 20;


-- =========================================================
-- 7. VIEW 2: TOP CĂRȚI DUPĂ RATING
-- =========================================================

CREATE OR REPLACE VIEW VW_TOP_RATED_BOOKS AS
SELECT
    isbn,
    title,
    author,
    publisher,
    year,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating,
    MAX(rating) AS max_rating
FROM VW_BOOK_RATINGS_FULL
WHERE title IS NOT NULL
  AND rating IS NOT NULL
GROUP BY isbn, title, author, publisher, year
ORDER BY average_rating DESC, rating_count DESC;

-- TEST VIEW 2
SELECT * FROM VW_TOP_RATED_BOOKS LIMIT 20;


-- =========================================================
-- 8. VIEW 3: CEI MAI ACTIVI UTILIZATORI
-- =========================================================

CREATE OR REPLACE VIEW VW_ACTIVE_USERS AS
SELECT
    user_id,
    age,
    location,
    COUNT(*) AS number_of_ratings,
    ROUND(AVG(rating), 2) AS average_given_rating,
    MAX(rating) AS max_given_rating
FROM VW_BOOK_RATINGS_FULL
WHERE user_id IS NOT NULL
  AND rating IS NOT NULL
GROUP BY user_id, age, location
ORDER BY number_of_ratings DESC;

-- TEST VIEW 3
SELECT * FROM VW_ACTIVE_USERS LIMIT 20;


-- =========================================================
-- 9. VIEW 4: RATINGURI PE ANI
-- =========================================================

CREATE OR REPLACE VIEW VW_RATINGS_BY_YEAR AS
SELECT
    year,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM VW_BOOK_RATINGS_FULL
WHERE year IS NOT NULL
  AND rating IS NOT NULL
GROUP BY year
ORDER BY year;

-- TEST VIEW 4
SELECT * FROM VW_RATINGS_BY_YEAR LIMIT 20;


-- =========================================================
-- 10. VIEW 5: RATINGURI PE EDITURI
-- =========================================================

CREATE OR REPLACE VIEW VW_RATINGS_BY_PUBLISHER AS
SELECT
    publisher,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating,
    MAX(rating) AS max_rating
FROM VW_BOOK_RATINGS_FULL
WHERE publisher IS NOT NULL
  AND rating IS NOT NULL
GROUP BY publisher
ORDER BY rating_count DESC;

-- TEST VIEW 5
SELECT * FROM VW_RATINGS_BY_PUBLISHER LIMIT 20;


-- =========================================================
-- 11. VIEW 6: RATINGURI PE LOCAȚII
-- =========================================================

CREATE OR REPLACE VIEW VW_RATINGS_BY_LOCATION AS
SELECT
    location,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM VW_BOOK_RATINGS_FULL
WHERE location IS NOT NULL
  AND rating IS NOT NULL
GROUP BY location
ORDER BY rating_count DESC;

-- TEST VIEW 6
SELECT * FROM VW_RATINGS_BY_LOCATION LIMIT 20;


-- =========================================================
-- 12. VIEW 7: RATINGURI PE GRUPE DE VÂRSTĂ
-- =========================================================

CREATE OR REPLACE VIEW VW_RATINGS_BY_AGE_GROUP AS
SELECT
    CASE
        WHEN age IS NULL OR age = 0 THEN 'Necunoscut'
        WHEN age < 18 THEN 'Sub 18 ani'
        WHEN age BETWEEN 18 AND 25 THEN '18-25 ani'
        WHEN age BETWEEN 26 AND 35 THEN '26-35 ani'
        WHEN age BETWEEN 36 AND 50 THEN '36-50 ani'
        WHEN age > 50 THEN 'Peste 50 ani'
        ELSE 'Necunoscut'
    END AS age_group,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM VW_BOOK_RATINGS_FULL
WHERE rating IS NOT NULL
GROUP BY
    CASE
        WHEN age IS NULL OR age = 0 THEN 'Necunoscut'
        WHEN age < 18 THEN 'Sub 18 ani'
        WHEN age BETWEEN 18 AND 25 THEN '18-25 ani'
        WHEN age BETWEEN 26 AND 35 THEN '26-35 ani'
        WHEN age BETWEEN 36 AND 50 THEN '36-50 ani'
        WHEN age > 50 THEN 'Peste 50 ani'
        ELSE 'Necunoscut'
    END
ORDER BY rating_count DESC;

-- TEST VIEW 7
SELECT * FROM VW_RATINGS_BY_AGE_GROUP LIMIT 20;


-- =========================================================
-- 13. VIEW 8: PERFORMANȚĂ EDITURĂ PE AN
-- =========================================================

CREATE OR REPLACE VIEW VW_PUBLISHER_YEAR_PERFORMANCE AS
SELECT
    publisher,
    year,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM VW_BOOK_RATINGS_FULL
WHERE publisher IS NOT NULL
  AND year IS NOT NULL
  AND rating IS NOT NULL
GROUP BY publisher, year
ORDER BY rating_count DESC;

-- TEST VIEW 8
SELECT * FROM VW_PUBLISHER_YEAR_PERFORMANCE LIMIT 20;


-- =========================================================
-- 14. VIEW 9: SEGMENTAREA CĂRȚILOR DUPĂ RATING
-- =========================================================

CREATE OR REPLACE VIEW VW_RECOMMENDATION_SEGMENTS AS
SELECT
    isbn,
    title,
    author,
    publisher,
    year,
    CASE
        WHEN AVG(rating) >= 8 THEN 'Foarte apreciată'
        WHEN AVG(rating) BETWEEN 5 AND 7.99 THEN 'Apreciere medie'
        WHEN AVG(rating) BETWEEN 1 AND 4.99 THEN 'Apreciere scăzută'
        ELSE 'Fără rating relevant'
    END AS rating_segment,
    COUNT(*) AS rating_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM VW_BOOK_RATINGS_FULL
WHERE title IS NOT NULL
  AND rating IS NOT NULL
GROUP BY isbn, title, author, publisher, year
ORDER BY average_rating DESC;

-- TEST VIEW 9
SELECT * FROM VW_RECOMMENDATION_SEGMENTS LIMIT 20;


-- =========================================================
-- 15. TESTE FINALE RAPIDE
-- =========================================================

SHOW TABLES;