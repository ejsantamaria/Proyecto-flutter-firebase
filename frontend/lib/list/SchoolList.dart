import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/card/SchoolListCard.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class SchoolList extends StatefulWidget {
  SchoolList({Key? key}) : super(key: key);

  @override
  State<SchoolList> createState() => _SchoolListState();
}

class _SchoolListState extends State<SchoolList> {

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> studentQuery;
    studentQuery = FirebaseFirestore.instance
        .collection("escuelas")
        .snapshots();
    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
        appBar: AppBar(
          backgroundColor: Constants.BUTTONS_COLOR,
          title: Text("Unidades educativas",
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
            SchoolListCard(
              currentSchool: studentQuery,
              adm:true,
            )
            //DeleteBikeCard(currentMotocycle: motocycle),
          ],
        ));
  }
}