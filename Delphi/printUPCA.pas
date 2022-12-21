unit printUPCA;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printUPCAFunction(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printUPCAFunction(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printUPCAFunction(text: string; printer : TBlockSerial)overload;
procedure printUPCAFunction(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printUPCAFunction(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'UPCA', text, printer);
end;

procedure printUPCAFunction(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'UPCA', text, printer);
end;

procedure printUPCAFunction(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'UPCA', text, printer);
end;

procedure printUPCAFunction(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'UPCA', text, printer);
end;

end.
