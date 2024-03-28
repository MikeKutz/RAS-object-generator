create or replace 
package body ras_acl_assertions
as
  /* utility for ayntax_t subtype acl_syntax_t
  */
/*
  missing_key          exception;
  bad_combo            exception;
  acl_exists           exception;
  acl_not_exists       exception;
  privilege_not_exists exception;
  secclass_not_exists  exception;
*/
  procedure create_syntax( c CLOB )
  as
  begin
    null;
  end create_syntax;

  procedure create_parsed( j JSON )
  as
    e_p1  varchar2(128 byte);
    e_p2  varchar2(128 byte);
  begin
    null;
  exception
    when missing_key then
      raise_application_error( -20701, 'missing keyword/phrase' );
    when bad_combo then
      raise_application_error( -20701, 'invalid option combination o "%s" and "%s"' );
    when acl_exists then
      raise_application_error( -20701, 'ACL "%s" exists' );
    when acl_not_exists then
      raise_application_error( -20701, 'ACL "%s" does not exists' );
    when privilege_not_exists then
      raise_application_error( -20701, 'Privilege "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Privilege "%s" does exists' );
    when secclass_not_exists then
      raise_application_error( -20701, 'Security Class "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Security Class "%s" does exists' );
  end create_parsed;

  procedure drop_syntax( c clob )
  as
  begin
    null;
  end drop_syntax;

  procedure drop_parsed( j JSON )
  as
    e_p1  varchar2(128 byte);
    e_p2  varchar2(128 byte);
  begin
    null;
  exception
    when missing_key then
      raise_application_error( -20701, 'missing keyword/phrase' );
    when bad_combo then
      raise_application_error( -20701, 'invalid option combination o "%s" and "%s"' );
    when acl_exists then
      raise_application_error( -20701, 'ACL "%s" exists' );
    when acl_not_exists then
      raise_application_error( -20701, 'ACL "%s" does not exists' );
    when privilege_not_exists then
      raise_application_error( -20701, 'Privilege "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Privilege "%s" does exists' );
    when secclass_not_exists then
      raise_application_error( -20701, 'Security Class "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Security Class "%s" does exists' );
  end drop_parsed;


  procedure alter_syntax( c clob )
  as
  begin
    null;
  end alter_syntax;

  procedure alter_parsed( j JSON )
  as
    e_p1  varchar2(128 byte);
    e_p2  varchar2(128 byte);
  begin
    null;
  exception
    when missing_key then
      raise_application_error( -20701, 'missing keyword/phrase' );
    when bad_combo then
      raise_application_error( -20701, 'invalid option combination o "%s" and "%s"' );
    when acl_exists then
      raise_application_error( -20701, 'ACL "%s" exists' );
    when acl_not_exists then
      raise_application_error( -20701, 'ACL "%s" does not exists' );
    when privilege_not_exists then
      raise_application_error( -20701, 'Privilege "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Privilege "%s" does exists' );
    when secclass_not_exists then
      raise_application_error( -20701, 'Security Class "%s" does not exists' );
    -- when xxx then
    --   raise_application_error( -20701, 'Security Class "%s" does exists' );
  end alter_parsed;

end;
/
