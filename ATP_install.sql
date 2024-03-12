set define off
whenever sqlerror exit 1;
prompt Creating RAS-object-generator
<<verify_user>>
declare
    dummy dual.dummy%type;
begin
    select a.dummy
        into verify_user.dummy
    from dual a
        where upper(USER) = 'TEPLSQL$SYS';
exception
    when no_data_found then
        raise_application_error( -20001, 'Please run this script as the tePLSQL$SYS user');
end;
/

prompt step 1 - creating user tePLSQL$SYS

-- this should probably be part of tePLSQL project
-- run "create_user.sql" as ADMIN or DBA first
-- run this as tePLSQL$SYS 2nd

create role tePLSQL_user;
create role tePLSQL_cbac;

prompt Step 2 - installing tePLSQL objects
@@tePLSQL/install.sql

prompt Step 3 - installing GenGen objects
@@translator/02_owner_create_all.sql

prompt Step 4 - installing RAS specific components for GenGen
@@DDLT_RAS.pks
@@DDLT_RAS.pkb

prompt Step 5 - Applying (all) Public Synonyms
@@public_synonyms.sql

prompt Step 6 - Normal Grants
-- tePLSQL
grant execute on teplsql to tePLSQL_user;
grant execute on te_templates_api to tePLSQL_user;

-- GenGen
grant execute on tePLSQL$SYS.tokens_t to tePLSQL_user; -- public
grant execute on tePLSQL$SYS.tokens_nt to tePLSQL_user; -- public

grant execute on tePLSQL$SYS.token_aggregator_obj to tePLSQL_user;

grant insert,update,select,delete on tePLSQL$SYS.token_aggregators to tePLSQL_user; --CBAC
grant select on tePLSQL$SYS.token_aggregator_seq to tePLSQL_user; -- CBAC
grant execute on tePLSQL$SYS.ddlt_util to tePLSQL_user;
grant execute on tePLSQL$SYS.ddlt_ut to tePLSQL_user;
-- mising TEMP tables
grant insert,update,select,delete on tePLSQL$SYS.ddlt_tokens_temp to tePLSQL_user;
grant insert,update,select,delete on tePLSQL$SYS.ddlt_matched_tokens_temp to tePLSQL_user;

-- RAS Objects
grant execute on tePLSQL$SYS.ddlt_ras to tePLSQL_user;

prompt Step 7 - CBAC Grants

prompt Step 8 - verify GenGen install
set serveroutput on;
set timing on;
declare
    p clob;
    s clob;
    tt     tePLSQL$SYS.tokens_nt;
    err_code int;
    
    a   tePLSQL$SYS.token_aggregator_obj := new     tePLSQL$SYS.token_aggregator_obj;
    sql_txt clob;
    
    test_no  int := null;
begin
    for test# in nvl(test_no,1) .. nvl(test_no,10)
    loop

    s := tePLSQL$SYS.ddlt_ut.sample_ut( test# );
    p := tePLSQL$SYS.ddlt_ut.sample_utp( test# );
    
    begin
        tt := tePLSQL$SYS.ddlt_util.pattern_parser(  s
                                        ,p
                                        ,tePLSQL$SYS.ddlt_util.mr_define_exp_hash()
                                        ,sql_txt );
--    exception
--        when others then null;
    end;
    
    delete from tePLSQL$SYS.ddlt_matched_tokens_temp;
    insert into tePLSQL$SYS.ddlt_matched_tokens_temp
    select * from table(tt);
    
    a := new tePLSQL$SYS.token_aggregator_obj();
    for t in (select * from table(tt) order by rn)
    loop
        null;
        err_code := a.iterate_step( tePLSQL$SYS.tokens_t(t.match#, t.match_class, t.rn, t.token));
    end loop;
    dbms_output.put_line( 'TEST # ' || to_char(test#,'99') );
    dbms_output.put_line( 'statement  ="' || s || '"' );
    dbms_output.put_line( 'pattern    ="' || p || '"' );
    dbms_output.put_line( 'JSON result=' || a.json_txt);
    dbms_output.put_line( '---------------------------' );




--    dbms_output.put_line( 'pat ="' || p || '"');
    
--    dbms_output.put_line( ' SQL = ' || sql_txt );
    end loop;

end;
/



