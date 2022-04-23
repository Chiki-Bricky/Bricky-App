// @dart=2.9
// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/take_picture_screen.dart';
import 'package:flutter_application_1/Pages/recognize_details.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../send_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

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
  String _userToDO;
  List todoList = [];
  File _storedImage;
  File _pickedImage;
  bool isPhoto = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoList.addAll(['legoSet 1', 'legoSet 2', 'legoSet 3']);
  }

  void onSelectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _sendPhoto() async {
    File imageFile = _storedImage;
    List<int> imageBytes = await imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    final url = Uri.parse('http://10.0.2.2:5000/proccessImage');
    http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'image': base64Image,
      }),
    )
        .then(
      (response) {
        //print(json.decode(response.body));
        //add to list
        // _items.insert(0, newProduct); // at the start of the list
      },
    );
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
      isPhoto = true;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    // widget.onSelectImage(savedImage);
    setState(() {
      _pickedImage = savedImage;
    });
  }

  void recognizeDetails(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      RecognizeDetailsScreen.routeName,
    );
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Menu'),
            ),
            body: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    child: Text('On main menu')),
              ],
            ),
          );
        },
      ),
    );
  }

  void openCamera(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      TakePictureScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'My lego',
          style: TextStyle(
            color: Color.fromRGBO(255, 226, 5, 100),
            fontSize: 30,
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 5, 5, 100),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu_open_outlined),
            onPressed: _menuOpen,
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
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
                key: Key(todoList[index]),
                children: <Widget>[
                  TextButton(
                      child: Text(
                        todoList[index],
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
                                  todoList[index],
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 226, 5, 100),
                                    fontSize: 30,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(255, 5, 5, 100),
                                centerTitle: true,
                              ),
                              body: Center(
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/1.png"),
                                    TextButton(
                                      child: Text(
                                        todoList[index],
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 100),
                                          fontSize: 17,
                                          fontFamily: "MochiyPopPOne-Regular",
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
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCamera(context),
        child: Icon(
          Icons.camera_enhance,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Text('Тут будет фото:)'),
      //             content: TextField(
      //               //row instead of TextField for adding another widget
      //               onChanged: (String value) {
      //                 _userToDO = value;
      //               },
      //             ),
      //             actions: [
      //               ElevatedButton(
      //                   onPressed: () {
      //                     setState(() {
      //                       todoList.add(_userToDO);
      //                     });
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: Text('add'))
      //             ],
      //           );
      //         });
      //   },
      //   child: Icon(
      //     Icons.camera_enhance,
      //   ),
      // ),
    );
  }
}
