import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'package:frontend/models/studentModel.dart';
import 'package:frontend/pages/AdminPage.dart';
import 'package:frontend/pages/OrderMorPage.dart';
import 'package:frontend/pages/loginPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/mainPage.dart';
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

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prowess Bike',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AdminPage(),
    );
  }
}
*/

//Keep User Logged in Flutter-Firebase
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//class _MyAppState extends StatelessWidget {

  // ignore: cancel_subscriptions
  late StreamSubscription<User?> user;
  late bool _pedidos = false;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        //checkPedidos();
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
                home: /*mainProvider.token == ""  mainProvider.adm == false
                    ? LoginPage()
                    : AdminPage())*/
                    mainProvider.token == ""
                        ? LoginPage()
                        : mainProvider.adm == true
                            ? AdminPage()
                            : /*MainPage(
                                titulo: '', motocycle: mainProvider.motocycle)*/
                            mainProvider.pendientes
                                ? OrderMot(
                                    motocycle: mainProvider.motocycle,
                                    pendiente: true)
                                : MainPage(
                                    titulo: '',
                                    motocycle: mainProvider.motocycle));
          }
          return const SizedBox.square(
              dimension: 100.0, child: CircularProgressIndicator());
        });
  }

  /*checkPedidos() async {
    final mainProvider = Provider.of<MainProvider>(context);
    await mainProvider.getPreferences();
    dev.log("Main", name: "MainProvider - checkPedidos");
    dev.log(mainProvider.motocycle, name: "MainProvider - checkPedidos");
    Motocycle motocycleObject = new Motocycle.fromJson(
        json.decode(mainProvider.motocycle) as Map<String, dynamic>);

    await FirebaseFirestore.instance
        .collection("pedidos")
        .where("uid_mot", isEqualTo: motocycleObject.uid)
        .where(
          "estado",
          whereIn: ["recogido", "en proceso", "en ruta"],
        )
        .get()
        .then((querySnapshot) {
          dev.log("checkPedidos");
          dev.log(querySnapshot.toString(), name: "checkPedidos");
          if (querySnapshot.docs.length > 0) {
            dev.log("checkPedidos mayor que 0");
            mainProvider.pendientes = true;
            dev.log(mainProvider.pendientes.toString(),
                name: "checkPedidos mayor que 0");
          } else {
            mainProvider.pendientes = false;
            dev.log("Menor que 0", name: "checkPedidos");
            dev.log(mainProvider.pendientes.toString(),
                name: "checkPedidos menor que 0");
          }
        });
  }*/
}