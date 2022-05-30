import 'package:flutter/material.dart';
import 'dart:math';
import 'globals.dart' as globals;

class AddBorder extends StatelessWidget {
  String className;
  double confidence;
  double x = 0.0, y = 0, width = 0, height = 0;
  static List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.lime
  ];
  static Random random = new Random();
  int rand = random.nextInt(colors.length);

  AddBorder(this.className, this.confidence, this.x, this.y, this.width,
      this.height) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.x + this.width + 50,
        child: Stack(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Positioned(
                left: x,
                top: y - 25,
                child: Container(
                    width: 100,
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      className + " - " + confidence.toString(),
                      style: TextStyle(color: colors[rand]),
                    ))),
            Container(
                margin: EdgeInsets.only(left: x, top: y),
                width: width,
                height: height,
                decoration:
                    BoxDecoration(border: Border.all(color: colors[rand]))),
          ],
        ));
  }

  void setState(int Function() param0) {}
}
