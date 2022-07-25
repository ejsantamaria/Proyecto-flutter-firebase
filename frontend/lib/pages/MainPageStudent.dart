import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:frontend/games/game1/GameOneMain.dart';
import 'package:frontend/games/game2/gameTwoMain.dart';
import 'package:frontend/games/game3/GameThreeMain.dart';
import 'package:frontend/games/game4/gameFourMain.dart';
import 'package:frontend/games/game5/GameFiveMain.dart';
import 'package:frontend/pages/exitMenu.dart';
import 'package:frontend/pages/loginSelector.dart';
import 'package:frontend/provider/main_provider.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttonComponent.dart';
import 'package:frontend/utils/constants.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.titulo, required this.student})
      : super(key: key);
  final String titulo;
  String student;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  bool emailVerified = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var student_json = json.decode(widget.student);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      drawer: ExitMenu("Estudiante"),
      backgroundColor: Constants.BACKGROUNDS,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Constants.BUTTONS_COLOR,
          title: Text("Menú estudiante",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'TitanOne',
              ))),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text("Bienvenid@",
                style: Theme.of(context).textTheme.headline3),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 75),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Constants.BUTTONS_COLOR),
              child: ClipOval(
                  child: Icon(Icons.person, color: Constants.WHITE, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameOneMain(widget.student)));
                },
                child: Text(
                  "Recuerda el animal",
                  style: TextStyle(color: Colors.white, fontFamily: 'TitanOne'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameTwoMain(widget.student)));
                },
                child: Text(
                  "Juego del ahorcado",
                  style: TextStyle(color: Colors.white, fontFamily: 'TitanOne'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameThreeMain(widget.student)));
                },
                child: Text(
                  "Recuerda la figura",
                  style: TextStyle(color: Colors.white, fontFamily: 'TitanOne'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GameFourMain()));
                },
                child: Text(
                  "Tres en raya, juega con un amigo",
                  style: TextStyle(color: Colors.white, fontFamily: 'TitanOne'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GameFiveMainExecute()));
                },
                child: Text(
                  "Salta, salta",
                  style: TextStyle(color: Colors.white, fontFamily: 'TitanOne'),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
_showImage() {
  return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 69, 100, 69),
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        child: Image.asset("assets/logo/logo_principal.png"),
      ));
}

