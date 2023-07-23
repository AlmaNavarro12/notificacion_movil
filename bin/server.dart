import 'dart:async';

import 'package:socket_io/socket_io.dart';

void main(){
  final server = Server();

  server.on('connection', (client) {
    print ('Connection to $client');

    client.on('message', (data) {
      print ('Mensaje: $data');
    });

    Timer(Duration(seconds: 5), () {
      client.emit('msg', 'Hello from server');
    });
  });

  server.listen(3000);
}