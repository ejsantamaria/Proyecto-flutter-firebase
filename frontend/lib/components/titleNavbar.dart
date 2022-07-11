import 'package:flutter/material.dart';
import 'package:frontend/components/titleComponent.dart';
import 'package:frontend/utils/constants.dart' as Constants;

// ignore: must_be_immutable
class TitleNavbar extends StatelessWidget {
  String title;
  Function()? onPressed;
  TitleNavbar({Key? key, this.title = "", this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Positioned(
              child: TextButton(
                  onPressed: this.onPressed,
                  child:
                      Icon(Icons.chevron_left, color: Constants.TEXT_COLOR))),
          TitleComponent(
            title: this.title,
          ),
          SizedBox(width: 20),
        ]));
  }
}
