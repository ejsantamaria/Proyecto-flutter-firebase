import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/games/game2/data/words.dart';
import 'package:frontend/games/game2/model/game.dart';
import 'package:frontend/games/game2/ui/widget/figure_image.dart';
import 'package:frontend/games/game2/ui/widget/letter.dart';
import 'package:frontend/models/scoreModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:word_search/word_search.dart';

Duration _totalTime = new Duration();
var _startDate;
var _endDate;
bool _startGame = false;
bool _abandoned = false;
var student_json;
String urlMessage = "";

class GameTwoMain extends StatefulWidget {
  String student;
  GameTwoMain(this.student, {Key? key}) : super(key: key);

  @override
  State<GameTwoMain> createState() => _GameTwoMainState();
}

class _GameTwoMainState extends State<GameTwoMain> {
  @override
  void initState() {
    super.initState();
    _startDate = new DateTime.now();
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
    student_json = json.decode(widget.student);
    /* "naranja".toUpperCase(),
    "pera".toUpperCase(),
    "uva".toUpperCase(),
    "mora"*/
    var track="";
    switch (word){
      case "NARANJA":
        track = "Es una fruta cítrica, dulce, amarilla y redonda.";
        break;
      case "PERA":
        track = "Es una fruta verde, dulce y tiene la forma de un 8.";
        break;
      case "UVA":
        track = "Es una fruta morada, pequeña, dulce y redonda.";
      break;
      case "MORA":
        track = "Blanco fue mi nacimiento, verde mi niñez, roja mi madurez y negra mi vejez.";
        break;
      default:
        track = "No se pudo encontrar la fruta";
        break;    
    }
    print("Acertijo fruta"+track);
    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
                  icon: Icon(Icons.error_sharp),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Recuerda',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Constants.BLACK,fontFamily: 'TitanOne')),
                              content: Text(
                                  'En este juego debes encontrar la palabra oculta.\nPista: '+track),
                              actions: <Widget>[
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Constants.BORDER_RADIOUS)),
                                  child: Text(
                                    'Ok',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Constants.BLACK),
                                  ),
                                  color: Constants.BUTTONS_COLOR,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                  tooltip: 'Ayuda',
                ),
        ],
        title: Text(
          "Adivina la palabra",
          style: TextStyle(fontFamily: 'TitanOne'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Constants.BUTTONS_COLOR,
        leading: BackButton(
          onPressed: (() async {
            _abandoned = true;
            if (_startGame) {
              _endDate = DateTime.now();
              _totalTime = _endDate.difference(_startDate);
              print(
                  'Tiempo total: ${_totalTime.inSeconds} end date: ${_endDate} - startDate: ${_startDate}');
              await _sendToServer();
              _startGame = false;
            }
            Navigator.of(context).pop();
          }),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text("Puntaje: " + Game.score.toString() + " ptos / 6 ptos",
                style: TextStyle(fontSize: 20, fontFamily: 'TitanOne')),
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
                          _startGame = true;
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
                          if (Game.score <= 0) {
                            Game.score = 0;
                            _endDate = DateTime.now();
                            _totalTime = _endDate.difference(_startDate);
                            _abandoned = false;
                            urlMessage =
                                "https://wa.me/593${student_json["tutorPhone"]}?text=Hola tutor!\nSoy ${student_json["name"]} ${student_json["surname"]}\n" + //${student_json["phone"]}
                                    "Mi puntaje en el juego del ahorcado, es ${Game.score.toString()}ptos / 6ptos\n" +
                                    "En un tiempo total de ${_totalTime.inSeconds.toString()} segundos.";
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',
                                        style:
                                            TextStyle(fontFamily: 'TitanOne'),
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
                                        onPressed: () async {
                                          await _sendToServer();
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                            _startGame = false;
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
                                        onPressed: () async {
                                          await _sendToServer();
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                            _startGame = false;
                                          });
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Compartir resultados',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        color: Constants.BTN_GREEN,
                                        onPressed: () async {
                                          await launch(urlMessage);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else if (correct_selected.length == word.length) {
                            _abandoned = false;
                            _endDate = DateTime.now();
                            _totalTime = _endDate.difference(_startDate);
                            urlMessage =
                                "https://wa.me/593${student_json["tutorPhone"]}?text=Hola tutor!\nSoy ${student_json["name"]} ${student_json["surname"]}\n" + //${student_json["phone"]}
                                    "Mi puntaje en el juego del ahorcado, es ${Game.score.toString()}ptos / 6ptos\n" +
                                    "En un tiempo total de ${_totalTime.inSeconds.toString()} segundos.";
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',
                                        style:
                                            TextStyle(fontFamily: 'TitanOne'),
                                        textAlign: TextAlign.center),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text(
                                              '¡Buen trabajo!, has encontrado la palabra.'),
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
                                        onPressed: () async {
                                          await _sendToServer();
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                            _startGame = false;
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
                                        onPressed: () async {
                                          await _sendToServer();
                                          setState(() {
                                            Game.score = 6;
                                            Game.tries = 0;
                                            Game.selectedChar = [];
                                            correct_selected = "";
                                            word = words();
                                            _startGame = false;
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        child: Text(
                                          'Compartir resultados',
                                          style:
                                              TextStyle(color: Constants.BLACK),
                                        ),
                                        color: Constants.BTN_GREEN,
                                        onPressed: () async {
                                          await launch(urlMessage);
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
        ],
      ),
    );
  }
}

Future<void> _sendToServer() async {
  var dateNow = DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now());
  ScoreModel scoreData = new ScoreModel();
  scoreData.date = dateNow.toString();
  scoreData.game = "game2";
  scoreData.score = Game.score.toInt();
  scoreData.time = _totalTime.inSeconds.toString();
  scoreData.username = student_json['username'];
  scoreData.abandoned = _abandoned;

  FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
    CollectionReference reference;
    reference = FirebaseFirestore.instance.collection("puntajes");
    await reference.add(scoreData.toJson());
  });
}
