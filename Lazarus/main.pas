unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, openDoor, closeDoor, synaser, blcksock,
  Printtext, TrigGuill, returnStatus, printCustomBarCode, printQRCODE, printBitmap,
  statusDrawer, printCODE128, printCODE39, printCODE93, printEAN13, returnSerialNumber, returnModel, returnFirmware,
  printEAN8, printITF, printUPCA,printUPCE, openDrawer, sendBinBuffer, Printers, laz2_DOM, laz2_XMLRead,
  iniConfig, DOM, XMLRead, printCouponNFCe, printCouponSAT;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCutPaper: TButton;
    btnGetStatus: TButton;
    btnOpenDrawer: TButton;
    btnPrintText: TButton;
    btnPrintQRCode: TButton;
    btnPrintCodeBar: TButton;
    btnSendBinBuffer: TButton;
    btnStatusDrawer: TButton;
    Button1: TButton;
    btnPrinterInformation: TButton;
    btnSaveConfig: TButton;
    btnLoadConfig: TButton;
    btnPrintBitmap: TButton;
    btnPrintXML: TButton;
    Button2: TButton;
    cbCorrectionLevel: TComboBox;
    cbCodeBarType: TComboBox;
    cbCodeBarHRI: TComboBox;
    cbUSBPrinters: TComboBox;
    edtStatusOption: TEdit;
    edtCouponType: TEdit;
    edtXMLPath: TEdit;
    edtBitMapPath: TEdit;
    edtDrawerStatus: TEdit;
    edtPrinterStatus: TEdit;
    edtCodeBarWidth: TEdit;
    edtSerialNumber: TEdit;
    edtPrinterFirmware: TEdit;
    edtPrinterModel: TEdit;
    edtSerialBaud: TEdit;
    edtSerialPortName: TEdit;
    edtIPPrinter: TEdit;
    edtPortPrinter: TEdit;
    edtCodeBarHeight: TEdit;
    edtCodeBarText: TEdit;
    edtQRCodeSize: TEdit;
    edtQRCodeText: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mmoResultado: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    rbUSBConnection: TRadioButton;
    rbNetWorkConnection: TRadioButton;
    rbSerialConnection: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure btnCutPaperClick(Sender: TObject);
    procedure btnGetStatusClick(Sender: TObject);
    procedure btnLoadConfigClick(Sender: TObject);
    procedure btnOpenDrawerClick(Sender: TObject);
    procedure btnPrint(Sender: TObject);
    procedure btnPrintBitmapClick(Sender: TObject);
    procedure btnPrinterInformationClick(Sender: TObject);
    procedure btnPrintQRCodeClick(Sender: TObject);
    procedure btnPrintXMLClick(Sender: TObject);
    procedure btnReturnSerialNumberClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnSendBinBufferClick(Sender: TObject);
    procedure btnStatusDrawerClick(Sender: TObject);
    procedure btnPrintCodeBarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function findNodeXML(noNome: string; xmlNode:TDOMNode):TDOMNode;

    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
//Foi necessário adicionar o Printer4Lazarus ao projeto para usar a Unit Printer
//link https://wiki.freepascal.org/Using_the_printer
procedure TForm1.FormCreate(Sender: TObject);
var
  I:integer;
begin
  If(Length(openDoor.getNamesSerialPorts())>0)Then
    //lblSerialPortNames.Caption:= openDoor.getNamesSerialPorts()
  else
      begin
        cbUSBPrinters.Clear;
        cbUSBPrinters.Items.Assign(Printer.Printers);
         //lblSerialPortNames.Caption:= IntToStr(Printer.Printers.Count);

        {for I := 0 to g250Printer.Printers.Count - 1 do
         begin
           if Pos('\\',g250Printer.Printers.Strings[I]) <> 0 then
             ComboBox1.Items.Add(g250Printer.Printers.Strings[I])
           else
             ComboBox1.Items.Add(g250Printer.Printers.Strings[I]);
         end; }

      end;
   edtSerialBaud.Text := IntToStr(9600);
   mmoResultado.Clear;
   mmoResultado.Lines.Add('Testando impressão com tags: </lf><ne>Texto Negrito</ne> & '
   +'<su> texto sublinhado </su> além disso podemos </lf><ne><ce> centralizar o texto em negrito'
   +'</ce></ne></lf>e <c> diminuir a font </c> entre outras tags.</lf>'
   +'<dl>largura Dupla</dl><dal>Altura e largura Dupla</dal>'
                    + '<fi>Fonte invertida</fi>'
                    + 'Teste de </ht> tab horizontal</lf>'+ 'teste de código de barras</lf>'
                    + '<ce><cbar>code128,2,100,1,234565567</cbar></ce></lf>'
                    + 'teste de QRCode</lf>'
                    + '<ce><qr>6,48,texto simples de qrCode via tag</qr></ce></lf>');
   //define os níveis de correção do QRCode
   cbCorrectionLevel.Clear;
   cbCorrectionLevel.Items.Add('L - 7%');
   cbCorrectionLevel.Items.Add('M - 15%');
   cbCorrectionLevel.Items.Add('Q - 25%');
   cbCorrectionLevel.Items.Add('H - 30%');

   //Define as opções de código de barras
   cbCodeBarType.clear;
   cbCodeBarType.Items.add('UPCA');
   cbCodeBarType.Items.add('UPCE');
   cbCodeBarType.Items.add('EAN8');
   cbCodeBarType.Items.add('EAN13');
   cbCodeBarType.Items.add('ITF');
   cbCodeBarType.Items.add('CODE39');
   cbCodeBarType.Items.add('CODE93');
   cbCodeBarType.Items.add('CODE128');

   //Define os valores possíveis para o HRI do código de barras
   cbCodeBarHRI.clear;
   cbCodeBarHRI.Items.add('Nenhum');
   cbCodeBarHRI.Items.add('Em cima');
   cbCodeBarHRI.Items.add('Embaixo');
   cbCodeBarHRI.Items.add('Ambos');

end;

procedure TForm1.btnPrint(Sender: TObject);
var
  mmoText: WideString;
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
  //networkPrinter : TTC
begin
  mmoText := mmoResultado.Text;
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         Printtext.printText(mmoText, networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printText.printText(mmoText, serialPrinter);  //impressão via porta serial
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
        printText.printText(mmoText,usbPrinter);
        closeDoor.closeDoor(usbPrinter);
   end;

end;

procedure TForm1.btnPrintBitmapClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  path : string;
begin
  //path := 'C:\Users\adels\Pictures\personagem0.jpg';
  path := edtBitMapPath.Text;
  //'C:\Users\adels\Pictures\personagem0.jpg'
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         printBITMAP.printBITMAP(path, networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printBITMAP.printBITMAP(path, serialPrinter);
         closeDoor.closeDoor(serialPrinter);
   end;

end;

procedure TForm1.btnPrinterInformationClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         edtSerialNumber.Text := returnSerialNumber.returnSerialNumber(networkPrinter);
         edtPrinterModel.Text := returnModel.returnModel(networkPrinter);
         edtPrinterFirmware.Text := returnFirmware.returnFirmware(networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         edtSerialNumber.Text := returnSerialNumber.returnSerialNumber(serialPrinter);
         edtPrinterModel.Text := returnModel.returnModel(serialPrinter);
         edtPrinterFirmware.Text := returnFirmware.returnFirmware(serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        //usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
   end;
end;

procedure TForm1.btnPrintQRCodeClick(Sender: TObject);
var
  corretionLevel:integer;
  size:integer;
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
   case cbCorrectionLevel.ItemIndex of
    0: corretionLevel:=48;
    1: corretionLevel:=49;
    2: corretionLevel:=50;
    3: corretionLevel:=51;
   end;
   size:=StrToInt(edtQRCodeSize.Text);
   If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         printQRCODE.printQRCODE(size, corretionLevel, edtQRCodeText.Text, networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printQRCODE.printQRCODE(size, corretionLevel, edtQRCodeText.Text, serialPrinter);  //impressão via porta serial
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
        printQRCODE.printQRCODE(size, corretionLevel, edtQRCodeText.Text, usbPrinter);
        closeDoor.closeDoor(usbPrinter);
   end;
end;

procedure TForm1.btnPrintXMLClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  //edtXMLPath.Text:= 'C:\Users\adels\Documents\procNFCe_edt.xml';
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         printCouponNFCe.printCouponNFCe(edtXMLPath.Text, StrToInt(edtCouponType.Text), networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printCouponNFCe.printCouponNFCe(edtXMLPath.Text, StrToInt(edtCouponType.Text), serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        //usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
   end;

end;

procedure TForm1.btnReturnSerialNumberClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         returnSerialNumber.returnSerialNumber(networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         returnSerialNumber.returnSerialNumber(serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        //usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
   end;
end;

procedure TForm1.btnSaveConfigClick(Sender: TObject);
begin
  iniConfig.iniConfig(edtSerialPortName.Text);
  iniConfig.iniConfig(edtIPPrinter.Text, edtPortPrinter.Text);
end;

procedure TForm1.btnSendBinBufferClick(Sender: TObject);
var
  textToPrint : string;
  atext: packed array of byte;
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  textToPrint:=#10+'teste de impressão'+#10#10#10;
  setLength(atext, length(textToPrint));
  Move(textToPrint[1], atext[0], Length(textToPrint));
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         sendBinBuffer.sendBinBuffer(atext,networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         sendBinBuffer.sendBinBuffer(atext,serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
        sendBinBuffer.sendBinBuffer(atext, usbPrinter);
        closeDoor.closeDoor(usbPrinter);
   end;

end;

procedure TForm1.btnStatusDrawerClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
begin
  If (rbNetWorkConnection.Checked) then
   begin
     networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
     edtDrawerStatus.Text := statusDrawer.statusDrawer(networkPrinter);
     closeDoor.closeDoor(networkPrinter);
   end
  else if (rbSerialConnection.Checked) then
   begin
     serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
     edtDrawerStatus.Text := statusDrawer.statusDrawer(serialPrinter);
     closeDoor.closeDoor(serialPrinter);
   end
  else if (rbUSBConnection.Checked) then
   begin
     //ShowMessage(cbUSBPrinters.Text);
   end;

end;

procedure TForm1.btnPrintCodeBarClick(Sender: TObject);
var
  codeBarType:string;
  codeBarWidth:integer;
  codeBarHeight:integer;
  codeBarHRI:integer;
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
   case cbCodeBarType.ItemIndex of
    0: codeBarType:='UPCA';
    1: codeBarType:='UPCE';
    2: codeBarType:='EAN8';
    3: codeBarType:='EAN13';
    4: codeBarType:='ITF';
    5: codeBarType:='CODE39';
    6: codeBarType:='CODE93';
    7: codeBarType:='CODE128';
   end;

   case cbCodeBarHRI.ItemIndex of
    0: codeBarHRI:=0;
    1: codeBarHRI:=1;
    2: codeBarHRI:=2;
    3: codeBarHRI:=3;
   end;

   codeBarHeight:=StrToInt(edtCodeBarHeight.text);
   codeBarWidth:= StrToInt(edtCodeBarWidth.Text);
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         printCustomBarCode.printCustomBarCode(codeBarHeight, codeBarWidth, codeBarHRI, codeBarType,edtCodeBarText.Text,networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printCustomBarCode.printCustomBarCode(codeBarHeight, codeBarWidth, codeBarHRI, codeBarType,edtCodeBarText.Text,serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
        printCustomBarCode.printCustomBarCode(codeBarHeight, codeBarWidth, codeBarHRI, codeBarType,edtCodeBarText.Text, usbPrinter);
        closeDoor.closeDoor(usbPrinter);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  usbPrinter:TPrinter;
  serialPrinter : TBlockSerial;
  print:TextFile;
  g250:TPrinter;
  PassNode: TDOMNode;
  //Doc: IXMLDocument;
  x : integer;
  texto : string;
  Result: String;
  doc: TXMLDocument;

  Child: TDOMNode;
  j: Integer;

  FXML: DOMString;

begin
  texto := 'Nada encontrado';
  try
    //printBITMAP.printBITMAP('C:\Users\adels\Pictures\personagem0.jpg');
    ReadXMLFile(doc, 'C:\Users\adels\Documents\procNFCe.xml');

    //texto := IntToStr(doc.DocumentElement.ChildNodes.Length);
    //ShowMessage(texto);
    Child := findNodeXML('vFrete',doc.DocumentElement);
    If Child <> nil then
       texto := 'No '+Child.NodeName + ' - '+Child.ChildNodes[0].NodeValue;
    ShowMessage(texto);
    //Testando de: https://pt.stackoverflow.com/questions/322631/txmldocument-carregar-a-partir-de-uma-string

    //printBITMAP.printBITMAP('C:/Users/Adels/Pictures/biscoito da sorte.png');
    //serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
    //serialPrinter.SendBlock(TEncoding.UTF8.GetString(TEncoding.UTF8.GetBytes('Teste de envio com bloco para impressão')) );
    //sendBinBuffer.sendBinBuffer('teste de impressao', serialPrinter);
    //closeDoor.closeDoor(serialPrinter);
    // Read in xml file from disk
    //ReadXMLFile(Doc, 'C:\Users\adels\Documents\procNFCe.xml');
    // Retrieve the "password" node
    //PassNode := Doc.DocumentElement.FindNode('xNome');

    // Write out value of the selected node
    //showMessage(PassNode.NodeValue);
    //WriteLn(PassNode.NodeValue); // will be blank
    // The text of the node is actually a separate child node
    //WriteLn(PassNode.FirstChild.NodeValue); // correctly prints "abc"
    // alternatively
    //WriteLn(PassNode.TextContent);
  finally
    // finally, free the document
    //Doc.Free;
  end;
  //g250:= Printer;
  //impressao direta via porta com
  {Assignfile (print, 'COM3'); //  = PORTA DE COMUNICACAO
  ShowMessage('Testando impressao direta');
  rewrite(print);
  writeLn(print, #10+'teste de impressão'+#10#10#10);
  closefile(print);  //fecha o arquivo }
  //sendBinBuffer.sendBinBuffer(TEncoding.ASCII.GetAnsiBytes(mmoResultado.Text), g250);
  //Printtext.printText(mmoResultado.Text, g250);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  //edtXMLPath.Text:= 'C:\Users\adels\Documents\XMLSATRetorno.xml';
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         printCouponSAT.printCouponSAT(edtXMLPath.Text, StrToInt(edtCouponType.Text), networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         printCouponSAT.printCouponSAT(edtXMLPath.Text, StrToInt(edtCouponType.Text), serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        //usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
   end;

end;

function TForm1.findNodeXML(noNome: string; xmlNode:TDOMNode): TDOMNode;
var
  I: integer;
  retorno: TDOMNode;
begin
  retorno := nil;
  i := 0;
  // considera apenas nós elementos
  if XmlNode.NodeType <> ELEMENT_NODE then
    Exit;

  if (XmlNode.ChildNodes.Count <= 1) and (XmlNode.ChildNodes[0].NodeValue <> '') then
   begin
   if (XmlNode.CompareName(noNome) = 0)  then
    begin
         showMessage('Achou - '+XmlNode.NodeName);
         Result := XmlNode;
         Exit;
    end;
   end
  else
    begin
    i := 0;
    if xmlNode.HasChildNodes then
     while (i <= xmlNode.ChildNodes.Count - 1) and (retorno = nil) do
     begin
          //ShowMessage('No - '+xmlNode.NodeName +' - possui '
          //+IntToStr(xmlNode.ChildNodes.Count)+' filhos -> Carregando o filho '+ IntToStr(i)+' - '+
          //xmlNode.ChildNodes[i].NodeName);
        retorno := FindNodeXML(noNome, xmlNode.ChildNodes[i]);
        i := i + 1;
     end;

    end;
  Result := retorno;
end;

procedure TForm1.btnGetStatusClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         edtPrinterStatus.Text:= returnStatus.returnStatus(networkPrinter, StrToInt(edtStatusOption.Text));
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         edtPrinterStatus.Text:= returnStatus.returnStatus(serialPrinter, StrToInt(edtStatusOption.Text));
         closeDoor.closeDoor(serialPrinter);
    end;
end;

procedure TForm1.btnLoadConfigClick(Sender: TObject);
var
  arrConfig : array of string;
begin
  arrConfig := getConfig();
  edtSerialPortName.Text:=arrConfig[0];
  edtIPPrinter.Text:=arrConfig[1];
  edtPortPrinter.Text:=arrConfig[2];
end;

procedure TForm1.btnOpenDrawerClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
begin
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         openDrawer.openDrawer(networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         openDrawer.openDrawer(serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end;
end;


procedure TForm1.btnCutPaperClick(Sender: TObject);
var
  serialPrinter : TBlockSerial;
  networkPrinter : TTCPBlockSocket;
  usbPrinter : TPrinter;
begin
  If (rbNetWorkConnection.Checked) then
    begin
         networkPrinter := openDoor.openDoor(edtIPPrinter.Text,edtPortPrinter.Text);
         TrigGuill.trigGuill(networkPrinter);
         closeDoor.closeDoor(networkPrinter);
    end
  else if (rbSerialConnection.Checked) then
    begin
         serialPrinter := openDoor.openDoor(edtSerialPortName.Text, StrToInt(edtSerialBaud.Text));
         TrigGuill.trigGuill(serialPrinter);
         closeDoor.closeDoor(serialPrinter);
    end
  else if (rbUSBConnection.Checked) then
   begin
        usbPrinter := openDoor.openDoor(cbUSBPrinters.Text);
        TrigGuill.trigGuill(usbPrinter);
        closeDoor.closeDoor(usbPrinter);
   end;
end;


end.

