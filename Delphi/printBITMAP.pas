unit printBITMAP;

interface

uses
  Classes, System.SysUtils, synaser, blcksock, openDoor, CloseDoor, Vcl.Dialogs,
   sendBinBuffer, FMX.Graphics, Windows, System.UITypes;

const
  PRINT_BITMAP_COMMAND = #27#42#33;
  LINE_SPACE_24 = #27#51#24;
  LINE_SPACE_30 = #27#51#30;
  LF = #10;
  Threshhold = 127;

type
  TRgbTriple = packed record
    // do not change the order of the fields, do not add any fields
    Blue: Byte;
    Green: Byte;
    Red: Byte;
  end;

  TBitArray = array of boolean;
  TRGBTripleArray = ARRAY[Word] of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray; // Use a PByteArray for pf8bit color.


procedure printBITMAPFunction(path:string; printer : TBlockSerial)overload;
procedure printBITMAPFunction(path:string; printer : TTCPBlockSocket)overload;

function bitmapBufferFactory2(path:string):string;

implementation

procedure printBITMAPFunction(path: string; printer : TBlockSerial);
begin
   printer.SendString(bitmapBufferFactory2(path));
end;
procedure printBITMAPFunction(path: string; printer : TTCPBlockSocket);
begin
   printer.SendString(bitmapBufferFactory2(path));
end;

function bitmapBufferFactory2(path:string): string;
var
  vCol : integer;
  vRow : integer;
  vIndex : integer;
  vSliceIndex : integer;
  vBytePos : integer;
  vBitPos : integer;
  vOffset : integer;
  vLuminance : integer;
  vLine: pRGBTripleArray;
  vPixel: TAlphaColor;
  vDots: TBitArray;
  vSlice : byte;
  vBit : byte;
  vTmpBit: byte;
  vVal: boolean;
  vTempStr : string;
  vBuffer : string;
  ABitmap : FMX.Graphics.TBitmap;
  //Picture : TPicture;
  BMPData: TBitmapData;
begin
  try
    vBuffer:='';
    //Picture := TPicture.Create;

    ABitmap := FMX.Graphics.TBitmap.Create;
    ABitmap.LoadFromFile(path);
    if not Assigned(ABitmap) then exit;

    ABitmap.Map(TMapAccess.Read, BMPData);

    //ABitmap := pf24bit;
    SetLength(vDots, (ABitmap.Height * ABitmap.Width));
    vIndex := 0;

    for vRow := 0 to ABitmap.Height-1 do begin
      for vCol := 0 to ABitmap.Width-1 do begin
        vPixel := BMPData.GetPixel(vCol, vRow);
        //ShowMessage('vLuminance '+IntToStr(Trunc((TAlphaColorRec(vPixel).R * 0.3)  + (TAlphaColorRec(vPixel).G * 0.59) + (TAlphaColorRec(vPixel).B * 0.11))));
        vLuminance := Trunc((TAlphaColorRec(vPixel).R * 0.3)  + (TAlphaColorRec(vPixel).G * 0.59) + (TAlphaColorRec(vPixel).B * 0.11));
        vDots[vIndex] := (vLuminance < Threshhold);
        inc(vIndex);
      end;
    end;

    vBuffer := LINE_SPACE_24;
    //vBuffer := vBuffer+' ';

    vOffset := 0;
    while (vOffset < ABitmap.Height) do begin
      vBuffer := vBuffer+PRINT_BITMAP_COMMAND+Char(Lo(ABitmap.Width))+Char(Hi(ABitmap.Width));

      vTempStr := '';
      for vCol := 0 to ABitmap.Width-1 do begin
        for vSliceIndex := 0 to 2 do begin
          vSlice := 0;
          for vBit := 0 to 7 do begin
            vBytePos := (((vOffset div 8) + vSliceIndex) * 8) + vBit;
            vBitPos := (vBytePos * ABitmap.Width) + vCol;

            vVal := false;
            if (vBitPos < Length(vDots)) then begin
              vVal := vDots[vBitPos];
            end;

            if (vVal) then
              vTmpBit := 1
            else
              vTmpBit := 0;
            //vTmpBit := iff(vVal, 1, 0);
            vSlice := vSlice or (vTmpBit shl (7 - vBit));
          end;
          vBuffer := vBuffer + Char(vSlice);
          //vTempStr := vTempStr + AnsiChar(vSlice);
        end;
      end;

      inc(vOffset, 24);
      vBuffer := vBuffer+LF;
    end;

    vBuffer := vBuffer+ LINE_SPACE_30;
    //vBuffer := vBuffer+ ' ';
  finally
     vDots := nil;
  end;
  Result := vBuffer;
end;

end.

