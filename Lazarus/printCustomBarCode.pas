unit printCustomBarCode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs, Printers, sendBinBuffer;

const
  HEIGHT_COMMAND = #29#104;
  WIDTH_COMMAND = #29#119;
  HRI_COMMAND = #29#72;

type
  TCodeBar = record
    name:string;
    minimumLength:integer;
    maximoLength:integer;
    codeToPrint:integer;
  end;

  TCodesBarArr = array[1..9] of TCodeBar;

procedure printCustomBarCode(height:integer; width:integer; hri:integer; codeType:string; text: string; printer : TBlockSerial);
procedure printCustomBarCode(height:integer; width:integer; hri:integer; codeType:string; text: string; printer: TPrinter);
procedure printCustomBarCode(height:integer; width:integer; hri:integer; codeType:string; text: string; printer : TTCPBlockSocket);
function loadCodesBarToArray():TCodesBarArr;

function printCodeBarFactory(height:integer; width:integer; hri:integer; codeType:string; text: string):String;

implementation

procedure printCustomBarCode(height:integer; width:integer; hri: integer;
  codeType:string; text: string; printer : TBlockSerial);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(printCodeBarFactory(height, width, hri, codeType, text)), printer);
end;

procedure printCustomBarCode(height: integer; width: integer; hri: integer;
  codeType: string; text: string; printer : TPrinter);
//var
  //arrBytes: packed array of byte;
  //codeBarStr : string;
begin
  //codeBarStr:=printCodeBarFactory(height, width, hri, codeType, text);
  //setLength(arrBytes, length(codeBarStr));
  //Move(codeBarStr[1], arrBytes[0], Length(codeBarStr));
  sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(printCodeBarFactory(height, width, hri, codeType, text)), printer);
end;

procedure printCustomBarCode(height: integer; width: integer; hri: integer;
  codeType: string; text: string; printer : TTCPBlockSocket);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetBytes(printCodeBarFactory(height, width, hri, codeType, text)), printer);
end;

function loadCodesBarToArray():TCodesBarArr;
var
  codesBarArr:TCodesBarArr;
begin
  codesBarArr[1].codeToPrint:=0;
  codesBarArr[1].name:='UPCA';
  codesBarArr[1].minimumLength:=11;
  codesBarArr[1].maximoLength:=12;

  codesBarArr[2].codeToPrint:=1;
  codesBarArr[2].name:='UPCE';
  codesBarArr[2].minimumLength:=11;
  codesBarArr[2].maximoLength:=12;

  codesBarArr[3].codeToPrint:=2;
  codesBarArr[3].name:='EAN13';
  codesBarArr[3].minimumLength:=12;
  codesBarArr[3].maximoLength:=13;

  codesBarArr[4].codeToPrint:=3;
  codesBarArr[4].name:='EAN8';
  codesBarArr[4].minimumLength:=7;
  codesBarArr[4].maximoLength:=8;

  codesBarArr[5].codeToPrint:=69;
  codesBarArr[5].name:='CODE39';
  codesBarArr[5].minimumLength:=1;
  codesBarArr[5].maximoLength:=255;

  codesBarArr[6].codeToPrint:=5;
  codesBarArr[6].name:='ITF';
  codesBarArr[6].minimumLength:=1;
  codesBarArr[6].maximoLength:=255;

  codesBarArr[7].codeToPrint:=72;
  codesBarArr[7].name:='CODE93';
  codesBarArr[7].minimumLength:=1;
  codesBarArr[7].maximoLength:=255;

  codesBarArr[8].codeToPrint:=73;
  codesBarArr[8].name:='CODE128';
  codesBarArr[8].minimumLength:=2;
  codesBarArr[8].maximoLength:=255;

  Result:= codesBarArr;
end;

function printCodeBarFactory(height: integer; width: integer; hri: integer;
  codeType: string; text: string): String;
var
  buffer:string;
  PRINT : string;
  height_concat, width_concat, hri_concat:string;
  codesBarArr:TCodesBarArr;
  i:TCodeBar;
  codeBar:TCodeBar;
begin

  if((height<0) or (height>255)) then
    raise Exception.Create('O valor de altura deve estar entre 0 e 255');

  //if((width<1) or (width>2)) then
    //raise Exception.Create('O valor de largura deve 1 ou 2');

  if((hri<0) or (hri>3)) then
    raise Exception.Create('Os valores válidos de HRI são 0, 1 ou 2: 0 - None; 1 - Above; 2 - Below; 3 - Above and Below');

  codesBarArr:= loadCodesBarToArray();
  codeBar.name := 'null';

  for i in codesBarArr do
  begin
    if (LowerCase(i.name) = LowerCase(codeType))then
       codeBar := i;

  end;

  if(codeBar.name = 'null') then
    raise Exception.Create('Tipo de código de barras não encontrado, os valores possíveis são: UPCA, UPCE, EAN8, EAN13'
    +', CODE39, ITF, CODE93 e CODE128');

  if((Length(text)<codeBar.minimumLength) or (Length(text)>codeBar.maximoLength)) then
    raise Exception.Create('Quantidade de caracteres incorreta. Para o código '+codeBar.name
          + ' são necessários no mínimo '+IntToStr(codeBar.minimumLength)+' e no máximo '+
          IntToStr(codeBar.maximoLength)
          +' caracteres.');

  PRINT := #29#107+ chr(codeBar.codeToPrint) ;
  if(width>127)then
    height_concat := HEIGHT_COMMAND + AnsiChar(Lo(height)) + AnsiChar(Hi(height));

  width_concat := WIDTH_COMMAND + chr(width);
  hri_concat := HRI_COMMAND + chr(hri);
  If(codeBar.codeToPrint <= 6) then
    buffer := height_concat + width_concat + hri_concat + PRINT + text + #0
  else
    buffer := height_concat + width_concat + hri_concat + PRINT + char(Length(text)) + text;

  Result := buffer;

end;

end.

