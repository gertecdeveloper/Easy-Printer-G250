unit printEAN13;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printEAN13Function(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printEAN13Function(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printEAN13Function(text: string; printer : TBlockSerial)overload;
procedure printEAN13Function(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printEAN13Function(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCodeFunction(height, width, hri, 'EAN13', text, printer);
end;

procedure printEAN13Function(text: string; printer : TBlockSerial);
begin
  printCustomBarCodeFunction(100, 1, 1, 'EAN13', text, printer);
end;

procedure printEAN13Function(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCodeFunction(100, 1, 1, 'EAN13', text, printer);
end;

procedure printEAN13Function(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCodeFunction(height, width, hri, 'EAN13', text, printer);
end;

end.
