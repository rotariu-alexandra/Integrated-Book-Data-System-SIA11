SET SERVEROUTPUT ON;

DECLARE
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  txt   VARCHAR2(32767);
BEGIN
  req := UTL_HTTP.begin_request('http://127.0.0.1:3000/users');
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


--themes--
SET SERVEROUTPUT ON;

DECLARE
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  txt   VARCHAR2(32767);
BEGIN
  req := UTL_HTTP.begin_request('http://127.0.0.1:3000/themes');
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


--user_interests

SET SERVEROUTPUT ON;

DECLARE
  req   UTL_HTTP.req;
  resp  UTL_HTTP.resp;
  txt   VARCHAR2(32767);
BEGIN
  req := UTL_HTTP.begin_request('http://127.0.0.1:3000/user_interests');
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