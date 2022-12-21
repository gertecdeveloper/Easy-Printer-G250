unit printCouponNFCe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, XMLRead, DOM, MaskUtils, printQRCODE, synaser, Dialogs, printText, blcksock;

const
  LINE_SPACE = #27#50;

procedure printCouponNFCe(XMLPath: string; typ : integer; printer : TBlockSerial)overload;
procedure printCouponNFCe(XMLPath: string; typ : integer; printer : TTCPBlockSocket)overload;
procedure printCouponNFCe(XMLPath: string; typ : integer)overload;
function nfceFactory(XMLPath: string; typ : integer):string;

function findNodeXML(noNome: string; xmlNode: TDOMNode): TDOMNode;

implementation

procedure printCouponNFCe(XMLPath: string; typ : integer);
begin
   //ShowMessage(nfceFactory(XMLPath, typ));
end;

procedure printCouponNFCe(XMLPath: string; typ : integer; printer : TBlockSerial);
begin
   printText.printText(nfceFactory(XMLPath, typ), printer);
end;

procedure printCouponNFCe(XMLPath: string; typ : integer; printer : TTCPBlockSocket);
begin

end;

function nfceFactory(XMLPath: string; typ : integer):string;
var
  response : string;
  xmlNode : TDOMNode;
  doc : TXMLDocument;
  nfceType : string;
  nfceObs : string;
  baseNode : TDOMNode;
  i : integer;
  cProd: string;
  vTemp:string;
  vRemaining : integer;
  typeOfPayment : string;

begin

   if not FileExists(XMLPath) then
    raise Exception.Create('Arquivo não encontrado!');


   ReadXMLFile(doc,XMLPath);
   baseNode := doc.DocumentElement;
   response := '<c>';
   response := response + #27#50;

   //Cabeçalho Centralizado
   response := response + '<ce>';

  case typ of
  1 : begin
      nfceType := 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica';
      nfceObs := 'Não permite aproveitamento de crédito do ICMS';
      end;

  2 : begin
      nfceType := 'EMITIDA EM CONTIGÊNCIA';
      nfceObs := 'Pendente de autorização</lf>' {+ 'Via Cliente';
      nfceObs := 'Pendente de autorização</lf>' + 'Via Estabelecimento';}
      end;

  3 : begin
      nfceType := 'CANCELAMENTO';
      nfceObs := 'Pendente de autorização';
      end;
  else
    raise Exception.Create('Invalid option for NFCE TYPE.');
end;

  {Divisão I - Informações do Cabeçalho}

  xmlNode := findNodeXML('CNPJ', baseNode);
  If xmlNode <> nil then
       response := '<c><ce>CNPJ: ' + FormatMaskText('00\.000\.000\/0000-00;0; ',xmlNode.ChildNodes[0].NodeValue) + '</lf>';

  xmlNode := findNodeXML('xNome',baseNode);
  If xmlNode <> nil then
       response := response + '<ne>' + xmlNode.ChildNodes[0].NodeValue + '</ne></lf>';

  response := response + findNodeXML('xLgr', baseNode).ChildNodes[0].NodeValue + ', ';
  response := response + findNodeXML('nro', baseNode).ChildNodes[0].NodeValue + ', ';
  response := response + findNodeXML('xBairro', baseNode).ChildNodes[0].NodeValue + ', ';
  response := response + findNodeXML('xMun', baseNode).ChildNodes[0].NodeValue + ', ';
  response := response + findNodeXML('UF', baseNode).ChildNodes[0].NodeValue + '</lf>';

  response := response + '</lf><ne>' + nfceType + '</ne></lf>';
  response := response + nfceObs + '</lf>';

  {Divisão II – Informações de detalhes de produtos/serviços}

  response := response + '<ne></lf>DETALHES DA VENDA</ne></lf>';
  response := response + '________________________________________________________________</lf>';
  response := response + '<ne>Codigo  Descricao              Qtde UN      Vl Unit     Vl Total</ne></lf>';

  xmlNode := findNodeXML('det',baseNode);
  i := 0;
  if xmlNode.HasChildNodes then
     while (i <= xmlNode.ChildNodes.Count - 1)  do
     begin
      if (xmlNode.ChildNodes[i].NodeName = 'prod') then
      begin
        cProd := xmlNode.ChildNodes[i].FindNode('cProd').ChildNodes[0].NodeValue;
        response := response + copy(cProd, (cProd.Length-5), 7).PadRight(8, ' ');
        vTemp := xmlNode.ChildNodes[i].FindNode('xProd').ChildNodes[0].NodeValue;

        if vTemp.Length > 20 then
          response := response + copy(vTemp, 1, 20).PadRight(23, ' ')
        else
          response := response + copy(vTemp, 1, vTemp.Length).PadRight(23, ' ');
        vRemaining := vTemp.Length - 20;
        vTemp := xmlNode.ChildNodes[i].FindNode('qCom').ChildNodes[0].NodeValue;
        response := response + vTemp.PadRight(7, ' ');
        vTemp := xmlNode.ChildNodes[i].FindNode('uCom').ChildNodes[0].NodeValue;
        response := response + vTemp.PadRight(6, ' ');
        vTemp := xmlNode.ChildNodes[i].FindNode('vUnCom').ChildNodes[0].NodeValue;
        response := response + vTemp.PadRight(12, ' ');
        vTemp := xmlNode.ChildNodes[i].FindNode('vProd').ChildNodes[0].NodeValue;
        response := response + vTemp.PadLeft(5, ' ')+'</lf>';

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

  {Divisão III – Informações de Totais do DANFE NFC-e}

  response := response + '________________________________________________________________ </lf>';
  xmlNode := findNodeXML('det', baseNode);
  vTemp := xmlNode.Attributes.Item[0].TextContent;
  response := response + 'Qtde. total de itens:'+''.PadLeft(64 - 21 - Length(vTemp))+vTemp+'</lf>';

  vTemp := findNodeXML('ICMSTot', baseNode).FindNode('vProd').ChildNodes[0].NodeValue;
  response := response + 'Valor Total R$:'+''.PadLeft(64 - 15 - Length(vTemp))+  vTemp+'</lf>';

  vTemp := findNodeXML('ICMSTot', baseNode).FindNode('vDesc').ChildNodes[0].NodeValue;
  response := response + 'Desconto R$:'+''.PadLeft(64 - 13 - Length(vTemp))+  vTemp+'</lf>';

  vTemp := findNodeXML('ICMSTot', baseNode).FindNode('vNF').ChildNodes[0].NodeValue;
  response := response + '<ne>Valor a Pagar R$:'+''.PadLeft(64 - 17 - Length(vTemp))+vTemp+'</ne></lf>';

  xmlNode := findNodeXML('tPag', baseNode);

  case StrToInt(xmlNode.ChildNodes[0].NodeValue) of
    1: typeOfPayment := 'Dinheiro';
    2: typeOfPayment := 'Cheque';
    3: typeOfPayment := 'Cartão de Crédito';
    4: typeOfPayment := 'Cartão de Débito';
    5: typeOfPayment := 'Crédito Loja';
    10: typeOfPayment := 'Vale Alimentação';
    11: typeOfPayment := 'Vale Refeição';
    12: typeOfPayment := 'Vale Presente';
    13: typeOfPayment := 'Vale Combustíve';
    14: typeOfPayment := 'Duplicata Mercantil';
    15: typeOfPayment := 'Boleto Bancário';
    90: typeOfPayment := 'Sem Pagamento';
    99: typeOfPayment := 'Outros';
    else
      raise Exception.Create('Invalid option for TYPE OF PAYMENT.');
   end;

  response := response + '________________________________________________________________</lf>';
  response := response + 'FORMA DE PAGAMENTO                                    VALOR PAGO</lf>';
  vTemp := findNodeXML('vPag', baseNode).ChildNodes[0].NodeValue;
  response := response + typeOfPayment+''.PadLeft(64 - typeOfPayment.Length - vTemp.Length)+ vTemp+'</lf>';

  {Divisão IV – Informações da consulta via chave de acesso}

  response := response + '________________________________________________________________</lf>';
  response := response + '<ce><ne>Consulte pela Chave de Acesso em</ne></lf>';

  xmlNode := findNodeXML('NFe',doc.DocumentElement).FindNode('infNFeSupl').FindNode('urlChave');

  response := response + xmlNode.ChildNodes[0].NodeValue + '</lf>';

  xmlNode := findNodeXML('nfeProc', baseNode).FindNode('protNFe').FindNode('infProt').FindNode('chNFe');

  response := response + FormatmaskText('0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000;0; ', xmlNode.ChildNodes[0].NodeValue) + '</lf>';

  {Divisão V – Informações da consulta via QR Code}

  response := response + '<qr>5,48,' + findNodeXML('qrCode', baseNode).ChildNodes[0].NodeValue +'</qr>';
  response := response + '</c></gui>';



  if typ = 2 then
     result := response + '<gui>' + response + '<gui>'
  else
      Result:= response;

end;

function findNodeXML(noNome: string; xmlNode: TDOMNode): TDOMNode;
var
  I: integer;
  retorno: TDOMNode;
begin
  retorno := nil;
  i := 0;

  // considera apenas nós elementos
  if XmlNode.NodeType <> ELEMENT_NODE then
     Exit;

  if (XmlNode.NodeName = noNome)  then
     begin
       Result := XmlNode;
       Exit;
     end
  else
    begin
        if xmlNode.HasChildNodes then
           while (i <= xmlNode.ChildNodes.Count - 1) and (retorno = nil)
                 and (XmlNode.ChildNodes[i].NodeType <> TEXT_NODE)  do
           begin
               retorno := FindNodeXML(noNome, xmlNode.ChildNodes[i]);
               i := i + 1;
           end;
    end;
    Result := retorno;
end;

end.

