clear screen;
set SERVEROUTPUT on;


DECLARE
  bp          teJSON.Blueprint;
  -- v_privs     teJSON.Blueprint;
  v_realms    teJSON.Blueprint;
  v_columns   teJSON.Blueprint;

  v_acls      teJSON.Blueprint;
  v_col_list  teJSON.Blueprint;
  v_f_keys    teJSON.Blueprint;

  e       teJSON.Engine_t;
  obj     cSQL.syntax_parser_t;
  h       MKLibrary.Hash_t;
BEGIN
  
  bp      := new teJSON.Blueprint( 'procedure', 'policy-create', 'blueprint' );

  bp.set_snippet( 'name', 'make_policy');

  v_realms := new teJSON.Blueprint( 'variable', '01-realm', 'blueprint' );
  v_realms.set_snippet( 'name', 'realms');
  v_realms.set_snippet( 'data-type', 'xs$realm_constraint_list');
  v_realms.set_snippet( 'element-data-type', 'xs$realm_constraint_type');

  v_columns := new teJSON.Blueprint( 'variable', '02-columns', 'blueprint' );
  v_columns.set_snippet( 'name', 'cols');
  v_columns.set_snippet( 'data-type', 'xs$column_constraint_list');
  v_columns.set_snippet( 'element-data-type', 'xs$column_constraint_type');

  v_acls := new teJSON.Blueprint( 'variable', '03-acls', 'blueprint' );
  v_acls.set_snippet( 'name', 'acls');
  v_acls.set_snippet( 'data-type', 'xs$name_list');

  v_col_list := new teJSON.Blueprint( 'variable', '04-col-list', 'blueprint' );
  v_col_list.set_snippet( 'name', 'col_list');
  v_col_list.set_snippet( 'data-type', 'xs$list');

  v_f_keys := new teJSON.Blueprint( 'variable', '05-f-keys', 'blueprint' );
  v_f_keys.set_snippet( 'name', 'fk_columns');
  v_f_keys.set_snippet( 'data-type', 'xs$key_list');
  v_f_keys.set_snippet( 'element-data-type', 'xs$key_type');



  bp.add_blueprint( v_realms ); -- colection of Realms
  bp.add_blueprint( v_columns ); -- collection of Columns protection
  bp.add_blueprint( v_acls ); -- (sub) list of ACLs for a Realm
  bp.add_blueprint( v_col_list ); -- (sub) list of Columns for Column Protection
  bp.add_blueprint( v_f_keys ); -- (sub) list of Foreign Key column mappings
  
  bp.set_snippet( 'bdy', q'[${@.variable.01-realm.name} := new ${@.variable.01-realm.data-type}();
${@.variable.02-columns.name} := new ${@.variable.02-columns.data-type}();

<%@ foreach( $.for, i ) %>
<%@- case( ${i.TYPE} ) +%>
<%@ when( rls ) +%>
-- Row Level policy
${@.variable.03-acls.name} := new ${@.variable.03-acls.data-type}();<%@ foreach( i.acls, j ) %>
${@.variable.03-acls.name}.extend(1);
${@.variable.03-acls.name}( ${@.variable.03-acls.name}.last ) := '${j.value}';
<%@ end-foreach %>
${@.variable.01-realm.name}.extend(1);
${@.variable.01-realm.name}( ${@.variable.01-realm.name}.last ) := new ${@.variable.01-realm.element-data-type}(
    realm     => q'❌${i.domain}❌'
  ,acl_list  => ${@.variable.03-acls.name}
  ,is_static => false
);
<%@ when( foreign )+ %>
-- FK domain
${@.variable.05-f-keys.name} := new ${@.variable.05-f-keys.data-type}();
<%@ foreach( i.key, r ) %>
${@.variable.05-f-keys.name}.extend(1);
${@.variable.05-f-keys.name}( ${@.variable.05-f-keys.name}.last ) := new ${@.variable.05-f-keys.element-data-type}( '${r.value}', '${r.value}', 1);
<%@ end-foreach %>
${@.variable.01-realm.name}.extend(1);
${@.variable.01-realm.name}( ${@.variable.01-realm.name}.last ) := new ${@.variable.01-realm.element-data-type}(
      parent_schema  => user
      ,parent_object => '${i.references}'
      ,key_list      => ${@.variable.05-f-keys.name}
      ,when_condition => trim( '❌${i.where}❌' )
      );
<%@- when( privilege ) %>
-- Column Privilege
${@.variable.04-col-list.name} := new ${@.variable.04-col-list.data-type}();
<%@ foreach( i.columns, k) %>
${@.variable.04-col-list.name}.extend(1);
${@.variable.04-col-list.name}( ${@.variable.04-col-list.name}.last ) := '${k.value}';
<%@ end-foreach %>
${@.variable.02-columns.name}.extend(1);
${@.variable.02-columns.name}( ${@.variable.02-columns.name}.last ) := new ${@.variable.02-columns.element-data-type}(
  privilege    => '${i.PRIVILEGE_NAME}'
  ,column_list => ${@.variable.04-col-list.name}
);

<%@ else %>-- oops
<%@ end-case %><%@ end-foreach %>

xs_data_security.create_policy( name=> '${OBJECT_NAME}'
   ,realm_constraint_list => ${@.variable.01-realm.name}
  ,column_constraint_list => ${@.variable.02-columns.name}
);
]' );

  obj                        := new cSQL.syntax_parser_t( 'create', 'application', 'policy' );
  obj.matchrecognize_pattern := cSQL.ddlt_ras.patterns( cSQL.ddlt_ras.policys );
  
  obj.matchrecognize_define  := cSQL.parser_util.aa2hash( cSQL.ddlt_ras.defines( cSQL.ddlt_ras.policys ) );

  obj.code_template          := bp;
  obj.append_snippet_list( '$.procedure.policy-create.exec' );

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;


end;
/
