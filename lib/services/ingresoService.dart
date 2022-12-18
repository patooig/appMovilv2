import 'package:http/http.dart' as http;
import '../global.dart';
import 'dart:convert';

class ingDatos {
  Future<http.Response> ingresarDatos(
      String sector, String descrip, String foto1, String foto2) async {
    print(sector);
    print(descrip);
    print(foto1);
    print(foto2);

    return await http.post(
      Uri.parse(
          'https://882aa2605781.sa.ngrok.io/api/wuakalasApi/Postwuakalas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'sector': sector,
        'descripcion': descrip,
        'id_autor': Global.getId(),
        'base64Foto1': foto1,
        'base64Foto2': foto2
      }),
    );
  }
}
