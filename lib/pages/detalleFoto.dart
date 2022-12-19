import 'package:flutter/material.dart';

class detalleFoto extends StatefulWidget {
  final String url;
  const detalleFoto({key, required this.url}) : super(key: key);

  @override
  State<detalleFoto> createState() => _detalleFotoState(url);
}

class _detalleFotoState extends State<detalleFoto> {
  late final String url;
  _detalleFotoState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Detalle foto Wakala'),
          backgroundColor: Colors.orange[800]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(children: [
              Image.network('https://d22292e4f79c.sa.ngrok.io/images/' + url,
                  width: 250, fit: BoxFit.fill),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Regresar'),
              ),
            ]),
          )),
    );
  }
}
