unit printCODE93;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printCODE93Function(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printCODE93Function(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printCODE93Function(text: string; printer : TBlockSerial)overload;
procedure printCODE93Function(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printCODE93Function(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE93', text, printer);
end;

procedure printCODE93Function(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE93', text, printer);
end;

procedure printCODE93Function(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE93', text, printer);
end;

procedure printCODE93Function(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE93', text, printer);
end;

end.
