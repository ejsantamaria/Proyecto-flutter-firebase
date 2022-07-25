import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/scoreModel.dart';
import 'package:frontend/models/studentModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:google_fonts/google_fonts.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class ScoreListCard extends StatefulWidget {
  ScoreListCard({Key? key, required this.currentScore, required this.adm})
      : super(key: key);
  final Stream<QuerySnapshot> currentScore;
  final bool adm;
  @override
  _ScoreListCardState createState() => _ScoreListCardState();
}

class _ScoreListCardState extends State<ScoreListCard> {
  late String us = "";
  late String defaultimg =
      "https://i.postimg.cc/tgpdd1C0/pngegg-1.png";
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(3),
      child: StreamBuilder(
          stream: widget.currentScore,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading'));
            }
            return Container(
              child: Column(
                children: snapshot.data!.docs.map((scores) {
                  var score;
                  var game_name;
                  var max_score_game=0;
                  var _abandoned;
                  
                  score =
                      ScoreModel.fromJson(scores.data() as Map<String, dynamic>);
                  print("score boolean "+ score.abandoned.toString());
                  switch (score.game){
                    case 'game1':
                      game_name = "Recuerda el animal";
                      max_score_game = 800;
                      break;
                    case 'game2':
                      game_name = "Juego del ahorcado";
                      max_score_game = 6;
                      break;
                    case 'game3':
                      game_name = "Recuerda la figura";
                      max_score_game = 400;
                      break;
                    default:
                      game_name = "No se pudo identificar el juego";
                      break;
                  }

                  if(score.abandoned){
                    _abandoned = "Abandonó el juego antes de terminar";
                  }else{
                    _abandoned = "Terminó el juego";
                  }

                  return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: size.width * .80,
                      decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(width: 2.0, color: Colors.black)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(defaultimg),
                          radius: 30,
                          backgroundColor: Constants.WHITE,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              'Juego: ' + game_name,
                              style: GoogleFonts.raleway(
                                  color: Color.fromARGB(255, 29, 29, 29),
                                  fontSize: 18.0,
                                  textStyle:
                                      Theme.of(context).textTheme.headline4)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fecha: " + score.date+ "\nTiempo: " + score.time.toString()+ " segundos" + "\n" + _abandoned ,
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    textStyle:
                                        Theme.of(context).textTheme.headline4)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.flutter_dash,
                                    color: Color.fromARGB(255, 156, 64, 255)),
                                Expanded(
                                    child: Text("Puntos: " + score.score.toString() + "/"+max_score_game.toString())),
                              ],
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              ),
            );
          }),
    );
  }
}
