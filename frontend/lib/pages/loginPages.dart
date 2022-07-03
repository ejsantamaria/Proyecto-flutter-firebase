import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend/pages/AdminPage.dart';
import 'package:frontend/pages/mainPage.dart';
import 'package:frontend/provider/main_provider.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;
import 'package:frontend/pages/RegisterPageStudent.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
late bool _visible = true;
late bool _valid = false;
final emailController = TextEditingController();

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;
  late Map<String, dynamic> roles;
  @override
  void initState() {
    _auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    if (mounted) {
      setState(() {
        user = userCred;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Constants.BACKGROUNDS,
      resizeToAvoidBottomInset: false,
      body: Builder(
      
        builder: (BuildContext context) {
          
          return ListView(
            padding: const EdgeInsets.all(2),
            children: <Widget>[
              SafeArea(child: Container(height: 30.0)),
              Container(
                
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  decoration: BoxDecoration(
                      //color: Theme.of(context).scaffoldBackgroundColor,
                      //borderRadius: BorderRadius.circular(10.0),
                      ),
                  child: Column(children: [
                    if (!isKeyboard)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        
                        child: Center(
                            child: Text('Inicio de sesión',
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                  color: Constants.TEXT_COLOR,
                                  fontSize: 40,
                                  fontFamily:'TitanOne')),
                                )),
                                
                    
                    Container(
                      height: 15,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        if (!isKeyboard) _showImage(),
                        Container(
                          width: 335.0,
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Text('Juegos educativos para niños con TDAH',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontFamily: 'TitanOne',
                            fontSize: 17)),
                    ),
                    Container(
                      height: 15,
                    ),
                    
                    SizedBox(height: 25.0),
                    const _EmailPasswordForm(),
                  ])),
            ],
          );
        },
      ),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  const _EmailPasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                margin: EdgeInsets.only(left: 12, right: 12),
                elevation: Constants.ELEVATION,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.email,
                              color: Theme.of(context).primaryColorDark),
                          hintText: 'usuario@gmail.com',
                          label: Text(
                            'Correo electrónico o usuario',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return emailValidation(value);
                          } else {
                            return 'Por favor ingrese su correo';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.0),
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Constants.BORDER_RADIOUS)),
                margin: EdgeInsets.only(left: 15, right: 15),
                elevation: Constants.ELEVATION,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscuringCharacter: "*",
                        obscureText: _visible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'Contraseña',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).primaryColorDark),
                          suffixIcon: Container(
                            child: MaterialButton(
                                height: 10,
                                minWidth: 10,
                                child: Icon((_visible == false)
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded),
                                textTheme: ButtonTextTheme.normal,
                                onPressed: () async {
                                  if (_valid) {
                                    setState(() {
                                      _visible = true;
                                    });
                                    _valid = false;
                                  } else {
                                    setState(() {
                                      _visible = false;
                                    });
                                    _valid = true;
                                  }
                                }),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty)
                            return 'Por favor ingrese su contraseña';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0),
                forgetPassword(context),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: MaterialButton(
                      minWidth: 300,
                      height: 50,
                      color: Constants.BUTTONS_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Constants.BORDER_RADIOUS)),
                      child: Column(
                        children: [
                          Text(
                            'Ingresar',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _signInWithEmailAndPassword();
                        }
                      },
                    ),
                    //),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPageStudent(
                                      adm: true,
                                    )));
                      },
                      child: Text(
                        "Registro",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),

      ///),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user!;
      dev.log(user.toString(), name: "INGRESAR");
      String userId = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection("usuarios")
          .where("uid", isEqualTo: userId)
          .get()
          .then((value) => {
                value.docs.forEach((result) {
                  var sections = result.get("Rol");
                  dev.log(sections, name: "Sections - Login Pages");
                  if (sections == "Admin") {
                    mainProvider.token = user.uid;
                    mainProvider.adm = true;
                    adminRol();
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Administrador');
                  } else if (sections == "Usuario") {
                    /*dev.log(result.data().toString(),
                        name: "Doc data from Student");*/
                    mainProvider.motocycle = json.encode(result.data());

                    /*dev.log(mainProvider.motocycle,
                        name: "Main Provider Student - LoginPage");*/
                    mainProvider.token = user.uid;
                    mainProvider.adm = false;

                    motocycleRol(mainProvider.motocycle);
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Usuario');
                  } else {
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Usuario');
                  }
                })
              });
    } catch (e) {
      /*ScaffoldSnackbar.of(context).show(
          'Error al iniciar sesión, por favor revise que su correo electrónico y contraseña sean correctos');*/
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error al iniciar sesión'),
                content: Text(
                    'Por favor revise que su correo electrónico y contraseña sean correctos'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  Future<dynamic> adminRol() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminPage()));
  }

//A TRAVÉS DEL UID HACER UNA CONSULTA Y PASAR COMO PARÁMETRO EL MOTOCYCLE
  Future<dynamic> motocycleRol(String motocycle) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage(
                  titulo: "Usuario",
                  motocycle: motocycle,
                )));
  }
}

class EmailTextControl extends StatelessWidget {
  const EmailTextControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.email,
                      color: Theme.of(context).primaryColorDark),
                  hintText: 'usuario@gmail.com',
                  labelText: 'Correo electrónico o usuario',
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return emailValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacio';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? emailValidation(String? email) {
  String patttern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(patttern);
  if (email!.length == 0) {
    return "Por favor ingrese su Email";
  } else if (!regExp.hasMatch(email)) {
    return "Verifique que su email: \n -No contenga espacios \n -Contega un @ y un dominio";
  }
  return null;
}

class PasswordTextControl extends StatelessWidget {
  const PasswordTextControl({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                ],
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.lock_outline,
                      color: Theme.of(context).primaryColorDark),
                  labelText: 'Contraseña',
                ),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Ingrese una contraseña válida';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmPasswordTextControl extends StatelessWidget {
  const ConfirmPasswordTextControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.lock_outline,
                    color: Theme.of(context).primaryColorDark),
                labelText: 'Confirmar Contraseña',
                errorText: snapshot.error?.toString()),
          ),
        );
      },
    );
  }
}

class ChangeButtonControl extends StatelessWidget {
  const ChangeButtonControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialButton(
          color: Constants.VINTAGE,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
            child: Text(
              'Cambiar',
              style: TextStyle(color: Constants.BACKGROUNDS),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
        );
      },
    );
  }
}

class SearchButtonControl extends StatelessWidget {
  SearchButtonControl({Key? key}) : super(key: key);

  void dispose() {
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialButton(
          color: Constants.VINTAGE,
          onPressed: () {
            resetPassword(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Text(
              'Enviar correo de recuperación',
              style: TextStyle(color: Constants.BACKGROUNDS),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
        );
      },
    );
  }
}

Future resetPassword(BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());

    print('Correo de recuperación enviado');
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Se ha enviado un enlace a tu correo electrónico, revísalo por favor"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar")),
            ],
          );
        });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No se encontró ningún usuario con ese email.');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No se encontró ningún usuario con ese email"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Aceptar")),
              ],
            );
          });
    }
  }
}
_showImage() {
  return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 69, 100, 69),
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        child: 
          Image.asset("assets/logo/logo_principal.png"),
      ));
}

recoverPassword(BuildContext context) {
  return MaterialButton(onPressed: () {
    //newPasswordPopUp(context);
  });
}

forgetPassword(BuildContext context) {
  return MaterialButton(
      onPressed: () {
        openPopUp(context);
      },
      child: Text(
        "¿Olvidaste tu contraseña?",
        style: TextStyle(
          color: Constants.TEXT_COLOR,
          fontFamily: 'TitanOne'),
      ));
}

void openPopUp(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
            body: new Stack(
              children: [
                new Center(
                  child: new ClipRect(
                    child: new BackdropFilter(
                        filter:
                            new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: new Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: new BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.1)),
                          child: new Center(
                            child: new SizedBox(
                              child: Card(
                                margin: EdgeInsets.all(50.0),
                                color: Colors.white,
                                elevation: Constants.BORDER_RADIOUS,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(children: [
                                        Expanded(
                                          flex: 5,
                                          child: Text(""),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 30.0,
                                              )),
                                        ),
                                      ]),
                                    ),
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        _showImage(),
                                        Container(
                                          width: 325.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                              'Enviaremos un enlace a tu correo electrónico para la recuperación de tu contraseña',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                        ),
                                        SizedBox(height: 30.0),
                                        Container(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Constants
                                                            .BORDER_RADIOUS)),
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15),
                                            elevation: Constants.ELEVATION,
                                            child: Column(
                                              children: [
                                                EmailTextControl(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        recoverPassword(context),
                                        SizedBox(height: 40.0),
                                        SearchButtonControl(),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ));
      });
}
