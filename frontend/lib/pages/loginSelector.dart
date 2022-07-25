import 'package:flutter/material.dart';
import 'package:frontend/pages/loginStudent.dart';
import 'package:frontend/pages/loginAdmin.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:frontend/pages/RegisterPageStudent.dart';

class LoginSelector extends StatefulWidget {
  LoginSelector({Key? key}) : super(key: key);

  @override
  State<LoginSelector> createState() => _LoginSelectorState();
}

class _LoginSelectorState extends State<LoginSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text('¿Quién eres?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Constants.TEXT_COLOR,
                        fontSize: 40,
                        fontFamily: 'TitanOne')),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPageAdmin()));
                },
                child: Text(
                  "Tutor",
                  style: TextStyle(color: Colors.white,fontFamily: 'TitanOne',fontSize: 30),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: MaterialButton(
                minWidth: 300,
                height: 50,
                color: Constants.BUTTONS_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "Estudiante",
                  style: TextStyle(color: Colors.white,fontFamily: 'TitanOne',fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
