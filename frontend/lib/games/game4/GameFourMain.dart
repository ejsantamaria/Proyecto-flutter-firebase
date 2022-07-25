import 'package:flutter/material.dart';
import 'package:frontend/games/game4/ui/color.dart';
import 'package:frontend/games/game4/utils/game_logic.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class GameFourMain extends StatefulWidget {
  GameFourMain({Key? key}) : super(key: key);

  @override
  State<GameFourMain> createState() => _GameFourMainState();
}

class _GameFourMainState extends State<GameFourMain> {
  //adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  //let's declare a new Game components

  Game game = Game();

  //let's initi the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.BUTTONS_COLOR,
          title: Text("Tres en raya"),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Constants.BACKGROUNDS,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Es el turno de ${lastValue}, ¡Suerte!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            //now we will make the game board
            //but first we will create a Game class that will contains all the data and method that we will need
            Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardlenth ~/
                    3, // the ~/ operator allows you to evide to integer and return an Int as a result
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardlenth, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);
                                if (gameOver) {
                                  result = "$lastValue es el ganador";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Fin del juego',
                                              textAlign: TextAlign.center),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(result),
                                                Text(
                                                    'Ahora, ¿Qué quieres hacer?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .BORDER_RADIOUS)),
                                              child: Text(
                                                'Volver a jugar',
                                                style: TextStyle(
                                                    color: Constants.BLACK),
                                              ),
                                              color: Constants.BTN_GREEN,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  //erase the board
                                                  game.board =
                                                      Game.initGameBoard();
                                                  lastValue = "X";
                                                  gameOver = false;
                                                  turn = 0;
                                                  result = "";
                                                  scoreboard = [
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0
                                                  ];
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .BORDER_RADIOUS)),
                                              child: Text(
                                                'Salir del juego',
                                                style: TextStyle(
                                                    color: Constants.BLACK),
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
                                } else if (!gameOver && turn == 9) {
                                  result = "Es un empate";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Fin del juego',
                                              textAlign: TextAlign.center),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(result),
                                                Text(
                                                    'Ahora, ¿Qué quieres hacer?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .BORDER_RADIOUS)),
                                              child: Text(
                                                'Volver a jugar',
                                                style: TextStyle(
                                                    color: Constants.BLACK),
                                              ),
                                              color: Constants.BTN_GREEN,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  //erase the board
                                                  game.board =
                                                      Game.initGameBoard();
                                                  lastValue = "X";
                                                  gameOver = false;
                                                  turn = 0;
                                                  result = "";
                                                  scoreboard = [
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0
                                                  ];
                                                });
                                              },
                                            ),
                                            FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Constants
                                                              .BORDER_RADIOUS)),
                                              child: Text(
                                                'Salir del juego',
                                                style: TextStyle(
                                                    color: Constants.BLACK),
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
                                  gameOver = true;
                                }
                                if (lastValue == "X")
                                  lastValue = "O";
                                else
                                  lastValue = "X";
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ));
  }
}
