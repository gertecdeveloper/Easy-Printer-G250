unit trigGuill;

interface

uses
  Classes, SysUtils, synaser, blcksock, OpenDoor, CloseDoor,sendBinBuffer;

const
  TRIG_GUILL = #29#86#65#00;
  RESTART = #27#64;

procedure trigGuillFunction(printer : TBlockSerial)overload;
procedure trigGuillFunction(printer : TTCPBlockSocket)overload;

implementation

procedure trigGuillFunction(printer : TBlockSerial);
begin
  sendBinBufferFunction(TEncoding.ASCII.GetBytes(TRIG_GUILL), printer);
end;

procedure trigGuillFunction(printer : TTCPBlockSocket);
begin
  sendBinBufferFunction(TEncoding.ASCII.GetBytes(TRIG_GUILL), printer);
end;

end.

