unit printCODE39;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printCODE39(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printCODE39(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);

procedure printCODE39(text: string; printer : TBlockSerial);
procedure printCODE39(text: string; printer : TTCPBlockSocket);

procedure printCODE39(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);
procedure printCODE39(text: string; printer : TPrinter);

implementation

procedure printCODE39(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE39', text, printer);
end;

procedure printCODE39(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE39', text, printer);
end;

procedure printCODE39(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE39', text, printer);
end;

procedure printCODE39(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
   printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE39', text, printer);
end;

procedure printCODE39(text: string; printer:TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'CODE39', text, printer);
end;

procedure printCODE39(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'CODE39', text, printer);
end;

end.

