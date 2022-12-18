import 'package:Wakala/pages/comentarios.dart';
import 'package:Wakala/pages/detalleWakala.dart';
import 'package:Wakala/pages/login.dart';
import 'package:Wakala/pages/principal.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wakala',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Principal());
  }
}
