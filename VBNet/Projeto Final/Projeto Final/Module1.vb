Imports System.Drawing
Imports System.IO.Ports
Imports System.Text

Module Module1
    'Definição da porta serial
    Dim Serial As SerialPort
    'Buffer que limpa a formatação
    Dim buffer() As Byte = {&H1B, &H40}
    'Passa uma linha
    Dim line() As Byte = {&HA}
    'Negrito
    Dim BOLD_ON() As Byte = {&H1B, &H45, &H1}
    'Negrito fechado
    Dim BOLD_OFF() As Byte = {&H1B, &H45, &H0}
    'Centralizado
    Dim CENTRALIZE() As Byte = {&H1B, &H61, &H1}
    'Buffer para centralizado
    Dim CENTRALIZE_OFF() As Byte = {&H1B, &H61, &H0}
    'Texto a direita
    Dim RIGHT_TEXT() As Byte = {&H1B, &H61, &H2}
    'Buffer para texto a direita
    Dim RIGHT_TEXT_OFF() As Byte = {&H1B, &H61, &H0}
    'Sublinhado
    Dim UNDERLINE() As Byte = {&H1B, &H2D, &H1}
    'Buffer para sublinhado
    Dim UNDERLINE_OFF() As Byte = {&H1B, &H2D, &H0}
    'Expandido
    Dim EXPANDED1() As Byte = {&H1B, &H20, &H10}
    'Buffer para expandido
    Dim EXPANDED_OFF() As Byte = {&H1B, &H20, &H0}
    'Fonte pequena
    Dim SMALL() As Byte = {&H1B, &H4D, &H1}
    'Buffer para fonte pequena
    Dim SMALL_OFF() As Byte = {&H1B, &H40}
    'Fonte padrão
    Dim DEFAULT_FONT() As Byte = {&H1B, &H4D, &H0}
    'Buffer para fonte padrão
    Dim DEFAULT_OFF() As Byte = {&H1B, &H40}
    'Altura dupla
    Dim DOUBLE_HEIGHT() As Byte = {&H1B, &H21, &H10}
    'Buffer para altura dupla
    Dim DOUBLE_HEIGHT_OFF() As Byte = {&H1B, &H21, &H0}
    'Largura dupla
    Dim DOUBLE_WIDTH() As Byte = {&H1B, &H21, &H20}
    'Buffer para largura dupla
    Dim DOUBLE_WIDTH_OFF() As Byte = {&H1B, &H21, &H0}
    'Altura e largura dupla
    Dim DOUBLE_HW() As Byte = {&H1B, &H21, &H30}
    'Buffer para altura e largura dupla
    Dim DOUBLE_HW_OFF() As Byte = {&H1B, &H21, &H0}
    'Fonte invertida
    Dim INVERTED_FONT() As Byte = {&H1D, &H42, &H1}
    'Buffer para fonte invertida
    Dim INVERTED_FONT_OFF() As Byte = {&H1D, &H42, &H0}
    'Cortar papel
    Dim CUT() As Byte = {&H1D, &H56, &H41, &H1}
    'Buffer para cortar papel
    Dim CUT_OFF() As Byte = {&H1D, &H56, &H41, &H42}
    Dim imprimir_upca() As Byte = {&H1D, &H6B, &H0}
    Dim imprimir_upce() As Byte = {&H1D, &H6B, &H1}
    Dim imprimir_ean13() As Byte = {&H1D, &H6B, &H2}
    Dim imprimir_ean8() As Byte = {&H1D, &H6B, &H3}
    Dim imprimir_128() As Byte = {&H1D, &H6B, &H49, &HF}
    Dim imprimir_93() As Byte = {&H1D, &H6B, &H48, &HF}
    Dim imprimir_ITF() As Byte = {&H1D, &H6B, &H46, &HF}
    Dim imprimir_39() As Byte = {&H1D, &H6B, &H4, &H43, &H4F, &H44, &H45, &H20, &H33, &H39, &H0}
    'Posição
    Dim posicao_off() As Byte = {&H1D, &H48, &H0}
    Dim posicao_cima() As Byte = {&H1D, &H48, &H1}
    Dim posicao_baixo() As Byte = {&H1D, &H48, &H2}
    Dim posicao_cima_baixo() As Byte = {&H1D, &H48, &H3}
    'Fonte
    Dim fonte() As Byte = {&H1D, &H66, &H0}
    'Altura
    Dim altura() As Byte = {&H1D, &H68, &H64}
    'Largura
    Dim largura() As Byte = {&H1D, &H77, &H3}
    Sub Main()
        'openDoor()
        'printText("")
        'printUPCA("")
        'printUPCE("")
        'printEAN13("")
        'printEAN8("")
        'printCODE128("")
        'printCODE39("")
        'printCODE93("")
        'printCODEITF("")
        'printQRCODE("glau1244gertec123")
        'printBITMAP()
        'returnSerialNumber("")
        'openDrawer()
        'trigGuill()
        'closeDoor()
    End Sub
    'Função openDoor
    Function openDoor()
        Serial = New SerialPort()
        If Serial.IsOpen = True Then
            Console.WriteLine("porta está aberta")
        Else
            Serial.PortName = "COM3"
            Serial.BaudRate = 19200  ''9600
            Serial.Parity = Parity.None
            Serial.DataBits = 8
            Serial.StopBits = StopBits.One
            Serial.Open()
        End If
        Return Serial
    End Function
    'Função closeDoor
    Function closeDoor()
        If Serial.IsOpen = False Then
            Serial.Close()
            Console.WriteLine("Fechou a Porta")
        End If
        Return Serial
    End Function
    'Função printText
    Function printText(ByRef texto As String)
        Serial.Write(tagsCovert("normal <l>" +
                                "<ne>negrito tag</ne> <l>" +
                                "<alc>centralizado tag</alc> <l>" +
                                "<ald>direita tag</ald> <l>" +
                                "<su>sublinhado tag</su> <l>" +
                                "<ex>expandido tag</ex> <l>" +
                                "<c>pequena tag</c> <l>" +
                                "<p>padrao tag</p> <l>" +
                                "<da>altura dupla tag</da> <l>" +
                                "<dl>largura dupla tag</dl> <l>" +
                                "<dal>largura altura dupla tag</dal> <l>" +
                                "<fi> investido</fi> <l>"
                                ))
        Return texto.ToString
    End Function
    'Função converter tags
    Function tagsCovert(ByRef texto As String)
        Dim boldOn_string As String = System.Text.ASCIIEncoding.ASCII.GetString(BOLD_ON)
        Dim boldOff_string As String = System.Text.ASCIIEncoding.ASCII.GetString(BOLD_OFF)
        Dim underOn_string As String = System.Text.ASCIIEncoding.ASCII.GetString(UNDERLINE)
        Dim underOff_string As String = System.Text.ASCIIEncoding.ASCII.GetString(UNDERLINE_OFF)
        Dim right_string As String = System.Text.ASCIIEncoding.ASCII.GetString(RIGHT_TEXT)
        Dim rightOff_string As String = System.Text.ASCIIEncoding.ASCII.GetString(RIGHT_TEXT_OFF)
        Dim centralize_string As String = System.Text.ASCIIEncoding.ASCII.GetString(CENTRALIZE)
        Dim centralizeOff_string As String = System.Text.ASCIIEncoding.ASCII.GetString(CENTRALIZE_OFF)
        Dim exp1_string As String = System.Text.ASCIIEncoding.ASCII.GetString(EXPANDED1)
        Dim expOff_string As String = System.Text.ASCIIEncoding.ASCII.GetString(EXPANDED_OFF)
        Dim small_string As String = System.Text.ASCIIEncoding.ASCII.GetString(SMALL)
        Dim small_off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(SMALL_OFF)
        Dim default_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DEFAULT_FONT)
        Dim default_Off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DEFAULT_OFF)
        Dim doubleH_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_HEIGHT)
        Dim doubleH_off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_HEIGHT_OFF)
        Dim doubleW_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_WIDTH)
        Dim doubleW_off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_WIDTH_OFF)
        Dim doubleHW_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_HW)
        Dim doubleHW_off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(DOUBLE_HW_OFF)
        Dim inver_string As String = System.Text.ASCIIEncoding.ASCII.GetString(INVERTED_FONT)
        Dim inver_off_string As String = System.Text.ASCIIEncoding.ASCII.GetString(INVERTED_FONT_OFF)
        Dim line_string As String = System.Text.ASCIIEncoding.ASCII.GetString(line)
        Dim r_string As String = System.Text.ASCIIEncoding.ASCII.GetString(buffer)
        Dim cut1 As String = System.Text.ASCIIEncoding.ASCII.GetString(CUT)
        Dim cut1_off As String = System.Text.ASCIIEncoding.ASCII.GetString(CUT_OFF)
        'Tags
        texto = texto.Replace("<ne>", boldOn_string).
            Replace("</ne>", boldOff_string).
            Replace("<su>", underOn_string).
            Replace("</su>", underOff_string).
            Replace("<alc>", centralize_string).
            Replace("</alc>", centralizeOff_string).
            Replace("<ald>", right_string).
            Replace("</ald>", rightOff_string).
            Replace("<ex>", exp1_string).
            Replace("</ex>", expOff_string).
            Replace("<c>", small_string).
            Replace("</c>", small_off_string).
            Replace("<p>", default_string).
            Replace("</p>", default_Off_string).
            Replace("<da>", doubleH_string).
            Replace("</da>", doubleH_off_string).
            Replace("<dl>", doubleW_string).
            Replace("</dl>", doubleW_off_string).
            Replace("<dal>", doubleHW_string).
            Replace("</dal>", doubleHW_off_string).
            Replace("<fi>", inver_string).
            Replace("</fi>", inver_off_string).
            Replace("<l>", line_string).
            Replace("<r>", r_string).
            Replace("<gui>", cut1)
        Return texto.ToString
    End Function
    'Função negrito
    Function fontToBold(ByRef texto As String)
        Serial.Write(BOLD_ON, 0, BOLD_ON.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função centralizado
    Function textToCenter(ByRef texto As String)
        Serial.Write(CENTRALIZE, 0, CENTRALIZE.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função texto a direita
    Function fontToRight(ByRef texto As String)
        Serial.Write(RIGHT_TEXT, 0, RIGHT_TEXT.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função sublinhado
    Function unterline(ByRef texto As String)
        'Parâmetros para a função sublinhado
        Serial.Write(UNDERLINE, 0, UNDERLINE.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte expandido
    Function fontExpanded(ByRef texto As String)
        Serial.Write(EXPANDED1, 0, EXPANDED1.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte pequena
    Function smallFont(ByRef texto As String)
        Serial.Write(SMALL, 0, SMALL.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte padrão
    Function defaultFont(ByRef texto As String)
        Serial.Write(DEFAULT_FONT, 0, DEFAULT_FONT.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função altura dupla
    Function fontDoubleHeight(ByRef texto As String)
        Serial.Write(DOUBLE_HEIGHT, 0, DOUBLE_HEIGHT.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte largura dupla
    Function fonteDoubleWidth(ByRef texto As String)
        Serial.Write(DOUBLE_WIDTH, 0, DOUBLE_WIDTH.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte altura e largura dupla
    Function fontDoubleHW(ByRef texto As String)
        Serial.Write(DOUBLE_HW, 0, DOUBLE_HW.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função fonte invertida
    Function fontInvert(ByRef texto As String)
        Dim invertido_on() As Byte = {&H1D, &H42, &H1}
        Serial.Write(invertido_on, 0, invertido_on.Length)
        Serial.Write(texto & vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printUPCA
    Function printUPCA(ByRef texto As String)
        UPCA_OFF("123454376897")
        UPCA_CIMA("123454376897")
        UPCA_BAIXO("123454376897")
        UPCA_CIMA_BAIXO("123454376897")
        Return Serial
    End Function
    'Função printUPCE
    Function printUPCE(ByRef texto As String)
        UPCE_OFF("123456789123")
        UPCE_CIMA("123456789123")
        UPCE_BAIXO("123456789012")
        UPCE_CIMA_BAIXO("123456789012")
        Return Serial
    End Function
    'Função printEAN13
    Function printEAN13(ByRef texto As String)
        EAN13_OFF("1234543768971")
        EAN13_CIMA("1234543768971")
        EAN13_BAIXO("1234543768971")
        EAN13_CIMA_BAIXO("1234543768971")
        Return Serial
    End Function
    'Função printEAN8
    Function printEAN8(ByRef texto As String)
        EAN8_OFF("12345678")
        EAN8_CIMA("12345678")
        EAN8_BAIXO("12345678")
        EAN8_CIMA_BAIXO("12345678")
        Return Serial
    End Function
    'Função printCODE128
    Function printCODE128(ByRef texto As String)
        CODE128_OFF("12345678674523")
        CODE128_CIMA("123243546345642")
        CODE128_BAIXO("123453647653546")
        CODE128_BAIXO_CIMA("123453647653546")
        Return Serial
    End Function
    'Funçao printCODE39
    Function printCODE39(ByRef texto As String)
        CODE39_OFF("")
        CODE39_CIMA("")
        CODE39_BAIXO("")
        CODE39_CIMA_BAIXO("")
        Return Serial
    End Function
    'Função printCODE93
    Function printCODE93(ByRef texto As String)
        CODE93_OFF("223EEDTTIFFEUFH")
        CODE93_CIMA("223EEDTTIFFEUFH")
        CODE93_BAIXO("223EEDTTIFFEUFH")
        CODE93_CIMA_BAIXO("223EEDTTIFFEUFH")
        Return Serial
    End Function
    'Função printCODEITF
    Function printCODEITF(ByRef texto As String)
        CODEITF_OFF("234526347568795")
        CODEITF_CIMA("234526347568795")
        CODEITF_BAIXO("234526347568795")
        CODEITF_CIMA_BAIXO("234526347568795")
        Return Serial
    End Function
    'Função printUPCA
    Function UPCA_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upca, 0, imprimir_upca.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCA_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upca, 0, imprimir_upca.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upca, 0, imprimir_upca.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCA_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upca, 0, imprimir_upca.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printUPCE
    Function UPCE_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upce, 0, imprimir_upce.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCE_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upce, 0, imprimir_upce.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCE_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upce, 0, imprimir_upce.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function UPCE_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_upce, 0, imprimir_upce.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printEAN13
    Function EAN13_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean13, 0, imprimir_ean13.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN13_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean13, 0, imprimir_ean13.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN13_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean13, 0, imprimir_ean13.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN13_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean13, 0, imprimir_ean13.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printEAN8
    Function EAN8_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean8, 0, imprimir_ean8.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN8_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean8, 0, imprimir_ean8.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN8_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean8, 0, imprimir_ean8.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function EAN8_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ean8, 0, imprimir_ean8.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printCODE39
    Function CODE39_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_39, 0, imprimir_39.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE39_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_39, 0, imprimir_39.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE39_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_39, 0, imprimir_39.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE39_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_39, 0, imprimir_39.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printCODE128
    Function CODE128_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_128, 0, imprimir_128.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE128_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_128, 0, imprimir_128.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE128_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_128, 0, imprimir_128.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE128_BAIXO_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_128, 0, imprimir_128.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printCODEITF
    Function CODEITF_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ITF, 0, imprimir_ITF.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODEITF_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ITF, 0, imprimir_ITF.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODEITF_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(fonte, 0, fonte.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ITF, 0, imprimir_ITF.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODEITF_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_ITF, 0, imprimir_ITF.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printCODE93
    Function CODE93_OFF(ByRef texto As String)
        Serial.Write(posicao_off, 0, posicao_off.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_93, 0, imprimir_93.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE93_CIMA(ByRef texto As String)
        Serial.Write(posicao_cima, 0, posicao_cima.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_93, 0, imprimir_93.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE93_BAIXO(ByRef texto As String)
        Serial.Write(posicao_baixo, 0, posicao_baixo.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_93, 0, imprimir_93.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    Function CODE93_CIMA_BAIXO(ByRef texto As String)
        Serial.Write(posicao_cima_baixo, 0, posicao_cima_baixo.Length)
        Serial.Write(altura, 0, altura.Length)
        Serial.Write(largura, 0, largura.Length)
        Serial.Write(imprimir_93, 0, imprimir_93.Length)
        Serial.Write(texto + vbCrLf)
        Serial.Write(buffer, 0, buffer.Length)
        Return texto.ToString
    End Function
    'Função printQRCODE
    Function printQRCODE(ByRef qrTexto As String)
        Dim buffer1 As String = ""
        Dim Len As Integer = qrTexto.Length + 3
        Dim pl As Byte = Len Mod 256
        Dim ph As Byte = Len / 256

        Dim m_encondig As Encoding = Encoding.GetEncoding("iso-8859-1")
        buffer1 += m_encondig.GetString(New Byte() {29, 40, 107, 4, 0, 49, 65, 50, 0})
        buffer1 += m_encondig.GetString(New Byte() {29, 40, 107, 3, 0, 49, 67, 8})
        buffer1 += m_encondig.GetString(New Byte() {29, 40, 107, 3, 0, 49, 69, 48})
        buffer1 += m_encondig.GetString(New Byte() {29, 40, 107, pl, ph, 49, 80, 48})
        buffer1 += qrTexto
        buffer1 += m_encondig.GetString(New Byte() {29, 40, 107, 3, 0, 49, 81, 48})

        Serial.Write(buffer1, 0, buffer1.Length)
        Return qrTexto
    End Function
    'Função triGuill
    Function trigGuill()
        Serial.Write(line, 0, line.Length)
        Serial.Write(line, 0, line.Length)
        Serial.Write(line, 0, line.Length)
        Serial.Write(line, 0, line.Length)
        Serial.Write(CUT, 0, CUT.Length)
        Return Serial
    End Function
    Function openDrawer()
        Dim abre_g() As Byte = {&H1B, &H70, &H0, &HA, &H64}
        Serial.Write(abre_g, 0, abre_g.Length)
        Return abre_g
    End Function
    Function returnSerialNumber(ByRef Serial As SerialPort)
        Dim serialNum() As Byte = {&H1D, &H49, &H44}
        Serial.Write(serialNum, 0, serialNum.Length)
        Console.WriteLine(Serial.ReadByte())
        Console.ReadLine()
        Return Serial
    End Function
End Module
