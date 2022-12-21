#include <iostream>
#include <fstream>
#include <string>
#include <regex>

using namespace std;
using std::regex_replace;
using std::regex;

string printText(string texto){

    #define textBold "\x1b\x45\x01"
    #define textBold_off "\x1b\x40"
    #define textCenter "\x1b\x61\x01"
    #define textCenter_off "\x1b\x40"
    #define textRight "\x1b\x61\x02"
    #define textRight_off "\x1b\x40"
    #define textUnderline "\x1b\x2d\x02"
    #define textUnderline_off "\x1b\x40"
    #define fontExpanded "\x1b\x20\x10" // Expandido x01 a x99
    #define fontExpanded_off "\x1b\x40"
    #define fontSmall "\x1b\x4d\x01"
    #define fontSmall_off "\x1b\x40"
    #define fontDefault "\x1b\x4d\x00"
    #define fontDefault_off "\x1b\x40"
    #define fontDoubleHeight "\x1b\x21\x10"
    #define fontDoubleHeight_off "\x1b\x40"
    #define fontDoubleWidth "\x1b\x21\x20"
    #define fontDoubleWidth_off "\x1b\x40"
    #define fontDoubleHW "\x1b\x21\x30"
    #define fontDoubleHW_off "\x1b\x40"
    #define fontInvert "\x1d\x42\x01"
    #define fontInvert_off "\x1b\x40"
    #define trigGuill "\x1d\x56\x42"
    #define trigGuill_off "\x1d\x56\x42"  
    #define codebar_ean13 "\x1d\x6b\x02"
    #define codebar_off "\x1b\x40"

    texto = regex_replace(texto, regex("\\<ne>"), textBold);
    texto = regex_replace(texto, regex("\\</ne>"), textBold_off);
    texto = regex_replace(texto, regex("\\<ce>"), textCenter);
    texto = regex_replace(texto, regex("\\</ce>"), textCenter_off);
    texto = regex_replace(texto, regex("\\<ad>"), textRight);
    texto = regex_replace(texto, regex("\\</ad>"), textRight_off);
    texto = regex_replace(texto, regex("\\<su>"), textUnderline);
    texto = regex_replace(texto, regex("\\</su>"), textUnderline_off);
    texto = regex_replace(texto, regex("\\<ex>"), fontExpanded);
    texto = regex_replace(texto, regex("\\</ex>"), fontExpanded_off);
    texto = regex_replace(texto, regex("\\<c>"), fontSmall);
    texto = regex_replace(texto, regex("\\</c>"), fontSmall_off);
    texto = regex_replace(texto, regex("\\<p>"), fontDefault);
    texto = regex_replace(texto, regex("\\</p>"), fontDefault_off);
    texto = regex_replace(texto, regex("\\<da>"), fontDoubleHeight);
    texto = regex_replace(texto, regex("\\</da>"), fontDoubleHeight_off);
    texto = regex_replace(texto, regex("\\<dl>"), fontDoubleWidth);
    texto = regex_replace(texto, regex("\\</dl>"), fontDoubleWidth_off);
    texto = regex_replace(texto, regex("\\<dal>"), fontDoubleHW);
    texto = regex_replace(texto, regex("\\</dal>"), fontDoubleHW_off);
    texto = regex_replace(texto, regex("\\<fi>"), fontInvert);
    texto = regex_replace(texto, regex("\\</fi>"), fontInvert_off);
    texto = regex_replace(texto, regex("\\<gui>"), trigGuill);
    texto = regex_replace(texto, regex("\\</gui>"), trigGuill_off);
    texto = regex_replace(texto, regex("\\<cbar>"), codebar_ean13);
    texto = regex_replace(texto, regex("\\</cbar>"), codebar_off);

    return texto;

}