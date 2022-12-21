unit printText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, synaser, blcksock, openDoor, CloseDoor, Printers, Dialogs, sendBinBuffer,
  printQRCODE, printCustomBarCode;

type
  Latin1String = type AnsiString(28591);

const
  //comandos
  TRIG_GUILL = #29#86#65#00; // Corta Papel
  TEXT_BOLD_ON = #27#69#1;   // habilita Texto em Negrito
  TEXT_BOLD_OFF = #27#69#0;  // desabilita Texto em Negrito
  TEXT_CENTER =      #27#97#1; //Centraliza o texto
  TEXT_RIGHT =    #27#97#2; //Alinha o texto a direita
  TEXT_LEFT =     #27#97#0;  //Alinhado a esquerda
  TEXT_UNDERLINED_ON =    #27#45#1; //Habilita Texto sublinhado
  TEXT_UNDERLINED_OFF =   #27#45#0; //Desabilita texto sublinhado
  FONT_EXPANDED_ON =      #27#32#16; //Habilita texto expandido   27 32 16
  FONT_EXPANDED_OFF =      #27#32#0; //Desabilita texto expandido  27 32 0
  FONT_SMALL_ON =  #27#77#1;
  FONT_SMALL_OFF =  #27#77#0;
  FONT_DOUBLE_HEIGHT_ON =  #27#33#16; //#27'd'#1; //Habilita texto de altura dupla
  FONT_DOUBLE_HEIGHT_OFF = #27#33#17;  //#27'd'#0; //Desabilita texto de altura dupla
  FONT_DOUBLE_WIDTH_ON =      #27#33#32;  //Habilitado texto em largura dupla
  FONT_DOUBLE_WIDTH_OFF =  #27#33#33; //desabilitado texto em largura dupla
  FONT_DOUBLE_HW_ON = #27#33#48; //altura_e_largura_dupla
  FONT_DEFAULT = #27#33#0; //altura_e_largura_dupla
  LF =  #10;             //Line feed
  HT =  #09;             //Tab Horizontal
  FONT_INVERT_ON =   #29#66#1; // habilita a Inversão de preto e branco
  FONT_INVERT_OFF =       #29#66#0;// desabilita a Inversão de preto e branco

procedure printText(text:string; printer : TBlockSerial);
procedure printText(text:string; printer : TPrinter);
procedure printText(text:string; printer : TTCPBlockSocket);
function formatText(text:string):string;
procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;

implementation

procedure printText(text: string; printer : TBlockSerial);
begin
   //formatText(text);
  sendBinBuffer.sendBinBuffer(TEncoding.GetEncoding(65001).ASCII.GetBytes(formatText(text)),printer);
  //sendBinBuffer.sendBinBuffer(formatText(text),printer);
end;

procedure printText(text: string; printer:TPrinter);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.GetEncoding(65001).ASCII.GetBytes(formatText(text)), printer);
end;

procedure printText(text: string; printer : TTCPBlockSocket);
begin
  sendBinBuffer.sendBinBuffer(TEncoding.GetEncoding(65001).ASCII.GetBytes(formatText(text)),printer);
end;

function formatText(text: string): string;
var
  splitted: TStringList;
  splitQR: TStringList;
  splitCBAR: TStringList;
  newText : string;
  finalText : string;
  i : integer;
begin
  splitted := TStringList.Create;
  splitQR := TStringList.Create;
  splitCBAR := TStringList.Create;
  finalText := '';
  newText := text;
  newText := StringReplace(newText, '</gui>', TRIG_GUILL, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ne>', TEXT_BOLD_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ne>', TEXT_BOLD_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</lf>', LF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ht>', HT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<fi>', FONT_INVERT_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</fi>', FONT_INVERT_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText,'<ce>', TEXT_CENTER, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText,'</ce>', TEXT_LEFT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ad>', TEXT_RIGHT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ad>', TEXT_LEFT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<su>', TEXT_UNDERLINED_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</su>', TEXT_UNDERLINED_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ex>', FONT_EXPANDED_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ex>', FONT_EXPANDED_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<c>', FONT_SMALL_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</c>', FONT_SMALL_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<p>',FONT_DEFAULT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<da>', FONT_DOUBLE_HEIGHT_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</da>', FONT_DOUBLE_HEIGHT_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<dl>', FONT_DOUBLE_WIDTH_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</dl>', FONT_DOUBLE_WIDTH_Off, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<dal>', FONT_DOUBLE_HW_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</dal>', FONT_DEFAULT, [rfReplaceAll, rfIgnoreCase]);
  //processa a tag de qrcode codigo de barras
  newText := StringReplace(newText, '<qr>', '@<qr>', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</qr>', '</qr>@', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<cbar>', '@<cbar>', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</cbar>', '</cbar>@', [rfReplaceAll, rfIgnoreCase]);
  Split('@', newText, Splitted);

  for i:= 0 to splitted.Count-1 do
  begin
   if pos('<qr>',splitted[i]) <> 0 then
     begin
     splitted[i] := StringReplace(splitted[i], '<qr>', '', [rfReplaceAll, rfIgnoreCase]);
     splitted[i] := StringReplace(splitted[i], '</qr>', '', [rfReplaceAll, rfIgnoreCase]);
     Split(',', splitted[i], splitQR);
     if splitQR.count <> 3 then
       raise Exception.Create('Quantidades de Parâmetros do QRCode é inválida');
     finalText := finalText + printQRCODEFactory(StrToInt(splitQr[0]),StrToInt(splitQr[1]), splitQR[2]);
     //ShowMessage('Usando o pos - '+splitted[i]);
     end
   else
   if pos('<cbar>',splitted[i]) <> 0 then
     begin
     splitted[i] := StringReplace(splitted[i], '<cbar>', '', [rfReplaceAll, rfIgnoreCase]);
     splitted[i] := StringReplace(splitted[i], '</cbar>', '', [rfReplaceAll, rfIgnoreCase]);
     Split(',', splitted[i], splitCBAR);
     if splitCBAR.count <> 5 then
       raise Exception.Create('Quantidades de Parâmetros do QRCode é inválida');
     finalText := finalText + printCodeBarFactory(StrToInt(splitCBAR[2]),StrToInt(splitCBAR[1]),
               StrToInt(splitCBAR[3]), splitCBAR[0], splitCBAR[4]);
     //ShowMessage('Usando o pos - '+splitted[i]);
     end
   else
   begin
     finalText := finalText + splitted[i];
   end;
  end;
  //ShowMessage(finalText);
  Result := finalText;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;
 {
function AnsiToAscii(str : string) : string;
var
  i : Integer;
begin
  for i := 1 to length(str) do
  case str[i] of
  ´á´ : str[i] := ´a´;
  ´é´ : str[i] := ´e´;
  ´í´ : str[i] := ´i´;
  ´ó´ : str[i] := ´o´;
  ´ú´ : str[i] := ´u´;
  ´à´ : str[i] := ´a´;
  ´è´ : str[i] := ´e´;
  ´ì´ : str[i] := ´i´;
  ´ò´ : str[i] := ´o´;
  ´ù´ : str[i] := ´u´;
  ´â´ : str[i] := ´a´;
  ´ê´ : str[i] := ´e´;
  ´î´ : str[i] := ´i´;
  ´ô´ : str[i] := ´o´;
  ´û´ : str[i] := ´u´;
  ´ä´ : str[i] := ´a´;
  ´ë´ : str[i] := ´e´;
  ´ï´ : str[i] := ´i´;
  ´ö´ : str[i] := ´o´;
  ´ü´ : str[i] := ´u´;
  ´ã´ : str[i] := ´a´;
  ´õ´ : str[i] := ´o´;
  ´ñ´ : str[i] := ´n´;
  ´ç´ : str[i] := ´c´;
  ´Á´ : str[i] := ´A´;
  ´É´ : str[i] := ´E´;
  ´Í´ : str[i] := ´I´;
  ´Ó´ : str[i] := ´O´;
  ´Ú´ : str[i] := ´U´;
  ´À´ : str[i] := ´A´;
  ´È´ : str[i] := ´E´;
  ´Ì´ : str[i] := ´I´;
  ´Ò´ : str[i] := ´O´;
  ´Ù´ : str[i] := ´U´;
  ´Â´ : str[i] := ´A´;
  ´Ê´ : str[i] := ´E´;
  ´Î´ : str[i] := ´I´;
  ´Ô´ : str[i] := ´O´;
  ´Û´ : str[i] := ´U´;
  ´Ä´ : str[i] := ´A´;
  ´Ë´ : str[i] := ´E´;
  ´Ï´ : str[i] := ´I´;
  ´Ö´ : str[i] := ´O´;
  ´Ü´ : str[i] := ´U´;
  ´Ã´ : str[i] := ´A´;
  ´Õ´ : str[i] := ´O´;
  ´Ñ´ : str[i] := ´N´;
  ´Ç´ : str[i] := ´C´;
  ´º´ : str[i] := ´.´;
  end;
  Result := Str;
end;   }

end.

