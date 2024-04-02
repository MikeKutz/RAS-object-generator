clear screen;
set serveroutput on;

DECLARE
  bp      teJSON.Blueprint;
  e       teJSON.Engine_t;
  obj     cSQL.syntax_parser_t;
  h       MKLibrary.Hash_t;
BEGIN
  bp      := new teJSON.Blueprint( 'procedure', 'sec-drop', 'blueprint' );

  bp.set_snippet( 'name', 'drop_security_class');

  bp.set_snippet( 'bdy',q'[xs_security_class.delete_security_class( sec_class => '${OBJECT_NAME}'
      ,delete_option => <%@ case( ${FORCE} ) %><%@ when( cascade ) %>cascade<%@ when( force ) %>force<%@ else %>default<%@ end-case %>
    );]');

  h := new MKLibrary.Hash_t();
  h.put_value ( 'w_drop', q'[token = 'drop']');
  h.put_value ( 'w_application', q'[token = 'application']');
  h.put_value ( 'x_object_type', q'[token = 'security_class']');
  h.put_value('x_force',q'[token in ('force','cascade','default')]');

  obj                        := new cSQL.syntax_parser_t( 'drop', 'application', 'security_class' );
  obj.matchrecognize_pattern := 'w_drop w_application x_object_type x_object_name x_force?';
  
  obj.matchrecognize_define  := h;

  obj.code_template          := bp;
  obj.execution_snippet      := '$.procedure.sec-drop.exec';

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;

end;
/