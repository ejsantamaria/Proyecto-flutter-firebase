import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/games/game2/data/words.dart';
import 'package:frontend/games/game2/model/game.dart';
import 'package:frontend/games/game2/ui/widget/figure_image.dart';
import 'package:frontend/games/game2/ui/widget/letter.dart';
import 'package:frontend/games/game2/ui/colors.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:word_search/word_search.dart';

class GameTwoMain extends StatefulWidget {
  GameTwoMain({Key? key}) : super(key: key);

  @override
  State<GameTwoMain> createState() => _GameTwoMainState();
}

class _GameTwoMainState extends State<GameTwoMain> {
  @override
  void initState() {
    super.initState();
    Game.score = 6;
    Game.tries = 0;
    Game.selectedChar = [];
    correct_selected = "";
    word = words();
  }

  //choosing the game word
  List<String> fruits = [
    "naranja".toUpperCase(),
    "pera".toUpperCase(),
    "uva".toUpperCase(),
    "mora".toUpperCase()
  ];

  List<int> weights = [1, 2, 3, 4];
  //String word = "Perro".toUpperCase();
  //String word = "Gato".toUpperCase();
  //Create a list that contains the Alphabet, or you can just copy and paste it

  //String word = "Hola".toUpperCase();
  String word = words();
  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  String correct_selected = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_YELLOW,
      appBar: AppBar(
        title: Text("Adivina la palabra"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.APP_BAR_ORANGE,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text("Puntaje: " + Game.score.toString() + " pts / 6 pts",
                style: TextStyle(
                  fontSize: 20,
                )),
            alignment: Alignment.bottomCenter,
            height: 23,
          ),
          Center(
            child: Stack(
              children: [
                //let's make the figure widget
                //let's add the images to the asset folder
                //Okey now we will create a Game class
                //Now the figure will be built according to the number of tries
                figureImage(Game.tries >= 0, "assets/hang.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png"),
              ],
            ),
          ),
          //Now we will build the Hidden word widget
          //now let's go back to the Game class and add
          // a new variable to store the selected character
          /* and check if it's on the word */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: word
                .split('')
                .map((e) => letter(e.toUpperCase(),
                    !Game.selectedChar.contains(e.toUpperCase())))
                .toList(),
          ),
          //Now let's build the Game keyboard
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: Game.selectedChar.contains(e)
                      ? null // we first check that we didn't selected the button before
                      : () {
                          setState(() {
                            Game.selectedChar.add(e);
                            print(Game.selectedChar);
                            if (!word.split('').contains(e.toUpperCase())) {
                              Game.tries++;
                              Game.score--;
                            } else {
                              correct_selected += e;
                              print(correct_selected);
                            }
                          });
                          //
                          if (Game.score == 0) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',
                                        textAlign: TextAlign.center),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Intentos agotados'),
                                          Text('Ahora, ¿Qué quieres hacer?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Volver a jugar',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        color: Constants.BTN_GREEN,
                                        onPressed: () {
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Salir del juego',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        //color: Constants.BUTTONS_COLOR,
                                        color: Constants.BTN_RED,
                                        onPressed: () {
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if(correct_selected.length == word.length) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',
                                        textAlign: TextAlign.center),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('¡Buen trabajo!, has encontrado la palabra.'),
                                          Text('Ahora, ¿Qué quieres hacer?.'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Volver a jugar',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        color: Constants.BTN_GREEN,
                                        onPressed: () {
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Salir del juego',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        //color: Constants.BUTTONS_COLOR,
                                        color: Constants.BTN_RED,
                                        onPressed: () {
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: Game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                );
              }).toList(),
            ),
          ),
          /*Game.tries == 6 ?
          AlertDialog(
            title: const Text('Fin del juego',
                          textAlign: TextAlign.center),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Intentos agotados',
                                textAlign: TextAlign.center),
                            Text('Ahora que quieres hacer?',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.BORDER_RADIOUS)),
                          child: Text(
                            'Volver a jugar',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Constants.BLACK),
                          ),
                          color: Constants.BTN_GREEN,
                          onPressed: () {
                            setState(() {
                              Game.tries = 0;
                              GameTwoMain();
                            });
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.BORDER_RADIOUS)),
                          child: Text(
                            'Salir del juego',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Constants.BLACK),
                          ),
                          //color: Constants.BUTTONS_COLOR,
                          color:Constants.BTN_RED,
                          onPressed: () {
                            setState(() {
                              Game.tries = 0;
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ],
          ): Game.score >= 6 ? AlertDialog(): AlertDialog()*/
        ],
      ),
    );
  }
}
