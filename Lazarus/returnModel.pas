unit returnModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs;

Const
  RETURN_MODEL = #29#73#67;
  RESTART = #27#64;

function returnModel(printer : TBlockSerial):string;
function returnModel(printer : TTCPBlockSocket):string;

implementation

function returnModel(printer : TBlockSerial): string;
var
  response: string;
  temp : char;
begin
  response := '';
  //printer.SendString(RESTART);
  printer.SendString(RETURN_MODEL);
  temp := chr(printer.RecvByte(200));
  //response := response + temp;
  while (temp <> chr(0)) do
  begin
    temp := chr(printer.RecvByte(200));
    response := response + temp;
  end;
  Result := response;
end;

function returnModel(printer : TTCPBlockSocket): string;
var
  response: string;
  temp : char;
begin
  //printer.SendString(RESTART);
  printer.SendString(RETURN_MODEL);
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
