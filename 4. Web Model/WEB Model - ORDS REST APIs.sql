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

--views
BEGIN
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'OLAP_BOOK_AUTHOR_PUBLISHER_V', 'VIEW', 'olap_book_author_publisher_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'OLAP_THEME_AGE_RATING_V', 'VIEW', 'olap_theme_age_rating_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'OLAP_AUTHOR_AGE_CUBE_V', 'VIEW', 'olap_author_age_cube_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'OLAP_YEAR_AUTHOR_THEME_GSETS_V', 'VIEW', 'olap_year_author_theme_gsets_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'WV_AUTHOR_RANK_V', 'VIEW', 'wv_author_rank_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'WV_USER_RATING_RUNNING_V', 'VIEW', 'wv_user_rating_running_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'WV_USER_RATING_AVG_DIFF_V', 'VIEW', 'wv_user_rating_avg_diff_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'WV_TOP_BOOKS_PER_YEAR_V', 'VIEW', 'wv_top_books_per_year_v');
  ORDS.ENABLE_OBJECT(TRUE, 'FDBO', 'OLAP_RATING_DISTRIBUTION_V', 'VIEW', 'olap_rating_distribution_v');
  COMMIT;
END;
/

http://localhost:8080/ords/fdbo/olap_book_author_publisher_v/
http://localhost:8080/ords/fdbo/olap_theme_age_rating_v/
http://localhost:8080/ords/fdbo/olap_author_age_cube_v/
http://localhost:8080/ords/fdbo/olap_year_author_theme_gsets_v/
http://localhost:8080/ords/fdbo/wv_author_rank_v/
http://localhost:8080/ords/fdbo/wv_user_rating_running_v/
http://localhost:8080/ords/fdbo/wv_user_rating_avg_diff_v/
http://localhost:8080/ords/fdbo/wv_top_books_per_year_v/
http://localhost:8080/ords/fdbo/olap_rating_distribution_v/