unit openDrawer;


interface

uses
  Classes, SysUtils,synaser, blcksock, openDoor, CloseDoor;

const
  BEEP_COMMAND = #27#66#1#2;
  OPENDRAWER_COMMAND = #27#112#0#2#2;

procedure openDrawerFunction(printer : TBlockSerial)overload;
procedure openDrawerFunction(printer : TTCPBlockSocket) overload;

implementation

procedure openDrawerFunction(printer : TBlockSerial);
begin
  printer.SendString(OPENDRAWER_COMMAND);
end;

procedure openDrawerFunction(printer : TTCPBlockSocket);
begin
  printer.SendString(OPENDRAWER_COMMAND);
end;

end.

