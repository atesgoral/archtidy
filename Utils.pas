unit Utils;

interface

uses
  SysUtils;

function ItemCount(Cnt: Integer; ItemName: String): String;

implementation

function ItemCount(Cnt: Integer; ItemName: String): String;
var
  Fmt: String;

begin
  case Cnt of
    0: Fmt := 'no %ss';
    1: Fmt := '1 %s';
  else
    Fmt := '%d %ss';
  end;
  if (Cnt > 1) then
    Result := Format(Fmt, [Cnt, ItemName])
  else
    Result := Format(Fmt, [ItemName]);
end;

end.
