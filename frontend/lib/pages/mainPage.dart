import 'dart:async';
import 'dart:convert';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttonComponent.dart';
import 'package:frontend/models/motocycleModel.dart';
import 'package:frontend/pages/loginPages.dart';
import 'package:frontend/utils/constants.dart';
import 'dart:developer' as dev;
import 'package:provider/provider.dart';



class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.titulo, required this.motocycle})
      : super(key: key);
  final String titulo;
  final String motocycle;
  //final Motocycle motocycle;
  /*late Motocycle motocycleObject =
      Motocycle.fromJson(json.encode(this.motocycle) as Map<String, String>);*/

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool emailVerified = false;
  @override
  void initState() {
    super.initState();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Cambiar por emailVerified en cuanto se pasen a usar cuentas verificadas por correo (dejar de usar el mot@test.com)
    return new Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ESTAMOS TRABAJANDO",

            style: TextStyle(
              fontFamily: 'Titanone',
              height: 5, 
              fontSize: 20,
              color: BLACK)
            ),
            new Image.network('https://www.gifsanimados.org/data/media/1003/bob-el-constructor-imagen-animada-0043.gif'),
            Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: ButtonComponent(
                  onPressed: () {
                    //mainProvider.token = "";
                    //mainProvider.adm = false;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<Null>(builder: (BuildContext contex) {
                      return new LoginPage();
                    }), (Route<dynamic> route) => false);
                  },
                  text: "Cerrar sesión",
                  width: 100.0,

                ))
          ]
        ),
        
      )
    );
  }
}

