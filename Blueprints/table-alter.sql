clear screen;
set serveroutput on;

DECLARE
  bp      teJSON.Blueprint;
  e       teJSON.Engine_t;
  obj     cSQL.syntax_parser_t;
  h       MKLibrary.Hash_t;
BEGIN
  bp      := new teJSON.Blueprint( 'procedure', 'table-alter', 'blueprint' );

  bp.set_snippet( 'name', 'alter_table');

  bp.set_snippet( 'bdy', q'[<%@ case( ${ACTION} ) %>
<%@ when( add, @.add_clause ) %>
<%@ when( modify, @.modify_clause ) %>
<%@ when( drop, @.drop_clause ) %>
<%@- end-case %>]' );

  bp.set_snippet( 'add_clause', q'[xs_data_security.apply_object_policy(
     policy        => '${policy}'
    ,schema        => user
    ,object        => '${OBJECT_NAME}'
    ,row_acl       => <%@ case( ${PERSISTANCE} ) %><%@ when( persist ) %>true<%@ else %>false<%@ end-case %>
    ,owner_bypass  => <%@ case( ${BYPASS_OPTION} ) %><%@ when( with ) %>true<%@ else %>false<%@ end-case %>
    ,statement_types => null -- todo
    ,aclmv           => trim( '${using}' )
  );
${@.enable_clause}
]' );

    bp.set_snippet( 'drop_clause', q'[xs_data_security.remove_object_policy( 
     policy        => '${policy}'
    ,schema        => user
    ,object        => '${OBJECT_NAME}'
      );]' );

    bp.set_snippet( 'modify_clause', q'[${@.enable_clause}]' );
  
  bp.set_snippet( 'enable_clause', q'[<%@ case( ${ENABLE} ) %>
  <%@ when( enable ) %>xs_data_security.enable_object_policy( '${policy}', user, '${OBJECT_NAME}' );
  <%@ when( disable ) %>xs_data_security.disable_object_policy( '${policy}', user, '${OBJECT_NAME}' );
  <%@- end-case %>]' );

  -------------------------------------------------
  h := new MKLibrary.Hash_t();
  h.put_value ( 'w_alter',       q'[token = 'alter']');
  h.put_value ( 'w_application', q'[token = 'application']');
  h.put_value ( 'x_object_type', q'[token = 'table']');
  -- x_object_name
  h.put_value ( 'x_action',      q'[token in ('add','drop','modify')]');
  h.put_value ( 'n_policy', q'[token = 'policy']');
  -- x_policy_name
  h.put_value ( 'x_bypass_action', q'[token in ( 'with', 'without' )]');
  h.put_value ( 'w_owner', q'[token = 'owner']');
  h.put_value ( 'w_bypass', q'[token = 'bypass']');
  h.put_value ( 'x_persistance', q'[token in ( 'persist', 'nopersist' )]');
  h.put_value ( 'w_acls', q'[token = 'acls']');
  h.put_value ( 'n_using', q'[token = 'using']');
  -- o_mv_name
  h.put_value ( 'n_for', q'[token = 'for']');
  h.put_value ( 'x_enable', q'[token in ( 'enable', 'disable' )]');
  h.put_value ( 'l_priv', q'[token in ( 'insert', 'select', 'update', 'delete', 'index' )]');

  obj                        := new cSQL.syntax_parser_t( 'alter', 'application', 'table' );
  obj.matchrecognize_pattern :=
  'w_alter w_application x_object_type x_object_name x_action n_policy o_policy_name
  (x_bypass_option w_owner w_bypass)?
  (x_persistance w_acls (n_using o_mv_name)? )?
  (n_for c_start_list l_priv (c_comma l_priv)*  c_end_list )?
  x_enable?
  ';
  
  obj.matchrecognize_define  := h;

  obj.code_template          := bp;
  obj.append_snippet_list( '$.procedure.table-alter.exec' );

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;

end;
/