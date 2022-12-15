import 'dart:io';

import 'package:camera/camera.dart';
import 'package:demo_login/pages/principal.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:demo_login/services/ingresoService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Ingreso extends StatefulWidget {
  const Ingreso({super.key});

  @override
  State<Ingreso> createState() => _IngresoState();
}

class _IngresoState extends State<Ingreso> {
  TextEditingController titulo = TextEditingController();
  TextEditingController texto = TextEditingController();

  late Future<void> _initializeControllerFuture; //for camera
  late CameraController _controller; //controller for camera

  File? _image; //for image picker
  File? _image2; //for image picker

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

// You must wait until the controller is initialized before displaying the
// camera preview. Use a FutureBuilder to display a loading spinner until the
// controller has finished initializing.

  loadCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Avisar por nuevo wakala'),
          backgroundColor: Colors.orange[800],
        ),
        body: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Sector"),
                maxLines: 1,
                controller: titulo,
              )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Descripcion"),
                maxLines: 1,
                controller: texto,
              )),
          Row(
            children: [
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image == null) return;

                        final ImageTemporal = File(image.path);

                        setState(() {
                          this._image = ImageTemporal;
                        });
                      },
                      child: Text('Añadir imagen 1'),
                      style: ElevatedButton.styleFrom(primary: Colors.cyan)),
                  Container(
                    //Show the imageFile1
                    padding: EdgeInsets.all(30),
                    child: _image == null
                        ? Text("No image captured")
                        : Image.file(
                            File(_image!.path),
                            height: 200,
                          ),
                  ) //display captured image
                  ,
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Borrar'),
                      style: ElevatedButton.styleFrom(primary: Colors.white24))
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final image2 = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image2 == null) return;

                        final ImageTemporal2 = File(image2.path);

                        setState(() {
                          this._image2 = ImageTemporal2;
                        });
                      },
                      child: Text('Añadir imagen 2'),
                      style: ElevatedButton.styleFrom(primary: Colors.cyan)),
                  Container(
                    //show captured image
                    padding: EdgeInsets.all(30),
                    child: _image == null
                        ? Text("No image captured")
                        : Image.file(
                            File(_image!.path),
                            height: 200,
                          ),
                  ) //display captured image
                  ,
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Borrar'),
                      style: ElevatedButton.styleFrom(primary: Colors.white24))
                ],
              ),
            ],
          ),
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
            child: const Text('Denunciar wakala !'),
            style: ElevatedButton.styleFrom(primary: Colors.green),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Principal()));
              },
              child: Text('Me arrepentí'),
              style: ElevatedButton.styleFrom(primary: Colors.red)),
        ]));
  }
}
