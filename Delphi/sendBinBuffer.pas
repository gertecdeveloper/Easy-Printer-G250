unit sendBinBuffer;

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor;


procedure sendBinBufferFunction(buffer:array of byte; printer : TBlockSerial)Overload;
procedure sendBinBufferFunction(buffer:array of byte; printer : TTCPBlockSocket)Overload;

implementation

procedure sendBinBufferFunction(buffer: array of byte; printer : TBlockSerial);
//var
  //printer : TBlockSerial;
begin
  //printer:=openDoor.openDoor(port, baud);
  printer.SendBuffer(@buffer, Length(buffer));
  //CloseDoor.closeDoor(printer);
end;

procedure sendBinBufferFunction(buffer: array of byte; printer : TTCPBlockSocket);
//var
  //printer : TTCPBlockSocket;
begin
  //printer:=openDoor.openDoor(host, port);
  printer.SendBuffer(@buffer, Length(buffer));
  //CloseDoor.closeDoor(printer);
end;

end.

