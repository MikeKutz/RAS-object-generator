clear screen;
set serveroutput on;

DECLARE
  bp      teJSON.Blueprint;
  e       teJSON.Engine_t;
  obj     cSQL.ras_acl_syntax;
  h       MKLibrary.Hash_t;
BEGIN
  bp      := new teJSON.Blueprint( 'procedure', 'acl-drop', 'blueprint' );

  bp.set_snippet( 'name', 'drop_acl');

  bp.set_snippet( 'bdy',q'[xs_acl.delete_acl( acl => '${OBJECT_NAME}'
      ,delete_option => <%@ case( ${FORCE} ) %><%@ when( cascade ) %>cascade<%@ when( force ) %>force<%@ else %>default<%@ end-case %>
    );]');

  h := new MKLibrary.Hash_t();
  h.put_value ( 'w_drop', q'[token = 'drop']');
  h.put_value ( 'w_application', q'[token = 'application']');
  h.put_value ( 'x_object_type', q'[token = 'acl']');
  h.put_value('x_force',q'[token in ('force','cascade','default')]');

  obj                        := new cSQL.ras_acl_syntax( 'drop', 'application', 'acl' );
  obj.matchrecognize_pattern := 'w_drop w_application x_object_type x_object_name x_force?';
  
  obj.matchrecognize_define  := h;

  obj.code_template          := bp;
  obj.append_snippet_list( '$.procedure.acl-drop.exec' );

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;

end;
/