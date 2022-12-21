unit printUPCE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, printCustomBarCode, Printers, synaser, blcksock;

procedure printUPCE(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial);
procedure printUPCE(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket);
procedure printUPCE(height:integer; width:integer; hri:integer; text: string; printer : TPrinter);

procedure printUPCE(text: string; printer : TPrinter);
procedure printUPCE(text: string; printer : TBlockSerial);
procedure printUPCE(text: string; printer : TTCPBlockSocket);

implementation

procedure printUPCE(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCE', text, printer);
end;

procedure printUPCE(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCE', text, printer);
end;

procedure printUPCE(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCE', text, printer);
end;

procedure printUPCE(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCE', text, printer);
end;

procedure printUPCE(height: integer; width: integer; hri: integer;
  text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(height, width, hri, 'UPCE', text, printer);
end;

procedure printUPCE(text: string; printer : TPrinter);
begin
  printCustomBarCode.printCustomBarCode(100, 1, 1, 'UPCE', text, printer);
end;

end.
