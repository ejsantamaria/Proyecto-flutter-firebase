import 'package:flutter/material.dart';
import 'package:frontend/games/game3/data/info_card.dart';
import 'package:frontend/games/game3/model/gameModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class GameThreeMain extends StatefulWidget {
  GameThreeMain({Key? key}) : super(key: key);

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
    _game.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.APP_BAR_ORANGE,
        title: Text("Memoriza las cartas"),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Constants.BTN_RED,
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
                        print(_game.matchCheck);
                        setState(() {
                          //incrementing the clicks
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
                            //incrementing the score
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
                        if (score == 400){
                          showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fin del juego',
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
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _game.initGame();
                                            score = 0;
                                            tries = 0;
                                          });
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
}