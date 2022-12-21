unit sendBinBuffer;

{$mode objfpc}{$H+}
{$Codepage utf8}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs, Printers;


procedure sendBinBuffer(buffer:array of byte; printer : TBlockSerial);
procedure sendBinBuffer(buffer:array of byte; printer:TPrinter);
procedure sendBinBuffer(buffer:array of byte; printer : TTCPBlockSocket);

procedure sendBinBuffer(buffer:WideString; printer : TBlockSerial);
procedure sendBinBuffer(buffer:WideString; printer:TPrinter);
procedure sendBinBuffer(buffer:WideString; printer : TTCPBlockSocket);

implementation

procedure sendBinBuffer(buffer: array of byte; printer : TBlockSerial);

begin
  printer.SendBuffer(@buffer, Length(buffer));
end;

procedure sendBinBuffer(buffer: array of byte; printer : TTCPBlockSocket);
//var
  //printer : TTCPBlockSocket;
begin
  //printer:=openDoor.openDoor(host, port);
  printer.SendBuffer(@buffer, Length(buffer));
  //CloseDoor.closeDoor(printer);
end;

procedure sendBinBuffer(buffer: array of byte; printer: TPrinter);
var
  written:integer;
  //printer: TPrinter;
begin
  //printer := openDoor.openDoor(printerName);
  printer.Write(buffer, Length(buffer), written);
  //closeDoor.closeDoor(printer);
end;

procedure sendBinBuffer(buffer: WideString; printer : TBlockSerial);
begin
  printer.SendString(buffer);
end;

procedure sendBinBuffer(buffer: WideString; printer : TTCPBlockSocket);
begin
  printer.SendString(buffer);
end;

procedure sendBinBuffer(buffer: WideString; printer: TPrinter);
var
  written:integer;
begin
  printer.Write(buffer, Length(buffer), written);
end;

end.

