create or replace 
package ras_acl_assertions
as
  /* utility for ayntax_t subtype acl_syntax_t
  */
  -- move to ras_syntax_exceptions
  missing_key          exception;
  bad_combo            exception;
  acl_exists           exception;
  acl_not_exists       exception;
  privilege_not_exists exception;
  secclass_not_exists  exception;


  procedure create_syntax( c CLOB );
  procedure create_parsed( j JSON );

  procedure drop_syntax( c clob );
  procedure drop_parsed( j JSON );

  procedure alter_syntax( c clob );
  procedure alter_parsed( j JSON );
end;
/
