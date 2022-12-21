unit printCouponSAT;

interface

uses
  Classes, SysUtils, StrUtils, Types, synaser, blcksock, VCL.Dialogs,
  XMLIntf, XMLDoc, System.MaskUtils, printCustomBarCode, printQRCODE, printText;

procedure printCouponSATFunction(XMLPath : string; typ : integer; printer : TBlockSerial)overload;
procedure printCouponSATFunction(XMLPath : string; typ : integer; printer : TTCPBlockSocket)overload;
function satFactory(XMLPath : string; typ : integer):string;
function satCFe(baseNode : IXMLNode) : string;
function satCFeSimple(baseNode : IXMLNode) : string;
function satCancellation(baseNode : IXMLNode) : string;
function buildQRCode(baseNode : IXMLNode) : string;

function findNodeXML(noNome: string; xmlNode:IXMLNode): IXMLNode;

implementation

procedure printCouponSATFunction(XMLPath: string; typ : integer; printer : TBlockSerial);
begin
   printTextFunction(satFactory(XMLPath, typ), printer);
end;

procedure printCouponSATFunction(XMLPath: string; typ : integer; printer : TTCPBlockSocket);
begin
    printTextFunction(satFactory(XMLPath, typ), printer);
end;

function satFactory(XMLPath: string; typ : integer):string;
var
  response : string;
  Doc: IXMLDocument;
  baseNode: IXMLNode;
  xmlNode: IXMLNode;
  prodList: IXMLNodeList;
  i : integer;
  cnpj,date,time,total,signature : string;
  xmlNfKey : string;
begin

   if not FileExists(XMLPath) then
      raise Exception.Create('Arquivo não encontrado!');
   //ShowMessage('Iniciando Documento');
   Doc := LoadXMLDocument(XMLPath);
   baseNode := Doc.DocumentElement;
   response := '<c>'; //#27#77#1;  //Fonte pequena
   response := response + #27#50; //espaçamento entre linhas

   response := response + '<ce>'; //#27#97#1; //Cabeçalho Centralizado

   {Divisão I - Informações do Cabeçalho}

   response := response + '________________________________________________________________' + '</lf></lf>';

   xmlNode := findNodeXML('xFant',baseNode);

   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + '</lf>';

   xmlNode := findNodeXML('xNome',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + '</lf>';

   xmlNode := findNodeXML('xLgr',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('nro',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('xBairro',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('xMun',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('CEP',baseNode);
   If xmlNode <> nil then
       response := response + 'CEP ' + xmlNode.ChildNodes[0].Text + '</lf>';

   xmlNode := findNodeXML('CNPJ', baseNode);
   If xmlNode <> nil then
       response := response + 'CNPJ ' + FormatMaskText('00\.000\.000\/0000-00;0; ',xmlNode.ChildNodes[0].Text) + '  ';

   xmlNode := findNodeXML('IE',baseNode);
   If xmlNode <> nil then
       response := response + 'IE ' + FormatMaskText('000\.000\.000\.000;0; ',xmlNode.ChildNodes[0].Text) + '  ';

   xmlNode := findNodeXML('IM',baseNode);
   If xmlNode <> nil then
       response := response + 'IM ' + xmlNode.ChildNodes[0].Text + ' </lf>';

   response:= response + '----------------------------------------------------------------</lf>';

   xmlNode := findNodeXML('nCFe',baseNode);
   If xmlNode <> nil then
       response := response + '<ne>Extrato No. ' + xmlNode.ChildNodes[0].Text + '</lf>';

   response:= response + '<ne>CUPOM FISCAL ELETRÔNICO - SAT</ne> </lf>';


   xmlNode := findNodeXML('CNPJ',baseNode);
   If xmlNode <> nil then
       cnpj := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('dEmi',baseNode);
   If xmlNode <> nil then
       date := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('hEmi',baseNode);
   If xmlNode <> nil then
       time := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('vCFe',baseNode);
   If xmlNode <> nil then
       total := xmlNode.ChildNodes[0].Text;
   xmlNode := findNodeXML('assinaturaQRCODE',baseNode);
   If xmlNode <> nil then
       signature := xmlNode.ChildNodes[0].Text;


   xmlNode := findNodeXML('infCFe',baseNode);
   If xmlNode <> nil then
       xmlNfKey := xmlNode.Attributes['Id'];


   case typ of
   1 : begin
       response := response + satCFe(baseNode);
       end;

   2 : begin
       response := response + satCancellation(baseNode);
       end;

   3 : begin
       response := response + satCFeSimple(baseNode);
       end;

   else
     raise Exception.Create('Invalid option for SAT TYPE.');
   end;

   Result := response + '</gui>';
end;

function satCFe(baseNode : IXMLNode): string;
var
  response : string;
  xmlNode: IXMLNode;
  vNodeTemp : IXMLNode;
  vTemp : string;
  date, time : string;
  xmlNfKey, qCom, typeOfPayment : string;
  infcpl : string;
  i : integer;
  vRemaining : integer;
begin
   response := response + '----------------------------------------------------------------' + '</lf>';
   //Nome e CPF/CNPJ do consumidor é opcional

   xmlNode := findNodeXML('CNPJ', baseNode);
   vNodeTemp := xmlNode;
   If xmlNode <> nil then
       response := response + #27#97#0 + 'CPF/CNPJ do Consumidor: ' +
                    FormatMaskText('00\.000\.000\/0000-00;0; ',xmlNode.ChildNodes[0].Text) + '</lf>';
   response := response + 'Razão Social/Nome: <nome do consumidor>' + #10;
   response := response + '----------------------------------------------------------------' + '</lf>';
   response := response + '# | COD |  DESC  | QTD | UN | VL UN R$ | (VLTR R$)* | VL ITEM R$' + '</lf>';
   response := response + '----------------------------------------------------------------' + '</lf>';

   xmlNode := findNodeXML('det',baseNode);
   i := 0;
   if xmlNode.HasChildNodes then
     while (i < xmlNode.ChildNodes.Count)  do
     begin
         if (xmlNode.ChildNodes[i].NodeName = 'prod') then
         begin
           //xmlNode := findNodeXML('det',baseNode);
           //If xmlNode <> nil then
               //response := response + xmlNode.Attributes.Item[0].TextContent + ' ';
           response := response + IntToStr(i+1).PadRight(4, ' ');

           vTemp := findNodeXML('cProd', baseNode).ChildNodes[0].Text;
           If vNodeTemp <> nil then
               response := response + vTemp.PadRight(4, ' ');
           //ShowMessage('codigo = '+vNodeTemp.ChildNodes[0].NodeValue );

           vNodeTemp := findNodeXML('xProd', baseNode);
           If vNodeTemp <> nil then
           begin
             vTemp := vNodeTemp.ChildNodes[0].Text;
             if vTemp.Length > 23 then
              response := response + copy(vTemp, 1, 22).PadRight(24, ' ')
             else
              response := response + copy(vTemp, 1, vTemp.Length).PadRight(24, ' ');
           end;
           vRemaining:= vTemp.Length - 23;

           vNodeTemp := findNodeXML('qCom', baseNode);
           If vNodeTemp <> nil then
               qCom := vNodeTemp.ChildNodes[0].Text;

           qCom := StringReplace(qCom, '.0000', '', [rfReplaceAll, rfIgnoreCase]);
           //ShowMessage('qtd = '+vNodeTemp.ChildNodes[0].NodeValue );
           response := response + qCom.PadLeft(6, ' ');

           vNodeTemp := findNodeXML('uCom', baseNode);

           If vNodeTemp <> nil then
           begin
             vTemp := vNodeTemp.ChildNodes[0].NodeValue;
             response := response + vTemp.PadRight(3, ' ') + ' X ';
           end;

           vNodeTemp := findNodeXML('vUnCom', baseNode);
           If vNodeTemp <> nil then
           begin
             vTemp:= vNodeTemp.ChildNodes[0].Text;
             response := response + vTemp.PadRight(6, ' ') + ' (';
           end;

           vNodeTemp := findNodeXML('vItem12741', baseNode);
           If vNodeTemp <> nil then
           begin
             vTemp:= vNodeTemp.ChildNodes[0].Text;
               response := response + vTemp.PadRight(5, ' ') + ') ';
           end;

           vNodeTemp := findNodeXML('vProd', baseNode);
           If vNodeTemp <> nil then
           begin
             vTemp := vNodeTemp.ChildNodes[0].Text;
             response := response + vTemp.PadLeft(5, ' ') + '</lf>';
           end;
           vTemp := findNodeXML('xProd', baseNode).ChildNodes[0].Text;
           while vRemaining > 0 do
            begin
              if vRemaining > 23 then
                response := response + ''.PadLeft(8, ' ')+copy(vTemp, (vTemp.Length - vRemaining), 23).PadRight(50, ' ') + '</lf>'
              else
                response := response + ''.PadLeft(8, ' ') + copy(vTemp, (vTemp.Length - vRemaining), vRemaining+1).PadRight(50, ' ') + '</lf>';
              vRemaining := vRemaining - 20;
            end;
       end;
       inc(i);

     end;

   xmlNode := findNodeXML('vProd',baseNode);
   If xmlNode <> nil then
       response := response + 'Total bruto de itens:                                     ' + xmlNode.ChildNodes[0].Text + '</lf>';

   xmlNode := findNodeXML('vCFe',baseNode);
   If xmlNode <> nil then
       response := response + '<ne>Total R$                                                  ' + xmlNode.ChildNodes[0].Text + '</ne></lf>';

   response := response + '----------------------------------------------------------------</lf>';
   response := response + 'FORMA DE PAGAMENTO                                    VALOR PAGO</lf>';

   xmlNode := findNodeXML('cMP',baseNode);
   //ShowMessage('Forma de pagamento: '+xmlNode.ChildNodes[0].Text);
   case StrToInt(xmlNode.ChildNodes[0].Text) of
    1: typeOfPayment := 'Dinheiro';
    2: typeOfPayment := 'Cheque';
    3: typeOfPayment := 'Cartão de Crédito';
    4: typeOfPayment := 'Cartão de Débito';
    5: typeOfPayment := 'Crédito Loja';
    10: typeOfPayment := 'Vale Alimentação';
    11: typeOfPayment := 'Vale Refeição';
    12: typeOfPayment := 'Vale Presente';
    13: typeOfPayment := 'Vale Combustíve';
    99: typeOfPayment := 'Outros';
    else
      raise Exception.Create('Invalid option for TYPE OF PAYMENT.');
   end;

   response:= response + typeOfPayment;
   //ShowMessage('Forma de pagamento definida');
   xmlNode := findNodeXML('vMP',baseNode);
   If xmlNode <> nil then
       response := response + '                                                  ' + xmlNode.ChildNodes[0].Text + '</lf>';
   //ShowMessage('Acessa vTroco');
   xmlNode := findNodeXML('vTroco',baseNode);
   If xmlNode <> nil then
       response := response + 'Troco R$                                                   ' + xmlNode.ChildNodes[0].Text + '</lf></lf>';
    //ShowMessage('Acessa obsFisco');
   xmlNode := findNodeXML('obsFisco',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.Attributes['xCampo'] + '</lf>';
   //ShowMessage('Acessa xTexto');
   xmlNode := findNodeXML('xTexto',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + '</lf>';

   response := response + '----------------------------------------------------------------' + '</lf>';
   response := response + #27#97#0 + 'DADOS PARA ENTREGA' + '</lf>';

   xmlNode := findNodeXML('xLgr',baseNode);
   If xmlNode <> nil then
       response := response + 'Endereço: ' + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('nro',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('xCpl',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ', ';

   xmlNode := findNodeXML('xBairro',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + ' - ';

   xmlNode := findNodeXML('xMun',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].Text + '</lf>';

   response := response + '----------------------------------------------------------------' + '</lf>';
   response := response + 'OBSERVAÇÕES DO CONTRIBUINTE' + '</lf>';

   xmlNode := findNodeXML('infCpl',baseNode);
   If xmlNode <> nil then
       infcpl := xmlNode.ChildNodes[0].Text;

   infcpl := SplitString(infcpl, ';')[0];
   response := response + infcpl + '</lf>';

   {xmlNode := findNodeXML('vCFeLei12741',baseNode);
   If xmlNode <> nil then
       response := response + xmlNode.ChildNodes[0].NodeValue + '</lf>';}

   response := response + '----------------------------------------------------------------' + '</lf>';

   response := response + '<ce>';

   xmlNode := findNodeXML('nserieSAT',baseNode);
   If xmlNode <> nil then
       response := response + 'SAT No. ' + '<ne>' + FormatMaskText('000\.000\.000;0; ',xmlNode.ChildNodes[0].Text) + '</ne></lf>';
   //ShowMessage('pega a data');
   xmlNode := findNodeXML('dEmi',baseNode);
   If xmlNode <> nil then
       begin
       date := date + copy(xmlNode.ChildNodes[0].Text, 7,2);
       date := date + copy(xmlNode.ChildNodes[0].Text, 5,2);
       date := date + copy(xmlNode.ChildNodes[0].Text, 1,4);

       end;

   xmlNode := findNodeXML('hEmi',baseNode);
   If xmlNode <> nil then
       time := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('infCFe',baseNode);
   If xmlNode <> nil then
       xmlNfKey := xmlNode.Attributes['Id'];

   response := response + FormatMaskText('00\/00\/0000;0; ',date) + ' - ';
   response := response + FormatMaskText('00\:00\:00;0; ',time) + '</lf>';
   //ShowMessage('formatando o numero');
   xmlNfKey := FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ',
               StringReplace(xmlNfKey, 'CFe', '', [rfReplaceAll, rfIgnoreCase]));
   response := response + xmlNfKey + '</lf>';

   //response := response + printCustomBarCode.printCodeBarFactory(100, 3,1,'code128',xmlNfKey)+'</lf>';
   ShowMessage('Concluindo o codigo');
   response := response + ('<qr>5,48,' + buildQRCode(baseNode) + '</qr></lf>');
   ShowMessage('Concluindo o codigo 2');
   response := response + '</lf>' + 'Consulte o QR Code pelo aplicativo [nome_do_aplicativo],' + #10
   + 'disponível na AppStore(Apple) e PlayStore(Android)' + '</lf></lf>';

   response := response + '________________________________________________________________' + '</lf></lf>';

   Result := response;
end;

function satCFeSimple(baseNode : IXMLNode): string;
var
  response : string;
  xmlNode : IXMLNode;
  date,time, xmlNfKey : string;
  infcpl : string;
begin

   response := response + '----------------------------------------------------------------' + '</lf>';
   //Nome e CPF/CNPJ do consumidor é opcional

   xmlNode := findNodeXML('CNPJ', baseNode);
   If xmlNode <> nil then
       response := response + #27#97#0 + 'CPF/CNPJ do Consumidor: ' + FormatMaskText('00\.000\.000\/0000-00;0; ',xmlNode.ChildNodes[0].Text) + '</lf>';

   xmlNode := findNodeXML('vCFe',baseNode);
   If xmlNode <> nil then
       response := response + '<ne>Total R$ ' + xmlNode.ChildNodes[0].Text + '</ne></lf>';

   response := response + '----------------------------------------------------------------' + '</lf>';

   response := response + 'OBSERVAÇÕES DO CONTRIBUINTE' + '</lf>';

   xmlNode := findNodeXML('infCpl',baseNode);
   If xmlNode <> nil then
       infcpl := xmlNode.ChildNodes[0].Text;

   infcpl := StringReplace(infcpl, 'NjQwdDAwMCc3Nzo2NCdROXZrclZvO052a1IhVXY5RUVoYTc4Nzo2Nyc6NDo6N0A0Nic3NzQ3OQ==', '', [rfReplaceAll, rfIgnoreCase]);
   response := response + infcpl + '</lf>';

   response := response + '----------------------------------------------------------------' + '</lf>';

   response := response + '<ce>';

   xmlNode := findNodeXML('nserieSAT',baseNode);
   If xmlNode <> nil then
       response := response + 'SAT No. ' + '<ne>' + FormatMaskText('000\.000\.000;0; ',xmlNode.ChildNodes[0].Text) + '</ne></lf>';

   xmlNode := findNodeXML('dEmi',baseNode);
   If xmlNode <> nil then
       date := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('hEmi',baseNode);
   If xmlNode <> nil then
       time := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('infCFe',baseNode);
   If xmlNode <> nil then
       xmlNfKey := xmlNode.Attributes['Id'];

   response := response + FormatMaskText('0000\/00\/00;0; ',date) + ' - ';
   response := response + FormatMaskText('00\:00\:00;0; ',time) + '</lf>';

   response := response + '</lf>' + FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ',
               StringReplace(xmlNfKey, 'CFe', '', [rfReplaceAll, rfIgnoreCase])) + '</lf></lf>';

   //response := response + xmlNfKey;

   //response := response + printCustomBarCode.printCodeBarFactory(100, 3,1,'code128',xmlNfKey)+'</lf>';

   response := response + ('<qr>5,48,' + buildQRCode(baseNode) + '</qr></lf>');

   response := response + '</lf>' + 'Consulte o QR Code pelo aplicativo [nome_do_aplicativo],' + #10
   + 'disponível na AppStore(Apple) e PlayStore(Android)' + '</lf>';

   response := response + '________________________________________________________________' + '</lf></lf>';

   Result := response;
end;

function satCancellation(baseNode : IXMLNode): string;
var
  xmlNode : IXMLNode;
  response : string;
  cnpj,date,time,total,signature : string;
  xmlNfKey, code128c, qrCode : string;
begin

   response := '<ce>' + '<ne>CANCELAMENTO' + '</lf>';
   response := response + '----------------------------------------------------------------';
   response := response + #27#97#0;
   response := response + 'DADOS DO CUPOM FISCAL ELETRÔNICO CANCELADO</ne>' + '</lf>';

   xmlNode := findNodeXML('CNPJ', baseNode);
   If xmlNode <> nil then
       response := response + 'CPF/CNPJ do Consumidor: ' + FormatMaskText('00\.000\.000\/0000-00;0; ',xmlNode.ChildNodes[0].Text) + '</lf>';

   xmlNode := findNodeXML('vCFe',baseNode);
   If xmlNode <> nil then
       total := xmlNode.ChildNodes[0].Text;

   response := response + '<ne>TOTAL R$ ' + total.PadLeft(56, ' ') + '</ne>' + ' </lf>';

   response := response + '---------------------------------------------------------------- </lf>';

   xmlNode := findNodeXML('nserieSAT',baseNode);
   If xmlNode <> nil then
       response := response + '<ce>' + 'SAT No. ' + '<ne>' + xmlNode.ChildNodes[0].Text + '</ne> </lf>';

   xmlNode := findNodeXML('dEmi',baseNode);
   If xmlNode <> nil then
       date := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('hEmi',baseNode);
   If xmlNode <> nil then
       time := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('infCFe',baseNode);
   If xmlNode <> nil then
       xmlNfKey := xmlNode.Attributes['Id'];

   response := response + FormatMaskText('0000\/00\/00;0; ',date) + ' - ';
   response := response + FormatMaskText('00\:00\:00;0; ',time) + '</lf>';

   response := response + '</lf>' + FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ',
               StringReplace(xmlNfKey, 'CFe', '', [rfReplaceAll, rfIgnoreCase])) + '</lf></lf>';

   //response := response + printCustomBarCode.printCodeBarFactory(100, 3,1,'code128',xmlNfKey)+'</lf>';

   response := response + ('<qr>5,48,' + buildQRCode(baseNode) + '</qr></lf>');

   response := response + '----------------------------------------------------------------';
   response := response + 'DADOS DO CUPOM FISCAL ELETRÔNICO DE CANCELAMENTO' + '</lf></lf>';

   xmlNode := findNodeXML('nserieSAT',baseNode);
   If xmlNode <> nil then
       response := response + '<ce>' + 'SAT No. ' + '<ne>' + xmlNode.ChildNodes[0].Text + '</ne> </lf>';

   response := response + FormatMaskText('0000\/00\/00;0; ',date) + ' - ';
   response := response + FormatMaskText('00\:00\:00;0; ',time) + '</lf>';

   response := response + FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ',
               StringReplace(xmlNfKey, 'CFe', '', [rfReplaceAll, rfIgnoreCase])) + '</lf>';

   //response := response + printCustomBarCode.printCodeBarFactory(100, 3,1,'code128',xmlNfKey)+'</lf>';

   response := response + ('<qr>5,48,' + buildQRCode(baseNode) + '</qr></lf>');

   response := response + '<c>Consulte o QR Code pelo aplicativo [nome_do_aplicativo],' + #10
   + 'disponível na AppStore(Apple) e PlayStore(Android).</c>' + '</lf>';

   response := response + '________________________________________________________________' + '</lf></lf>';

   Result := response;
end;

function buildQRCode(baseNode : IXMLNode): string;
var
  builder : string;
  xmlNfKey : string;
  xmlNode : IXMLNode;
  cnpj,date,time,total,signature : string;
begin
   xmlNode := findNodeXML('CNPJ',baseNode);
   If xmlNode <> nil then
       cnpj := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('dEmi',baseNode);
   If xmlNode <> nil then
       date := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('hEmi',baseNode);
   If xmlNode <> nil then
       time := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('vCFe',baseNode);
   If xmlNode <> nil then
       total := xmlNode.ChildNodes[0].Text;

   xmlNode := findNodeXML('assinaturaQRCODE',baseNode);
   If xmlNode <> nil then
       signature := xmlNode.ChildNodes[0].Text;


   xmlNode := findNodeXML('infCFe',baseNode);
   If xmlNode <> nil then
       xmlNfKey := xmlNode.Attributes['Id'];

   xmlNfKey := FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ',
               StringReplace(xmlNfKey, 'CFe', '', [rfReplaceAll, rfIgnoreCase]));

   builder := '';
   builder := builder + xmlNfKey + '|';
   builder := builder + date + time + '|';
   builder := builder + total + '|';
   builder := builder + cnpj + '|';
   //builder := builder + signature;

   Result := builder;
end;

function findNodeXML(noNome: string; xmlNode:IXMLNode): IXMLNode;
var
  i: integer;
  retorno: IXMLNode;
begin
  retorno := nil;
  i := 0;
  // considera apenas nós elementos
  if XmlNode.NodeType <> ntElement then
    Exit;

   if (XmlNode.NodeName = noNome)  then
    begin
         //showMessage('Achou - '+XmlNode.NodeName);
         Result := XmlNode;
         Exit;
    end
  else
    begin
    i := 0;
    if xmlNode.HasChildNodes then
     while (i <= xmlNode.ChildNodes.Count - 1) and (retorno = nil) do
     begin
        retorno := FindNodeXML(noNome, xmlNode.ChildNodes[i]);
        i := i + 1;
     end;

    end;
  Result := retorno;
end;

end.
