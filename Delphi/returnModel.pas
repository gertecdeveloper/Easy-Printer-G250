unit returnModel;

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor;

Const
  RETURN_MODEL = #29#73#67;
  RESTART = #27#64;

function returnModelFunction(printer : TBlockSerial):string overload;
function returnModelFunction(printer : TTCPBlockSocket):string overload;

implementation

function returnModelFunction(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_MODEL);
  temp := chr(printer.RecvByte(200));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnModelFunction(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_MODEL);
  temp := chr(printer.RecvByte(500));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(500));
    response := response + temp;
  end;
  Result := response;
end;

end.
