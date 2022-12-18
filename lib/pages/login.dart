import 'package:cool_alert/cool_alert.dart';
import 'package:Wakala/global.dart';
import 'package:Wakala/pages/principal.dart';
import 'package:Wakala/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late final pref;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> validarDatos(String email, String password) async {
    final response =
        await LoginService().validar(email.toString(), password.toString());

    print(response.statusCode);

    if (response.statusCode == 200) {
      //almacenar de alguna manera el login
      await pref.setString('usuario', email);
      Global.login_global = email;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Ups...',
        text: 'El nombre de usuario y/o contraseña no es válido',
        loopAnimation: false,
      );
    }
  }

  String? login_guardado = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargaPreferencia();
  }

  void cargaPreferencia() async {
    pref = await SharedPreferences.getInstance();
    login_guardado = pref.getString("usuario");
    emailController.text = login_guardado == null ? "" : login_guardado!;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = const SizedBox(height: 30);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/wakala.png', fit: BoxFit.fill),
              ),
              sizedBox,
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Ingrese su usuario",
                      labelText: "Usuario",
                      suffixIcon: const Icon(
                        Icons.supervised_user_circle_rounded,
                        color: Colors.black54,
                      ))),
              sizedBox,
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Ingrese su contraseña",
                      labelText: "Contraseña",
                      suffixIcon: const Icon(Icons.remove_red_eye))),
              sizedBox,
              sizedBox,
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange[800], shape: StadiumBorder()),
                      onPressed: () {
                        if (emailController.text.length == 0) {
                          Fluttertoast.showToast(
                              msg: "Ingrese nombre de usuario",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (passwordController.text.length == 0) {
                          Fluttertoast.showToast(
                              msg: "Ingrese una contraseña",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          validarDatos(
                              emailController.text, passwordController.text);
                        }
                      },
                      child: Text("Ingresar"))),
              sizedBox,
              GestureDetector(
                  onLongPress: () {
                    print("Longpress");
                  },
                  onTap: () {
                    print("hola");
                  },
                  child: const Text(
                    "¿Olvido su password?",
                    style: TextStyle(color: Colors.blue),
                  )),
              Padding(padding: EdgeInsets.only(top: 18)),
              Text(
                "By: Ivonne Flores &  Patricio Inostroza",
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
      ),
    );
  }
}
