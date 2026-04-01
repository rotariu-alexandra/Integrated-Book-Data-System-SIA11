SELECT host, lower_port, upper_port, acl
FROM dba_network_acls;

SELECT grantee, owner, table_name, privilege
FROM dba_tab_privs
WHERE grantee = 'FDBO'
  AND table_name = 'UTL_HTTP';
  
SELECT host, lower_port, upper_port, principal, privilege, is_grant
FROM dba_host_aces
WHERE principal = 'FDBO';

BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE (
    host       => '127.0.0.1',
    lower_port => 3000,
    upper_port => 3000,
    ace        => XS$ACE_TYPE(
                    privilege_list => XS$NAME_LIST('http'),
                    principal_name => 'FDBO',
                    principal_type => XS_ACL.PTYPE_DB
                  )
  );
END;
/
COMMIT;

SELECT host, lower_port, upper_port, principal, privilege
FROM dba_host_aces
WHERE principal = 'FDBO';