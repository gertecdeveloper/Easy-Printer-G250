unit statusDrawer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs;

Const
  RETURN_STATUS_DRAWER_COMMAND = #16#4#1;
  RESTART = #27#64;

function statusDrawer(printer : TBlockSerial):string;
function statusDrawer(printer : TTCPBlockSocket):string;

implementation

function statusDrawer(printer : TBlockSerial): string;
var
  response: string;

begin
  printer.SendString(RETURN_STATUS_DRAWER_COMMAND);
  response := printer.RecvByte(2000).ToBinString;
  //ShowMessage(response);
  if((response[7] = '1') and (response[6] = '1'))then
    Result := 'Drawer close'
  else if((response[7] = '1') and (response[6] = '0'))then
    Result := 'Drawer open'
  else
    Result := 'inaccessible printer';
end;

function statusDrawer(printer : TTCPBlockSocket): string;
var
  response: string;

begin
  printer.SendString(RESTART);
  printer.SendString(RETURN_STATUS_DRAWER_COMMAND);
  response := printer.RecvByte(2000).ToBinString;
  //ShowMessage(response);
  if((response[7] = '1') and (response[6] = '1'))then
    Result := 'Drawer close'
  else if((response[7] = '1') and (response[6] = '0'))then
    Result := 'Drawer open'
  else
    Result := 'inaccessible printer';
end;

end.

