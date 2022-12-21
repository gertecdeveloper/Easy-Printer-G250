using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace GertecEasyPrint
{
    internal class printCouponSAT {
        public static String PrintCouponSAT(String filePath, int type) {
            if (!File.Exists(filePath)) {
                return "File not found.";
            }

            XmlDocument xml = new XmlDocument();
            xml.Load(filePath);

            String satBuilder = "";
            satBuilder += printBITMAP.EncodeBitmap(@"C:\logogertec.jpg") + "\x0a";
            satBuilder += "\x0a\x0a"; //pular linha
            satBuilder += "\x1b\x4d\x01"; //fonte pequena
            satBuilder += "\x1b\x32"; //espacamento entre linhas
            satBuilder += "\x1b\x61\x01"; //centralizar
            satBuilder += xml.GetElementsByTagName("xFant")[0].InnerText + "\x0a";
            satBuilder += xml.GetElementsByTagName("xNome")[0].InnerText + "\x0a";
            satBuilder += xml.GetElementsByTagName("xLgr")[0].InnerText + ", ";
            satBuilder += xml.GetElementsByTagName("nro")[0].InnerText + ", ";
            satBuilder += xml.GetElementsByTagName("xBairro")[0].InnerText + ", ";
            satBuilder += xml.GetElementsByTagName("xMun")[0].InnerText + ", ";
            satBuilder += "CEP " + xml.GetElementsByTagName("CEP")[0].InnerText+ "\x0a";
            String formatCNPJ = xml.GetElementsByTagName("CNPJ")[1].InnerText;
            satBuilder += "CNPJ " + Convert.ToUInt64(formatCNPJ).ToString(@"00\.000\.000\/0000\-00") + " ";
            String formatIE = xml.GetElementsByTagName("IE")[0].InnerText;
            satBuilder += "IE " + Convert.ToUInt64(formatIE).ToString(@"000\.000\.000\.000") + " ";
            satBuilder += "IM " + xml.GetElementsByTagName("IM")[0].InnerText + "\x0a";
            satBuilder += "----------------------------------------------------------------" + "\x0a";
            satBuilder += "\x1b\x45\x01";
            satBuilder += "Extrato No. " + xml.GetElementsByTagName("cNF")[0].InnerText + "\x0a";
            satBuilder += "CUPOM FISCAL ELETRÔNICO SAT" + "\x0a";

            String spaceChar = "";
            String cnpj = xml.GetElementsByTagName("CNPJ")[0].InnerText;
            String date = xml.GetElementsByTagName("dEmi")[0].InnerText;
            String time = xml.GetElementsByTagName("hEmi")[0].InnerText;
            String total = xml.GetElementsByTagName("vCFe")[0].InnerText;
            String signature = xml.GetElementsByTagName("assinaturaQRCODE")[0].InnerText;

            
            String xmlNfKey = xml.SelectSingleNode("/CFe/infCFe/@Id").Value.Substring(3,44);
            
            String nfKey = "";
            for(int i = 0; i < 11; i++) {
                nfKey += xmlNfKey.Substring(i*4, 4) + " ";
            }


             switch (type) {
                case 1: satBuilder += satNFCe(); break;
                case 2: satBuilder += satCancelamento(); break;
                default: return "Invalid option for SAT TYPE";
            }

            String satNFCe() {
                String builder = "";

                builder += "----------------------------------------------------------------" + "\x0a";
                builder += "\x1b\x61\x00";
                builder += "\x1b\x45\x00";
                builder += "CPF/CNPJ do Consumidor: " + cnpj + "\x0a";
                builder += "\x1b\x45\x01";
                builder += "TOTAL: " + total + "\x0a";

                builder += "\x1b\x45\x00"; //neg-off
                builder += "\x1b\x21\x00"; //texto normal
                builder += "------------------------------------------------" + "\x0a";
                builder += "#|COD|DESC|QTD|UN|VL UN R$|(VLTR R$)*|VL ITEM R$" +"\x0a";
                builder += "------------------------------------------------" + "\x0a";
                builder += "\x1b\x61\x00";
                builder += "\x1b\x4d\x01";

                XmlNodeList productList = xml.GetElementsByTagName("prod");
                int count = 0;
                for (int i = 0; i < productList.Count; i++) {
                    //satBuilder += productList[i].InnerText;
                    builder += xml.GetElementsByTagName("cProd")[i].InnerText + " ";
                    builder += xml.GetElementsByTagName("xProd")[i].InnerText + " ";
                    builder += xml.GetElementsByTagName("uCom")[i].InnerText + " ";
                    builder += xml.GetElementsByTagName("qCom")[i].InnerText + " X ";
                    builder += xml.GetElementsByTagName("vUnCom")[i].InnerText + " (";
                    builder += xml.GetElementsByTagName("vItem12741")[i].InnerText + ") ";
                    builder += xml.GetElementsByTagName("vProd")[i].InnerText;
                    builder += "\x0a";
                    count++;
                }

                builder += "________________________________________________________________" + "\x0a";
                String amount = xml.GetElementsByTagName("vProd")[count].InnerText;
                builder += "Total bruto de itens: " + spaceChar.PadLeft(42 - amount.ToString().Length) + amount + "\x0a";
                String desAddSub = xml.GetElementsByTagName("vDesc")[0].InnerText;
                builder += "Total de descontos/acréscimos sobre item: " + spaceChar.PadLeft(22 - desAddSub.ToString().Length) + desAddSub + "\x0a";
                //String addSub = xml.GetElementsByTagName("vAcresSubtot")[0].InnerText;
                //builder += "Desconto sobre subtotal: " + spaceChar.PadLeft(39 - addSub.Length) + addSub + "\x0a";
                builder += "Desconto sobre subtotal: " + spaceChar.PadLeft(34) + "-0.00" + "\x0a";
                //String discountSub = xml.GetElementsByTagName("vDescSubtot")[0].InnerText;
                //builder += "Desconto sobre subtotal: " + spaceChar.PadLeft(39 - discountSub.Length) + discountSub + "\x0a";
                builder += "Desconto sobre subtotal: " + spaceChar.PadLeft(35) + "0.00" + "\x0a";

                builder += "\x1b\x45\x01";
                String amountToPay = xml.GetElementsByTagName("vCFe")[0].InnerText;
                builder += "Valor a Pagar R$: " + spaceChar.PadLeft(46 - amountToPay.Length) + amountToPay + "\x0a";
                builder += "\x1b\x45\x00";
                builder += "________________________________________________________________" + "\x0a";
                builder += "FORMA DE PAGAMENTO                                    VALOR PAGO" + "\x0a";
                String typeOfPayment = xml.GetElementsByTagName("cMP")[0].InnerText;

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

                String amountPaid = xml.GetElementsByTagName("vMP")[0].InnerText;
                builder += typeOfPayment + spaceChar.PadLeft(64 - amountPaid.Length - typeOfPayment.Length) + amountPaid;
                builder += "________________________________________________________________" + "\x0a\x0a";





                String satNumber = xml.GetElementsByTagName("nserieSAT")[0].InnerText;
                builder += "\x1b\x61\x01";
                builder += "SAT No. " + "\x1b\x45\x01" + satNumber + "\x0a";
                builder += "\x1b\x45\x00";
                builder += date.Substring(6, 2) + "/" + date.Substring(4, 2) + "/" + date.Substring(0, 4) + " - ";
                builder += time.Substring(0, 2) + ":" + time.Substring(2, 2) + ":" + time.Substring(4, 2);
                builder += "\x0a\x0a";
                builder += nfKey;
                builder += "\x0a";
                string code128c = printCODE128C.PrintCODE128C(xmlNfKey);
                builder += code128c;
                builder += "\x0a\x0a";
                String qrCode = printQRCODE.EncodeQRCODE(buildQRCode()) + "\x0a";
                builder += qrCode;
                builder += "Consulte o QR Code pelo aplicativo [nome_do_aplicativo], disponível na AppStore(Apple) e PlayStore(Android)" + "\x0a";

                return builder;
            }
            
            String satCancelamento() {
                String builder = "";
                builder += "CANCELAMENTO" + "\x0a";
                builder += "----------------------------------------------------------------" + "\x0a";
                builder += "\x1b\x61\x00";
                builder += "DADOS DO CUPOM ELETRÔNICO CANCELADO" + "\x0a";
                builder += "\x1b\x45\x00";
                builder += "CPF/CNPJ do Consumidor: "+ cnpj + "\x0a";
                builder += "\x1b\x45\x01";
                builder += "TOTAL: " + total + "\x0a";
                builder += "\x1b\x45\x00";
                String satNumber = xml.GetElementsByTagName("nserieSAT")[0].InnerText;
                builder += "\x1b\x61\x01";
                builder += "SAT No. " + "\x1b\x45\x01" + satNumber + "\x0a"; 
                builder += "\x1b\x45\x00";
                builder += date.Substring(6, 2) + "/" + date.Substring(4, 2) + "/" + date.Substring(0, 4) + " - ";
                builder += time.Substring(0,2)+":"+ time.Substring(2, 2) + ":" + time.Substring(4, 2);
                builder += "\x0a\x0a";
                builder += nfKey;
                builder += "\x0a";
                string code128c = printCODE128C.PrintCODE128C(xmlNfKey);
                builder += code128c;
                builder += "\x0a\x0a";
                String qrCode = printQRCODE.EncodeQRCODE(buildQRCode()) + "\x0a";
                builder += qrCode;
                builder += "----------------------------------------------------------------" + "\x0a";
                builder += "DADOS DO CUPOM FISCAL ELETRÔNICO DE CANCELAMENTO" + "\x0a";
                builder += "\x1b\x61\x01";
                builder += "SAT No. " + "\x1b\x45\x01" + satNumber + "\x0a";
                builder += "\x1b\x45\x00";
                builder += date.Substring(6, 2) + "/" + date.Substring(4, 2) + "/" + date.Substring(0, 4) + " - ";
                builder += time.Substring(0, 2) + ":" + time.Substring(2, 2) + ":" + time.Substring(4, 2);
                builder += "\x0a\x0a";
                builder += nfKey;
                builder += "\x0a";
                builder += code128c;
                builder += "\x0a\x0a";
                builder += qrCode + "\x0a";
                builder += "Consulte o QR Code pelo aplicativo [nome_do_aplicativo], disponível na AppStore(Apple) e PlayStore(Android)" + "\x0a";
                return builder;
            }

           String buildQRCode() {
                String builder = "";
                builder += xmlNfKey + "|";
                builder += date + time + "|";
                builder += total + "|";
                builder += cnpj + "|";
                builder += signature;
                return builder;
           }


           
            return satBuilder;
        }


        

        


    }
}
