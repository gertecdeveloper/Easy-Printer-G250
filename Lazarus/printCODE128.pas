unit printCODE128;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printCODE128(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printCODE128(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);
procedure printCODE128(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);

procedure printCODE128(text: string; printer : TPrinter);
procedure printCODE128(text: string; printer : TBlockSerial);
procedure printCODE128(text: string; printer : TTCPBlockSocket);

implementation

procedure printCODE128(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE128', text, printer);
end;

procedure printCODE128(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE128', text, printer);
end;

procedure printCODE128(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE128', text, printer);
end;

procedure printCODE128(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE128', text, printer);
end;

procedure printCODE128(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE128', text, printer);
end;

procedure printCODE128(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE128', text, printer);
end;

end.

