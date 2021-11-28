import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/home.dart';
import 'package:flutter_application_1/Pages/mainScene.dart';

void main() => runApp(MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent,
        ),
        // home: MainScrene(),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        }));
