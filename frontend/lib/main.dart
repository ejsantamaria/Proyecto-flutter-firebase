import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/loginSelector.dart';
import 'package:provider/provider.dart';


import 'package:frontend/models/studentModel.dart';
import 'package:frontend/pages/OrderMorPage.dart';
import 'package:frontend/pages/loginStudent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/MainPageStudent.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:frontend/provider/main_provider.dart';
void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription<User?> user;
  late bool _pedidos = false;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return FutureBuilder<bool>(
        future: mainProvider.getPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ignore: unused_local_variable
            final String str = mainProvider.token;
            dev.log("Main", name: "MainProvider String - Main");
            dev.log(str, name: "MainProvider String - Main");
            dev.log(mainProvider.token, name: "MainProvider - Main");
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Juegos TDAH',
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                ),
                home: 
                    mainProvider.token == ""
                        ? LoginSelector()
                            : 
                            mainProvider.pendientes
                                ? OrderMot(
                                    motocycle: mainProvider.motocycle,
                                    pendiente: true)
                                : MainPage(
                                    titulo: '',
                                    student: mainProvider.motocycle));
          }
          return const SizedBox.square(
              dimension: 100.0, child: CircularProgressIndicator());
        });
  }
}