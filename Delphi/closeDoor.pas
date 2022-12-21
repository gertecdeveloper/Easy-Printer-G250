unit closeDoor;

interface

uses
  Classes, SysUtils, synaser, blcksock;

procedure closeDoorFunction(conection: TBlockSerial)Overload;
procedure closeDoorFunction(conection: TTCPBlockSocket)Overload;

implementation

procedure closeDoorFunction(conection: TBlockSerial);
begin
  conection.CloseSocket;
  conection.Free();
end;

procedure closeDoorFunction(conection: TTCPBlockSocket);
begin
  conection.CloseSocket;
  conection.Free();
end;

end.

