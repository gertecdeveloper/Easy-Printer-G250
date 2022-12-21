unit printEAN8;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printEAN8Function(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printEAN8Function(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printEAN8Function(text: string; printer : TBlockSerial)overload;
procedure printEAN8Function(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printEAN8Function(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'EAN8', text, printer);
end;

procedure printEAN8Function(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'EAN8', text, printer);
end;

procedure printEAN8Function(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'EAN8', text, printer);
end;

procedure printEAN8Function(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'EAN8', text, printer);
end;

end.
