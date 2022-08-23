import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/schoolModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as dev;


final FirebaseAuth _auth = FirebaseAuth.instance;

class SchoolListCard extends StatefulWidget {
  SchoolListCard({Key? key, required this.currentSchool, required this.adm})
      : super(key: key);
  final Stream<QuerySnapshot> currentSchool;
  final bool adm;
  @override
  _SchoolListCardState createState() => _SchoolListCardState();
}

class _SchoolListCardState extends State<SchoolListCard> {
  late String us = "";
  late String defaultimg =
      "https://i.postimg.cc/fR3J0Mhc/1051.jpg";
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
          stream: widget.currentSchool,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading'));
            }
            return Container(
              child: Column(
                children: snapshot.data!.docs.map((schools) {
                  var school;
                  school =
                      SchoolModel.fromJson(schools.data() as Map<String, dynamic>);

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
                            'Escuela: ' + school.school_name,
                              style: GoogleFonts.raleway(
                                  color: Color.fromARGB(255, 29, 29, 29),
                                  fontSize: 18.0,
                                  textStyle:
                                      Theme.of(context).textTheme.headline4)),
                        ),
                      ));
                }).toList(),
              ),
            );
          }),
    );
  }

}
