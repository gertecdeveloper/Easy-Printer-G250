unit returnStatus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Dialogs, Printers;

Const
  RETURN_STATUS_COMMAND = #16#4#1;
  RETURN_OFFLINE_COMMAND = #16#4#2;
  RETURN_PAPER_SENSOR_COMMAND = #16#4#4;
  RESTART = #27#64;

function returnStatus(printer : TBlockSerial; option:integer):string;
function returnStatus(printer : TTCPBlockSocket; option:integer):string;
function getStatus(response:string;option:integer):string;

implementation

//valores validos de opções:
// 1 - online ou offline status
// 2 - Gaveta aberta ou fechada
// 3 - Tampa aberta ou fechada
// 4 - Erro Alimentação do papel
// 5 - Erro parada do papel
// 6 - Ocorrência de erros
// 7 - Sensor de fim de papel
// 8 - Sensor de papel

function returnStatus(printer : TBlockSerial; option:integer): string;
var
  //printer : TBlockSerial;
  response: string;

begin
  //printer := openDoor.openDoor(port, baud);
  //printer.SendString(RESTART);
  if(not printer.CanWrite(1000)) then
    raise Exception.Create('Inacessible Printer');

  if((option = 1) or (option = 2)) then
    printer.SendString(RETURN_STATUS_COMMAND)
  else if((option >= 3) and (option <= 6)) then
    printer.SendString(RETURN_OFFLINE_COMMAND)
  else if((option = 7) or (option = 8)) then
    printer.SendString(RETURN_PAPER_SENSOR_COMMAND)
  else
    raise Exception.Create('Opção inválida');

  response := printer.RecvByte(2000).ToBinString;
  Result := getStatus(response, option);

end;

function returnStatus(printer : TTCPBlockSocket; option:integer): string;
var
  //printer : TTCPBlockSocket;
  response: string;

begin
  //printer := openDoor.openDoor(host, port);
  if(not printer.CanWrite(1000)) then
    raise Exception.Create('Inacessible Printer');

  if((option = 1) or (option = 2)) then
    printer.SendString(RETURN_STATUS_COMMAND)
  else if((option >= 3) and (option <= 6)) then
    printer.SendString(RETURN_OFFLINE_COMMAND)
  else if((option = 7) or (option = 8)) then
    printer.SendString(RETURN_PAPER_SENSOR_COMMAND)
  else
    raise Exception.Create('Opção inválida');

  response := printer.RecvByte(2000).ToBinString;
  Result := getStatus(response,option);
end;

function getStatus(response:string;option: integer): string;
begin
  
  CASE option OF
      1:
        begin
           if((response[5] = '0'))then
            Result := 'online'
          else
            Result := 'offline';
        end;
      2:
        begin
           if((response[6] = '0'))then
            Result := 'Drawer Kick-out connetor pin 3 is LOW'
          else
            Result := 'Drawer Kick-out connetor pin 3 is HIGH';
        end;
      3:
        begin
           if((response[6] = '0'))then
            Result := 'Cover is closed.'
          else
            Result := 'Cover is open.';
        end;
      4:
        begin
           if((response[5] = '0'))then
            Result := 'Paper is not fed by using the FEED button.'
          else
            Result := 'Paper is beging fed by the FEED button.';
        end;
      5:
        begin
           if((response[3] = '0'))then
            Result := 'No paper-end stop.'
          else
            Result := 'Printing is being stopped.';
        end;
      6:
        begin
           if((response[2] = '0'))then
            Result := 'No error.'
          else
            Result := 'Error occurs.';
        end;
      7:
        begin
           if((response[6] = '0') and (response[5] = '0'))then
            Result := 'Paper roll near-end sensor: paper adequate.'
          else
            Result := 'Paper near-end is detected by the paper roll near-end sensor.';
        end;
      8:
        begin
           if((response[3] = '0') and (response[2] = '0'))then
            Result := 'Paper roll sensor: paper present.'
          else
            Result := 'Paper roll end detected by paper roll senso.';
        end;
    else
      Result:='Opção inválida.';
  END
end;

end.

