import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart' as Constants;

// ignore: must_be_immutable
class ModalComponent extends StatelessWidget {
  Widget? body;

  ModalComponent({Key? key, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
        body: new Stack(
          children: [
            new Center(
              child: new ClipRect(
                child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: new BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.1)),
                      child: new Center(
                        child: new SizedBox(
                          child: body,
                        ),
                      ),
                    )),
              ),
            )
          ],
        ));
  }
}

// ignore: must_be_immutable
class ModalCard extends StatelessWidget {
  List<Widget> children;
  bool scroll;
  Function()? onClose;
  String? title;
  ModalCard(
      {Key? key,
      this.children = const <Widget>[],
      this.onClose,
      this.title,
      this.scroll = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
      margin: EdgeInsets.symmetric(vertical: 75, horizontal: 15),
      color: Colors.white,
      elevation: Constants.ELEVATION,
      child: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(32),
        child: Stack(
          children: [
            (!this.scroll)
                ? Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: children,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 50, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  ),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Constants.BORDER_RADIOUS)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (this.title != null) ? this.title.toString() : "",
                        style: TextStyle(
                            color: Constants.TEXT_COLOR,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                      TextButton(
                        onPressed: this.onClose,
                        child: Icon(Icons.close),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
