import 'dart:convert';
import 'package:Wakala/pages/comentarios.dart';
import 'package:Wakala/pages/detalleFoto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class detalleWakala extends StatefulWidget {
  final int id;
  detalleWakala({key, required this.id}) : super(key: key);

  @override
  _detalleWakalaState createState() => new _detalleWakalaState(id); //id);
}

class _detalleWakalaState extends State<detalleWakala> {
  var mappp;
  late final int id;

  Map<String, dynamic> _data = Map<String, dynamic>();
  _detalleWakalaState(this.id) {
    mappp = obtDatos(id);
  }

  int num_likes = 0;
  int num_dislikes = 0;
  bool flag_like = true;
  bool flag_dislike = true;
  bool option1 = true;
  bool option2 = true;

  String foto1 = "";

  String foto2 = "";

  Future<http.Response> updateCountSigue(int id) {
    return http.put(
      Uri.parse(
          'https://882aa2605781.sa.ngrok.io/api/wuakalasApi/PutSigueAhi/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
  }

  Future<http.Response> discountCountSigue(int id) {
    return http.put(
      Uri.parse(
          'https://882aa2605781.sa.ngrok.io/api/wuakalasApi/PutYanoEsta/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
  }

  void submit1() {
    if (flag_like) {
      setState(() {
        flag_like = false;
        option2 = false;
      });
    } else {
      setState(() {
        flag_like = true;
        option2 = true;
      });
    }
  }

  void submit2() {
    if (flag_dislike) {
      setState(() {
        num_dislikes++;
        flag_dislike = false;
        option1 = false;
      });
    } else {
      setState(() {
        num_dislikes--;
        flag_dislike = true;
        option1 = true;
      });
    }
  }

  obtDatos(idd) async {
    var url = Uri.parse(
        "https://882aa2605781.sa.ngrok.io/api/wuakalasApi/Getwuakala/$idd");
    final rep = await http.get(url);
    if (rep.statusCode == 200) {
      var data = json.decode(rep.body);
      return data;
    } else {
      throw Exception("Fallo al obtener datos");
    }
  }

  /*Widget getImagenBase64(String imagen) {
    var _imageBase64 = imagen;
    const Base64Codec base64 = Base64Codec();
    if (_imageBase64 == null) return new Container();
    var bytes = base64.decode(_imageBase64);
    return Image.memory(
      bytes,
      width: 100,
      fit: BoxFit.contain,
    );
  }*/

  Widget getImagenWeb(String imagen) {
    String url = 'https://882aa2605781.sa.ngrok.io/images/' + imagen;

    if (imagen == null || imagen == '') {
      return new Container();
    } else
      return Image.network(
        url,
        width: 125,
        fit: BoxFit.fill,
      );
  }

  Widget cuadro_comentarios(String nombre, String comentario) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    comentario,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Por @' + nombre,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                )
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Wakala'), // Reemplazar por titulo
        backgroundColor: Colors.orange[800],
      ),
      body: FutureBuilder(
          future: mappp,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Column(children: [
                        SizedBox(height: 1),
                        Text(snapshot.data['sector'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        SizedBox(height: 20),
                        Text(
                          snapshot.data['descripcion'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detalleFoto(
                                              url:
                                                  snapshot.data['url_foto1'])));
                                },
                                child: getImagenWeb(snapshot.data['url_foto1']),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detalleFoto(
                                              url:
                                                  snapshot.data['url_foto2'])));
                                },
                                child: getImagenWeb(snapshot.data['url_foto2']),
                              )
                            ]),
                        SizedBox(height: 8),
                        Text(
                            'Subido por: ' +
                                snapshot.data['autor'] +
                                ' el ' +
                                snapshot.data['fecha_publicacion']
                                    .toString()
                                    .substring(0, 10), // Reemplazar por autor
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              // Boton de SIGUE AHI
                              onPressed: option1
                                  ? () => {
                                        if (flag_like)
                                          {
                                            num_likes =
                                                snapshot.data['sigue_ahi'],
                                            snapshot.data['sigue_ahi']++,
                                            submit1()
                                          }
                                        else
                                          {
                                            snapshot.data['sigue_ahi']--,
                                            submit1()
                                          },
                                      }
                                  : null,
                              child: Text('Sigue ahí (' +
                                  snapshot.data['sigue_ahi'].toString() +
                                  ')'),
                              style: ElevatedButton.styleFrom(
                                  primary: CupertinoColors.activeGreen),
                            ),
                            ElevatedButton(
                              // Boton de YA NO ESTA
                              onPressed: option2
                                  ? () => {
                                        if (flag_dislike)
                                          {
                                            num_dislikes =
                                                snapshot.data['ya_no_esta'],
                                            snapshot.data['ya_no_esta']++,
                                            submit2()
                                          }
                                        else
                                          {
                                            snapshot.data['ya_no_esta']--,
                                            submit2()
                                          },
                                      }
                                  : null,
                              child: Text('Ya no está (' +
                                  snapshot.data['ya_no_esta'].toString() +
                                  ')'),
                              style: ElevatedButton.styleFrom(
                                  primary: CupertinoColors.destructiveRed),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Comentarios: ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Expanded(child: SizedBox()),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              comentarios(id: id)));
                                },
                                child: Text(
                                  'Comentar',
                                  textAlign: TextAlign.right,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[800]))
                          ],
                        ),
                        for (int i = 0;
                            i < snapshot.data['comentarios'].length;
                            i++)
                          cuadro_comentarios(
                              snapshot.data['comentarios'][i]['autor'],
                              snapshot.data['comentarios'][i]['descripcion']),
                        ElevatedButton(
                            onPressed: () {
                              if (flag_like == false && flag_dislike == true) {
                                updateCountSigue(id);
                              }
                              if (flag_dislike == false && flag_like == true) {
                                discountCountSigue(id);
                              }
                              Navigator.pop(context);
                            },
                            child: Text('Guardar y volver'))
                      ]),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

// To parse this JSON data, do
//
//     final wakalaInfo = wakalaInfoFromJson(jsonString);

WakalaInfo wakalaInfoFromJson(String str) =>
    WakalaInfo.fromJson(json.decode(str));

String wakalaInfoToJson(WakalaInfo data) => json.encode(data.toJson());

class WakalaInfo {
  int? id;
  String? sector;
  String? descripcion;
  String? fechaPublicacion;
  String? autor;
  String? urlFoto1;
  String? urlFoto2;
  int? sigueAhi;
  int? yaNoEsta;
  List<Comentario>? comentarios;

  WakalaInfo({
    this.id,
    this.sector,
    this.descripcion,
    this.fechaPublicacion,
    this.autor,
    this.urlFoto1,
    this.urlFoto2,
    this.sigueAhi,
    this.yaNoEsta,
    this.comentarios,
  });

  WakalaInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    sector = json["sector"];
    descripcion = json["descripcion"];
    fechaPublicacion = json["fecha_publicacion"];
    autor = json["autor"];
    urlFoto1 = json["url_foto1"];
    urlFoto2 = json["url_foto2"];
    sigueAhi = json["sigue_ahi"];
    yaNoEsta = json["ya_no_esta"];
    comentarios = List<Comentario>.from(
        json["comentarios"].map((x) => Comentario.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector'] = this.sector;
    data['descripcion'] = this.descripcion;
    data['fecha_publicacion'] = this.fechaPublicacion;
    data['autor'] = this.autor;
    data['url_foto1'] = this.urlFoto1;
    data['url_foto2'] = this.urlFoto2;
    data['sigue_ahi'] = sigueAhi;
    data['ya_no_esta'] = yaNoEsta;
    data['comentarios'] =
        List<dynamic>.from(comentarios!.map((x) => x.toJson()));
    return data;
  }
}

class Comentario {
  int? id;
  String? descripcion;
  String? fechaComentario;
  String? autor;

  Comentario({
    this.id,
    this.descripcion,
    this.fechaComentario,
    this.autor,
  });

  Comentario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json["descripcion"];
    fechaComentario = json["fecha_comentario"];
    autor = json["autor"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descripcion'] = this.descripcion;
    data['fecha_comentario'] = this.fechaComentario;
    data['autor'] = this.autor;
    return data;
  }
}
