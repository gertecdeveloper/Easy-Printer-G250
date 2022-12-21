unit returnFirmware;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs;

Const
  RETURN_FIRMWARE = #29#73#65;
  RESTART = #27#64;

function returnFirmware(printer : TBlockSerial):string;
function returnFirmware(printer : TTCPBlockSocket):string;

implementation

function returnFirmware(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  //printer.SendString(RESTART);
  printer.SendString(RETURN_FIRMWARE);
  temp := chr(printer.RecvByte(200));
  //response := response + temp;
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnFirmware(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  //printer.SendString(RESTART);
  printer.SendString(RETURN_FIRMWARE);
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
