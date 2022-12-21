unit returnSerialNumber;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs;

Const
  RETURN_SERIAL_NUMBER = #29#73#68;
  RESTART = #27#64;

function returnSerialNumber(printer : TBlockSerial):string;
function returnSerialNumber(printer : TTCPBlockSocket):string;

implementation

function returnSerialNumber(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  //printer.SendString(RESTART);
  printer.SendString(RETURN_SERIAL_NUMBER);
  temp := chr(printer.RecvByte(200));
  //response := response + temp;
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnSerialNumber(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  //printer.SendString(RESTART);
  printer.SendString(RETURN_SERIAL_NUMBER);
  temp := chr(printer.RecvByte(500));
  //response := response + temp;
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(500));
    response := response + temp;
  end;
  Result := response;
end;

end.
