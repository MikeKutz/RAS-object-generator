create or replace
function permutate_nulls( cols dbms_tf.columns_t
                         ,a001 varchar2 default null
                         ,a002 varchar2 default null
                         ,a003 varchar2 default null
                         ,a004 varchar2 default null
                         ,a005 varchar2 default null
                         ,a006 varchar2 default null
                         ,a007 varchar2 default null
                         ,a008 varchar2 default null
                         ,a009 varchar2 default null
                         ,a010 varchar2 default null
                         ,a011 varchar2 default null
                         ,a012 varchar2 default null
                         ,a013 varchar2 default null
                         ,a014 varchar2 default null
                         ,a015 varchar2 default null
                         ,a016 varchar2 default null
                         ,a017 varchar2 default null
                         ,a018 varchar2 default null
                         ,a019 varchar2 default null
                        ) return clob
sql_macro( table)
as
  type data_t is table of varchar2(128 byte) index by pls_integer;
  dat  constant data_t := new data_t(
     1    => 'a001'
    ,2    => 'a002'
    ,3    => 'a003'
    ,4    => 'a004'
    ,5    => 'a005'
    ,6    => 'a006'
    ,7    => 'a007'
    ,8    => 'a008'
    ,9    => 'a009'
    ,10   => 'a010'
    ,11   => 'a011'
    ,12   => 'a012'
    ,13   => 'a013'
    ,14   => 'a014'
    ,15   => 'a015'
    ,16   => 'a016'
    ,17   => 'a017'
    ,18   => 'a018'
    ,19   => 'a019'
    );
  max_i constant int := dat.count;
  
  sql_text    clob;  
  select_list clob := 'select distinct * from ( values ( ';
  
  sql_columns clob;
  sql_cube    clob := ' ) ) "_internal"( #COLUMNS# ) group by cube ( #COLUMNS# )';

  i int := 1;
begin
  if cols is null then
    raise no_data_found; -- never reached
  end if;

  if cols.count = 0 then
    raise no_data_found;
  end if;
  
  for rec in values of cols
  loop
    select_list := select_list || case i when 1 then ' ' else ', ' end || dat(i);
    sql_columns := sql_columns || case i when 1 then ' ' else ', ' end || cols(i);

    exit when i >= max_i;

    i := i + 1;
  end loop;

  sql_text := select_list || replace( sql_cube, '#COLUMNS#', sql_columns );
  
  return sql_text;
end;
/
