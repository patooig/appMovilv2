import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<http.Response> validar(String login, String pass) async {
    return await http.post(
      Uri.parse(
          'https://94d890b81bf7.sa.ngrok.io/https://94d890b81bf7.sa.ngrok.io/api/usuariosApi/Getusuario?email=test@udec.cl&password=123'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': login, 'password': pass}),
    );
  }
}
