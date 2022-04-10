// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import '../send_image.dart';

class TakePictureScreen extends StatefulWidget {
  static const routeName = '/take-picture';

  TakePictureScreen();

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  File _pickedImage;
  String serverResponse;

  void onSelectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _takePictureFromCamera() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    _saveImage(imageFile);
  }

  Future<void> _takePictureFromGallery() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    _saveImage(imageFile);
  }

  Future<void> _saveImage(PickedFile imageFile) async {
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

  Future<void> _sendPhoto() async {
    if (_pickedImage == null) {
      setState(() {
        serverResponse = "No image provided!";
      });
      return;
    }
    http.Response response = await ServerAPI.sendPhoto(_pickedImage);
    print("Response status: ${response.statusCode}");
    setState(() {
      serverResponse = "Response status: ${response.statusCode}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take and send picture'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.grey),
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
            height: 20,
          ),
          TextButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            onPressed: _takePictureFromCamera,
          ),
          TextButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            onPressed: _takePictureFromGallery,
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('Send Photo'),
            onPressed: _sendPhoto,
          ),
          Text(serverResponse ?? 'No request'),
        ],
      ),
    );
  }
}
