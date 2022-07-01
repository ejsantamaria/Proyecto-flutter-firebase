import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:frontend/components/navbarComponent.dart';
import 'package:frontend/models/motocycleModel.dart';
//import 'package:frontend/pages/orderPage.dart';
//import 'package:frontend/pages/settingsPage.dart';
//import 'package:frontend/utils/itemMenu.dart';
import 'package:frontend/pages/loginPages.dart';
import 'dart:developer' as dev;

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.titulo, required this.motocycle})
      : super(key: key);
  final String titulo;
  final String motocycle;
  //final Motocycle motocycle;
  /*late Motocycle motocycleObject =
      Motocycle.fromJson(json.encode(this.motocycle) as Map<String, String>);*/

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool emailVerified = false;
  @override
  void initState() {
    super.initState();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!emailVerified) {
      Timer.periodic(Duration(seconds: 3), (_) => _checkEmailVerified());
    }
  }

  int _selectedIndex = 0;

  /*@override
  Widget build(BuildContext context) {
    //Cambiar por emailVerified en cuanto se pasen a usar cuentas verificadas por correo (dejar de usar el mot@test.com)
    return !emailVerified
        ? Scaffold(
            body: Container(child: getbody(_selectedIndex)),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 5),
              ]),
              child: ClipRRect(
                child: NavbarComponent(
                  index: this._selectedIndex,
                  onTap: (value) {
                    _onItemTapped(value);
                  },
                  items: menuOptions
                      .map((e) =>
                          BottomNavigationBarItem(icon: e.icon, label: e.label))
                      .toList(),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(child: getbody(_selectedIndex)),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 5),
              ]),
              child: AlertDialog(
                title: Text('Error de verificación de correo electrónico'),
                content: Text("Verifica tu correo " +
                    FirebaseAuth.instance.currentUser!.email!),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ),
            ),
          );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getbody(int index) {
    dev.log(widget.motocycle, name: "Motocycle - getbody");

    Motocycle motocycleObject = new Motocycle.fromJson(
        json.decode(widget.motocycle) as Map<String, dynamic>);
    if (index == 0) {
      return OrderPage(
        motocycle: motocycleObject,
      );
    } else if (index == 1) {
      return SettingsPage(motocycle: motocycleObject);
    }
    return Text("error");
  }
*/
  Future _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (mounted) {
      setState(() {
        emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        dev.log(emailVerified.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
