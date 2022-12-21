unit printUPCA;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printUPCA(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printUPCA(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);
procedure printUPCA(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);

procedure printUPCA(text: string; printer : TPrinter);
procedure printUPCA(text: string; printer : TBlockSerial);
procedure printUPCA(text: string; printer : TTCPBlockSocket);

implementation

procedure printUPCA(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCA', text, printer);
end;

procedure printUPCA(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCA', text, printer);
end;

procedure printUPCA(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCA', text, printer);
end;

procedure printUPCA(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCA', text, printer);
end;

procedure printUPCA(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCA', text, printer);
end;

procedure printUPCA(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCA', text, printer);
end;

end.
