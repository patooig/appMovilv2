import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> addComentario(id_wakala, descripcion, id_autor) {
  return http.put(
    Uri.parse(
        'https://882aa2605781.sa.ngrok.io/api/comentariosApi/Postcomentario/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id_wakala': id_wakala,
      'descripcion': descripcion,
      'id_autor': id_autor
    }),
  );
}
