import 'package:demo_login/pages/principal.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:demo_login/services/ingresoService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Ingreso extends StatefulWidget {
  const Ingreso({super.key});

  @override
  State<Ingreso> createState() => _IngresoState();
}

class _IngresoState extends State<Ingreso> {
  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();

  Future<void> validarDatos(String titulo, String texto) async {
    final response = await ingDatos().ingresarDatos(titulo, texto);
    if (response.statusCode == 200) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: 'Ingreso Correcto',
        text: 'Se ingresaron los datos',
        loopAnimation: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar mensajes'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Título"),
              maxLines: 1,
              controller: titulo,
            )),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Texto"),
              maxLines: 1,
              controller: texto,
            )),
        ElevatedButton(
          onPressed: () {
            if (titulo.text.length == 0) {
              Fluttertoast.showToast(
                  msg: "Ingrese titulo",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            if (texto.text.length == 0) {
              Fluttertoast.showToast(
                  msg: "Ingrese una descripción",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              validarDatos(titulo.text, texto.text);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Principal()));
            }
          },
          child: const Text('Guardar'),
        ),
      ]),
    );
  }
}
