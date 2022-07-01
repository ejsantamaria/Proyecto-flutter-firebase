import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/motocycleModel.dart';
//import 'package:frontend/models/pedidoModel.dart';
import 'package:frontend/utils/constants.dart' as Constants;
//import 'package:frontend/widgets/Card/orderCard.dart';

import '../provider/main_provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

class OrderMot extends StatefulWidget {
  const OrderMot({Key? key, required this.motocycle, required this.pendiente})
      : super(key: key);
  final String motocycle;
  final bool pendiente;
  @override
  State<OrderMot> createState() => _OrderMotState();
}

class _OrderMotState extends State<OrderMot> {
  static final DateTime now = DateTime.now();
  var newDate = new DateTime(now.year, now.month, now.day-3);
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    UserApp motocycleObject = new UserApp.fromJson(
        json.decode(mainProvider.motocycle) as Map<String, dynamic>);
    final Stream<QuerySnapshot> _pedidoStrem = widget.pendiente
        ? FirebaseFirestore.instance
            .collection('pedidos')
            .where(
              "estado",
              whereIn: ["recogido", "en proceso", "en ruta"],
            )
            .where("uid_mot", isEqualTo: motocycleObject.uid)
            //.where("fecha", isGreaterThanOrEqualTo: newDate)
            .snapshots()
        : FirebaseFirestore.instance
            .collection('pedidos')
            .where("estado", isEqualTo: "Entregado")
            .where("uid_mot", isEqualTo: motocycleObject.uid)
            //.where("fecha", isGreaterThanOrEqualTo: newDate)
            .snapshots();

    return Scaffold(
        backgroundColor: Constants.VINTAGE,
        appBar: AppBar(
          title: Text('Detalles del pedido'),
          shadowColor: Constants.VINTAGE,
          backgroundColor: Constants.BACKGROUNDS,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _pedidoStrem,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                const Center(
                  child: Center(child: Text("Error al consultar los pedidos")),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator()),
                );
              }
              return ListView();
              /*return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Pedido model =
                    Pedido.fromJson(document.data() as Map<String, dynamic>);
                model.documentId = document.id;
                dev.log(model.toJson().toString(),
                    name: "model from OrderMorPage");
                if(newDate.isBefore(model.fecha!)) {
                  return  OrderCard(
                  pedido: model,
                  pendiente: widget.pendiente,
                );
                };
                return  Container();
              }).toList());*/
            }));
  }
}
