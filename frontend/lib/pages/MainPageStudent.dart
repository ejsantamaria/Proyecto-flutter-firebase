import 'package:flame/flame.dart';
import 'package:frontend/games/game1/GameOneMain.dart';
import 'package:frontend/games/game2/gameTwoMain.dart';
import 'package:frontend/games/game3/GameThreeMain.dart';
import 'package:frontend/games/game4/gameFourMain.dart';
import 'package:frontend/games/game5/gameFiveMain.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttonComponent.dart';
import 'package:frontend/utils/constants.dart';



class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.titulo, required this.student})
      : super(key: key);
  final String titulo;
  String student;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool emailVerified = false;


  @override
  Widget build(BuildContext context) {
    //Cambiar por emailVerified en cuanto se pasen a usar cuentas verificadas por correo (dejar de usar el mot@test.com)
    
    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  "Juego 1",
                  style: TextStyle(color: Colors.white),
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
                      MaterialPageRoute(builder: (context) => GameTwoMain(widget.student)));
                },
                child: Text(
                  "Juego 2",
                  style: TextStyle(color: Colors.white),
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
                      MaterialPageRoute(builder: (context) => GameThreeMain()));
                },
                child: Text(
                  "Juego 3",
                  style: TextStyle(color: Colors.white),
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
                  "Juego 4",
                  style: TextStyle(color: Colors.white),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GameFiveMain(robertSlapper: robertSlapper)));
                },
                child: Text(
                  "Juego 5",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
