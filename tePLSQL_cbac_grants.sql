grant execute on tePLSQL$SYS.te_syntax to tePLSQL_cbac;
grant execute on tePLSQL$SYS.te_templates_api to tePLSQL_cbac;
grant insert,select,update,delete on tePLSQL$SYS.te_templates to tePLSQL_cbac;
grant execute on tePLSQL$SYS.teplsql to tePLSQL_cbac;

grant tePLSQL_cbac to package teplsql;
grant tePLSQL_cbac to package te_templates_api;
