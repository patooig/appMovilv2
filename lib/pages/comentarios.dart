import 'package:Wakala/pages/detalleWakala.dart';
import 'package:Wakala/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Wakala/services/comentarioService.dart';
import 'package:Wakala/global.dart';

class comentarios extends StatefulWidget {
  final int id;

  const comentarios({key, required this.id}) : super(key: key);

  @override
  State<comentarios> createState() => _comentariosState(id);
}

class _comentariosState extends State<comentarios> {
  TextEditingController comentario = TextEditingController();
  final int id;
  _comentariosState(this.id);

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
            controller: comentario,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              addComentario(id.toString(), comentario.text, Global.getId());

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => detalleWakala(
                            id: id,
                          )));
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
