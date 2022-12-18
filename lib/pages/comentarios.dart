import 'package:Wakala/pages/detalleWakala.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class comentarios extends StatefulWidget {
  const comentarios({super.key});

  @override
  State<comentarios> createState() => _comentariosState();
}

class _comentariosState extends State<comentarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir comentario'), // Reemplazar por titulo
        backgroundColor: Colors.orange[800],
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const Text(
            'Comentario',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Comentar wakala'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Me arrepentí'))
        ],
      )),
    );
  }
}
