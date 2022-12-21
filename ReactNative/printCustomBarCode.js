const net = require('net')

function printCustomBarCode(socket, height, width, hri, systemBarCode, value) {
    switch (systemBarCode) {
        case 'CODE128':
            socket.write(BuildCustomBarCode('\x1d\x6b\x49\x0f'));
            break; 
        case 'CODE39':
            socket.write(BuildCustomBarCode('\x1d\x6b\x04\x43\x4f\x44\x45\x20\x33\x39\x00'));
            break; 
            case 'CODE93':
            socket.write(BuildCustomBarCode('\x1d\x6b\x48\x0f'));
            break; 
        case 'EAN13':
            socket.write(BuildCustomBarCode('\x1d\x6b\x02'));
            break; 
        case 'ITF':
            socket.write(BuildCustomBarCode('\x1d\x6b\x46\x0f'));
            break; 
        case 'UPCA':
            socket.write(BuildCustomBarCode('\x1d\x6b\x00'));
            break; 
        case 'UPCE':
            socket.write(BuildCustomBarCode('\x1d\x6b\x01'));
            break; 
        default:
            socket.write('Invalid option for System Bar Code.');
            break; 
    }

    function BuildCustomBarCode(hexCommand) {
        var hriPreCommand = "\x1d\x48";
        var heightPreCommand = "\x1d\x68";
        var widthPreCommand = "\x1d\x77";
        var hriOptions = [0, 1, 2, 3];
        var heightCheck = false;
        var widthOptions = [1, 2, 3, 4, 5, 6];
         
        for (var i = 1; i <= 255; i++) {
            if(i == height) {
                heightCheck = true;
            }
        }

        if (hriOptions.includes(hri) == false) {
            return "Invalid option for HRI";
        } else if (heightCheck == false) {
            return "Invalid option for HEIGHT";
        } else if (widthOptions.includes(width) == false) {
            return "Invalid option for WIDTH";
        }

        var  customBarCode = hriPreCommand;
                customBarCode += String.fromCharCode(hri);
                customBarCode += heightPreCommand;
                customBarCode += String.fromCharCode(height);
                customBarCode += widthPreCommand;
                customBarCode += String.fromCharCode(width);
                customBarCode += hexCommand;
                customBarCode += value;
        return customBarCode;
    }
    
}

export {printCustomBarCode};