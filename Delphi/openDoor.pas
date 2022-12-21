unit openDoor;

interface

uses
  Classes, SysUtils, synaser, blcksock, closeDoor, Vcl.Dialogs;


function openDoorFunction(port:String):TBlockSerial;Overload;
function openDoorFunction(host:String; port:String):TTCPBlockSocket; Overload;
function getNamesSerialPorts():string;

implementation

function openDoorfunction(port:String): TBlockSerial;
var
  sprinter: TBlockSerial;

begin
    sprinter := TBlockSerial.Create();
    sprinter.Config(38400, 8, 'N', 1, False, False);
    sprinter.Connect(port);
    //ShowMessage(port);
    If (not sprinter.CanWrite(2000)) then
    begin
       raise Exception.Create('Não foi possível acessar a impressora');
    end;

    Result:= sprinter;
end;

function openDoorFunction(host: String; port: String): TTCPBlockSocket;
var
  netprinter: TTCPBlockSocket;

begin
    netPrinter := TTCPBlockSocket.Create();
    netPrinter.Connect( host, port);
    If (not netPrinter.CanWrite(2000)) then
    begin
       raise Exception.Create('Não foi possível acessar a impressora');
    end;
    Result:= netPrinter;
end;

function getNamesSerialPorts(): string;
begin
    Result:=GetSerialPortNames;
end;

end.

