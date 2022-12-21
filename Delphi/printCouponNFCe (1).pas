unit printCouponNFCe;

interface

uses
  Classes, SysUtils, StrUtils, Types, synaser, blcksock, VCL.Dialogs, XMLIntf, XMLDoc,
  System.MaskUtils, printText, sendBinBuffer;

const
  LINE_SPACE = #27#50;
  RESTART = #27#64;

procedure printCouponNFCeFunction(XMLPath: string; vType:integer; printer : TBlockSerial)overload;
procedure printCouponNFCeFunction(XMLPath: string; vType:integer; printer : TTCPBlockSocket)overload;
procedure printCouponNFCeFunction(XMLPath: string)overload;
function nfceFactory(XMLPath: string; vType:integer):string;

function findNodeXML(noNome: string; xmlNode:IXMLNode): IXMLNode;

implementation

procedure printCouponNFCeFunction(XMLPath: string);
Begin
   ShowMessage(nfceFactory(XMLPath, 1));
End;

procedure printCouponNFCeFunction(XMLPath: string; vType:integer; printer : TBlockSerial);
Begin
    sendBinBufferFunction(TEncoding.GetEncoding(65001).ASCII.GetBytes(Restart + '#27#77#1' + '#27#50'), printer);
   printTextFunction(nfceFactory(XMLPath, vType), printer);
End;

procedure printCouponNFCeFunction(XMLPath: string; vType:integer; printer : TTCPBlockSocket);
Begin
    sendBinBufferFunction(TEncoding.GetEncoding(65001).ASCII.GetBytes(Restart+ '#27#77#1' + '#27#50'), printer);
   printTextFunction(nfceFactory(XMLPath, vType), printer);
End;

function nfceFactory(XMLPath: string; vType:integer):string;
var
  Doc: IXMLDocument;
  baseNode: IXMLNode;
  xmlNode: IXMLNode;
  prodList: IXMLNodeList;
  response: string;
  i: integer;
  typeOfPayment : string;
  cProd: string;
  vTemp:string;
  vRemaining : integer;
  nfceType: string;
  nfceObs: string;
begin

  if not FileExists(XMLPath) then
    raise Exception.Create('Arquivo n�o encontrado!');

  case vType of
  1: begin
    nfceType := 'Documento Auxiliar da Nota Fiscal de Consumidor Eletr�nica';
    nfceObs := 'N�o permite aproveitamento de cr�dito do ICMS';
  end;
  2: begin
    nfceType := 'EMITIDA EM CONTIG�NCIA';
    nfceObs := 'Pendente de autoriza��o';
  end;
  3: begin
    nfceType := 'CANCELAMENTO';
    nfceObs := 'Pendente de autoriza��o';
  end
  else
    raise Exception.Create('Tipo de documento inv�lido!');
  end;

  Doc := LoadXMLDocument(XMLPath);
  baseNode := Doc.DocumentElement;
  //response := '<c> ';
  //response := response + #27#50;
  //Cabecalho centralizado
  response := response + '<ce> ';

  xmlNode := findNodeXML('CNPJ', baseNode);
  if xmlNode = nil then
    raise Exception.Create('Arquivo XML inv�lido');

  response := response + 'CNPJ: ' + FormatmaskText('00\.000\.000\/0000\-00;0;',xmlNode.Text)+' </lf> ';

  xmlNode := findNodeXML('xNome', baseNode);
  if xmlNode = nil then
    raise Exception.Create('Arquivo XML inv�lido');
  response := response + '<ne>'+ xmlNode.Text +'</ne> </lf>';

  response := response + findNodeXML('xLgr', baseNode).Text +',';
  response := response + findNodeXML('nro', baseNode).Text +',';
  response := response + findNodeXML('xBairro', baseNode).Text +',';
  response := response + findNodeXML('xMun', baseNode).Text +',';
  response := response +findNodeXML('UF', baseNode).Text +'</lf>';

  response := response + '<ne>'+ nfceType +'</ne> </lf>';
  response := response + nfceObs;

  //Divis�o II � Informa��es de detalhes de produtos/servi�os
  response := response + '<ne> </lf> </lf>DETALHES DA VENDA </ce> </lf>';

  response := response + '________________________________________________________________</lf>';
  response := response + 'C�digo  Descri��o             Qtde    UN    Vl Unit     Vl Total</lf></ne>';
  xmlNode := findNodeXML('det', baseNode);

  if xmlNode.HasChildNodes then
     while (i <= xmlNode.ChildNodes.Count - 1)  do
     begin
      if (xmlNode.ChildNodes[i].NodeName = 'prod') then
      begin
        cProd := xmlNode.ChildNodes[i].ChildNodes.FindNode('cProd').Text;
        response := response + copy(cProd, (cProd.Length-6), 7).PadRight(8, ' ');
        vTemp := xmlNode.ChildNodes[i].ChildNodes.FindNode('xProd').Text;

        if vTemp.Length > 20 then
          response := response + copy(vTemp, 1, 20).PadRight(23, ' ')
        else
          response := response + copy(vTemp, 1, vTemp.Length).PadRight(23, ' ');
        vRemaining := vTemp.Length - 20;

        response := response + xmlNode.ChildNodes[i].ChildNodes.FindNode('qCom').Text.PadRight(8, ' ');
        response := response + xmlNode.ChildNodes[i].ChildNodes.FindNode('uCom').Text.PadRight(6, ' ');
        response := response + xmlNode.ChildNodes[i].ChildNodes.FindNode('vUnCom').Text.PadRight(12, ' ');
        response := response + xmlNode.ChildNodes[i].ChildNodes.FindNode('vProd').Text.PadLeft(5, ' ')+'</lf>';

        while vRemaining > 0 do
        begin
          if vRemaining > 20 then
            response := response + ''.PadLeft(8, ' ')+copy(vTemp, (vTemp.Length - vRemaining), 20).PadRight(56, ' ') + '</lf>'
          else
            response := response + ''.PadLeft(8, ' ') + copy(vTemp, (vTemp.Length - vRemaining), vRemaining+1).PadRight(56, ' ') + '</lf>';
          vRemaining := vRemaining - 20;
        end;
      end;
      i := i + 1;
     end;

   //Divis�o III � Informa��es de Totais do DANFE NFC-e
   response := response + '________________________________________________________________ </lf>';
   vTemp := xmlNode.Attributes['nItem'];
   response := response + 'Qtde. total de itens:'+''.PadLeft(64 - 21 - Length(vTemp))+vTemp+'</lf>';

   vTemp := findNodeXML('ICMSTot', baseNode).ChildNodes.FindNode('vProd').NodeValue;
   response := response + 'Valor Total R$:'+''.PadLeft(64 - 15 - Length(vTemp))+  vTemp+'</lf>';

   vTemp := findNodeXML('ICMSTot', baseNode).ChildNodes.FindNode('vDesc').NodeValue;
   response := response + 'Desconto R$:'+''.PadLeft(64 - 13 - Length(vTemp))+  vTemp+'</lf>';

   vTemp := findNodeXML('ICMSTot', baseNode).ChildNodes.FindNode('vNF').NodeValue;
   response := response + '<ne>Valor a Pagar R$:'+''.PadLeft(64 - 17 - Length(vTemp))+vTemp+'</ne> </lf>';
   response := response + '________________________________________________________________ </lf>' + #27#50;

   xmlNode :=  findNodeXML('tPag', baseNode);
   case StrToInt(xmlNode.Text) of
    1: typeOfPayment := 'Dinheiro';
    2: typeOfPayment := 'Cheque';
    3: typeOfPayment := 'Cart�o de Cr�dito';
    4: typeOfPayment := 'Cart�o de D�bito';
    5: typeOfPayment := 'Cr�dito Loja';
    10: typeOfPayment := 'Vale Alimenta��o';
    11: typeOfPayment := 'Vale Refei��o';
    12: typeOfPayment := 'Vale Presente';
    13: typeOfPayment := 'Vale Combust�ve';
    14: typeOfPayment := 'Duplicata Mercantil';
    15: typeOfPayment := 'Boleto Banc�rio';
    90: typeOfPayment := 'Sem Pagamento';
    99: typeOfPayment := 'Outros';
   end;

   response := response + 'FORMA DE PAGAMENTO                                    VALOR PAGO </lf>';
   vTemp := findNodeXML('vPag', baseNode).Text;
   response := response + typeOfPayment+''.PadLeft(64 - typeOfPayment.Length - vTemp.Length)+ vTemp+'</lf>';
   response := response + '________________________________________________________________ </lf>';
   //Divis�o IV � Informa��es da consulta via chave de acesso
   response := response + '<ce> <ne> Consulte pela Chave de Acesso em </ne> </ce> </lf>';
   response := response + findNodeXML('urlChave', baseNode).Text+'</lf>';
   response := response +
        FormatmaskText('0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ 0000\ ;0;',
        findNodeXML('chNFe', baseNode).Text)+'</lf>';
   response := response +'<qr>5,48,'+findNodeXML('qrCode', baseNode).Text +' </qr>';
  response := response + ' </c> </gui>';


  if vType = 2 then
    Result:= response + response
  else
    Result:= response;
end;

function findNodeXML(noNome: string; xmlNode:IXMLNode): IXMLNode;
var
  I: integer;
  retorno: IXMLNode;
begin
  retorno := nil;
  i := 0;
  // considera apenas n�s elementos
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
