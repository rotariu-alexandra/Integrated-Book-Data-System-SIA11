--Integration view--
--view profil utilizatori tematici
CREATE OR REPLACE VIEW INT_USER_THEME_PROFILE_V AS
SELECT
    u.user_id,
    u.location,
    u.age,
    ui.theme_id,
    t.theme_name
FROM v_pg_users u
LEFT JOIN v_pg_user_interests ui
    ON u.user_id = ui.user_id
LEFT JOIN v_pg_themes t
    ON ui.theme_id = t.theme_id;
    
--test
SELECT * FROM INT_USER_THEME_PROFILE_V;


--profil + carte + rating
CREATE OR REPLACE VIEW INT_BOOK_RATING_PROFILE_V AS
SELECT
    b.isbn,
    b.title,
    b.author,
    b.year_of_publication,
    b.publisher,
    r.user_id,
    r.book_rating,
    u.location,
    u.age
FROM book b
LEFT JOIN v_mongo_ratings r
    ON b.isbn = r.isbn
LEFT JOIN v_pg_users u
    ON r.user_id = u.user_id;
    
--test
SELECT * FROM INT_BOOK_RATING_PROFILE_V;

--view carte + rating + user + theme
CREATE OR REPLACE VIEW INT_BOOK_USER_THEME_V AS
SELECT
    b.isbn,
    b.title,
    b.author,
    b.year_of_publication,
    b.publisher,
    r.user_id,
    r.book_rating,
    u.location,
    u.age,
    ut.theme_id,
    ut.theme_name
FROM book b
LEFT JOIN v_mongo_ratings r
    ON b.isbn = r.isbn
LEFT JOIN INT_USER_THEME_PROFILE_V ut
    ON r.user_id = ut.user_id
LEFT JOIN v_pg_users u
    ON r.user_id = u.user_id;
    
--test
SELECT * FROM INT_BOOK_USER_THEME_V;

--view reviews
CREATE OR REPLACE VIEW INT_BOOK_REVIEW_V AS
SELECT
    b.isbn,
    b.title,
    b.author,
    rv.review_text,
    rv.review_date
FROM book b
LEFT JOIN v_mongo_reviews rv
    ON UPPER(TRIM(b.title)) = UPPER(TRIM(rv.book_title));
    
--test
SELECT * FROM INT_BOOK_REVIEW_V;

--view activity feed
CREATE OR REPLACE VIEW INT_BOOK_ACTIVITY_V AS
SELECT
    b.isbn,
    b.title,
    r.user_id,
    CAST(r.book_rating AS VARCHAR2(50)) AS activity_value,
    'RATING' AS activity_type,
    CAST(NULL AS VARCHAR2(4000)) AS review_text
FROM book b
JOIN v_mongo_ratings r
    ON b.isbn = r.isbn

UNION ALL

SELECT
    b.isbn,
    b.title,
    CAST(NULL AS NUMBER) AS user_id,
    CAST(NULL AS VARCHAR2(50)) AS activity_value,
    'REVIEW' AS activity_type,
    rv.review_text
FROM book b
JOIN v_mongo_reviews rv
    ON UPPER(TRIM(b.title)) = UPPER(TRIM(rv.book_title));
    
--test
SELECT * FROM INT_BOOK_ACTIVITY_V;


--JOIN
--carti care au rating
SELECT
    b.isbn,
    b.title,
    r.user_id,
    r.book_rating
FROM book b
JOIN v_mongo_ratings r
    ON b.isbn = r.isbn;
    
--toate cartile
SELECT
    b.isbn,
    b.title,
    r.user_id,
    r.book_rating
FROM book b
LEFT JOIN v_mongo_ratings r
    ON b.isbn = r.isbn;
    
--ratings
SELECT
    b.isbn,
    b.title,
    r.user_id,
    r.book_rating
FROM book b
RIGHT JOIN v_mongo_ratings r
    ON b.isbn = r.isbn;
    
--carti fara rating
SELECT
    b.isbn AS oracle_isbn,
    r.isbn AS mongo_isbn,
    b.title,
    r.user_id,
    r.book_rating
FROM book b
FULL OUTER JOIN v_mongo_ratings r
    ON b.isbn = r.isbn;
    
--DIMENSION + FACT
--dim_book_v
CREATE OR REPLACE VIEW DIM_BOOK_V AS
SELECT
    isbn,
    title,
    author,
    publisher,
    year_of_publication,
    CASE
        WHEN TO_NUMBER(year_of_publication DEFAULT NULL ON CONVERSION ERROR) < 1980 THEN 'OLD'
        WHEN TO_NUMBER(year_of_publication DEFAULT NULL ON CONVERSION ERROR) BETWEEN 1980 AND 1999 THEN 'CLASSIC'
        WHEN TO_NUMBER(year_of_publication DEFAULT NULL ON CONVERSION ERROR) >= 2000 THEN 'MODERN'
        ELSE 'UNKNOWN_YEAR'
    END AS publication_group
FROM book;

SELECT * FROM DIM_BOOK_V;

--dim_user_v
CREATE OR REPLACE VIEW DIM_USER_V AS
SELECT
    user_id,
    location,
    age,
    CASE
        WHEN REGEXP_LIKE(age, '^\d+$') AND TO_NUMBER(age) < 18 THEN 'UNDER_18'
        WHEN REGEXP_LIKE(age, '^\d+$') AND TO_NUMBER(age) BETWEEN 18 AND 25 THEN '18_25'
        WHEN REGEXP_LIKE(age, '^\d+$') AND TO_NUMBER(age) BETWEEN 26 AND 40 THEN '26_40'
        WHEN REGEXP_LIKE(age, '^\d+$') AND TO_NUMBER(age) > 40 THEN '40_PLUS'
        ELSE 'UNKNOWN_AGE'
    END AS age_group
FROM v_pg_users;

SELECT * FROM DIM_USER_V;

--THEME
CREATE OR REPLACE VIEW DIM_THEME_V AS
SELECT
    theme_id,
    theme_name
FROM v_pg_themes;

SELECT * FROM DIM_THEME_V;

--REVIEW
CREATE OR REPLACE VIEW DIM_TIME_REVIEW_V AS
SELECT DISTINCT
    review_date,
    SUBSTR(review_date, 1, 4) AS review_year,
    SUBSTR(review_date, 6, 2) AS review_month
FROM v_mongo_reviews
WHERE review_date IS NOT NULL;

SELECT * FROM DIM_TIME_REVIEW_V;

--FACT_BOOK_RATINGS_V
CREATE OR REPLACE VIEW FACT_BOOK_RATINGS_V AS
SELECT
    b.isbn,
    r.user_id,
    r.book_rating
FROM book b
JOIN v_mongo_ratings r
    ON b.isbn = r.isbn;
    
SELECT * FROM FACT_BOOK_RATINGS_V;

--FACT_BOOK_USER_THEME_V
CREATE OR REPLACE VIEW FACT_BOOK_USER_THEME_V AS
SELECT
    i.isbn,
    i.user_id,
    i.theme_id,
    i.book_rating
FROM INT_BOOK_USER_THEME_V i
WHERE i.user_id IS NOT NULL;

SELECT * FROM FACT_BOOK_USER_THEME_V;

--Analytical views 
--A. Rating total și număr de rating-uri pe autor și editură
CREATE OR REPLACE VIEW OLAP_BOOK_AUTHOR_PUBLISHER_V AS
SELECT
    CASE
        WHEN GROUPING(b.author) = 1 THEN '{TOTAL_GENERAL}'
        ELSE b.author
    END AS author,
    CASE
        WHEN GROUPING(b.author) = 1 THEN ' '
        WHEN GROUPING(b.publisher) = 1 THEN 'subtotal author ' || b.author
        ELSE b.publisher
    END AS publisher,
    COUNT(r.book_rating) AS rating_count,
    ROUND(AVG(r.book_rating), 2) AS avg_rating
FROM DIM_BOOK_V b
LEFT JOIN FACT_BOOK_RATINGS_V r
    ON b.isbn = r.isbn
GROUP BY ROLLUP(b.author, b.publisher)
ORDER BY b.author, b.publisher;

SELECT * FROM OLAP_BOOK_AUTHOR_PUBLISHER_V;

--B. Ratinguri pe tematică și grupă de vârstă
CREATE OR REPLACE VIEW OLAP_THEME_AGE_RATING_V AS
SELECT
    CASE
        WHEN GROUPING(t.theme_name) = 1 THEN '{TOTAL_GENERAL}'
        ELSE t.theme_name
    END AS theme_name,
    CASE
        WHEN GROUPING(t.theme_name) = 1 THEN ' '
        WHEN GROUPING(u.age_group) = 1 THEN 'subtotal theme ' || t.theme_name
        ELSE u.age_group
    END AS age_group,
    COUNT(f.book_rating) AS rating_count,
    ROUND(AVG(f.book_rating), 2) AS avg_rating
FROM FACT_BOOK_USER_THEME_V f
LEFT JOIN DIM_THEME_V t
    ON f.theme_id = t.theme_id
LEFT JOIN DIM_USER_V u
    ON f.user_id = u.user_id
GROUP BY ROLLUP(t.theme_name, u.age_group)
ORDER BY t.theme_name, u.age_group;

SELECT * FROM OLAP_THEME_AGE_RATING_V;

--C. CUBE pe autor și grupă de vârstă
CREATE OR REPLACE VIEW OLAP_AUTHOR_AGE_CUBE_V AS
SELECT
    CASE
        WHEN GROUPING(b.author) = 1 THEN '{ALL_AUTHORS}'
        ELSE b.author
    END AS author,
    CASE
        WHEN GROUPING(u.age_group) = 1 THEN '{ALL_AGES}'
        ELSE u.age_group
    END AS age_group,
    COUNT(*) AS rating_count,
    ROUND(AVG(f.book_rating), 2) AS avg_rating
FROM FACT_BOOK_RATINGS_V f
LEFT JOIN DIM_BOOK_V b
    ON f.isbn = b.isbn
LEFT JOIN DIM_USER_V u
    ON f.user_id = u.user_id
GROUP BY CUBE(b.author, u.age_group)
ORDER BY b.author, u.age_group;

SELECT * FROM OLAP_AUTHOR_AGE_CUBE_V;

--D. GROUPING SETS pe an publicare, autor, tematică
CREATE OR REPLACE VIEW OLAP_YEAR_AUTHOR_THEME_GSETS_V AS
SELECT
    CASE
        WHEN GROUPING(b.year_of_publication) = 1 THEN '{TOTAL_GENERAL}'
        ELSE b.year_of_publication
    END AS year_of_publication,
    CASE
        WHEN GROUPING(b.year_of_publication) = 1 THEN ' '
        WHEN GROUPING(b.author) = 1 THEN 'subtotal year ' || b.year_of_publication
        ELSE b.author
    END AS author,
    CASE
        WHEN GROUPING(b.year_of_publication) = 1 THEN ' '
        WHEN GROUPING(b.author) = 1 THEN ' '
        WHEN GROUPING(t.theme_name) = 1 THEN 'subtotal author ' || b.author
        ELSE t.theme_name
    END AS theme_name,
    COUNT(*) AS rating_count,
    ROUND(AVG(f.book_rating), 2) AS avg_rating
FROM FACT_BOOK_USER_THEME_V f
LEFT JOIN DIM_BOOK_V b
    ON f.isbn = b.isbn
LEFT JOIN DIM_THEME_V t
    ON f.theme_id = t.theme_id
GROUP BY GROUPING SETS (
    (b.year_of_publication),
    (b.year_of_publication, b.author),
    (b.year_of_publication, b.author, t.theme_name),
    ()
)
ORDER BY 1, 2, 3;

SELECT * FROM OLAP_YEAR_AUTHOR_THEME_GSETS_V;

--E. Top autori după rating mediu
CREATE OR REPLACE VIEW WV_AUTHOR_RANK_V AS
SELECT
    x.author,
    x.rating_count,
    x.avg_rating,
    RANK() OVER (ORDER BY x.avg_rating DESC, x.rating_count DESC) AS rank_author,
    DENSE_RANK() OVER (ORDER BY x.avg_rating DESC, x.rating_count DESC) AS dense_rank_author,
    ROW_NUMBER() OVER (ORDER BY x.avg_rating DESC, x.rating_count DESC) AS row_number_author
FROM (
    SELECT
        b.author,
        COUNT(*) AS rating_count,
        ROUND(AVG(f.book_rating), 2) AS avg_rating
    FROM FACT_BOOK_RATINGS_V f
    JOIN DIM_BOOK_V b
        ON f.isbn = b.isbn
    GROUP BY b.author
) x;

SELECT * FROM WV_AUTHOR_RANK_V;

--F. Running total de rating-uri per utilizator
CREATE OR REPLACE VIEW WV_USER_RATING_RUNNING_V AS
SELECT
    f.user_id,
    f.isbn,
    f.book_rating,
    SUM(f.book_rating) OVER (
        PARTITION BY f.user_id
        ORDER BY f.isbn
        ROWS UNBOUNDED PRECEDING
    ) AS running_total_rating
FROM FACT_BOOK_RATINGS_V f;

SELECT * FROM WV_USER_RATING_RUNNING_V;

--G. Media ratingului pe utilizator și abaterea față de medie
CREATE OR REPLACE VIEW WV_USER_RATING_AVG_DIFF_V AS
SELECT
    f.user_id,
    f.isbn,
    f.book_rating,
    ROUND(
        AVG(f.book_rating) OVER (
            PARTITION BY f.user_id
        ),
        2
    ) AS avg_rating_per_user,
    ROUND(
        f.book_rating - AVG(f.book_rating) OVER (
            PARTITION BY f.user_id
        ),
        2
    ) AS diff_from_user_avg
FROM FACT_BOOK_RATINGS_V f;

SELECT * FROM WV_USER_RATING_AVG_DIFF_V;


--H. TOP cărți în fiecare an (window + partition)
CREATE OR REPLACE VIEW WV_TOP_BOOKS_PER_YEAR_V AS
SELECT *
FROM (
    SELECT
        b.year_of_publication,
        b.title,
        COUNT(f.book_rating) AS rating_count,
        ROUND(AVG(f.book_rating), 2) AS avg_rating,
        ROW_NUMBER() OVER (
            PARTITION BY b.year_of_publication
            ORDER BY AVG(f.book_rating) DESC, COUNT(*) DESC
        ) AS rank_in_year
    FROM FACT_BOOK_RATINGS_V f
    JOIN DIM_BOOK_V b
        ON f.isbn = b.isbn
    GROUP BY b.year_of_publication, b.title
)
WHERE rank_in_year <= 3;

SELECT * FROM WV_TOP_BOOKS_PER_YEAR_V;

--I. Distribuție ratinguri pe categorii (CASE + agregare)
CREATE OR REPLACE VIEW OLAP_RATING_DISTRIBUTION_V AS
SELECT
    CASE
        WHEN book_rating <= 3 THEN 'LOW'
        WHEN book_rating <= 7 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS rating_category,
    COUNT(*) AS rating_count,
    ROUND(AVG(book_rating), 2) AS avg_rating
FROM FACT_BOOK_RATINGS_V
GROUP BY
    CASE
        WHEN book_rating <= 3 THEN 'LOW'
        WHEN book_rating <= 7 THEN 'MEDIUM'
        ELSE 'HIGH'
    END;
    
SELECT * FROM OLAP_RATING_DISTRIBUTION_V;

--J. Top utilizatori după activitate (window + rank)
CREATE OR REPLACE VIEW WV_TOP_USERS_ACTIVITY_V AS
SELECT
    user_id,
    rating_count,
    avg_rating,
    RANK() OVER (ORDER BY rating_count DESC) AS rank_user
FROM (
    SELECT
        user_id,
        COUNT(*) AS rating_count,
        ROUND(AVG(book_rating), 2) AS avg_rating
    FROM FACT_BOOK_RATINGS_V
    GROUP BY user_id
);

SELECT * FROM WV_TOP_USERS_ACTIVITY_V;


--INTEROGARI VERIFICARE

--Cărți care au rating în Mongo dar nu există în Oracle
SELECT
    r.isbn,
    COUNT(*) AS cnt
FROM v_mongo_ratings r
LEFT JOIN book b
    ON r.isbn = b.isbn
WHERE b.isbn IS NULL
GROUP BY r.isbn;

--Cărți din Oracle fără niciun rating
SELECT
    b.isbn,
    b.title
FROM book b
LEFT JOIN v_mongo_ratings r
    ON b.isbn = r.isbn
WHERE r.isbn IS NULL;

--Utilizatori care au dat rating, dar nu există în Postgres
SELECT
    r.user_id,
    COUNT(*) AS rating_count
FROM v_mongo_ratings r
LEFT JOIN v_pg_users u
    ON r.user_id = u.user_id
WHERE u.user_id IS NULL
GROUP BY r.user_id;

--Verificare distribuție pe surse
SELECT COUNT(*) AS cnt, 'ORACLE_BOOKS' AS source_name FROM book
UNION ALL
SELECT COUNT(*) AS cnt, 'POSTGRES_USERS' AS source_name FROM v_pg_users
UNION ALL
SELECT COUNT(*) AS cnt, 'POSTGRES_THEMES' AS source_name FROM v_pg_themes
UNION ALL
SELECT COUNT(*) AS cnt, 'POSTGRES_USER_INTERESTS' AS source_name FROM v_pg_user_interests
UNION ALL
SELECT COUNT(*) AS cnt, 'MONGO_RATINGS' AS source_name FROM v_mongo_ratings
UNION ALL
SELECT COUNT(*) AS cnt, 'MONGO_REVIEWS' AS source_name FROM v_mongo_reviews;

