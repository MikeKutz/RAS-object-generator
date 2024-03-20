create or replace
package body ut_create
as
  subtype key_t is number(2);

  sql_key_secclass  constant key_t := 1;
  sql_key_acl       constant key_t := 2;
  sql_key_policy    constant key_t := 3;

  sql_texts      MKLibrary.CLOB_Array := MKLibrary.CLOB_array(
    -- SECURITY CLASS
    'create application security_class blah',

    -- ACL
    q'[
create application acl hr_acl for security class hrpriv aces (
    principal hr_representive privileges ( insert,update,select,delete,view_salary ),
    principal auditor privileges ( select, view_salary ) ,
    principal assasin privileges ( poison, mdk, select, delete )
)]',

    -- POLICY
    'create application policy'
  );

  procedure test_acl_create
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'create', 'application', 'acl');
    DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_acl) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_acl_create;

end ut_create;
/
