--reviews
SET SERVEROUTPUT ON;

DECLARE
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  txt   VARCHAR2(32767);
BEGIN
  req := UTL_HTTP.begin_request('http://localhost:8081/booksDB/reviews');
  UTL_HTTP.set_authentication(req, 'admin', 'secret');
  resp := UTL_HTTP.get_response(req);

  LOOP
    UTL_HTTP.read_text(resp, txt, 32767);
    DBMS_OUTPUT.put_line(SUBSTR(txt, 1, 2000));
  END LOOP;

EXCEPTION
  WHEN UTL_HTTP.end_of_body THEN
    UTL_HTTP.end_response(resp);
END;
/

--ratings
SET SERVEROUTPUT ON;

DECLARE
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  txt   VARCHAR2(32767);
BEGIN
  req := UTL_HTTP.begin_request('http://localhost:8081/booksDB/ratings');
  UTL_HTTP.set_authentication(req, 'admin', 'secret');
  resp := UTL_HTTP.get_response(req);

  LOOP
    UTL_HTTP.read_text(resp, txt, 32767);
    DBMS_OUTPUT.put_line(SUBSTR(txt, 1, 2000));
  END LOOP;

EXCEPTION
  WHEN UTL_HTTP.end_of_body THEN
    UTL_HTTP.end_response(resp);
END;
/


