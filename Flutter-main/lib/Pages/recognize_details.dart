// @dart=2.9
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import '../send_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_application_1/Pages/take_picture_screen.dart';

class RecognizeDetailsScreen extends StatefulWidget {
  //        <uses-permission android:name="android.permission.INTERNET" /><uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

  static const routeName = '/recognize-details';
  // final Function onSelectImage;

  RecognizeDetailsScreen();

  @override
  _RecognizeDetailsScreenState createState() => _RecognizeDetailsScreenState();
}

class AddBorder extends StatelessWidget {
  double LU_X = 0.0, LU_Y = 0, RD_X = 0, RD_Y = 0;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.lime
  ];
  Random random = new Random();

  AddBorder(this.LU_X, this.LU_Y, this.RD_X, this.RD_Y) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: LU_X, top: LU_Y),
          padding: EdgeInsets.only(left: RD_X, top: RD_Y),
          decoration: BoxDecoration(
              border: Border.all(color: colors[random.nextInt(colors.length)])),
          child: Text('.'),
        ),
      ],
    ));
  }

  void setState(int Function() param0) {}
}

class _RecognizeDetailsScreenState extends State<RecognizeDetailsScreen> {
  File _storedImage;
  File _pickedImage;
  List coordinateLU_X = [];
  List coordinateLU_Y = [];
  List coordinateRD_X = [];
  List coordinateRD_Y = [];
  List borders = [];
  bool isVisibleCircle = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    coordinateLU_X.addAll([220, 20, 180]);
    coordinateLU_Y.addAll([56, 56, 230]);
    coordinateRD_X.addAll([86, 22, 154]);
    coordinateRD_Y.addAll([105, 59, 95]);
  }

  void addBorders() {
    isVisibleCircle = true;
    // for (int i = 1; i < 9; i++) {
    //   borders.add(AddBorder(198, 48, 82, 98));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recognize details'),
        ),
        body: Column(children: [
          Stack(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Container(
                  // width: 200,
                  // height: 200,
                  // child: Image.asset("assets/images/5.jpg"),
                  child: Image.file(
                TakePictureScreenState.storedImage,
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  // color: Colors.blueGrey,
                  ),
              if (isVisibleCircle)
                for (int i = 0; i < coordinateLU_X.length; i++)
                  if (isVisibleCircle)
                    AddBorder(
                        coordinateLU_X[i].toDouble(),
                        coordinateLU_Y[i].toDouble(),
                        coordinateRD_X[i].toDouble(),
                        coordinateRD_Y[i].toDouble()),
            ],
          ),
          TextButton(
              child: Text('Recognize details'),
              onPressed: () {
                setState(() {
                  isVisibleCircle = true;
                });
              })
        ]));
  }
}



    //  showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return Scaffold(
    //               appBar: AppBar(
    //                 title: const Text('Take and send picture'),
    //               ),
    //               body: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Container(
    //                     width: 150,
    //                     height: 200,
    //                     decoration: BoxDecoration(
    //                       border: Border.all(width: 1, color: Colors.grey),
    //                     ),
    //                     child: _storedImage != null
    //                         ? Image.file(
    //                             _storedImage,
    //                             fit: BoxFit.cover,
    //                             width: double.infinity,
    //                           )
    //                         : const Text(
    //                             'No Image Taken',
    //                             textAlign: TextAlign.center,
    //                           ),
    //                     alignment: Alignment.center,
    //                   ),
    //                   const SizedBox(
    //                     width: 10,
    //                   ),
    //                   Expanded(
    //                     child: Column(
    //                       children: [
    //                         const SizedBox(
    //                           height: 10,
    //                         ),
    //                         FlatButton.icon(
    //                           icon: Icon(Icons.camera),
    //                           label: Text('Send Photo'),
    //                           textColor: Theme.of(context).primaryColor,
    //                           onPressed: _sendPhoto,
    //                         ),
    //                         FlatButton.icon(
    //                           icon: Icon(Icons.camera),
    //                           label: Text('Recognize Details'),
    //                           textColor: Theme.of(context).primaryColor,
    //                           onPressed: () => recognizeDetails(context),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             );
    //           });