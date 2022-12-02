import 'dart:convert';
import 'package:demo_login/pages/ingreso.dart';
import 'package:demo_login/pages/integrantes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../global.dart';
import 'package:demo_login/pages/login.dart';
import 'package:http/http.dart' as http;

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<MensajesApi> parseMensajes(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<MensajesApi>((json) => MensajesApi.fromJson(json))
        .toList();
  }

  Future<List<MensajesApi>> obtDatos() async {
    var url = Uri.parse("https://40fd422c6d4d.sa.ngrok.io/api/mensajes");
    final rep = await http.get(url);
    if (rep.statusCode == 200) {
      return parseMensajes(rep.body);
    } else {
      throw Exception("Fallo al obtener datos");
    }
  }

  Widget cuadro_indicador(
      String fecha, String login, String titulo, String texto) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            width: double.infinity,
            height: 100 + (titulo.length / 10 + texto.length / 10) * 4.2,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lime[100]),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Fecha: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(fecha.substring(0, 10) +
                          '  ' +
                          fecha.substring(11, 16))
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Login: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(login)
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Titulo: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Flexible(
                        child: Text(titulo),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Descripción: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Flexible(child: Text(texto))
                    ],
                  ),
                ],
              )),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supermensajes'),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<List<MensajesApi>>(
          future: obtDatos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              AsyncSnapshot<List<MensajesApi>> ls = snapshot;
              List<MensajesApi>? lll = ls.data?.cast<MensajesApi>();

              return SingleChildScrollView(
                controller: null,
                child: Column(children: [
                  for (int i = 0; i < lll!.length; i++)
                    cuadro_indicador(
                        lll.elementAt(i).fecha,
                        lll.elementAt(i).login,
                        lll.elementAt(i).texto,
                        lll.elementAt(i).titulo)
                ]),
              );
            } else if (snapshot.hasError) {
              return const Text("ERROR");
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mensajes',
        backgroundColor: Colors.cyan,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Ingreso()));
        },
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset('assets/usuario.png', fit: BoxFit.contain),
            ),
            Center(
              child: Text('Bienvenid@, ' + Global.login),
            ),
            ListTile(
              title: const Text('Agregar'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Ingreso()));
              },
            ),
            ListTile(
              title: const Text('Integrantes'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Integrantes()));
              },
            ),
            ListTile(
              title: const Text('Salir'),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return login();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}

class MensajesApi {
  MensajesApi({
    required this.id,
    required this.login,
    required this.titulo,
    required this.texto,
    required this.fecha,
  });

  int id;
  String login;
  String titulo;
  String texto;
  String fecha;

  factory MensajesApi.fromJson(Map<String, dynamic> json) => MensajesApi(
        id: json["id"],
        login: json["login"],
        titulo: json["titulo"],
        texto: json["texto"],
        fecha: (json["fecha"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "login": login,
        "titulo": titulo,
        "texto": texto,
        "fecha": fecha,
      };
}
