unit printBITMAP;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synaser, blcksock, openDoor, CloseDoor, Printers, Dialogs, sendBinBuffer,
  Graphics, Windows;

const
  PRINT_BITMAP_COMMAND = #27#42#33;
  LINE_SPACE_24 = #27#51#24;
  LINE_SPACE_30 = #27#51#30;
  LF = #10;
  Threshhold = 127;

type
  TRGBTriple = packed record
    Blue: Byte;
    Green: Byte;
    Red: Byte;
  end;
  TBitArray = array of boolean;
  TRGBTripleArray = array[Word] of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray; // Use a PByteArray for pf8bit color.


procedure printBITMAP(path:string; printer : TBlockSerial);
procedure printBITMAP(path:string; printer : TTCPBlockSocket);

function bitmapBufferFactory(path:string):string;

implementation

procedure printBITMAP(path: string; printer : TBlockSerial);
begin
   printer.SendString(bitmapBufferFactory(path));
end;

procedure printBITMAP(path: string; printer : TTCPBlockSocket);
begin
   printer.SendString(bitmapBufferFactory(path));
end;

function bitmapBufferFactory(path:string): string;
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
  vPixel: TRGBTriple;
  vDots: TBitArray;
  vSlice : byte;
  vBit : byte;
  vTmpBit: byte;
  vVal: boolean;
  vTempStr : string;
  vBuffer : string;
  ABitmap : Graphics.TBitmap;
  Picture : TPicture;
begin
  try
    //vBuffer:='';
    new(vLine);
    Picture := TPicture.Create;
    Picture.LoadFromFile(path);
    ABitmap := Picture.Bitmap;
    if not Assigned(ABitmap) then exit;
    //ABitmap. := pf24bit;
    SetLength(vDots, (ABitmap.Height * ABitmap.Width));

    vIndex := 0;

    for vRow := 0 to ABitmap.Height-1 do begin
      vLine := ABitmap.Scanline[vRow];
      for vCol := 0 to ABitmap.Width-1 do begin
        vPixel := vLine^[vCol];
        vLuminance := Trunc((vPixel.Red * 0.3) + (vPixel.Green * 0.59) + (vPixel.Blue * 0.11));
        vDots[vIndex] := (vLuminance < Threshhold);

        inc(vIndex);

      end;
    end;

    //vBuffer := vBuffer+LINE_SPACE_24{,false};
    //vBuffer := vBuffer+' ';
    Result := LINE_SPACE_24;

    vOffset := 0;
    while (vOffset < ABitmap.Height) do begin
      //Result := Result + #27;
      //Result := Result + '*'; // Bit image mode
      Result := Result + PRINT_BITMAP_COMMAND; // 24-dot double density
      Result := Result + Char( Lo( ABitmap.Width ) );
      Result := Result + Char( Hi( ABitmap.Width ) );
      //vBuffer := vBuffer+(PRINT_BITMAP_COMMAND+AnsiChar(Lo(ABitmap.Width))+AnsiChar(Hi(ABitmap.Width)){,false});

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
          Result := Result + Chr( vSlice );
          //vTempStr := vTempStr + AnsiChar(vSlice);
        end;
      end;

      inc(vOffset, 24);
      Result := Result + #10;
      //vBuffer := vBuffer+vTempStr;
    end;
    Result := Result + LINE_SPACE_30;
    //vBuffer := vBuffer+ LF;
    //vBuffer := vBuffer+ ' ';
  finally
     vDots := nil;
  end;
  //ShowMessage(vBuffer);
  //Result := vBuffer;
end;

end.

