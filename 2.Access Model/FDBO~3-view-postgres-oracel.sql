CREATE OR REPLACE FUNCTION fetch_url(p_url VARCHAR2)
RETURN CLOB
IS
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  buffer VARCHAR2(32767);
  result CLOB;
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

---view themes
CREATE OR REPLACE VIEW v_pg_themes AS
SELECT jt.*
FROM JSON_TABLE(
  fetch_url('http://127.0.0.1:3000/themes'),
  '$[*]'
  COLUMNS (
    theme_id NUMBER PATH '$.theme_id',
    theme_name VARCHAR2(100) PATH '$.theme_name'
  )
) jt;

--test view themes
SELECT * FROM v_pg_themes;



---view user_interests
CREATE OR REPLACE VIEW v_pg_user_interests AS
SELECT jt.*
FROM JSON_TABLE(
  fetch_url('http://127.0.0.1:3000/user_interests'),
  '$[*]'
  COLUMNS (
    user_id NUMBER PATH '$.user_id',
    theme_id NUMBER PATH '$.theme_id'
  )
) jt;

--test view user_interest
SELECT * FROM v_pg_user_interests;


--view user
CREATE OR REPLACE VIEW v_pg_users AS
SELECT jt.*
FROM JSON_TABLE(
  fetch_url('http://127.0.0.1:3000/users?limit=100'),
  '$[*]'
  COLUMNS (
    user_id NUMBER PATH '$.user_id',
    location VARCHAR2(200) PATH '$.location',
    age VARCHAR2(20) PATH '$.age'
  )
) jt;

--test view user
SELECT * FROM v_pg_users;

--teste finale
SELECT * FROM v_pg_users;
SELECT * FROM v_pg_themes;
SELECT * FROM v_pg_user_interests;
