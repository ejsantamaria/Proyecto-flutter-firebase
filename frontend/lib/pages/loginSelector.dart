import 'package:flutter/material.dart';
import 'package:frontend/pages/loginStudent.dart';
import 'package:frontend/pages/loginAdmin.dart';
import 'package:frontend/utils/constants.dart' as Constants;

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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
