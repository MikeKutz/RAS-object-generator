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
    object_type    varchar2(128 byte);
    acl_name       varchar2(128 byte);
    secclass_name  varchar2(128 byte);

    principal_name varchar2(128 byte);
    principal_type varchar2(128 byte);
    privilege_name varchar2(128 byte);

    h   MKLibrary.Hash_t;
    k   MKLibrary.Hash_t;
    principal_iterator   MKLibrary.Iterator_t;
    privilege_iterator   MKLibrary.Iterator_t;

    e_key  varchar2(100);
  begin
    -- check keyword
    object_type   := JSON_VALUE( j, '$.OBJECT_TYPE');
    acl_name      := JSON_VALUE( j, '$.OBJECT_NAME');
    secclass_name := JSON_VALUE( j, '$.SECURITY_CLASS');

    if object_type is null
    then
      e_key := 'acl';
      raise missing_key;
    end if;

    if secclass_name is null
    then
      e_key := 'security class';
      raise missing_key;
    end if;

    -- assert ACL does not exist
    -- assert Security Class exists

    -- build Iterator_t
    h := new MKLibrary.Hash_t();
    h.json_clob := JSON_SERIALIZE( j );
    principal_iterator := new MKLibrary.Iterator_t( h, '$.aces');

    -- check aces array exist
    if principal_iterator is null or principal_iterator.max_i < 1 then raise no_data_found; end if;

    -- foreach object
    while( principal_iterator.has_more )
    loop
      principal_iterator.get_next;
      h := principal_iterator.get_current_row;

      principal_name := h.get_string( 'principal' );
      principal_type := nvl( h.get_string( 'PRINCIPAL_TYPE'), 'internal' );

      -- assert principal_name is a principal_type
      case principal_type
        when 'internal' then null; -- TODO
        when 'database' then null;
          -- cSQL.ddlt_util.assert_schema( principal_name ); -- TODO: wrap and raise correctly
        when 'external' then
          null;
        else
          raise bad_combo;
      end case;

       -- privilige array exists
        privilege_iterator := new MKLibrary.Iterator_t( h, '$.privileges' );
        while( privilege_iterator.has_more )
        loop
          privilege_iterator.get_next;
          k := privilege_iterator.get_current_row;
          privilege_name := k.get_string( 'VALUE' );

          -- assert privilige is part of state security class(*)
        end loop;
    end loop;

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
