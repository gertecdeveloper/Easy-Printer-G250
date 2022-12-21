unit iniConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

type
  TStringArray = array of string;

function iniConfig(serialPort:string): Boolean;
function iniConfig(server, port:string): Boolean;
function getConfig() : TStringArray;

implementation

function iniConfig(serialPort:string): Boolean;
var
  ArquivoINI : TIniFile;
  return : boolean;
begin
  return := false;
  ArquivoINI := TIniFile.Create(ChangeFileExt(ExtractFileName('GertecEasyPrinter'),'.INI'));
  try
    ArquivoINI.WriteString('Serial', 'Port', serialPort);
    return := true;
  finally
    ArquivoINI.Free;
    Result := return;
  end;
end;

function iniConfig(server, port: string): Boolean;
var
  ArquivoINI : TIniFile;
  return : boolean;
begin
  return := false;
  ArquivoINI := TIniFile.Create(ChangeFileExt(ExtractFileName('GertecEasyPrinter'),'.INI'));
  try
    ArquivoINI.WriteString('Network', 'Server', server);
    ArquivoINI.WriteString('Network', 'Port', port);
    return := true;
  finally
    ArquivoINI.Free;
    Result := return;
  end;
end;

function getConfig(): TStringArray;
var
  ArquivoINI : TIniFile;
  serialPort, server, serverPort : string;
begin
  SetLength(Result, 3);
  ArquivoINI := TIniFile.Create(ChangeFileExt(ExtractFileName('GertecEasyPrinter'),'.INI'));
  try
    serialPort := ArquivoINI.ReadString('Serial','Port', '');
    server := ArquivoINI.ReadString('Network','Server', '');
    serverPort := ArquivoINI.ReadString('Network','Port', '');
    if((serialPort = '') and (server = '') and (serverPort = '')) then
       raise Exception.Create('Arquivo inexistente ou nenhuma configuração salva!');

    Result[0] := serialPort;
    Result[1] := server;
    Result[2] := serverPort;
  finally
    ArquivoINI.Free;
    //Result := arrConfig;
  end;
end;

end.

