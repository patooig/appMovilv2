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
  List<ListadoApi> parseMensajes(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ListadoApi>((json) => ListadoApi.fromJson(json)).toList();
  }

  Future<List<ListadoApi>> obtDatos() async {
    var url = Uri.parse(
        "https://94d890b81bf7.sa.ngrok.io/api/wuakalasApi/Getwuakalas");
    final rep = await http.get(url);
    if (rep.statusCode == 200) {
      return parseMensajes(rep.body);
    } else {
      throw Exception("Fallo al obtener datos");
    }
  }

  Widget cuadro_indicador(String sector, String autor, String fecha) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            width: double.infinity,
            height: 100,
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
                  Row(children: [
                    const Text('Sector: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Flexible(child: Text(sector))
                  ]),
                  Row(children: [
                    const Text('por: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Flexible(child: Text(autor))
                  ]),
                  Row(children: [
                    const Text('fecha: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Flexible(child: Text(fecha))
                  ])
                ],
              )),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Wakalas'),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<List<ListadoApi>>(
          future: obtDatos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              AsyncSnapshot<List<ListadoApi>> ls = snapshot;
              List<ListadoApi>? lll = ls.data?.cast<ListadoApi>();

              return SingleChildScrollView(
                controller: null,
                child: Column(children: [
                  for (int i = 0; i < lll!.length; i++)
                    cuadro_indicador(
                        lll.elementAt(i).sector.toString(),
                        lll.elementAt(i).autor.toString(),
                        lll.elementAt(i).fecha.toString())
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

class ListadoApi {
  int? id;
  String? sector;
  String? autor;
  String? fecha;

  ListadoApi({this.id, this.sector, this.autor, this.fecha});

  ListadoApi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sector = json['sector'];
    autor = json['autor'];
    fecha = json['fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector'] = this.sector;
    data['autor'] = this.autor;
    data['fecha'] = this.fecha;
    return data;
  }
}
