import 'dart:convert';

import 'package:Wakala/pages/detalleWakala.dart';
import 'package:Wakala/pages/ingreso.dart';
import 'package:flutter/material.dart';
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
        "https://882aa2605781.sa.ngrok.io/api/wuakalasApi/Getwuakalas");
    final rep = await http.get(url);
    if (rep.statusCode == 200) {
      return parseMensajes(rep.body);
    } else {
      throw Exception("Fallo al obtener datos");
    }
  }

  Widget cuadro_indicador(int id, String sector, String autor, String fecha) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.amber[100]),
            child: Column(children: [
              Center(
                  child: Column(
                children: [
                  Row(children: [
                    Flexible(
                        child: Text(
                      sector,
                      style: TextStyle(fontSize: 20),
                    )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detalleWakala(
                                        id: id,
                                      )));
                        },
                        icon: const Icon(Icons.arrow_forward_ios))
                  ]),
                  Row(children: [
                    const Text('por @',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    Flexible(child: Text(autor)),
                    const Text(' el ',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                    Flexible(child: Text(fecha.substring(0, 10)))
                  ]),
                ],
              )),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Wakalas'),
        backgroundColor: Colors.orange[800],
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
                  for (int i = lll!.length - 1; i >= 0; i--)
                    cuadro_indicador(
                        lll.elementAt(i).id!,
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
        tooltip: 'Añadir Wakala',
        backgroundColor: Colors.orange[800],
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Ingreso()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
