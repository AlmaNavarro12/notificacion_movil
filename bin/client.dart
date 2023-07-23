import 'dart:convert';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

void main(){
  final client = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

  client.onConnect((_){
    print('Connected');

    readLine()
    .listen((String line) => client.emit('message', line));
  });

  client.on('message', (data) => _printFromServer(data));
}

Stream<String> readLine () => stdin
.transform(utf8.decoder)
.transform(const LineSplitter());

void _printFromServer(String message) => print(message);

