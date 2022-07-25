import 'package:flutter/material.dart';
import 'package:frontend/pages/loginAdmin.dart';
import 'package:frontend/pages/loginSelector.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/main_provider.dart';
import 'package:frontend/utils/constants.dart' as Constants;
import 'package:frontend/pages/loginStudent.dart';

class ExitMenu extends StatelessWidget {
  final String role;
  ExitMenu(this.role, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Column(
              children: [
                _showImage(),
                Text(role),
                Container(
                  width: 200.0,
                  padding: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Theme.of(context).primaryColor, Color(0xffF5F0BB)]),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined,
                color: Theme.of(context).primaryColorDark),
            title: Text('Cerrar sesión'),
            onTap: () {
              mainProvider.token = "";
              mainProvider.adm = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginSelector()));
            },
          ),
        ],
      ),
    );
  }
}

_showImage() {
  return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90.0),
        color: Color.fromARGB(255, 249, 249, 249),
        border: Border.all(
          width: 3,
          color: Color.fromARGB(255, 69, 100, 69),
          style: BorderStyle.solid,
        ),
      ),
      child: ClipOval(
        child: Image.asset('assets/logo/logo_principal.png'),
      ));
}
