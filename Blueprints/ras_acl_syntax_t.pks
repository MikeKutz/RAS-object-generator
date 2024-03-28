create or replace
type ras_acl_syntax under syntax_parser_t (
  constructor function ras_acl_syntax( act varchar2, grp varchar2, obj varchar2) return self as result,
  OVERRIDING member procedure assert_syntax( self in out nocopy ras_acl_syntax, code clob ),
  overriding member procedure assert_parsed( self in out nocopy ras_acl_syntax, parsed JSON)
);
/
