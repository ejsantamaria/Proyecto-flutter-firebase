import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/AdminPage.dart';
import 'package:frontend/pages/loginPages.dart';
class VerifyScreen extends StatefulWidget{

  @override 
  _VerifyScreenState createState() => _VerifyScreenState();

}

class _VerifyScreenState extends State<VerifyScreen>{
  bool isEmailVerified = false;
  Timer? timer;
  @override 
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmailVerified){
      sendVerificationEmail();
      Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState((){
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified){
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
    }catch(e){
      //Utils.showSnackBar(e.toString());
    }
    
  }

  @override 
  Widget build(BuildContext context) => isEmailVerified
    ?LoginPage()
    :Scaffold(
      appBar : AppBar(
        title: Text(
          'Correo de verificación enviado',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminPage()));
          },
          child: Text('Regresar'),
        ),
      ),
    );
  
 
 /* final auth = FirebaseAuth.instance;
  late User user = auth.currentUser!;
  late Timer timer;
  bool isEmailVerified = false;
  void initState(){

    user = auth.currentUser!;
    user.sendEmailVerification();
    //print("Se envio el correo 1");
    timer = Timer.periodic(Duration(seconds: 5), (timer){
        checkEmailVerified();
    }); //Timer.periodic
  
    super.initState();
  }

  @override 
  void dispose(){
    timer.cancel();
    super.dispose();
  }
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Text(
          'Se ha enviado un email al correo ${user.email}, por favor verificar'),),
    );
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser!;
    await  user.reload();
    print("Se envio el correo 2");
    if(user.emailVerified){
      timer.cancel();
      Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
   }
  }*/
}