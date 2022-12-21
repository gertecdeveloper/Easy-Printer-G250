unit printText;

interface

uses
  Classes, SysUtils, StrUtils, Types, synaser, blcksock, openDoor, CloseDoor,
  sendBinBuffer, printQRCODE, printCustomBarCode, Vcl.Dialogs;

const
  //comandos
  TRIG_GUILL = #29#86#65#0; // Corta Papel
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
  FONT_DEFAULT = #27#33#0; //Fonte Normal
  LF =  #10;             //Line feed
  HT =  #09;             //Tab Horizontal
  FONT_INVERT_ON =   #29#66#1; // habilita a Inversão de preto e branco
  FONT_INVERT_OFF =       #29#66#0;// desabilita a Inversão de preto e branco

procedure printTextFunction(text:String; printer : TBlockSerial)Overload;
procedure printTextFunction(text:String; printer : TTCPBlockSocket)Overload;
function formatText(text:String):String;
procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;

implementation

procedure printTextFunction(text: String; printer : TBlockSerial);
begin
  sendBinBuffer.sendBinBufferFunction(TEncoding.GetEncoding(65001).ASCII.GetBytes(formatText(text)),printer);
  //printer.SendString(formatText(text));
end;

procedure printTextFunction(text: String; printer : TTCPBlockSocket);
begin
  sendBinBuffer.sendBinBufferFunction(TEncoding.GetEncoding(65001).ASCII.GetBytes(formatText(text)),printer);

end;

function formatText(text: String): String;
var
  splitted: TStringDynArray;
  splitQR: TStringDynArray;
  splitCBAR: TStringDynArray;
  newText : String;
  finalText : string;
  i : integer;
begin
  newText := text;
  newText := StringReplace(newText, '<ne>', TEXT_BOLD_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ne>', TEXT_BOLD_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</lf>', LF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ht>', HT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<fi>', FONT_INVERT_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</fi>', FONT_INVERT_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ce>', TEXT_CENTER, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ce>', TEXT_LEFT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ad>', TEXT_RIGHT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ad>', TEXT_LEFT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<su>', TEXT_UNDERLINED_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</su>', TEXT_UNDERLINED_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<ex>', FONT_EXPANDED_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</ex>', FONT_EXPANDED_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<c>', FONT_SMALL_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</c>', FONT_SMALL_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<p>', FONT_DEFAULT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<da>', FONT_DOUBLE_HEIGHT_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</da>', FONT_DOUBLE_HEIGHT_OFF, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<dl>', FONT_DOUBLE_WIDTH_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</dl>', FONT_DOUBLE_WIDTH_Off, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<dal>', FONT_DOUBLE_HW_ON, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</dal>', FONT_DEFAULT, [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</gui>', TRIG_GUILL, [rfReplaceAll, rfIgnoreCase]);
  //processando qrcode e codigo de barras
  newText := StringReplace(newText, '<qr>', '@<qr>', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</qr>', '</qr>@', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '<cbar>', '@<cbar>', [rfReplaceAll, rfIgnoreCase]);
  newText := StringReplace(newText, '</cbar>', '</cbar>@', [rfReplaceAll, rfIgnoreCase]);
  Splitted := SplitString(newText, '@');

  for i:= 0 to Length(splitted)-1 do
  begin
   if pos('<qr>',splitted[i]) <> 0 then
     begin
     splitted[i] := StringReplace(splitted[i], '<qr>', '', [rfReplaceAll, rfIgnoreCase]);
     splitted[i] := StringReplace(splitted[i], '</qr>', '', [rfReplaceAll, rfIgnoreCase]);
     splitQR := SplitString(splitted[i], ',');
     if Length(splitQR) <> 3 then
       raise Exception.Create('Quantidades de Parâmetros do QRCode é inválida');
     finalText := finalText + printQRCODEFactory(StrToInt(splitQr[0]),StrToInt(splitQr[1]), splitQR[2]);

     end
   else
   if pos('<cbar>',splitted[i]) <> 0 then
     begin
     splitted[i] := StringReplace(splitted[i], '<cbar>', '', [rfReplaceAll, rfIgnoreCase]);
     splitted[i] := StringReplace(splitted[i], '</cbar>', '', [rfReplaceAll, rfIgnoreCase]);
     splitCBAR := SplitString(splitted[i], ',');
     if Length(splitCBAR) <> 5 then
       raise Exception.Create('Quantidades de Parâmetros do QRCode é inválida');
     finalText := finalText + printCodeBarFactory(StrToInt(splitCBAR[2]),StrToInt(splitCBAR[1]),
               StrToInt(splitCBAR[3]), splitCBAR[0], splitCBAR[4]);
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
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.DelimitedText   := Str;
end;

end.

