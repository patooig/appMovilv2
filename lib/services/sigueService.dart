import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> updateCountSigue(String id) {
  return http.put(
    Uri.parse(
        'https://882aa2605781.sa.ngrok.io/api/wuakalasApi/PutSigueAhi/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{}),
  );
}
