unit printCODE93;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printCODE93(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printCODE93(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);

procedure printCODE93(text: string; printer : TBlockSerial);
procedure printCODE93(text: string; printer : TTCPBlockSocket);

procedure printCODE93(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);
procedure printCODE93(text: string; printer : TPrinter);

implementation

procedure printCODE93(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE93', text, printer);
end;

procedure printCODE93(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE93', text, printer);
end;

procedure printCODE93(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE93', text, printer);
end;

procedure printCODE93(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE93', text, printer);
end;

procedure printCODE93(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE93', text, printer);
end;

procedure printCODE93(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE93', text, printer);
end;

end.
