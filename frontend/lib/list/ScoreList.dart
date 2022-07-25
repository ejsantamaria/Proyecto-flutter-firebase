import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/ScoreListCard.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class ScoreList extends StatefulWidget {
  const ScoreList({Key? key, required this.admin, required this.username}) : super(key: key);
  final String username;
  final bool admin;
  @override
  _ScoreListState createState() => _ScoreListState();
}

class _ScoreListState extends State<ScoreList> {

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Username del score list: "+widget.username);
    Stream<QuerySnapshot> studentQuery;
    studentQuery = FirebaseFirestore.instance
        .collection("puntajes")
        .where("username", isEqualTo: widget.username)
        .snapshots();

    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
        appBar: AppBar(
          backgroundColor: Constants.BUTTONS_COLOR,
          title: Text("Puntajes registrados",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          children: [
            ScoreListCard(
              currentScore: studentQuery,
              adm: widget.admin,
            )
          ],
        ));
  }
}
