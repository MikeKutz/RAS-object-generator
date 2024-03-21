clear screen;
set SERVEROUTPUT on;

exec cSQL.ut_create.test_acl_create;

select * from SYNTAX_LISTS;

select JSON_SERIALIZE( json(x.MATCHRECOGNIZE_DEFINE.json_clob) ) def_json
from syntax_lists x;

select JSON_SERIALIZE( json(x.CODE_TEMPLATE.blueprint_json) ) def_json
from syntax_lists x;

exec ut_create.test_acl_create;

select * from all_objects where OWNER ='TEJSON';


