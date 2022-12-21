program gertecLazarus;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, Main, openDoor, printText, closeDoor, trigGuill,
  returnStatus, printCustomBarCode, printQRCODE, statusDrawer,
  returnSerialNumber, printCODE128, printCODE39, printCODE93, printEAN13,
  printEAN8, printITF, printUPCA, printUPCE, openDrawer, sendBinBuffer,
  printBITMAP, returnModel, returnFirmware, iniConfig, printCouponNFCe
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

