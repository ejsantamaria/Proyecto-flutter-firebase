import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/games/game1/models/TileModel.dart';
import 'package:frontend/games/game1/data/data.dart';
import 'package:frontend/models/scoreModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const maxPoints = 800; //800
Duration _totalTime = new Duration();
var _startDate;
var _endDate;
bool _startGame = false;
bool _abandoned = false;
String urlMessage = "";
var student_json;

class GameOneMain extends StatefulWidget {
  String student;
  GameOneMain(this.student, {Key? key}) : super(key: key);
  @override
  State<GameOneMain> createState() => _GameOneMainState();
}

class _GameOneMainState extends State<GameOneMain> {
  List<TileModel> gridViewTiles = [];
  List<TileModel> questionPairs = [];

  @override
  void initState() {
    // TODO: implement initState
    _startDate = new DateTime.now();
    super.initState();
    reStart();
  }

  void reStart() {
    myPairs = getPairs();
    myPairs.shuffle();
    gridViewTiles = myPairs;
    Future.delayed(const Duration(seconds: 5), () {
// Here you can write your code
      setState(() {
        print("2 seconds done");
        // Here you can write your code for open new view
        questionPairs = getQuestionPairs();
        gridViewTiles = questionPairs;
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Get a student json from mainPageStudent
    student_json = json.decode(widget.student);
    print("Informacion de estudiante: " + student_json.toString());

    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      appBar: AppBar(
        backgroundColor: Constants.BUTTONS_COLOR,
        title: Text(
          "Memoriza las cartas",
          style: TextStyle(fontFamily: 'TitanOne'),
        ),
        leading: BackButton(
          onPressed: () async {
            _abandoned = true;
            if (_startGame) {
              _endDate = DateTime.now();
              _totalTime = _endDate.difference(_startDate);
              print(
                  'Tiempo total: ${_totalTime.inSeconds} end date: ${_endDate} - startDate: ${_startDate}');
              await _sendToServer();
              _startGame = false;
            }
            setState(() {
              _startGame = false;
              points = 0;
              reStart();
            });
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              points != maxPoints
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$points/800",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'TitanOne'),
                        ),
                        Text(
                          "Puntaje",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'TitanOne'),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              points != maxPoints
                  ? GridView(
                      shrinkWrap: true,
                      //physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                      children: List.generate(gridViewTiles.length, (index) {
                        return Tile(
                          imagePathUrl:
                              gridViewTiles[index].getImageAssetPath(),
                          tileIndex: index,
                          parent: this,
                        );
                      }),
                    )
                  : AlertDialog(
                      title: const Text('Fin del juego',
                          style: TextStyle(fontFamily: 'TitanOne'),
                          textAlign: TextAlign.center),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('¡Lo hiciste muy bien!',
                                textAlign: TextAlign.center),
                            Text('¿Ahora que quieres hacer?',
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
                            style: TextStyle(
                              color: Constants.BLACK,
                            ),
                          ),
                          color: Constants.BTN_GREEN,
                          onPressed: () async {
                            _endDate = DateTime.now();
                            _totalTime = _endDate.difference(_startDate);
                            await _sendToServer();
                            setState(() {
                              points = 0;
                              reStart();
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
                          color: Constants.BTN_RED,
                          onPressed: () async {
                            _endDate = DateTime.now();
                            _totalTime = _endDate.difference(_startDate);
                            await _sendToServer();
                            setState(() {
                              points = 0;
                              reStart();
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
                            style: TextStyle(color: Constants.BLACK),
                          ),
                          color: Constants.BTN_GREEN,
                          onPressed: () async {
                            await launch(urlMessage);
                          },
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendToServer() async {
    var dateNow = DateFormat('yyyy-MM-dd KK:mm:ss').format(DateTime.now());
    ScoreModel scoreData = new ScoreModel();
    scoreData.date = dateNow.toString();
    scoreData.game = "game1";
    scoreData.score = points;
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

class Tile extends StatefulWidget {
  String imagePathUrl;
  int tileIndex;
  _GameOneMainState parent;

  Tile(
      {required this.imagePathUrl,
      required this.tileIndex,
      required this.parent});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            myPairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedTile != "") {
            /// testing if the selected tiles are same
            if (selectedTile == myPairs[widget.tileIndex].getImageAssetPath()) {
              print("add point (╯°□°)╯︵ ┻━┻");
              points = points + 100;
              print(selectedTile + " thishis" + widget.imagePathUrl);

              TileModel tileModel = new TileModel("", false);
              print(widget.tileIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                tileModel.setImageAssetPath("");
                myPairs[widget.tileIndex] = tileModel;
                print(selectedIndex);
                myPairs[selectedIndex] = tileModel;
                this.widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
              if (points >= maxPoints) {
                _endDate = DateTime.now();
                _totalTime = _endDate.difference(_startDate);
                print(
                    'Tiempo total: ${_totalTime.inSeconds} end date: ${_endDate} - startDate: ${_startDate}');
                urlMessage =
                    "https://wa.me/593${student_json["tutorPhone"]}?text=Hola tutor!\nSoy ${student_json["name"]} ${student_json["surname"]}\n" + //${student_json["phone"]}
                        "Mi puntaje en el juego encontrar los animales, es de ${points}ptos / 800ptos\n" +
                        "En un tiempo total de ${_totalTime.inSeconds.toString()} segundos.";
              }
            } else {
              print(selectedTile +
                  " thishis " +
                  myPairs[widget.tileIndex].getImageAssetPath());
              print("Mala elección");
              print(widget.tileIndex);
              print(selectedIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                this.widget.parent.setState(() {
                  myPairs[widget.tileIndex].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = myPairs[widget.tileIndex].getImageAssetPath();
              selectedIndex = widget.tileIndex;
            });

            print(selectedTile);
            print(selectedIndex);
            _startGame = true;
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: myPairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(myPairs[widget.tileIndex].getIsSelected()
                ? myPairs[widget.tileIndex].getImageAssetPath()
                : widget.imagePathUrl)
            : Container(
                color: Colors.white,
                child: Image.asset("assets/correct.png"),
              ),
      ),
    );
  }
}
