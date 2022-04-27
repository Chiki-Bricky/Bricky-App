// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import '../send_image.dart';
import 'dart:math';

class TakePictureScreen extends StatefulWidget {
  static const routeName = '/take-picture';

  TakePictureScreen();

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class AddBorder extends StatelessWidget {
  String className;
  double x = 0.0, y = 0, width = 0, height = 0;
  static List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.lime
  ];
  static Random random = new Random();
  int rand = random.nextInt(colors.length);

  AddBorder(this.className, this.x, this.y, this.width, this.height) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: x, top: y),
          width: width,
          height: height,
          decoration: BoxDecoration(border: Border.all(color: colors[rand])),
          child: Text(
            className,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors[rand]),
          ),
        ),
      ],
    ));
  }

  void setState(int Function() param0) {}
}

class TakePictureScreenState extends State<TakePictureScreen> {
  static File pickedImage;
  String serverResponse;

  List bordersX = [];
  List bordersY = [];
  List bordersWidth = [];
  List bordersHeight = [];
  List bordersNames = [];
  bool isVisibleCircle = false;

  void onSelectImage(File selectedImage) {
    pickedImage = selectedImage;
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
      pickedImage = savedImage;
    });
  }

  Future<void> _sendPhoto() async {
    bordersNames.clear();
    bordersX.clear();
    bordersY.clear();
    bordersWidth.clear();
    bordersHeight.clear();

    if (pickedImage == null) {
      setState(() {
        serverResponse = "No image provided!";
      });
      return;
    }
    http.Response response = await ServerAPI.sendPhoto(pickedImage);
    print("Response status: ${response.statusCode}");

    final Map parsed = json.decode(response.body);
    final bricks = parsed['bricks'];

    setState(() {
      serverResponse =
          "Response status: ${response.statusCode}, Bricks founded: ${bricks.length}";
      for (int i = 0; i < bricks.length; i++) {
        final singleBrick = bricks[i];
        print(singleBrick);
        bordersNames.add(singleBrick['class']);
        bordersX.add(singleBrick['xmin']);
        bordersY.add(singleBrick['ymin']);
        bordersWidth.add(singleBrick['xmax'] - singleBrick['xmin']);
        bordersHeight.add(singleBrick['ymax'] - singleBrick['ymin']);
      }
      isVisibleCircle = true;
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
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.grey),
              ),
              child: pickedImage != null
                  ? Image.asset(
                      pickedImage.path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Text(
                      'No Image Taken',
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            if (isVisibleCircle)
              for (int i = 0; i < bordersNames.length; i++)
                if (isVisibleCircle)
                  AddBorder(
                      bordersNames[i],
                      bordersX[i].toDouble() *
                          ((MediaQuery.of(context).size.width) / 1024),
                      bordersY[i].toDouble() * ((500) / 1024),
                      bordersWidth[i].toDouble() *
                          ((MediaQuery.of(context).size.width) / 1024),
                      bordersHeight[i].toDouble() * ((500) / 1024)),
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
