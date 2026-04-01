DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'web_anon') THEN
    CREATE ROLE web_anon NOLOGIN;
  END IF;
END $$;

GRANT CONNECT ON DATABASE db_book TO web_anon;
GRANT USAGE ON SCHEMA public TO web_anon;

GRANT SELECT ON TABLE public.users TO web_anon;
GRANT SELECT ON TABLE public.themes TO web_anon;
GRANT SELECT ON TABLE public.user_interests TO web_anon;


SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'web_anon';