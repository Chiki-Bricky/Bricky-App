// @dart=2.9
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Pages/home.dart';
import 'package:flutter_application_1/Pages/mainScene.dart';
import 'package:flutter_application_1/Pages/take_picture_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  // final cameras = await availableCameras();
  // final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      // home: MainScrene(),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        TakePictureScreen.routeName: (ctx) => TakePictureScreen(),
      },
    ),
  );
}
