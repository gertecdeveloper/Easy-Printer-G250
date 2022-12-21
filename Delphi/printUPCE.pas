unit printUPCE;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printUPCEFunction(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printUPCEFunction(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printUPCEFunction(text: string; printer : TBlockSerial)overload;
procedure printUPCEFunction(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printUPCEFunction(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'UPCE', text, printer);
end;

procedure printUPCEFunction(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'UPCE', text, printer);
end;

procedure printUPCEFunction(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'UPCE', text, printer);
end;

procedure printUPCEFunction(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'UPCE', text, printer);
end;

end.
