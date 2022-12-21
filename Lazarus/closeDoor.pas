unit closeDoor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, Printers;

procedure closeDoor(conection: TBlockSerial);
procedure closeDoor(conection: TTCPBlockSocket);
procedure closeDoor(usbPrinter:TPrinter);

implementation

procedure closeDoor(conection: TBlockSerial);
begin
  conection.CloseSocket;
  conection.Free();
end;

procedure closeDoor(conection: TTCPBlockSocket);
begin
  conection.CloseSocket;
  conection.Free();
end;

procedure closeDoor(usbPrinter: TPrinter);
begin
  usbPrinter.EndDoc;
end;

end.

