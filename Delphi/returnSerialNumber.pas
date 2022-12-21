unit returnSerialNumber;

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor;

Const
  RETURN_SERIAL_NUMBER = #29#73#68;
  RESTART = #27#64;

function returnSerialNumberFunction(printer : TBlockSerial):string overload;
function returnSerialNumberFunction(printer : TTCPBlockSocket):string overload;

implementation

function returnSerialNumberFunction(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_SERIAL_NUMBER);
  temp := chr(printer.RecvByte(200));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnSerialNumberFunction(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_SERIAL_NUMBER);
  temp := chr(printer.RecvByte(500));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(500));
    response := response + temp;
  end;
  Result := response;
end;

end.
