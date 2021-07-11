import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
    // TCP Server 
    var serverSocket = await ServerSocket.bind('127.0.0.1', 3000);
    print('Listening');

    await for(var socket in serverSocket){
        socket.listen((List values) {
            print('$socket.remoteAddress : $socket.remotePort = $utf8.decode(values)');
        });
    }

    // TCP CLient
    var socket = await Socket.connect('127.0.0.1', 3000);
    print('Connected');

    socket.write('Hello');
    print('Sent, closing');
    await socket.close();
    print('Closed');

    // HTTP get
    var url = 'http//httpbin.org';
    var response = await http.get(url);
    print('Response status $response.statusCode');
    print('Response body $response.body');

    // HTTP post
    var url2 = 'http//httpbin.org/post';
    var response2 = await http.post(url2, body:'name=Malcom&color=green');
    print('Response status $response2.statusCode');
    print('Response body $response2.body');

    // UDP socket

    var data = 'data';
    List<int> dataToSend = utf8.encode(data);
    int port = 3000;

    // Server
    RawDatagramSocket.bind(InternetAddress.LOOPBACK_IP_V4, port).then((RawDatagramSocket udpSocket) {
        udpSocket.listen(( RawSocketEvent event ) {
            if(event == RawSocketEvent.READ) {
                Datagram dg = udpSocket.receive();
                print(utf8.decode(dg.data));
            }
        });
        // Client 
        udpSocket.send(dataToSend, InternetAddress.loopbackIPv4, port);
        print('Send');
    });

}

