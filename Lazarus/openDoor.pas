unit openDoor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, closeDoor, Dialogs, Printers;


function openDoor(port:String;baud:integer):TBlockSerial;
function openDoor(printerName:string):TPrinter;
function openDoor(host:String; port:String):TTCPBlockSocket;
function getNamesSerialPorts():string;

implementation

function openDoor(port:String; baud:integer): TBlockSerial;
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

function openDoor(printerName:string): TPrinter;
var
  written:integer;
  usbPrinter:TPrinter;
begin
    usbPrinter:=Printer.create;
    usbPrinter.SetPrinter(printerName);
    usbPrinter.RawMode:=True;
    if (not usbPrinter.CanPrint) then
      raise Exception.Create('Não foi possível encontrar a impressora selecionada');

    usbPrinter.BeginDoc;
    Result:=usbPrinter
end;

function openDoor(host: String; port: String): TTCPBlockSocket;
var
  netprinter: TTCPBlockSocket;

begin
    netPrinter := TTCPBlockSocket.Create();
    netPrinter.Connect( host, port);
    If (not netPrinter.CanWrite(2000)) then
    begin
       closeDoor.closeDoor(netPrinter);
       raise Exception.Create('Não foi possível acessar a impressora');
    end;
    Result:= netPrinter;
end;

function getNamesSerialPorts(): string;
begin
    Result:=GetSerialPortNames;
end;

end.

