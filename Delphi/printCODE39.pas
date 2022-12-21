unit printCODE39;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printCODE39Function(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printCODE39Function(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printCODE39Function(text: string; printer : TBlockSerial)overload;
procedure printCODE39Function(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printCODE39Function(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE39', text, printer);
end;

procedure printCODE39Function(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE39', text, printer);
end;

procedure printCODE39Function(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'CODE39', text, printer);
end;

procedure printCODE39Function(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'CODE39', text, printer);
end;

end.

