// @dart=2.9
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../send_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:flutter/services.dart' show rootBundle;

class TakePictureScreen extends StatefulWidget {
  static const routeName = '/take-picture';

  TakePictureScreen();

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  File _pickedImage;
  String text;

  void onSelectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _sendPhoto() async {
    Image img = Image.asset(_pickedImage.path);
    Uint8List imageBytes =
        (await rootBundle.load(_pickedImage.path)).buffer.asUint8List();
    String base64Image = base64Encode(imageBytes);

    final url = Uri.parse('http://192.168.31.234:5000/proccessImage');
    http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'image': base64Image,
      }),
    )
        .then((response) {
      print("Response status: ${response.statusCode}");
      setState(() {
        text = "Response status: ${response.statusCode}";
      });
    });
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (imageFile == null) {
      return;
    }

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');

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
            child: _pickedImage != null
                ? Image.asset(
                    _pickedImage.path,
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
                TextButton.icon(
                  icon: Icon(Icons.camera),
                  label: const Text('Take Picture'),
                  onPressed: _takePicture,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  icon: Icon(Icons.camera),
                  label: const Text('Send Photo'),
                  onPressed: _sendPhoto,
                ),
                text != null
                    ? Text(
                        text,
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        'No request',
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
