#include <fstream>
#include <iostream>
#include <vector>
#include <C:\Users\Marcus\Desktop\Gertec Easy Print\c++\rapidxml\rapidxml.hpp>

using namespace std;
using namespace rapidxml;

xml_document <> doc;
xml_node <> * pri_no = NULL;

string printCouponNFCe(string filePath, int type){

    ofstream serial("/dev/usb/lp0");

    string nfceType, nfceObs;
    string spaceChar = "";

    switch (type){
        case 1:
            nfceType = "Documento Auxiliar da Nota Fiscal de Consumidor Eletronica";
            nfceObs = "Nao permite aproveitamento de credito do ICMS";
            break;
        case 2:
            nfceType = "EMITIDA EM CONTINGÊNCIA";
            nfceObs = "Pendente de autorização";
            break;
        case 3:
            nfceType = "CANCELAMENTO";
            nfceObs = "Pendente de autorizaçã";
            break;
    
        default:
            return "Invalid option for NFCE TYPE";
    }

    //Ler arquivo .xml
    ifstream xml(filePath);
    vector<char> buffer((istreambuf_iterator<char>(xml)), istreambuf_iterator<char>());
    buffer.push_back('\0');

    //Analizar o buffer
    doc.parse<0>(&buffer[0]);

    //Divisão I - Informação do Cabeçalho
    string nfceBuilder = "";
    nfceBuilder += "\x0a\x0a"; //pular linha
    nfceBuilder += "\x1b\x4d\x01"; //fonte pequena
    nfceBuilder += "\x1b\x32"; //espaçamento entre linhas
    nfceBuilder += "\x1b\x61\x01"; //centralizar
    //string formatCNPJ = xml.GetElementByTagName("CNPJ")[0].InnerText;
    
    //Descubra o nó raiz
    pri_no = doc.first_node("nfeProc");

    // Iterar sobre os nós de aluno
    for (xml_node<> * seg_no = pri_no->first_node("NFe"); seg_no; seg_no = seg_no->next_sibling())
    {
        for (xml_node<> * ter_no = seg_no->first_node("infNFe"); ter_no; ter_no = ter_no->next_sibling())
        {
            for (xml_node<> * qua_no = ter_no->first_node("emit"); qua_no; qua_no = qua_no->next_sibling())
            {
                xml_node<> * qui_no = qua_no->first_node("CNPJ");
                xml_node<> * sex_no = qua_no->first_node("xNome");
                
                nfceBuilder += "CNPJ: ";
                nfceBuilder += qui_no->value();
                nfceBuilder += "\x0a";
                nfceBuilder += "\x1b\x45\x01"; //negrito on
                nfceBuilder += sex_no->value();
                nfceBuilder += "\x1b\x45\x00"; //negrito off
                nfceBuilder += "\x0a\x0a";

                for (xml_node<> * qua1_no = qua_no->first_node("enderEmit"); qua1_no; qua1_no = qua1_no->next_sibling())
                {
                    xml_node<> * qui1_no = qua1_no->first_node("xLgr");
                    xml_node<> * sex1_no = qua1_no->first_node("nro");
                    xml_node<> * set1_no = qua1_no->first_node("xBairro");
                    xml_node<> * oit1_no = qua1_no->first_node("xMun");
                    xml_node<> * non1_no = qua1_no->first_node("UF");

                    nfceBuilder += qui1_no->value();
                    nfceBuilder += ", ";
                    nfceBuilder += sex1_no->value();
                    nfceBuilder += ", ";
                    nfceBuilder += set1_no->value();
                    nfceBuilder += ", ";
                    nfceBuilder += oit1_no->value();
                    nfceBuilder += ", ";
                    nfceBuilder += non1_no->value();

                    nfceBuilder += "\x1b\x45\x01"; //negrito on
                    nfceBuilder += "\x0a\x0a" + nfceType;
                    nfceBuilder += "\x1b\x45\x00"; //negrito off
                    nfceBuilder += "\x0a\x0a";
                    nfceBuilder += nfceObs;

                    break;
                }
            }
        }
    }

    cout << nfceBuilder << endl;
}


int main(void){

    printCouponNFCe("nfce.xml", 1);

}
