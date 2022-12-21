unit openDrawer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,synaser, blcksock, openDoor, CloseDoor, Dialogs;

const
  BEEP_COMMAND = #27#66#1#2;
  OPENDRAWER_COMMAND = #27#112#0#2#2;

procedure openDrawer(printer : TBlockSerial);
procedure openDrawer(printer : TTCPBlockSocket);

implementation

procedure openDrawer(printer : TBlockSerial);
//var
  //printer : TBlockSerial;

begin
  //printer:=openDoor.openDoor(port, baud);
  printer.SendString(OPENDRAWER_COMMAND);
  //printer.SendString(BEEP_COMMAND);
  //CloseDoor.closeDoor(printer);
end;

procedure openDrawer(printer : TTCPBlockSocket);
//var
  //printer : TTCPBlockSocket;

begin
  //printer:=openDoor.openDoor(host, port);
  printer.SendString(OPENDRAWER_COMMAND);
  //printer.SendString(BEEP_COMMAND);
  //CloseDoor.closeDoor(printer);
end;

end.

