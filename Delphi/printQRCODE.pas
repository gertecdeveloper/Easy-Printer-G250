unit printQRCODE;

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, SendBinBuffer;

type
  Latin1String = type AnsiString(28591);

const
  F165 = #29#40#107#4#0#49#65#50#0;
  F167 = #29#40#107#3#0#49#67; //adicionar o valor de size
  F169 = #29#40#107#3#0#49#69; //adicionar o corretionLevel
  F180 = #29#40#107; //completar ainda
  F181 = #29#40#107#3#0#49#81#48;
  F182 = #29#40#107#3#0#49#82#48;


procedure printQRCODEFunction(size:integer; corretionLevel:integer; text: string; printer : TBlockSerial) overload;
procedure printQRCODEFunction(text: string;printer : TBlockSerial)overload;

procedure printQRCODEFunction(size:integer; corretionLevel:integer; text: string; printer : TTCPBlockSocket)overload;
procedure printQRCODEFunction(text: string;printer : TTCPBlockSocket)overload;

function printQRCODEFactory(size:integer; corretionLevel:integer; text: string):string;

implementation

procedure printQRCODEFunction(size: integer; corretionLevel: integer;
  text: string; printer : TBlockSerial);
begin
  sendBinBufferFunction(TEncoding.GetEncoding(860).ASCII.GetBytes(printQRCODEFactory(size, corretionLevel, text)), printer);
end;

procedure printQRCODEFunction(text: string; printer : TBlockSerial);
begin
  printQRCODEFunction(5, 48, text, printer);
end;


procedure printQRCODEFunction(size: integer; corretionLevel: integer; text: string; printer : TTCPBlockSocket);
begin
  sendBinBufferFunction(TEncoding.GetEncoding(860).ASCII.GetBytes(printQRCODEFactory(size, corretionLevel, text)),printer);
end;

procedure printQRCODEFunction(text: string; printer : TTCPBlockSocket);
begin
    printQRCODEFunction(5, 48, text, printer);
end;

function printQRCODEFactory(size: integer; corretionLevel: integer;
  text: string): string;
var
  utf8: UTF8String;
  latin1: Latin1String;
  textSize : integer;
  pL : integer;
  pH : integer;
  F180v : string;
begin
  utf8 := text;
  latin1 := Latin1String(utf8);

  //size tem que ser de 1 a 16
  if((size<1) or (size>16)) then
    raise Exception.Create('Valor de tamanho inválido. O tamanho do QRCode deve estar entre 1 e 16');

  //corretionLevel vai de 48 a 51
  if((corretionLevel<48) or (corretionLevel>51)) then
    raise Exception.Create('Valor de corretionLevel inválido. Os valores de correção são 48(7%), 49(15%), 50(25%), 51(30%)');

  textSize := Length(latin1)+ 3;
  pL := (textSize)mod(256);
  pH := (textSize)div(256);
  F180v := F180 + chr(pL) + chr(pH) + #49#80#48;
  //ShowMessage(F180v);
  Result := F165 + F167 + chr(size) + F169 +chr(corretionLevel) + F180v + latin1 + F181 + F182;
end;

end.

