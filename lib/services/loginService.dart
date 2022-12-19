import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<http.Response> validar(String login, String pass) async {
    String link =
        'https://d22292e4f79c.sa.ngrok.io/api/usuariosApi/GetUsuario?email=' +
            login +
            '&password=' +
            pass;
    return await http.get(
      Uri.parse(link),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
