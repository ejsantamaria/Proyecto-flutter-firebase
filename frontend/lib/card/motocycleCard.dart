import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart' as Constants;
late String defaultiamge = "https://res.cloudinary.com/dydttkb7s/image/upload/v1645048970/ic_launcher_lhjvqs.png";

class BikeCard extends StatefulWidget {
  const BikeCard({Key? key, required this.currentMotocycle}) : super(key: key);
  final CollectionReference currentMotocycle;

  @override
  _BikeCardState createState() => _BikeCardState();
}

class _BikeCardState extends State<BikeCard> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      child: StreamBuilder(
          stream: widget.currentMotocycle.orderBy('name').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading'));
            }
            return Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  children: snapshot.data!.docs.map((motocycle) {
                    if (motocycle['Rol'].toString() != "Motorizado") {
                      print(motocycle['name'].toString());
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Constants.VINTAGE,
                          radius: 50.0,
                          child: Text(
                            motocycle['name'].substring(0, 1) +
                                motocycle['surname'].substring(0, 1),
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                            motocycle['name'] + ' ' + motocycle['surname'],
                            style: Theme.of(context).textTheme.headline5),
                        subtitle: Column(
                          children: [
                            ListTile(
                              title: Text('Dirección'),
                              subtitle: Text(motocycle['address']),
                              leading: Icon(Icons.home_outlined,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            ListTile(
                              title: Text('Edad'),
                              subtitle: Text(motocycle['age']),
                              leading: Icon(Icons.account_circle_outlined,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
    );
  }
}
