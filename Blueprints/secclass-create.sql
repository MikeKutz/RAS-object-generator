clear screen;
set SERVEROUTPUT on;


DECLARE
  bp        teJSON.Blueprint;
  v_privs   teJSON.Blueprint;
  v_parent  teJSON.Blueprint;
  x_others  teJSON.Blueprint;

  e       teJSON.Engine_t;
  obj     cSQL.syntax_parser_t;
  h       MKLibrary.Hash_t;
BEGIN
  
  bp      := new teJSON.Blueprint( 'procedure', 'secclass-create', 'blueprint' );

  bp.set_snippet( 'name', 'create_secclass');

  v_privs := new teJSON.Blueprint( 'variable', '01-privs', 'blueprint' );
  v_privs.set_snippet( 'name', 'priv');
  v_privs.set_snippet( 'data-type', 'xs$privilege_list');
  v_privs.set_snippet( 'element-data-type', 'xs$privilege');

  v_parent := new teJSON.Blueprint( 'variable', '02-parent', 'blueprint' );
  v_parent.set_snippet( 'name', 'parent_list');
  v_parent.set_snippet( 'data-type', 'xs$name_list');

  x_others := new teJSON.Blueprint( 'exception', '01-others', 'blueprint' );
  x_others.set_snippet( 'name', 'others' );

  bp.add_blueprint( v_privs );
  bp.add_blueprint( v_parent );
  -- bp.add_blueprint( x_others );

  bp.set_snippet( 'bdy', q'[${@.variable.01-privs.name} := new ${@.variable.01-privs.data-type}();
  <%@ foreach( privileges, i) %>
  ${@.variable.01-privs.name}.extend(1);
  ${@.variable.01-privs.name}( ${@.variable.01-privs.name}.last ) := new ${@.variable.01-privs.element-data-type}( '${i.value}' );
  <%@ end-foreach %>

  ${@.variable.02-parent.name} := new ${@.variable.02-parent.data-type}();
  <%@ foreach( under, i ) %>
  ${@.variable.02-parent.name}.extend(1);
  ${@.variable.02-parent.name}( ${@.variable.02-parent.name}.last ) := '${i.value}';
  <%@ end-foreach %>

  sys.xs_security_class.create_security_class( name => '${OBJECT_NAME}'
    ,priv_list   => ${@.variable.01-privs.name}
    ,parent_list => ${@.variable.02-parent.name}
    );
  exception
    when others then
      dbms_output.put_line( 'something went wrong' );
   ]' );


  obj                        := new cSQL.syntax_parser_t( 'create', 'application', 'security_class' );
  obj.matchrecognize_pattern := cSQL.ddlt_ras.patterns( cSQL.ddlt_ras.security_class );
  
  obj.matchrecognize_define  := cSQL.parser_util.aa2hash( cSQL.ddlt_ras.defines( cSQL.ddlt_ras.security_class ) );

  obj.code_template          := bp;
  obj.append_snippet_list( '$.procedure.secclass-create.exec' );

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;

  end;
  /


