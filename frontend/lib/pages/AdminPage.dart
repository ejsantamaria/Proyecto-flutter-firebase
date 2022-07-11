import 'package:flutter/material.dart';
import 'package:frontend/pages/RegisterPageAdm.dart';
import 'package:frontend/pages/RegisterPageStudent.dart';
import 'package:frontend/pages/exitMenu.dart';
import 'package:frontend/utils/constants.dart' as Constants;

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ExitMenu(),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Constants.WHITE,
          title: Text("Menú administrador/a",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text("Bienvenid@",
                    style: Theme.of(context).textTheme.headline3),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Constants.VINTAGE),
                  child: ClipOval(
                      child:
                          Icon(Icons.person, color: Constants.WHITE, size: 50)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  minWidth: 300,
                  height: 50,
                  color: Constants.VINTAGE,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.BORDER_RADIOUS)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPageStudent(
                                  adm: true,
                                )));
                  },
                  child: Text("Registrar estudiantes",
                      style: TextStyle(color: Constants.WHITE)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  minWidth: 300,
                  height: 50,
                  color: Constants.VINTAGE,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.BORDER_RADIOUS)),
                  onPressed: () {
                    AlertDialog(title: Text("Apartado den desarrollo"),);
                  },
                  child: Text(
                    "Ver estudiantes",
                    style: TextStyle(color: Constants.WHITE),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  minWidth: 300,
                  height: 50,
                  color: Constants.VINTAGE,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.BORDER_RADIOUS)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPageAdm()));
                  },
                  child: Text(
                    "Registrar administrador",
                    style: TextStyle(color: Constants.WHITE),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Text("MindTDAH",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
