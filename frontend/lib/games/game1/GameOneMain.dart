import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/games/game1/models/TileModel.dart';
import 'package:frontend/games/game1/data/data.dart';
import 'package:frontend/utils/constants.dart' as Constants;


class GameOneMenu extends StatefulWidget {
  String student;
  GameOneMenu(this.student, {Key? key}) : super(key: key);
  @override
  State<GameOneMenu> createState() => _GameOneMenuState();
}

class _GameOneMenuState extends State<GameOneMenu> {
  List<TileModel> gridViewTiles = [];
  List<TileModel> questionPairs = [];

  var student_json={};

  @override
  void initState() {
    // TODO: implement initState
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
    print("Informacion de estudiante: "+student_json.toString());


    return Scaffold(
      backgroundColor: Constants.BACKGROUND_YELLOW,
      appBar: AppBar(
        backgroundColor: Constants.APP_BAR_ORANGE,
        title: Text("Memoriza las cartas"),
        leading: BackButton(
          onPressed: () {
            setState(() {
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
              points != 800
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$points/800",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Puntaje",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              points != 800
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
                            style: TextStyle(color: Constants.BLACK),
                          ),
                          color: Constants.BTN_GREEN,
                          onPressed: () {
                            setState(() {
                              points = 0;
                              reStart();
                            });
                            sendToServer();
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
                              points = 0;
                              reStart();
                              Navigator.of(context).pop();
                              sendToServer();
                            });
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

  sendToServer() async {
    var now = new DateTime.now().toString();
    var score_day = {
      "days": {
        "$now":{
          "game1:" : points.toString()
        }
      },

      };
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection("usuario");
      QuerySnapshot pd = await reference.get();
      String docUid = "";
      for (var doc in pd.docs) {
        if (student_json['username'] == doc.get("username").toString()) {
          docUid = doc.id;
          break;
        }
      }
      await reference.doc(docUid).update(score_day);
    });
  }
}

class Tile extends StatefulWidget {
  String imagePathUrl;
  int tileIndex;
  _GameOneMenuState parent;

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
              print("add point");
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
