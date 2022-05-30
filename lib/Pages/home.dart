// @dart=2.9
// ignore_for_file: prefer_const_constructors, unnecessary_new, dead_code

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Bricky/Pages/take_picture_screen.dart';
import 'globals.dart' as globals;
import 'borders.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String docsPath;

  @override
  Future<void> initState() {
    super.initState();
    final appDir = getApplicationDocumentsDirectory();
    appDir.then((value) => docsPath = '${value.path}/');
  }

  void openCamera(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      TakePictureScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    _getPrefs();
    return _buildPage();
  }

  Widget _buildPage() {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [],
            ),
            Expanded(
              child: _buildList(),
            )
          ],
        ),
      ),
    );

    Column(
      children: <Widget>[
        //  _buildBox(),
        _buildList(),
      ],
    );
  }

  Widget _buildList() {
    return Scaffold(
        body: ListView.builder(
            itemCount: globals.photosPaths.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: UniqueKey(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 150,
                  width: 70,
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    key: Key(globals.photosPaths[index]),
                    children: <Widget>[
                      TextButton(
                          child: Text(
                            globals.photosPaths[index],
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 100),
                              fontSize: 17,
                              fontFamily: "MochiyPopPOne-Regular",
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text(
                                      globals.photosPaths[index],
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 226, 5, 100),
                                        fontSize: 30,
                                      ),
                                    ),
                                    backgroundColor:
                                        Color.fromRGBO(255, 5, 5, 100),
                                    centerTitle: true,
                                  ),
                                  body: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Stack(children: <Widget>[
                                          Image.asset(
                                              '${docsPath}/${globals.photosPaths[index]}'),
                                          if (globals.photoDetails[globals.photosPaths[index]] !=
                                              null)
                                            for (int i = 0; i < globals.photoDetails[globals.photosPaths[index]].length; i++)
                                              AddBorder(
                                                  globals.photoDetails[globals.photosPaths[index]]
                                                      [i]['class'],
                                                  globals.photoDetails[globals.photosPaths[index]]
                                                      [i]['confidence'],
                                                  globals.photoDetails[globals.photosPaths[index]][i]['x'].toDouble() *
                                                      ((MediaQuery.of(context)
                                                          .size
                                                          .width)),
                                                  globals.photoDetails[globals.photosPaths[index]][i]['y'].toDouble() *
                                                      ((MediaQuery.of(context)
                                                          .size
                                                          .width)),
                                                  globals.photoDetails[globals.photosPaths[index]][i]['width'].toDouble() *
                                                      ((MediaQuery.of(context)
                                                          .size
                                                          .width)),
                                                  globals.photoDetails[globals.photosPaths[index]]
                                                              [i]['height']
                                                          .toDouble() *
                                                      ((MediaQuery.of(context).size.width)))
                                        ]),
                                        Container(
                                          height: 300,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              itemCount: globals
                                                  .photoDetails[globals
                                                      .photosPaths[index]]
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext partContext,
                                                      int partIndex) {
                                                return Container(
                                                    height: 100,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            16, 5, 16, 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          globals.photoDetails[
                                                                  globals.photosPaths[
                                                                      index]][
                                                              partIndex]['class'],
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    100),
                                                            fontSize: 17,
                                                            fontFamily:
                                                                "MochiyPopPOne-Regular",
                                                          ),
                                                        ),
                                                        Image.asset(
                                                            '${docsPath}/${globals.photosPaths[index]}_${partIndex}',
                                                            width: 100,
                                                            height: 100),
                                                        Image.asset(
                                                            'assets/bricks/${globals.photoDetails[globals.photosPaths[index]][partIndex]['class']}.jpeg',
                                                            width: 100,
                                                            height: 100),
                                                      ],
                                                    ));
                                              }),
                                        )
                                      ]),
                                );
                              },
                            ));
                          }),
                      Image.asset('${docsPath}/${globals.photosPaths[index]}',
                          width: 100, height: 100),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    _removeItem(index);
                  });
                },
              );
            }),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              iconSize: 50,
              color: Colors.blue,
              onPressed: () => openCamera(context),
            ),
            IconButton(
                icon: const Icon(Icons.update),
                iconSize: 50,
                color: Colors.blue,
                onPressed: () {
                  setState(() {
                    // if (globals.photosPaths.isNotEmpty) {
                    //   for (int i = 0; i < globals.photosPaths.length; i++) {
                    //     globals.detailList.add(globals.photosPaths[i]);
                    //   }
                    //   _setPrefs();
                    //   globals.bordersNames.clear();
                    // }
                  });
                }),
          ],
        ));
  }

  void _removeItem(int index) {
    setState(() => globals.photosPaths.removeAt(index));
    _setPrefs();
  }

  void _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('photosPaths', globals.photosPaths);
  }

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('DetailList') != null) {
      // globals.photosPaths = prefs.getStringList('photosPaths');
    }
  }
}
