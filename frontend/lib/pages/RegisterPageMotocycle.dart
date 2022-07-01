// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/AdminPage.dart';
import 'package:frontend/pages/loginPages.dart';
import 'package:frontend/pages/verify.dart';
import 'package:frontend/services/imageService.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:frontend/utils/constants.dart' as Constants;

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPageMotocycle extends StatefulWidget {
  const RegisterPageMotocycle({Key? key, required this.adm}) : super(key: key);
  final bool adm;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPageMotocycle> {
  String countryValue = "";
  String countryCheck = "";
  String stateValue = "";
  String cityValue = "";
  String addressCountry = "";
  late String _dropDownValue = "";
  int currentStep = 0;
  File? image;
  String? urlImagen;
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
  late DateTime? expiryLicense = DateTime.now();

  final school = TextEditingController();
  final grade = TextEditingController();
  final gparallel = TextEditingController();

  final license = TextEditingController();
  final typeLicense = TextEditingController();
  final brand = TextEditingController();
  final model = TextEditingController();
  final plate = TextEditingController();
  final numberRegist = TextEditingController();
  final owner = TextEditingController();
  final FotosService _fotosService = FotosService();

  List<GlobalKey<FormState>> _listKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  Future _selectImage(ImageSource source) async {
    final imageCamera = await ImagePicker().pickImage(source: source);
    if (imageCamera == null) return;
    final imageTemporary = File(imageCamera.path);
    image = imageTemporary;
    if (image != null) {
      urlImagen = await _fotosService.uploadImage(image!);
    }
    setState(() {});
  }

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
        Step(
          isActive: currentStep >= 1,
          title: const Icon(Icons.contact_mail_outlined),
          content: Form(
            key: _listKeys[1],
            autovalidateMode: AutovalidateMode.disabled,
            child: formUser2(),
          ),
        ),
      ];

  List emailsBD = [];

  @override
  Widget build(BuildContext context) {
    //recuperar Email de la base de datos
    recuperarEmail();
    return SizedBox(
      width: 500,
      height: 800,
      child: Scaffold(
        appBar: AppBar(
          title: Text((widget.adm)
              ? "Registrar nuevo usuario"
              : "Registrar nuevo usuario"),
          centerTitle: true,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Constants.VINTAGE),
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
                              Constants.VINTAGE)),
                      onPressed: (widget.adm)
                          ? () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPage()),
                                )
                              }
                          : () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
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
                  if (widget.adm) {
                    await _register();
                    await _sendToServer(true);
                  } else {
                    await _sendToServer(false);
                  }

                  print(
                      "_____----******************************completado****************************----_____"); 
                  showDialog(
                      context: context,
                      barrierDismissible: false,
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
                                  'Exitoso',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          
                        );
                      });
                } else {
                  setState(() => currentStep += 1);
                }
              }
            },
            onStepCancel: currentStep == 0
                ? (widget.adm)
                    ? () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPage()),
                          )
                        }
                    : () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          )
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
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
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
                      return 'No puede dejar este casillero vacío\nEjemplo: Erick';
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
                    return 'No puede dejar este casillero vacío\nEjemplo: Santamaria';
                  }
                },
              ),
              SizedBox(
                height: 5,
              ),
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
                keyboardType: TextInputType.number,
                controller: age,
                maxLength: 2,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Edad",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return ageValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              ),
              ListTile(
                title: Text(
                  "Seleccione una imagen de perfil",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            color: Colors.black,
                            child: const Icon(
                              Icons.camera,
                              color: Colors.white,
                            ),
                            onPressed: () => _selectImage(ImageSource.camera))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          color: Colors.black,
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: () => _selectImage(ImageSource.gallery)),
                    ),
                  ],
                ),
              ),
              image != null
                  ? ClipOval(
                      child: Image.file(
                      image!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ))
                  : FlutterLogo(
                      size: 0,
                    )
            ])));
  }

  Widget formUser2() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        //key: _form2Key,
        child: Padding(
            padding: EdgeInsets.all(11.0),
            child: Column(children: <Widget>[
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: school,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Unidad educativa",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    if (value.isEmpty) {
                      return 'No puede dejar este casillero vacío\nEjemplo: Unidad educativa 3 de Diciembre';
                    }
                  }
                },
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: grade,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Curso",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    if (value.isEmpty) {
                      return 'No puede dejar este casillero vacío\nEjemplo: Unidad educativa 3 de Diciembre';
                    }
                  }
                },
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.name,
                controller: gparallel,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text("Paralelo",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(" *", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    if (value.isEmpty) {
                      return 'No puede dejar este casillero vacío\nEjemplo: Unidad educativa 3 de Diciembre';
                    }
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
              ),
              Container(
                alignment: AlignmentDirectional.bottomEnd,
                child: MaterialButton(
                    height: 10,
                    minWidth: 10,
                    
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () async {
                      if (_valid == false) {
                        setState(() {
                          _visible = false;
                        });
                        _valid = true;
                      } else {
                        setState(() {
                          _visible = true;
                        });
                        _valid = false;
                      }
                    }),
              ),
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
        acum += 'Ingrese la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Erick';
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
      return acum + 'Ejemplo: Toapanta';
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
      return "Celular Requerido";
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
    if (edad! >= 0 && edad <= 99) {
      return null;
    } else {
      return "Ingrese un número válido";
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
    int a = 0, j;

    for (j = 0; j < emailsBD.length; j++) {
      if (emailsBD[j] == email) {
        a = 1;
        break;
      }
    }

    if (a == 1) {
      return "Email ya se encuentra registrado";
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

  String? licenseValidation(String? codLicencia) {
    //comprobado
    String patttern = r'(^[0-9]*$)'; //comprobar si funciona
    RegExp regExp = new RegExp(patttern);
    if (codLicencia!.length == 0) {
      return "Licencia requerida ";
    } else if (!regExp.hasMatch(codLicencia)) {
      return "Licencia requiere caracteres numéricos";
    } else if (codLicencia.length != 8) {
      return "Licencia requiere 8 dígitos";
    }
    return null;
  }

  String? typeLicenseValidation(String? tipoLicencia) {
    if (tipoLicencia!.length == 0) {
      return "Tipo de licencia requerido";
    } else if (tipoLicencia.length < 1 || tipoLicencia.length > 2) {
      return "Escoja entre A-B, \nSi es Profesional A-B";
    }
    return null;
  }

  String? brandValidation(String? brand) {
    if (brand!.length < 3) {
      return "Mínimo 3 carácteres para la marca";
    }
    return null;
  }

  String? modelValidation(String? modelo) {
    if (modelo!.length < 3) {
      return "Mínimo 3 carácteres para el modelo";
    }
    return null;
  }

  String? numberRegistValidation(String? numRegistro) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp1 = new RegExp(patttern);
    if (!regExp1.hasMatch(numRegistro!)) {
      return "No se admiten caracteres numéricos ni especiales";
    }
    return null;
  }

  String? plateValidation(String? plate) {
    String pattern1 = r'^[A-Z]{2}[0-9]{4}$';
    String pattern2 = r'^(?=.*\s).+$';
    var acum = '';
    RegExp regExp = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    if (regExp.hasMatch(plate!)) {
      return null;
    } else {
      if (plate.length < 7) {
        acum += 'Se necesitan 2 letras y 4 numeros\n';
      }
      if (regExp.hasMatch(plate) || !regExp.hasMatch(plate)) {
        acum +=
            'Ingrese las primeras 2 letras con mayusculas seguido \nde los 4 numeros de la placa\n';
      }
      if (regExp2.hasMatch(plate)) {
        acum += 'Sin espacios en blancos\n';
      }
      return acum + 'Ejemplo: AB1234';
    }
  }

  String? ownerValidation(String? dueno) {
    String patttern = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ]+)(\s[A-ZÀ-ÝÑ][a-zà-ÿñ ]+)$';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'(^[a-zà-ÿñ ]+)$';
    String pattern4 = r'(^[a-zà-ÿñ ]+)(\s[a-zà-ÿñ ]+)$';
    String pattern5 = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ ]+)(\s[a-zà-ÿñ ]+)$';
    String pattern6 = r'(^[a-zà-ÿñ ]+[A-ZÀ-ÝÑ]+)$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp4 = new RegExp(pattern4);
    RegExp regExp5 = new RegExp(pattern5);
    RegExp regExp6 = new RegExp(pattern6);

    if (regExp.hasMatch(dueno!)) {
      return null;
    } else {
      if (regExp1.hasMatch(dueno)) {
        acum += 'Ingrese solo letras\n';
      }
      if (dueno.length < 2) {
        acum += 'Ingrese más de 2 letras\n';
      }
      if ((regExp4.hasMatch(dueno) ||
              regExp2.hasMatch(dueno) ||
              regExp5.hasMatch(dueno) ||
              regExp6.hasMatch(dueno) ||
              !regExp.hasMatch(dueno)) &&
          !regExp1.hasMatch(dueno)) {
        acum +=
            'Ingrese solo la primera letra de cada palabra\ncon mayúscula \nIngrese el Nombre y Apellido\n';
      }
      return acum + 'Ejemplo: Erick Santamaria';
    }
  }

  Future<void> _sendToServer(bool admin) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference;
      if (admin) {
        reference = FirebaseFirestore.instance.collection("usuarios");
        await reference.add({
          "uid": "$us",
          "name": name.text.trim(),
          "surname": surname.text.trim(),
          "Rol": "Usuario",
          "age": age.text.trim(),
          "phone": phone.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
          "urlimage": urlImagen,
          "escuela": school.text.trim(),
          "grade": grade.text.trim(),
          "gparallel": gparallel.text.trim(),
          "score":0,
        });
      } else {
        reference =
            FirebaseFirestore.instance.collection('usuarios');
        await reference.add({
          "uid": "$us",
          "name": name.text.trim(),
          "surname": surname.text.trim(),
          "Rol": "Usuario",//"Rol": "Motorizado",
          "age": age.text.trim(),
          "phone": phone.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
          "urlimage": urlImagen,
          "escuela": school.text.trim(),
          "grade": grade.text.trim(),
          "gparallel": gparallel.text.trim(),
          "score":0,
        });
      }
    });
  }

  Future<void> _register() async {
    final User? user = (
      await _auth.createUserWithEmailAndPassword(
      email: email.text, password: password.text,)
      ).user;
    us = user!.uid;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email!;
      });
    } else {
      _success = false;
    }
  }

  //Funcion para guardar los correos electronicos registrados
  recuperarEmail() async {
    var rol = "";
    var email;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .get()
        .then((value) => {
              value.docs.forEach((result) {
                rol = result.get("Rol");
                if (rol == "Usuario") {
                  email = result.get("email");
                  emailsBD.add(email.toString());
                }
              })
            });
  }
}
