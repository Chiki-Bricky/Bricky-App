// @dart=2.9
// ignore_for_file: prefer_const_constructors, unnecessary_new, dead_code

import 'package:flutter/material.dart';

import 'package:Bricky/Pages/take_picture_screen.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  // final CameraDescription camera;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late String _userToDO;
  // String userToDO;
  // List detailList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    globals.detailList.addAll(['detail 1', 'detail 2', 'detail 3']);
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
            itemCount: globals.detailList.length,
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 150,
                  width: 70,
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    key: Key(globals.detailList[index]),
                    children: <Widget>[
                      TextButton(
                          child: Text(
                            globals.detailList[index],
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
                                      globals.detailList[index],
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 226, 5, 100),
                                        fontSize: 30,
                                      ),
                                    ),
                                    backgroundColor:
                                        Color.fromRGBO(255, 5, 5, 100),
                                    centerTitle: true,
                                  ),
                                  body: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/1.png"),
                                        TextButton(
                                          child: Text(
                                            globals.detailList[index],
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 100),
                                              fontSize: 17,
                                              fontFamily:
                                                  "MochiyPopPOne-Regular",
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ));
                          }),
                      Image.asset("assets/images/1.png"),
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
                    if (globals.bordersNames.isNotEmpty) {
                      for (int i = 0; i < globals.bordersNames.length; i++) {
                        globals.detailList.add(globals.bordersNames[i]);
                      }
                      _setPrefs();
                      globals.bordersNames.clear();
                    }
                  });
                }),
          ],
        ));
  }

  void _removeItem(int index) {
    setState(() => globals.detailList.removeAt(index));
    _setPrefs();
  }

  void _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('DetailList', globals.detailList);
  }

  void _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('DetailList') != null) {
      globals.detailList = prefs.getStringList('DetailList');
    }
  }
}
