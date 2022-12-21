unit printITF;

interface

uses
  Classes, SysUtils, printCustomBarCode, synaser, blcksock;

procedure printITFFunction(height:integer; width:integer; hri:integer; text: string; printer : TBlockSerial)overload;
procedure printITFFunction(height:integer; width:integer; hri:integer; text: string; printer : TTCPBlockSocket)overload;

procedure printITFFunction(text: string; printer : TBlockSerial)overload;
procedure printITFFunction(text: string; printer : TTCPBlockSocket)overload;

implementation

procedure printITFFunction(height: integer; width: integer; hri: integer; text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'ITF', text, printer);
end;

procedure printITFFunction(text: string; printer : TBlockSerial);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'ITF', text, printer);
end;

procedure printITFFunction(text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(100, 1, 1, 'ITF', text, printer);
end;

procedure printITFFunction(height: integer; width: integer; hri: integer; text: string; printer : TTCPBlockSocket);
begin
  printCustomBarCode.printCustomBarCodeFunction(height, width, hri, 'ITF', text, printer);
end;

end.
