unit iniConfig;

interface

uses
  Classes, SysUtils, System.IniFiles, Vcl.Dialogs;

type
  TStringArray = array of string;

function iniConfigFunction(serialPort:string): Boolean overload;
function iniConfigFunction(server, port:string): Boolean overload;
function getConfig() : TStringArray;

implementation

function iniConfigFunction(serialPort:string): Boolean;
var
  ArquivoINI : TIniFile;
  return : boolean;
begin
  return := false;
  ArquivoINI := TIniFile.Create('.\GertecEasyPrinter.INI');
  try
    ArquivoINI.WriteString('Serial', 'Port', serialPort);
    return := true;
  finally
    ArquivoINI.Free;
    Result := return;
  end;
end;

function iniConfigFunction(server, port: string): Boolean;
var
  ArquivoINI : TIniFile;
  return : boolean;
begin
  return := false;
  ArquivoINI := TIniFile.Create('.\GertecEasyPrinter.INI');
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
  ArquivoINI := TIniFile.Create('.\GertecEasyPrinter.INI');
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

