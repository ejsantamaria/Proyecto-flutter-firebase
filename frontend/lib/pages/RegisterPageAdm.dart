import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/AdminPage.dart';
import 'package:frontend/pages/loginAdmin.dart';
import 'package:frontend/utils/constants.dart' as Constants;

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPageAdm extends StatefulWidget {
  const RegisterPageAdm({
    Key? key,
  }) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPageAdm> {
  int currentStep = 0;
  String countryValue = "";
  String countryCheck = "";
  String stateValue = "";
  String cityValue = "";
  String addressCountry = "";
  late String us = "";
  // ignore: unused_field
  late bool? _success;
  late int cont;
  late bool _visible = true;
  late bool _valid = false;
  // ignore: unused_field
  late String _userEmail = '';

  final name = TextEditingController();
  final surname = TextEditingController();
  final nationality = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();

  final age = TextEditingController();
  final docId = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  //Lista para guardar email de la BD
  List emailBD = [];

  List<GlobalKey<FormState>> _listKeys = [
    GlobalKey(),
    GlobalKey(),
  ];

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Icon(Icons.person),
          content: Form(
            key: _listKeys[0],
            autovalidateMode: AutovalidateMode.disabled,
            child: formUser1(),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    //Cargar los datos en la lista
    recuperarEmail();
    return SizedBox(
      width: 500,
      height: 800,
      child: Scaffold(
        backgroundColor: Constants.BACKGROUNDS,
        appBar: AppBar(
          title: Text("Registrar nuevo tutor"),
          centerTitle: true,
          backgroundColor: Constants.BUTTONS_COLOR,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Constants.BUTTONS_COLOR),
          ),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white70)),
                      onPressed: details.onStepCancel,
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.BUTTONS_COLOR)),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPageAdmin()),
                        )
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white70)),
                      onPressed: details.onStepContinue,
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              );
            },
            type: StepperType.vertical,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () async {
              final isLastStep = currentStep == getSteps().length - 1;
              if (_listKeys[currentStep].currentState!.validate()) {
                if (isLastStep) {
                  await _register();
                  await _sendToServer();
                  print(
                      "_____----******************************completado****************************----_____");

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Registro Completado',
                            textAlign: TextAlign.center,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Image.asset(
                                  "assets/images/check-correct.gif",
                                  height: 125.0,
                                  width: 125.0,
                                ),
                                Text(
                                  'Ahora tiene una cuenta de Tutor',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('Aceptar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ))),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext contex) {
                                    return new AdminPage(email.text.trim());
                                  }), (Route<dynamic> route) => false);
                                })
                          ],
                        );
                      });
                } else {
                  setState(() => currentStep += 1);
                }
              }
            },
            onStepCancel: currentStep == 0
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPageAdmin()),
                    );
                  }
                : () {
                    setState(() => currentStep -= 1);
                  },
          ),
        ),
      ),
    );
  }

  Widget formUser1() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        child: Padding(
            padding: EdgeInsets.all(11.0),
            child: Column(children: <Widget>[
              SizedBox(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text:
                              "* Campo obligatorio                                        ",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 170, 41, 41))),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: name,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Nombre",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return nameValidation(value);
                  } else {
                    if (value.isEmpty) {
                      return 'No puede dejar este casillero vacío\nEjemplo: Diego';
                    }
                  }
                },
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: surname,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Apellido",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return surnameValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío\nEjemplo: Padilla';
                  }
                },
              ),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  controller: phone,
                  decoration: InputDecoration(
                    label: Row(
                      children: [
                        Text("Celular",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" *", style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return phoneValidation(value);
                    } else {
                      return 'No puede dejar este casillero vacío';
                    }
                  }),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: email,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Email",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.alternate_email_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return emailValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 15,
                obscuringCharacter: "*",
                controller: password,
                obscureText: _visible,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Contraseña",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
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
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return passwordValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              )
            ])));
  }

  String? nameValidation(String? name) {
    String patttern = r'(^[A-ZÀ-ÝÑ]{1}([a-zà-ÿñ]*$){2,})';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'^(?=.*\s).+$';
    String pattern3 = r'(^[A-ZÀ-ÝÑ]{1}(.+))';
    String pattern4 = r'^(?=.*[A-ZÀ-ÝÑ]).{2,}$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);
    RegExp regExp4 = new RegExp(pattern4);

    if (regExp.hasMatch(name!)) {
      return null;
    } else {
      if (regExp1.hasMatch(name)) {
        acum += 'Ingrese solo letras\n';
      }
      if (regExp2.hasMatch(name)) {
        acum += 'Elimine los espacios en blanco\n';
      }
      if (name.length < 3) {
        acum += 'Ingrese más de 3 letras\n';
      }
      if (regExp4.hasMatch(name) && !regExp1.hasMatch(name)) {
        acum += 'Solo la primera letra con mayúscula\n';
      }
      if (!regExp3.hasMatch(name)) {
        acum += 'Ingrese la primera letra con mayúscula';
      }
      return acum + 'Ejemplo: Diego';
    }
  }

  String? surnameValidation(String? apellido) {
    String patttern = r'(^[A-ZÀ-ÝÑ]{1}([a-zà-ÿñ]*$){2,})';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'^(?=.*\s).+$';
    String pattern3 = r'(^[A-ZÀ-ÝÑ]{1}(.+))';
    String pattern4 = r'^(?=.*[A-ZÀ-ÝÑ]).{2,}$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);
    RegExp regExp4 = new RegExp(pattern4);

    if (regExp.hasMatch(apellido!)) {
      return null;
    } else {
      if (regExp1.hasMatch(apellido)) {
        acum += 'Ingrese solo letras\n';
      }
      if (regExp2.hasMatch(apellido)) {
        acum += 'Elimine los espacios en blanco\n';
      }
      if (apellido.length < 3) {
        acum += 'Ingrese más de 3 letras\n';
      }
      if (regExp4.hasMatch(apellido) && !regExp1.hasMatch(apellido)) {
        acum += 'Solo la primera letra con mayúscula\n';
      }
      if (!regExp3.hasMatch(apellido)) {
        acum += 'Ingrese la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Padilla';
    }
  }

  String? nationalityValidation(String? nacionalidad) {
    String patttern = r'(^[a-zA-ZÀ-ÿ\u00f1\u00d1]*$)';
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(nacionalidad!)) {
      return "No se admiten caracteres numéricos ni especiales";
    }
    return null;
  }

  String? adressValidation(String? value) {
    String patttern = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ\sA-ZÀ-ÝÑ ]+?)$';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'(^[a-zà-ÿñ ]+)$';
    String pattern3 = r'(^[a-zà-ÿñ ]+[A-ZÀ-ÝÑ]+)$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);

    if (regExp.hasMatch(value!)) {
      return null;
    } else {
      if (regExp1.hasMatch(value)) {
        acum += 'Ingrese solo letras\n';
      }
      if (value.length < 2) {
        acum += 'Ingrese más de 2 letras\n';
      }
      if (regExp2.hasMatch(value) || regExp3.hasMatch(value)) {
        acum += 'Ingrese solo la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Quito';
    }
  }

  String? phoneValidation(String? phone) {
    String patttern = r'(^[0-9]*$)'; //comprobar si funciona
    RegExp regExp = new RegExp(patttern);
    if (phone!.length == 0) {
      return "Celular requerido";
    } else if (!regExp.hasMatch(phone)) {
      return "Celular requiere caracteres numéricos";
    } else if (phone.length != 10) {
      return "Celular requiere 10 caracteres";
    }
    return null;
  }

  String? ageValidation(String? age) {
    String patttern = r'(^[0-9]*$)'; //comprobar si funciona
    var edad = int.tryParse(age!);
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(age)) {
      return "Edad requiere caracteres numéricos";
    }
    if (edad! >= 18 && edad <= 99) {
      return null;
    } else {
      return "Debes ser mayor de edad para registrarte";
    }
  }

  String? idValidation(String? docId) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    int suma = 0;
    if (!regExp.hasMatch(docId!)) {
      return "Cédula solo acepta caracteres numéricos";
    }
    if (docId.length == 10) {
      String pro = docId[0] + docId[1];
      int provincia = int.parse(pro);
      if (provincia < 25) {
        for (var i = 0; i < docId.length; i++) {
          int num = int.parse(docId[i]);
          if (i % 2 == 0) {
            num = num * 2;
            if (num > 9) {
              num = num - 9;
            }
          }
          suma = suma + num;
        }
        if (suma % 10 != 0) {
          int reusultado = 10 - (suma % 10);
          if (reusultado == num) {
            return null;
          } else {
            return "Cédula no válida";
          }
        }
      } else {
        return "Verifique su cédula";
      }
    } else if (docId.length != 10) {
      return "Por favor ingrese 10 dígitos";
    }
    return null;
  }

  String? emailValidation(String? email) {
    String patttern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(patttern);
    int a = 0, i;

    for (i = 0; i < emailBD.length; i++) {
      if (emailBD[i] == email) {
        a = 1;
      }
    }
    if (a == 1) {
      return "Email ya esta registrado";
    }
    if (email!.length == 0) {
      return "Email es requerido";
    } else if (!regExp.hasMatch(email)) {
      return "Email necesita un @ y un dominio";
    }
    return null;
  }

  String? passwordValidation(String? pass) {
    if (pass == null || pass.isEmpty) {
      return 'Ingrese una contraseña temporal';
    } else if (pass.length < 6) {
      return "La contraseña requiere al menos 6 caracteres";
    }
    return null;
  }

  Future<void> _sendToServer() async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference;
      reference = FirebaseFirestore.instance.collection("usuarios");
      await reference.add({
        "uid": "$us",
        "name": name.text.trim(),
        "surname": surname.text.trim(),
        "Rol": "Admin",
        "email": email.text.trim(),
        "password":password.text.trim(),
        "phone":phone.text.trim()
      });
    });
  }

  Future<void> _register() async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    ))
        .user;
    us = user!.uid;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email ?? '';
      });
    } else {
      _success = false;
    }
  }

  //Funcion para recuperar email de la BD
  Future<void> recuperarEmail() async {
    var rol = "";
    var email;
    await FirebaseFirestore.instance
        .collection("usuarios")
        .get()
        .then((data) => {
              data.docs.forEach((result) {
                rol = result.get("Rol");
                if (rol == "Admin") {
                  email = result.get("email");
                  emailBD.add(email.toString());
                }
              })
            });
  }
}
