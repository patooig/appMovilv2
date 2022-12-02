import 'package:http/http.dart' as http;
import '../global.dart';
import 'dart:convert';

class ingDatos {
  Future<http.Response> ingresarDatos(String titulo, String texto) async {
    var data = {'login': Global.login, 'titulo': texto, 'texto': titulo};
    final String jsonString = jsonEncode(data);
    return await http.post(
      Uri.parse('https://40fd422c6d4d.sa.ngrok.io/api/mensajes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonString,
    );
  }
}
