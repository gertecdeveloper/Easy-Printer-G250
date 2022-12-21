unit printITF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printITF(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printITF(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);
procedure printITF(height:integer; width:integer; hri:integer; text: string; printer:TPrinter);

procedure printITF(text: string; printer : TPrinter);
procedure printITF(text: string; printer : TBlockSerial);
procedure printITF(text: string; printer : TTCPBlockSocket);

implementation

procedure printITF(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'ITF', text, printer);
end;

procedure printITF(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'ITF', text, printer);
end;

procedure printITF(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'ITF', text, printer);
end;

procedure printITF(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'ITF', text, printer);
end;

procedure printITF(height: integer; width: integer; hri: integer; text: string;
  printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'ITF', text, printer);
end;

procedure printITF(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'ITF', text, printer);
end;

end.
