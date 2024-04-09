create or REPLACE
package ut_create
as

  procedure test_sec_create;
  procedure test_sec_drop;

  procedure test_acl_create;
  procedure test_acl_drop;

  procedure test_policy_create;
  procedure test_policy_drop;
  
  procedure test_alter_add;
  procedure test_alter_modify;
  procedure test_alter_drop;

end ut_create;
/
