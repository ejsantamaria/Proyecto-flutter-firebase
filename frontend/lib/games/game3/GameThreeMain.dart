import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/games/game3/data/info_card.dart';
import 'package:frontend/games/game3/model/gameModel.dart';
import 'package:frontend/models/scoreModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

Duration _totalTime = new Duration();
var _startDate;
var _endDate;
bool _startGame = false;
bool _abandoned = false;
var student_json;
String urlMessage = "";

class GameThreeMain extends StatefulWidget {
  String student;
  GameThreeMain(this.student, {Key? key}) : super(key: key);

  @override
  State<GameThreeMain> createState() => _GameThreeMainState();
}

class _GameThreeMainState extends State<GameThreeMain> {

  //setting text style
  TextStyle whiteText = TextStyle(color: Colors.white);
  bool hideTest = false;
  Game _game = Game();

  //game stats
  int tries = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startDate = new DateTime.now();
    _game.initGame();
  }

  @override
  Widget build(BuildContext context) {
    student_json = json.decode(widget.student);
    return Scaffold(
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
                                  'En este juego debes memorizar las cartas y encontrar sus pares correspondientes, ¡Suerte!'),
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
        backgroundColor: Constants.BUTTONS_COLOR,
        title: Text("Memoriza las cartas",style: TextStyle(fontFamily: 'TitanOne')),
        elevation: 0,
        centerTitle: true,
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
      backgroundColor: Constants.BACKGROUNDS,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              info_card("Intentos", "$tries"),
              info_card("Puntaje", "$score"),
            ],
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  itemCount: _game.gameImg!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _startGame = true;
                        print(_game.matchCheck);
                        setState(() {
                          tries++;
                          _game.gameImg![index] = _game.cards_list[index];
                          _game.matchCheck
                              .add({index: _game.cards_list[index]});
                          print(_game.matchCheck.first);
                        });
                        if (_game.matchCheck.length == 2) {
                          if (_game.matchCheck[0].values.first ==
                              _game.matchCheck[1].values.first) {
                            print("true");
                            score += 100;
                            _game.matchCheck.clear();
                          } else {
                            print("false");

                            Future.delayed(Duration(milliseconds: 500), () {
                              print(_game.gameColors);
                              setState(() {
                                _game.gameImg![_game.matchCheck[0].keys.first] =
                                    _game.hiddenCardpath;
                                _game.gameImg![_game.matchCheck[1].keys.first] =
                                    _game.hiddenCardpath;
                                _game.matchCheck.clear();
                              });
                            });
                          }
                        }
                        if (score >= 400){
                          _endDate = DateTime.now();
                          _totalTime = _endDate.difference(_startDate);
                          _abandoned = false;
                          urlMessage =
                                "https://wa.me/593${student_json["tutorPhone"]}?text=Hola tutor!\nSoy ${student_json["name"]} ${student_json["surname"]}\n" + //${student_json["phone"]}
                                    "Mi puntaje en el juego de encontrar las figuras, es ${score.toString()}ptos/ 400ptos\n" +
                                    "En un tiempo total de ${_totalTime.inSeconds.toString()} segundos.";
                          showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',style: TextStyle(fontFamily: 'TitanOne'),
                                        textAlign: TextAlign.center),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('¡Felicidades!, has encontrado todos los pares de cartas'),
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
                                            _game.initGame();
                                            score = 0;
                                            tries = 0;
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
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFB46A),
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(_game.gameImg![index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
  Future<void> _sendToServer() async {
  var dateNow = DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now());
  ScoreModel scoreData = new ScoreModel();
  scoreData.date = dateNow.toString();
  scoreData.game = "game3";
  scoreData.score = score;
  scoreData.time = _totalTime.inSeconds.toString();
  scoreData.username = student_json['username'];
  scoreData.abandoned = _abandoned;

  FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
    CollectionReference reference;
    reference = FirebaseFirestore.instance.collection("puntajes");
    await reference.add(scoreData.toJson());
  });
}
}

