BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE (
    host       => '127.0.0.1',
    lower_port => 8081,
    upper_port => 8081,
    ace        => XS$ACE_TYPE(
                    privilege_list => XS$NAME_LIST('http'),
                    principal_name => 'FDBO',
                    principal_type => XS_ACL.PTYPE_DB
                  )
  );
END;
/
COMMIT;

---
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE (
    host       => 'localhost',
    lower_port => 8081,
    upper_port => 8081,
    ace        => XS$ACE_TYPE(
                    privilege_list => XS$NAME_LIST('http'),
                    principal_name => 'FDBO',
                    principal_type => XS_ACL.PTYPE_DB
                  )
  );
END;
/
COMMIT;