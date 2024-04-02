create or replace
package body ut_create
as
  subtype key_t is number(2);

  sql_key_secclass        constant key_t := 1;
  sql_key_acl             constant key_t := 2;
  sql_key_policy          constant key_t := 3;
  sql_key_alter_add       constant key_t := 4;
  sql_key_alter_drop      constant key_t := 5;
  sql_key_alter_modify    constant key_t := 6;

  sql_texts      MKLibrary.CLOB_Array := MKLibrary.CLOB_array(
    -- SECURITY CLASS
    'create application security_class  hrprivs under ( dml )
      define privileges ( view_salary )',

    -- ACL
    q'[
create application acl hr_acl for security class hrpriv aces (
    principal hr_representive privileges ( insert,update,select,delete,view_salary ),
    database principal auditor privileges ( select, view_salary ) ,
    external principal assasin privileges ( poison, mdk, select, delete )
)]',

    -- POLICY
    q'[create application policy emp_policy for (
      rls domain ( 1=1 ) acls ( hr_acl ) ,
      rls domain ( employee_id = xs_sys_context( 'app$session', 'employee_id') ) acls ( employee_id ) ,
      privilege view_salary protects columns ( salary ),
      foreign key ( col1 ) references tab_b columns ( blbh ) where ( 1=0 )
    )]',

    -- ALTER add
    q'[alter application table employees add policy hr_policy
        with owner bypass
        persist acls using some_mv
        for ( insert, index)
        disable]',
    q'[alter application table employees drop policy hr_policy]',
    q'[alter application table employees modify policy hr_policy disable]'
  );

  procedure test_acl_create
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'create', 'application', 'acl');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_acl) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_acl_create;

  procedure test_acl_drop
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'drop', 'application', 'acl');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( q'[drop application acl bobby_tables force]' );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_acl_drop;

  procedure test_sec_create
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'create', 'application', 'security_class');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_secclass ) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_sec_create;

  procedure test_policy_create
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'create', 'application', 'policy');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_policy) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_policy_create;

  procedure test_alter_add
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'alter', 'application', 'table');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_alter_add ) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_alter_add;

  procedure test_alter_drop
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'alter', 'application', 'table');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_alter_drop ) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_alter_drop;

  procedure test_alter_modify
  as
    obj    cSQL.syntax_parser_t;
    j      JSON;
    output CLOB;
  BEGIN
    obj := new cSQL.syntax_parser_t( 'alter', 'application', 'table');
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.match_string || '"' );
    -- DBMS_OUTPUT.PUT_LINE( 'matching "' || obj.syntax_action || '"' );
    -- dbms_output.put_line( sql_texts( sql_key_acl)  );
    
    j := obj.transpile( sql_texts( sql_key_alter_modify ) );

    if j is null THEN
      dbms_output .put_line( 'j is null');
      RAISE_APPLICATION_ERROR(-20999, 'did not parse code (null tokens)');
    else
      dbms_output.put_line( json_serialize(j));
      output := obj.build_code( j );
    end if;


    -- dbms_output.PUT_LINE( '----' );
    dbms_output.put_line( output );
  end test_alter_modify;


end ut_create;
/
