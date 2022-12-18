import 'dart:convert';

import 'package:Wakala/global.dart';
import 'package:http/http.dart' as http;

Future<http.Response> addComentario(id_wakala, descripcion, id_autor) {
  int id = int.parse(id_wakala);

  return http.post(
    Uri.parse(
        'https://882aa2605781.sa.ngrok.io/api/comentariosApi/Postcomentario/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id_wuakala': id,
      'descripcion': descripcion,
      'id_autor': id_autor
    }),
  );
}
