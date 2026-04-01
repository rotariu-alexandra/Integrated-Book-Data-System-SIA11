BEGIN
    ORDS.delete_module(
        p_module_name => 'fdbo.books.api'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/
BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => 'FDBO',
        p_url_mapping_type    => 'BASE_PATH',
        p_url_mapping_pattern => 'fdbo',
        p_auto_rest_auth      => FALSE
    );
    COMMIT;
END;
/
DECLARE
    PROCEDURE add_get_endpoint(
        p_module_name IN VARCHAR2,
        p_pattern     IN VARCHAR2,
        p_sql         IN CLOB
    ) IS
    BEGIN
        ORDS.DEFINE_TEMPLATE(
            p_module_name => p_module_name,
            p_pattern     => p_pattern,
            p_priority    => 0,
            p_etag_type   => 'NONE'
        );

        ORDS.DEFINE_HANDLER(
            p_module_name    => p_module_name,
            p_pattern        => p_pattern,
            p_method         => 'GET',
            p_source_type    => 'json/collection',
            p_items_per_page => 25,
            p_source         => p_sql
        );
    END;
BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'fdbo.books.api',
        p_base_path      => '/books/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'Books analytical REST endpoints'
    );

    add_get_endpoint('fdbo.books.api', 'author-publisher', q'[
        SELECT * FROM OLAP_BOOK_AUTHOR_PUBLISHER_V
    ]');

    add_get_endpoint('fdbo.books.api', 'theme-age', q'[
        SELECT * FROM OLAP_THEME_AGE_RATING_V
    ]');

    add_get_endpoint('fdbo.books.api', 'author-age-cube', q'[
        SELECT * FROM OLAP_AUTHOR_AGE_CUBE_V
    ]');

    add_get_endpoint('fdbo.books.api', 'year-author-theme', q'[
        SELECT * FROM OLAP_YEAR_AUTHOR_THEME_GSETS_V
    ]');

    add_get_endpoint('fdbo.books.api', 'author-rank', q'[
        SELECT * FROM WV_AUTHOR_RANK_V
    ]');

    add_get_endpoint('fdbo.books.api', 'user-running', q'[
        SELECT * FROM WV_USER_RATING_RUNNING_V
    ]');

    add_get_endpoint('fdbo.books.api', 'user-avg-diff', q'[
        SELECT * FROM WV_USER_RATING_AVG_DIFF_V
    ]');

    add_get_endpoint('fdbo.books.api', 'top-books-year', q'[
        SELECT * FROM WV_TOP_BOOKS_PER_YEAR_V
    ]');

    add_get_endpoint('fdbo.books.api', 'rating-distribution', q'[
        SELECT * FROM OLAP_RATING_DISTRIBUTION_V
    ]');

    COMMIT;
END;
/


http://localhost:8080/ords/fdbo/books/author-publisher
http://localhost:8080/ords/fdbo/books/theme-age
http://localhost:8080/ords/fdbo/books/author-age-cube
http://localhost:8080/ords/fdbo/books/year-author-theme
http://localhost:8080/ords/fdbo/books/author-rank
http://localhost:8080/ords/fdbo/books/user-running
http://localhost:8080/ords/fdbo/books/user-avg-diff
http://localhost:8080/ords/fdbo/books/top-books-year
http://localhost:8080/ords/fdbo/books/rating-distribution