create or replace
type body ras_acl_syntax
as
  constructor function ras_acl_syntax( act varchar2, grp varchar2, obj varchar2) return self as result
  as
  begin
    ( self as syntax_parser_t ).init( act, grp, obj );
    
    return;
  end ras_acl_syntax;

  OVERRIDING member procedure assert_syntax( self in out nocopy ras_acl_syntax, code clob )
  as
  begin
    (self as syntax_parser_t).assert_syntax( code );

    case self.syntax_action
      when 'create' then
        cSQL.ras_acl_assertions.create_syntax( code );
      when 'drop' then
        cSQL.ras_acl_assertions.drop_syntax( code );
      when 'alter' then
        cSQL.ras_acl_assertions.alter_syntax( code );
      else
        raise invalid_number;
    end case;
  end assert_syntax;

  overriding member procedure assert_parsed( self in out nocopy ras_acl_syntax, parsed JSON)
  as
  begin
    (self as syntax_parser_t).assert_parsed( parsed );

    case self.syntax_action
      when 'create' then
        cSQL.ras_acl_assertions.create_parsed( parsed );
      when 'drop' then
        cSQL.ras_acl_assertions.drop_parsed( parsed );
      when 'alter' then
        cSQL.ras_acl_assertions.alter_parsed( parsed );
      else
        raise invalid_number;
    end case;
  end;
end;
/
