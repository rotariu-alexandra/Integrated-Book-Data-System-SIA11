--postgres
CREATE OR REPLACE FUNCTION fetch_url(p_url VARCHAR2)
RETURN CLOB
IS
  req     UTL_HTTP.req;
  resp    UTL_HTTP.resp;
  buffer  VARCHAR2(32767);
  result  CLOB;
BEGIN
  req := UTL_HTTP.begin_request(p_url);
  resp := UTL_HTTP.get_response(req);

  DBMS_LOB.createtemporary(result, TRUE);

  LOOP
    BEGIN
      UTL_HTTP.read_text(resp, buffer, 32767);
      DBMS_LOB.writeappend(result, LENGTH(buffer), buffer);
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        EXIT;
    END;
  END LOOP;

  UTL_HTTP.end_response(resp);
  RETURN result;
END;
/

--mongo
CREATE OR REPLACE FUNCTION fetch_url_auth(
  p_url      VARCHAR2,
  p_user     VARCHAR2,
  p_password VARCHAR2
)
RETURN CLOB
IS
  req     UTL_HTTP.req;
  resp    UTL_HTTP.resp;
  buffer  VARCHAR2(32767);
  result  CLOB;
BEGIN
  req := UTL_HTTP.begin_request(p_url);
  UTL_HTTP.set_authentication(req, p_user, p_password);
  resp := UTL_HTTP.get_response(req);

  DBMS_LOB.createtemporary(result, TRUE);

  LOOP
    BEGIN
      UTL_HTTP.read_text(resp, buffer, 32767);
      DBMS_LOB.writeappend(result, LENGTH(buffer), buffer);
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        EXIT;
    END;
  END LOOP;

  UTL_HTTP.end_response(resp);
  RETURN result;
END;
/

--view mongo
--ratings
CREATE OR REPLACE VIEW v_mongo_ratings AS
SELECT jt.*
FROM JSON_TABLE(
  fetch_url_auth(
    'http://127.0.0.1:8081/booksDB/ratings',
    'admin',
    'secret'
  ),
  '$[*]'
  COLUMNS (
    user_id     NUMBER       PATH '$."User-ID"',
    isbn        VARCHAR2(30) PATH '$."ISBN"',
    book_rating NUMBER       PATH '$."Book-Rating"'
  )
) jt;

--test view ratings
SELECT * FROM v_mongo_ratings;

--view reviews
CREATE OR REPLACE VIEW v_mongo_reviews AS
SELECT jt.*
FROM JSON_TABLE(
  fetch_url_auth(
    'http://127.0.0.1:8081/booksDB/reviews',
    'admin',
    'secret'
  ),
  '$[*]'
  COLUMNS (
    book_title   VARCHAR2(500)  PATH '$."Book"',
    review_text  VARCHAR2(4000) PATH '$."Review"',
    review_date  VARCHAR2(100)  PATH '$."Review Date"'
  )
) jt;


--test view review
SELECT * FROM v_mongo_ratings;


--teste finale
SELECT * FROM v_pg_users;
SELECT * FROM v_pg_themes;
SELECT * FROM v_pg_user_interests;
SELECT * FROM v_mongo_ratings;
SELECT * FROM v_mongo_reviews;