import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/list/ScoreList.dart';
import 'package:frontend/models/studentModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as dev;

final FirebaseAuth _auth = FirebaseAuth.instance;

class StudentListCard extends StatefulWidget {
  StudentListCard({Key? key, required this.currentStudent, required this.adm})
      : super(key: key);
  final Stream<QuerySnapshot> currentStudent;
  final bool adm;
  @override
  _StudentListCardState createState() => _StudentListCardState();
}

class _StudentListCardState extends State<StudentListCard> {
  late String us = "";
  late String defaultimg = "https://i.postimg.cc/XJ4cnryN/default-user.jpg";
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
          stream: widget.currentStudent,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading'));
            }
            return Container(
              child: Column(
                children: snapshot.data!.docs.map((student) {
                  var studen;
                  studen =
                      UserApp.fromJson(student.data() as Map<String, dynamic>);

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
                            backgroundImage: NetworkImage(
                                (studen.urlimage == null)
                                    ? defaultimg
                                    : studen.urlimage.toString()),
                            radius: 30,
                            backgroundColor: Constants.WHITE,
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                studen.name! +
                                    ' ' +
                                    studen.secondname +
                                    ' ' +
                                    studen.surname.toString(),
                                style: GoogleFonts.raleway(
                                    color: Color.fromARGB(255, 29, 29, 29),
                                    fontSize: 18.0,
                                    textStyle:
                                        Theme.of(context).textTheme.headline4)),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Grado: " +
                                      studen.grade +
                                      "\nParalelo: " +
                                      studen.gparallel,
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headline4)),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.flutter_dash,
                                      color: Color.fromARGB(255, 156, 64, 255)),
                                  Expanded(
                                      child:
                                          Text("Usuario: " + studen.username)),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.more_horiz_outlined),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScoreList(
                                            admin: true,
                                            username: studen.username)));
                              })));
                }).toList(),
              ),
            );
          }),
    );
  }
}
