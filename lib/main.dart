// @dart=2.9
import 'package:flutter/material.dart';

import 'package:Bricky/Pages/home.dart';
import 'package:Bricky/Pages/take_picture_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
