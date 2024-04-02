clear screen;
set SERVEROUTPUT on;

-- exec cSQL.ut_create.test_acl_drop;

-- exec cSQL.ut_create.test_acl_create;

-- exec cSQL.ut_create.test_sec_create;

-- exec cSQL.ut_create.test_policy_create;

exec cSQL.ut_create.test_alter_drop;
-- exec cSQL.ut_create.test_policy_create;
-- exec cSQL.ut_create.test_policy_create;

select * from table( teJSON.Blueprint() );
