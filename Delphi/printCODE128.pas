unit printCODE128;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printCODE128Function(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printCODE128Function(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printCODE128Function(text: string; printer : TBlockSerial)overload;
procedure printCODE128Function(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printCODE128Function(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE128', text, printer);
end;

procedure printCODE128Function(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE128', text, printer);
end;

procedure printCODE128Function(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE128', text, printer);
end;

procedure printCODE128Function(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE128', text, printer);
end;

end.

