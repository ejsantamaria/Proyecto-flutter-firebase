import 'package:flutter/material.dart';
import 'package:frontend/pages/RegisterPageMotocycle.dart';
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
          backgroundColor: Constants.BACKGROUNDS,
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
                          Icon(Icons.person, color: Constants.BACKGROUNDS, size: 50)),
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
                            builder: (context) => RegisterPageMotocycle(
                                  adm: true,
                                )));
                  },
                  child: Text("Registrar motorizados",
                      style: TextStyle(color: Constants.BACKGROUNDS)),
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
                  /*onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MotocycleList(
                                  admin: true,
                                )));
                  },*/
                  onPressed: () {  },
                  child: Text(
                    "Ver motorizados",
                    style: TextStyle(color: Constants.BACKGROUNDS),
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
                  /*onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MotocycleList(
                                  admin: false,
                                )));
                  },*/onPressed: () {  },
                  child: Text(
                    "Revisar solicitudes",
                    style: TextStyle(color: Constants.BACKGROUNDS),
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
                  /*onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPageAdm()));
                  },*/
                  onPressed: () {  },
                  child: Text(
                    "Registrar administrador",
                    style: TextStyle(color: Constants.BACKGROUNDS),
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
                            builder: (context) => AlertDialog(
                                  title: Text('Preguntas frecuentes'),
                                  content: Container(
                                      child: SingleChildScrollView(
                                          child: Column(children: [
                                    Text(
                                        '¿Cuáles son los servicios que ofrece ProwessBike?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '\nProwessBike permite generar una interacción entre vendedor y cliente mediante la entrega de los productos de los vendedores registrados en la plataforma Prowessec.\n\n'),
                                    Text(
                                        '¿Quiénes pueden ingresar al sistema ProwessBike?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '\nProwessBike está a disposición de aquellos motorizados que han sido aprobados por el administrador quien registrara a los mismos por medio de la aplicación y a su vez asigna un usuario y una contraseña para que el motorizado.\n\n'),
                                    Text(
                                        '¿Se puede recuperar la contraseña de un administrador en caso de olvidarla?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '\nProwessBike cuenta con la posibilidad de recuperación de contraseña para los usuarios por medio de administradores.'),
                                  ]))),
                                  actions: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                        top: BorderSide(
                                            width: 0.7,
                                            color: Color(0xFF7F7F7F)),
                                      )),
                                    ),
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )));
                  },
                  child: Text(
                    "Preguntas frecuentes",
                    style: TextStyle(color: Constants.BACKGROUNDS),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Text("Prowess-Bike",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
