// @dart=2.9
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../send_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class TakePictureScreen extends StatefulWidget {
  //        <uses-permission android:name="android.permission.INTERNET" /><uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

  static const routeName = '/take-picture';
  // final Function onSelectImage;

  TakePictureScreen();

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  File _storedImage;
  File _pickedImage;

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
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    // widget.onSelectImage(savedImage);
    setState(() {
      _pickedImage = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take and send picture'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: _storedImage != null
                ? Image.file(
                    _storedImage as File,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  ),
            alignment: Alignment.center,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text('Take Picture'),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: _takePicture,
                ),
                const SizedBox(
                  height: 10,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text('Send Photo'),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: _sendPhoto,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
