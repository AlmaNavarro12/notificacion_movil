import 'dart:async';
import 'package:appmovil/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotifyADNG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Notify - ADNG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    listenToDataFromFirebase();
  }

  void listenToDataFromFirebase() {
    databaseReference.child('mensajes').child('notificacion').onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      dynamic data = snapshot.value;
      mostrarNotificacion('NotifyADNG', data);
      if (data is Map<dynamic, dynamic>) {
        String newMessage = data['descripcion'];
        mostrarNotificacion('NotifyADNG', newMessage);
      }
    }
  }, onError: (error) {
    mostrarNotificacion('NotifyADNG','Error al escuchar datos desde Firebase: $error');
  });
  }
  
  void writeToDatabase(String text) {
    databaseReference.child('mensajes').child('notificacion').set({
      'descripcion': text,
    });
    listenToDataFromFirebase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.7), // Ajusta la opacidad aquí (0.0 a 1.0)
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '¡Bienvenido a NotifyADNG!',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 2, // Altura de la línea
                    width: 200, // Ancho de la línea
                    color: Colors.teal, // Color de la línea
                  ),
                  const SizedBox(height: 25),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.message,
                            size: 20, color: Colors.grey), // Icono de mensaje
                        SizedBox(width: 5),
                        Text(
                          'Mensaje:',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.9,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ]),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _textEditingController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje aquí',
                      contentPadding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 80.0,
                          left: 20.0,
                          right:
                              20.0), // Aplica padding solo en la parte inferior
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Ajusta el radio para hacer los bordes redondeados
                        borderSide: const BorderSide(
                            color: Colors.teal), // Color del borde
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Ajusta el radio para hacer los bordes redondeados
                        borderSide: const BorderSide(
                            color: Colors
                                .grey), // Color del borde cuando el TextField no está enfocado
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Ajusta el radio para hacer los bordes redondeados
                        borderSide: const BorderSide(
                            color: Colors
                                .teal), // Color del borde cuando el TextField está enfocado
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  OutlinedButton(
                    onPressed: () {
                      writeToDatabase(_textEditingController.text);
                      _textEditingController.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    ),
                    child: const Text(
                      'ENVIAR',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
