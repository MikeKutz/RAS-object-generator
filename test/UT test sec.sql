clear screen;
set serveroutput on;
alter session set current_schema=cSQL;
declare
    s clob;
    p clob;
    
    tt       cSQL.tokens_nt;
    err_code int;
    
    a cSQL.token_aggregator_obj := new cSQL.token_aggregator_obj;
    sql_txt clob;
begin
    s := cSQL.ddlt_ras_ut.sample_security_class( 1 );
    p := cSQL.ddlt_ras.get_pattern( cSQL.ddlt_ras.security_class );
    dbms_output.put_line(s);
    dbms_output.put_line(p);
    
    tt := cSQL.ddlt_util.pattern_parser( s
                                    ,p
                                    ,cSQL.ddlt_ras.get_define( cSQL.ddlt_ras.security_class )
                                    ,sql_txt );

    delete from cSQL.ddlt_matched_tokens_temp;
    insert into cSQL.ddlt_matched_tokens_temp select * from table(tt);
    
    for t in values of tt
    loop
        err_code := a.iterate_step( t );
    end loop;

    dbms_output.put_line( a.json_txt );
end;
/
-- select * from cSQL.ddlt_matched_tokens_temp;
-- select * from cSQL.ddlt_tokens_temp;
