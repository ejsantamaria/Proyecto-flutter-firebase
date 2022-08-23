import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/card/StudentListCard.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class StudentList extends StatefulWidget {
  const StudentList({Key? key, required this.admin}) : super(key: key);
  final bool admin;
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final textController = TextEditingController();
  final searchController = TextEditingController();

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
    Stream<QuerySnapshot> studentQuery;
    studentQuery = FirebaseFirestore.instance
        .collection("usuarios")
        .where("Rol", isEqualTo: "Usuario")
        .snapshots();

    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
        appBar: AppBar(
          backgroundColor: Constants.BUTTONS_COLOR,
          title: Text("Estudiantes registrados",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: 
        ListView(
          children: [
            StudentListCard(
              currentStudent: studentQuery,
              adm: widget.admin,
            )
          ],
        ));
  }
}
