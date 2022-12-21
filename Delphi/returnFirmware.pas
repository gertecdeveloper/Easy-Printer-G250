unit returnFirmware;


interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor;

Const
  RETURN_FIRMWARE = #29#73#65;
  RESTART = #27#64;

function returnFirmwareFunction(printer : TBlockSerial):string overload;
function returnFirmwareFunction(printer : TTCPBlockSocket):string overload;

implementation

function returnFirmwareFunction(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_FIRMWARE);
  temp := chr(printer.RecvByte(200));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnFirmwareFunction(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  response := '';
  printer.SendString(RETURN_FIRMWARE);
  temp := chr(printer.RecvByte(500));
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(500));
    response := response + temp;
  end;
  Result := response;
end;

end.
