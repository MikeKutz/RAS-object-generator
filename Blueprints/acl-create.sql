clear screen;
set SERVEROUTPUT on;


DECLARE
  bp      teJSON.Blueprint;
  v_privs teJSON.Blueprint;
  v_aces  teJSON.Blueprint;
  v_ace   teJSON.Blueprint;
  e       teJSON.Engine_t;
  obj     cSQL.ras_acl_syntax;
  h       MKLibrary.Hash_t;
BEGIN
  
  bp      := new teJSON.Blueprint( 'procedure', 'acl-create', 'blueprint' );

  bp.set_snippet( 'name', 'make_acl');

  v_privs := new teJSON.Blueprint( 'variable', '01-privs', 'blueprint' );
  v_privs.set_snippet( 'name', 'priv');
  v_privs.set_snippet( 'data-type', 'xs$name_list');

  v_ace   := new teJSON.Blueprint( 'variable', '02-ace', 'blueprint' );
  v_ace.set_snippet( 'name', 'ace');
  v_ace.set_snippet( 'data-type', 'xs$ace_type');

  v_aces  := new teJSON.Blueprint( 'variable', '03-aces', 'blueprint' );
  v_aces.set_snippet( 'name', 'aces');
  v_aces.set_snippet( 'data-type', 'xs$ace_list');
  
  bp.add_blueprint( v_privs );
  bp.add_blueprint( v_ace );
  bp.add_blueprint( v_aces );

  bp.set_snippet( 'bdy', q'[${@.variable.03-aces.name} := new ${@.variable.03-aces.data-type}();

<%@ foreach( aces, i ) %>-- ACE for "${i.principal}"
${@.variable.01-privs.name} := new ${@.variable.01-privs.data-type}();
<%@ foreach( i.privileges, j ) %>
${@.variable.01-privs.name}.extend(1);
${@.variable.01-privs.name}( ${@.variable.01-privs.name}.last ) := '${j.value}';
<%@- end-foreach %>

${@.variable.02-ace.name} := new ${@.variable.02-ace.data-type}( privilege_list => ${@.variable.01-privs.name}
    ,principal_name => '${i.principal}'
    ,principal_type => <%@ case( ${i.PRINCIPAL_TYPE} ) %><%@ when( database ) %>2<%@ when( external ) %>4<%@ else %>1<%@ end-case %>
   );

${@.variable.03-aces.name}.extend(1);
${@.variable.03-aces.name}( ${@.variable.03-aces.name}.last ):= ${@.variable.02-ace.name};

<%@ end-foreach +%>
/******************************************************************/

sys.xs_acl.create_acl( name => '${OBJECT_NAME}'
                      ,ace_list => ${@.variable.03-aces.name}
                      ,sec_class => '${SECURITY_CLASS}' );
]');
  
  -- RUN A TEST OUTPUT !!
--   e := new TEJSON.Engine_t( bp );
--   e.vars.json_clob := '{"OBJECT_TYPE":"acl","OBJECT_NAME":"hr_acl","SECURITY_CLASS":"hrpriv","aces":[{"principal":"hr_representive","privileges":["insert","update","select","delete","view_salary"]},{"principal":"auditor","privileges":["select","view_salary"]},{"principal":"assasin","privileges":["poison","mdk","select","delete"]}]}';

-- dbms_output.PUT_LINE( '=====================' );
--   dbms_output.PUT_LINE( e.render_snippet( '$.procedure.acl-create.exec'));

  -- TODO - finish them
  h := new MKLibrary.Hash_t();
  for k,v in pairs of cSQL.ddlt_ras.defines( cSQL.ddlt_ras.acls )
  LOOP
    h.put_value(k,v);
  end loop;

  obj                        := new cSQL.ras_acl_syntax( 'create', 'application', 'acl' );
  obj.matchrecognize_pattern := cSQL.ddlt_ras.patterns( cSQL.ddlt_ras.acls );
  
  obj.matchrecognize_define  := cSQL.parser_util.aa2hash( cSQL.ddlt_ras.defines( cSQL.ddlt_ras.acls ) );

  obj.code_template          := bp;
  obj.append_snippet_list( '$.procedure.acl-create.exec' );

  -- save instrucktion here
  obj.upsert_group( 'RAS Objects');
  obj.upsert_syntax();
  commit;

  -- make UT of a->z
end;
/
