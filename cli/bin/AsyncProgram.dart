import 'dart:io';
import 'dart:async';
import 'dart:convert';

int counter = 0;

main(List<String> arguments) async {

    //Timers and Callbacks
    var duration = new Duration();

    var timer = Timer.periodic(duration, timeOut);

    print('Started $getTime()');

    // Futures
    String path = Directory.current.path + '/test.txt';
    print('Appending to $path');

    var file = new File(path);

    Future<RandomAccessFile> f = file.open(mode: FileMode.APPEND);

    f.then((RandomAccessFile raf) {
        print('File has been open');
        raf.writeString('Testing ').then((value) {
            print('File has been appened with $value');
        }).catchError(() => print('An error ocurred')).whenComplete(() => raf.close());
    });

    print('% End %');

    // Await
    print('Starting');

    var aNewFile = await appenFile();

    print('Appending to file $aNewFile.path');

    // Compresion
    String data = generateData(); 

    // Original 
    var original = utf8.encode(data);

    // Compressed 
    var compressed = gzip.encode(original);

    // Decompressed
    var decompressed = gzip.decode(compressed);

    print('The original $original');
    print('Compressed $compressed');
    print('Decompressed $decompressed');

    // zlib vs gzip
    int zlib = TestCompress(ZLIB);
    int gzip = TestCompress(GZIP);
    print(gzip);
    print(zlib);

    // zip files

}

String generateData(){
    String data = '';
    for(int i = 0; i < 100; i++){
        data = data + 'hi\r\n';
    }
    return data;
}
int TestCompress(var code){
    String data = generateData();

    var original = utf8.encode(data);

    var compressed = code.encode(original);
    var decompress = code.decode(compressed);

    print('Testing $code.toString()');
    // all prints with lenght blabla

    return compressed;
}

Future<File> appenFile(){
    var file = File(Directory.current.path + '/test.txt');
    var now = DateTime.now();
    return file.writeAsStringSync(now.toString() + '\r\n', mode: FileMode.append);
}

void timeOut(Timer timer){
    print('Timeout: $getTime()');

    counter++;
    if(counter >= 5) timer.cancel();
}

String getTime(){
    var dt = DateTime.now();
    return dt.toString();
}
