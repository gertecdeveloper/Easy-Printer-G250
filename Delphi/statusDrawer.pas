unit statusDrawer;

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Vcl.Dialogs;

Const
  RETURN_STATUS_DRAWER_COMMAND = #16#4#1;
  RESTART = #27#64;

function statusDrawerFunction(printer : TBlockSerial):string overload;
function statusDrawerFunction(printer : TTCPBlockSocket):string overload;

implementation

function statusDrawerFunction(printer : TBlockSerial): string;
var
  response: byte;
  mask : integer;
  arr : array of integer;
  i : integer;
begin
  SetLength(arr, 8);
  printer.SendString(RETURN_STATUS_DRAWER_COMMAND);
  response := printer.RecvByte(2000);
  //valor := response;

  for i := 0 to 7 do
  begin
    if response and (1 shl i) <> 0 then
      arr[i]:= 1
    else
      arr[i]:=0;

  end;

  //ShowMessage(IntToStr(arr[1])+IntToStr(arr[3]));
  if((arr[2] = 1))then
    Result := 'Drawer close'
  else
    Result := 'Drawer open';
end;

function statusDrawerFunction(printer : TTCPBlockSocket): string;
var
  response: byte;
  mask : integer;
  arr : array of integer;
  i : integer;
begin
  SetLength(arr, 8);
  printer.SendString(RETURN_STATUS_DRAWER_COMMAND);
  response := printer.RecvByte(2000);
  //valor := response;

  for i := 0 to 7 do
  begin
    if response and (1 shl i) <> 0 then
      arr[i]:= 1
    else
      arr[i]:=0;

  end;

  //ShowMessage(IntToStr(arr[1])+IntToStr(arr[3]));
  if((arr[2] = 1))then
    Result := 'Drawer close'
  else
    Result := 'Drawer open';
end;

end.

