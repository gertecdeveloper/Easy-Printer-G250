unit printEAN13;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printEAN13(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printEAN13(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);
procedure printEAN13(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);

procedure printEAN13(text: string; printer : TPrinter);
procedure printEAN13(text: string; printer : TBlockSerial);
procedure printEAN13(text: string; printer : TTCPBlockSocket);

implementation

procedure printEAN13(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'EAN13', text, printer);
end;

procedure printEAN13(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'EAN13', text, printer);
end;

procedure printEAN13(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'EAN13', text, printer);
end;

procedure printEAN13(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'EAN13', text, printer);
end;

procedure printEAN13(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'EAN13', text, printer);
end;

procedure printEAN13(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'EAN13', text, printer);
end;

end.
