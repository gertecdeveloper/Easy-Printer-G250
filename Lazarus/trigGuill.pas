unit TrigGuill;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, OpenDoor, CloseDoor, Printers, sendBinBuffer;

const
  TRIG_GUILL = #29#86#65#00;
  RESTART = #27#64;

procedure trigGuill(printer : TBlockSerial);
procedure trigGuill(printer : TPrinter);
procedure trigGuill(printer : TTCPBlockSocket);

implementation

procedure trigGuill(printer : TBlockSerial);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(TRIG_GUILL), printer);
end;

procedure trigGuill(printer : TPrinter);
begin
   sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(TRIG_GUILL), printer);
end;

procedure trigGuill(printer : TTCPBlockSocket);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(TRIG_GUILL), printer);
end;

end.

