using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace GertecEasyPrint
{
    internal class printCouponNFCe {
        public static String PrintCouponNFCe(String filePath, int type) {
            if (!File.Exists(filePath)) {
                return "File not found.";
            }

            String nfceType, nfceObs;
            String spaceChar = "";

            switch (type) {
                case 1:
                    nfceType = "Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica";
                    nfceObs = "Não permite aproveitamento de crédito do ICMS";
                    break;
                case 2:
                    nfceType = "EMITIDA EM CONTIGÊNCIA";
                    nfceObs = "Pendente de autorização";
                    break;
                case 3:
                    nfceType = "DOCUMENTO CANCELADO";
                    nfceObs =  "-------------------";
                    break;
                default:
                    return "Invalid option for NFCE TYPE.";
            }


            XmlDocument xml = new XmlDocument();
            xml.Load(filePath);

            //Divisão I - Informações do Cabeçalho
            String nfceBuilder = "";
            nfceBuilder += printBITMAP.EncodeBitmap(@"C:\logogertec.jpg");
            nfceBuilder += "\x0a\x0a"; //pular linha
            nfceBuilder += "\x1b\x4d\x01"; //fonte pequena
            nfceBuilder += "\x1b\x32"; //espacamento entre linhas
            nfceBuilder += "\x1b\x61\x01"; //centralizar
            String formatCNPJ = xml.GetElementsByTagName("CNPJ")[0].InnerText;
            nfceBuilder += "CNPJ:" + Convert.ToUInt64(formatCNPJ).ToString(@"00\.000\.000\/0000\-00") + "\x0a";
            nfceBuilder += "\x1b\x45\x01"; //negrito on
            nfceBuilder += xml.GetElementsByTagName("xNome")[0].InnerText + "\x0a";
            nfceBuilder += "\x1b\x45\x00"; //negrito off
            nfceBuilder += xml.GetElementsByTagName("xLgr")[0].InnerText + ", ";
            nfceBuilder += xml.GetElementsByTagName("nro")[0].InnerText + ", ";
            nfceBuilder += xml.GetElementsByTagName("xBairro")[0].InnerText + ", ";
            nfceBuilder += xml.GetElementsByTagName("xMun")[0].InnerText + ", ";
            nfceBuilder += xml.GetElementsByTagName("UF")[0].InnerText + "\x0a";
            nfceBuilder += "\x1b\x45\x01"; //negrito
            nfceBuilder += "\x0a" + nfceType;
            nfceBuilder += "\x1b\x45\x00"; //negrito off
            nfceBuilder += "\x0a" + nfceObs;

            //Divisão II – Informações de detalhes de produtos/serviços
            nfceBuilder += "\x1b\x45\x01";
            nfceBuilder += "\x0a\x0a" + "DETALHE DA VENDA" + "\x0a";
            nfceBuilder += "\x1b\x61\x00";
            nfceBuilder += "________________________________________________________________";
            nfceBuilder += "Código  Descrição              Qtde UN      Vl Unit     Vl Total" + "\x0a";
            nfceBuilder += "\x1b\x45\x00";
            int countItems = 0;
            XmlNodeList productList = xml.GetElementsByTagName("prod");
            for (int i = 0; i < productList.Count; i++) {
                String cProd = xml.GetElementsByTagName("cProd")[i].InnerText;
                String xProd = xml.GetElementsByTagName("xProd")[i].InnerText;
                String qCom = xml.GetElementsByTagName("qCom")[i].InnerText;
                String uCom = xml.GetElementsByTagName("uCom")[i].InnerText;
                String vUnCom = xml.GetElementsByTagName("vUnCom")[i].InnerText;
                String vProd = xml.GetElementsByTagName("vProd")[i].InnerText;

                String buildFirstLine = "";
                if (cProd.Length <= 6) {
                    buildFirstLine += cProd + spaceChar.PadLeft(8 - cProd.Length);
                } else {
                    buildFirstLine += cProd.Substring(cProd.Length - 6, 6) + "  ";
                }

                bool stop = false;
                bool first = false;
                do {
                    if (xProd.Length <= 20) {
                        buildFirstLine += xProd + spaceChar.PadLeft(23 - xProd.Length);
                        stop = true;
                        if (first == false) {
                            buildFirstLine += qCom + " ";
                            buildFirstLine += uCom + spaceChar.PadLeft(10 - qCom.Length);
                            buildFirstLine += vUnCom + spaceChar.PadLeft(20 - (vUnCom.Length + vProd.Length)); ;
                            buildFirstLine += vProd;
                        }
                    } else {
                        if (first == false) {
                            buildFirstLine += xProd.Substring(0, 20) + spaceChar.PadLeft(3);
                            xProd = xProd.Substring(20);
                            buildFirstLine += qCom + " ";
                            buildFirstLine += uCom + spaceChar.PadLeft(10 - qCom.Length);
                            buildFirstLine += vUnCom + spaceChar.PadLeft(20 - (vUnCom.Length + vProd.Length)); ;
                            buildFirstLine += vProd + spaceChar.PadLeft(8);
                            first = true;
                        } else {
                            buildFirstLine += xProd.Substring(0, 20) + spaceChar.PadLeft(44);
                            xProd = xProd.Substring(20);
                        }
                    }
                } while (stop != true);

                nfceBuilder += buildFirstLine;
                nfceBuilder += "\x0a";
                countItems++;
            }

            //Divisão III – Informações de Totais do DANFE NFC-e
            nfceBuilder += "________________________________________________________________" + "\x0a";
            nfceBuilder += "Qtde. total de itens: " + spaceChar.PadLeft(42 - countItems.ToString().Length) + countItems + "\x0a";
            String amount = xml.GetElementsByTagName("vProd")[countItems].InnerText;
            nfceBuilder += "Valor Total R$: " + spaceChar.PadLeft(48 - amount.Length) + amount + "\x0a";
            String discount = xml.GetElementsByTagName("vDesc")[0].InnerText;
            nfceBuilder += "Desconto R$: " + spaceChar.PadLeft(51 - discount.Length) + discount + "\x0a";
            nfceBuilder += "\x1b\x45\x01";
            String amountToPay = xml.GetElementsByTagName("vNF")[0].InnerText;
            nfceBuilder += "Valor a Pagar R$: " + spaceChar.PadLeft(46 - amountToPay.Length) + amountToPay + "\x0a";
            nfceBuilder += "\x1b\x45\x00";
            nfceBuilder += "________________________________________________________________" + "\x0a";
            nfceBuilder += "FORMA DE PAGAMENTO                                    VALOR PAGO" + "\x0a";
            String typeOfPayment = xml.GetElementsByTagName("tPag")[0].InnerText;

            switch (typeOfPayment) {
                case "01": typeOfPayment = "Dinheiro"; break;
                case "02": typeOfPayment = "Cheque"; break;
                case "03": typeOfPayment = "Cartão de Crédito"; break;
                case "04": typeOfPayment = "Cartão de Débito"; break;
                case "05": typeOfPayment = "Crédito Loja"; break;
                case "10": typeOfPayment = "Vale Alimentação"; break;
                case "11": typeOfPayment = "Vale Refeição"; break;
                case "12": typeOfPayment = "Vale Presente"; break;
                case "13": typeOfPayment = "Vale Combustível"; break;
                case "14": typeOfPayment = "Duplicata Mercantil"; break;
                case "15": typeOfPayment = "Boleto Bancário"; break;
                case "90": typeOfPayment = "Sem Pagamento"; break;
                case "99": typeOfPayment = "Outros"; break;
                default:
                    return "Invalid option for TYPE OF PAYMENT.";
            }

            String amountPaid = xml.GetElementsByTagName("vPag")[0].InnerText;
            nfceBuilder += typeOfPayment + spaceChar.PadLeft(64 - amountPaid.Length - typeOfPayment.Length) + amountPaid;
            nfceBuilder += "________________________________________________________________" + "\x0a\x0a";
            //Divisão IV – Informações da consulta via chave de acesso
            nfceBuilder += "\x1b\x61\x01";
            nfceBuilder += "\x1b\x45\x01";
            nfceBuilder += "Consulte pela Chave de Acesso em" + "\x0a";
            nfceBuilder += "\x1b\x45\x00";
            nfceBuilder += xml.GetElementsByTagName("urlChave")[0].InnerText + "\x0a";
            String nfeKey = xml.GetElementsByTagName("chNFe")[0].InnerText;
                      
            for(int i = 0; i < 11; i++) {
                nfceBuilder += nfeKey.Substring(i*4, 4) + " ";
            }
            nfceBuilder += "\x0a\x0a";
            //Divisão V – Informações da consulta via QR Code
            nfceBuilder += "Protocolo de Autorização: " + xml.GetElementsByTagName("nProt")[0].InnerText + "\x0a";
            String AutDate = xml.GetElementsByTagName("dhRecbto")[0].InnerText;
            nfceBuilder += "Data de Autorização: " + Convert.ToDateTime(AutDate) + "\x0a";

            if(type == 2) {
                nfceBuilder += "\x1b\x45\x01"; //negrito
                nfceBuilder += "\x0a" + nfceType;
                nfceBuilder += "\x1b\x45\x00"; //negrito off
                nfceBuilder += "\x0a" + nfceObs + "\x0a";
            }

            String qrCode = xml.GetElementsByTagName("qrCode")[0].InnerText;
            nfceBuilder += printQRCODE.EncodeQRCODE(qrCode);
            nfceBuilder += "\x0a\x0a";
            nfceBuilder += "\x0a\x0a";
            return nfceBuilder;
        }
    }
}
