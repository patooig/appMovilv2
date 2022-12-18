import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Wakala/pages/principal.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:Wakala/services/ingresoService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Ingreso extends StatefulWidget {
  const Ingreso({super.key});

  @override
  State<Ingreso> createState() => _IngresoState();
}

class _IngresoState extends State<Ingreso> {
  TextEditingController sector = TextEditingController();
  TextEditingController descrip = TextEditingController();

  File? _image; //for image1 picker
  File? _image2; //for image2 picker
  String _base64Image1 = "";
  String _base64Image2 = "";

  Future<void> validarDatos(String sec, String desc) async {
    final response =
        await ingDatos().ingresarDatos(sec, desc, _base64Image1, _base64Image2);
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
                controller: sector,
              )),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Descripcion"),
                maxLines: 1,
                controller: descrip,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image == null) return;
                        final ImageTemporal = File(image.path);

                        Uint8List _bytes = await image.readAsBytes();
                        _base64Image1 = base64.encode(_bytes);

                        setState(() {
                          this._image = ImageTemporal;
                        });
                      },
                      child: Text('Añadir imagen 1'),
                      style: ElevatedButton.styleFrom(primary: Colors.cyan)),
                  Container(
                    //Show the imageFile1
                    padding: EdgeInsets.all(16),
                    child: _image == null
                        ? Icon(Icons.camera_alt_outlined,
                            size: 100, color: Colors.grey)
                        : Image.file(
                            File(_image!.path),
                            height: 200,
                          ),
                  ) //display captured image
                  ,
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
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

                        Uint8List _bytes = await image2.readAsBytes();
                        _base64Image2 = base64.encode(_bytes);
                        setState(() {
                          this._image2 = ImageTemporal2;
                        });
                      },
                      child: Text('Añadir imagen 2'),
                      style: ElevatedButton.styleFrom(primary: Colors.cyan)),
                  Container(
                    //show captured image
                    padding: EdgeInsets.all(16),
                    child: _image2 == null
                        ? Icon(Icons.camera_alt_outlined,
                            size: 100, color: Colors.grey)
                        : Image.file(
                            File(_image2!.path),
                            height: 200,
                          ),
                  ) //display captured image
                  ,
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _image2 = null;
                        });
                      },
                      child: Text('Borrar'),
                      style: ElevatedButton.styleFrom(primary: Colors.white24))
                ],
              ),
            ],
          ),
          Column(children: [
            ElevatedButton(
              onPressed: () {
                if (sector.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: "Ingrese sector",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                if (descrip.text.length == 0) {
                  Fluttertoast.showToast(
                      msg: "Ingrese una descripción",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                if (descrip.text.length < 15) {
                  Fluttertoast.showToast(
                      msg: "Ingrese una descripción más larga",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  validarDatos(sector.text, descrip.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Principal()));
                }
              },
              child: const Text('Denunciar wakala !'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Me arrepentí'),
                style: ElevatedButton.styleFrom(primary: Colors.red)),
          ]),
        ]));
  }
}
