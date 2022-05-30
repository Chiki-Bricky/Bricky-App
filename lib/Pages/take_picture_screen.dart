// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../send_image.dart';
import 'package:image/image.dart' as ImageCrop;
import 'borders.dart';
import 'globals.dart' as globals;

class TakePictureScreen extends StatefulWidget {
  static const routeName = '/take-picture';

  TakePictureScreen();

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  static File pickedImage;
  String serverResponse;

  String fileName = null;
  String docsPath;

  @override
  Future<void> initState() {
    super.initState();
    final appDir = getApplicationDocumentsDirectory();
    appDir.then((value) => docsPath = '${value.path}');
  }

  void onSelectImage(File selectedImage) {
    pickedImage = selectedImage;
  }

  Future<void> _takePictureFromCamera() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    _saveImage(imageFile);
  }

  Future<void> _takePictureFromGallery() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _saveImage(imageFile);
  }

  Future<void> _saveImage(File imageFile) async {
    if (imageFile == null) {
      return;
    }

    if (imageFile != null) {
      CroppedFile cropped = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 640,
          maxHeight: 640,
          compressFormat: ImageCompressFormat.jpg);

      final fileName = 'Image_${globals.photosPaths.length}';
      final imagePath = '${docsPath}/${fileName}';
      final savedImage = await File(cropped.path).copy(imagePath);

      globals.photosPaths.add(fileName);
      this.fileName = fileName;

      setState(() {
        pickedImage = savedImage;
      });
    } else {
      pickedImage = null;
    }
  }

  Future<void> _sendPhoto() async {
    if (pickedImage == null) {
      setState(() {
        serverResponse = "No image provided!";
      });
      return;
    }
    http.Response response = await ServerAPI.sendPhoto(pickedImage);

    final decodedImage =
        await decodeImageFromList(pickedImage.readAsBytesSync());
    print("Response status: ${response.statusCode}");

    final Map parsed = json.decode(response.body);
    final bricks = parsed['bricks'];

    setState(() {
      serverResponse =
          "Response status: ${response.statusCode}, Bricks founded: ${bricks.length}";

      final photoBricks = [];
      for (int i = 0; i < bricks.length; i++) {
        final singleBrick = bricks[i];

        final brickMap = {
          "class": singleBrick['class'],
          "confidence": singleBrick['confidence'],
          "x": singleBrick['xmin'],
          "y": singleBrick['ymin'],
          "width": singleBrick['xmax'] - singleBrick['xmin'],
          "height": singleBrick['ymax'] - singleBrick['ymin']
        };

        photoBricks.add(brickMap);

        final brickImage = ImageCrop.copyCrop(
            ImageCrop.decodeImage(
                File('${docsPath}/${fileName}').readAsBytesSync()),
            (brickMap['x'] * decodedImage.width).toInt(),
            (brickMap['y'] * decodedImage.width).toInt(),
            (brickMap['width'] * decodedImage.width).toInt(),
            (brickMap['height'] * decodedImage.width).toInt());
        File('${docsPath}/${fileName}_${i}')
            .writeAsBytes(ImageCrop.encodePng(brickImage));
      }
      if (fileName != null && globals.photoDetails[fileName] == null) {
        globals.photoDetails[fileName] = photoBricks;
      }
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
        children: [
          Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.grey),
              ),
              child: pickedImage != null
                  ? Image.file(
                      pickedImage as File,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Text(
                      'No Image Taken',
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            if (this.fileName != null &&
                globals.photoDetails[this.fileName] != null)
              for (int i = 0;
                  i < globals.photoDetails[this.fileName].length;
                  i++)
                AddBorder(
                    globals.photoDetails[this.fileName][i]['class'],
                    globals.photoDetails[this.fileName][i]['confidence'],
                    globals.photoDetails[this.fileName][i]['x'].toDouble() *
                        ((MediaQuery.of(context).size.width)),
                    globals.photoDetails[this.fileName][i]['y'].toDouble() *
                        ((MediaQuery.of(context).size.width)),
                    globals.photoDetails[this.fileName][i]['width'].toDouble() *
                        ((MediaQuery.of(context).size.width)),
                    globals.photoDetails[this.fileName][i]['height']
                            .toDouble() *
                        ((MediaQuery.of(context).size.width))),
          ]),
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
