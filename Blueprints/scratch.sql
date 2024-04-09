clear screen;
set SERVEROUTPUT on;

-- exec cSQL.ut_create.test_acl_drop;

-- exec cSQL.ut_create.test_acl_create;

--exec cSQL.ut_create.test_sec_create;

-- exec cSQL.ut_create.test_policy_create;

-- exec cSQL.ut_create.test_alter_drop;
-- exec cSQL.ut_create.test_policy_create;
-- exec cSQL.ut_create.test_policy_create;

-- select * from table( teJSON.Blueprint() );

-- create or replace
-- package p
-- as  end;
-- /

alter session set sql_translation_profile = RAS_SQL;
alter session set events = '10601 trace name context forever, level 32';
--create application security_class  hrprivs3 under ( dml )
--       define privileges ( view_salary );
--
declare
 vclob clob;
BEGIN
  -- translate
   DBMS_SQL_TRANSLATOR.TRANSLATE_SQL(
--  cSQL.ddlt_translator.translate_sql(
                                         SQL_TEXT         => q'[create application security_class  hrprivs3 under ( dml )
      define privileges ( view_salary )]',
                                         TRANSLATED_TEXT  => vclob
                                        );
  dbms_output.put_line( '----' || chr(10) || vclob || chr(10) || '---');
end;
/

drop procedure if exists ".noop";

