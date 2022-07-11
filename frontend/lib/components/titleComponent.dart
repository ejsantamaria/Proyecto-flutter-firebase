import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart' as Constants;

// ignore: must_be_immutable
class TitleComponent extends StatelessWidget {
  String title;

  TitleComponent({Key? key, this.title = "Sample Title"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        this.title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constants.BLACK,
            fontWeight: Constants.FONT_TITLE_WEIGHT,
            fontSize: 20),
      ),
    );
  }
}
