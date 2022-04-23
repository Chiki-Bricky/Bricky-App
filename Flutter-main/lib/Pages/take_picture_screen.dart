// @dart=2.9
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Pages/recognize_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../send_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'dart:math';

class TakePictureScreen extends StatefulWidget {
  //        <uses-permission android:name="android.permission.INTERNET" /><uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

  static const routeName = '/take-picture';
  // final Function onSelectImage;

  TakePictureScreen();

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class AddBorder extends StatelessWidget {
  double LU_X = 0.0, LU_Y = 0, RD_X = 0, RD_Y = 0;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.lime
  ];
  Random random = new Random();

  AddBorder(this.LU_X, this.LU_Y, this.RD_X, this.RD_Y) {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: LU_X, top: LU_Y),
          padding: EdgeInsets.only(left: RD_X, top: RD_Y),
          decoration: BoxDecoration(
              border: Border.all(color: colors[random.nextInt(colors.length)])),
          child: Text('.'),
        ),
      ],
    ));
  }

  void setState(int Function() param0) {}
}

class TakePictureScreenState extends State<TakePictureScreen> {
  static File storedImage;
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isButtonDisabled = false;
  List coordinateLU_X = [];
  List coordinateLU_Y = [];
  List coordinateRD_X = [];
  List coordinateRD_Y = [];
  List borders = [];
  bool isVisibleCircle = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addBorders() {
    isVisibleCircle = true;
  }

  void onSelectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Future<void> _sendPhoto() async {
    print("fwe");
    File imageFile = storedImage;
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
    // Тута по идее будет приходить ответ от сервера, так как я еще не знаю в каком виде, то в тупую пока заполняю массивы
    setState(() {
      coordinateLU_X.addAll([220, 20, 180]);
      coordinateLU_Y.addAll([56, 56, 230]);
      coordinateRD_X.addAll([86, 22, 154]);
      coordinateRD_Y.addAll([105, 59, 95]);
      isVisibleCircle = true;
    });
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
      storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    // widget.onSelectImage(savedImage);
    setState(() {
      _pickedImage = savedImage;
      _isButtonDisabled = true;
    });
  }

  Future<void> _takePictureFromGallery() async {
    final File imageFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      storedImage = imageFromGallery;
      _isButtonDisabled = true;
    });
  }

  void _repeatPhoto() {
    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take and send picture'),
      ),
      body: Column(
        children: [
          Stack(children: <Widget>[
            Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: storedImage != null
                  ? Image.file(
                      storedImage as File,
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
              for (int i = 0; i < coordinateLU_X.length; i++)
                if (isVisibleCircle)
                  AddBorder(
                      coordinateLU_X[i].toDouble(),
                      coordinateLU_Y[i].toDouble(),
                      coordinateRD_X[i].toDouble(),
                      coordinateRD_Y[i].toDouble()),
          ]),
          Expanded(
            child: Stack(
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: FlatButton.icon(
                        icon: _isButtonDisabled
                            ? const Icon(Icons.loop_rounded)
                            : Icon(Icons.camera),
                        label: _isButtonDisabled
                            ? Text("Choose another photo")
                            : Text('Take Picture'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed:
                            _isButtonDisabled ? _repeatPhoto : _takePicture,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: FlatButton.icon(
                        icon: _isButtonDisabled
                            ? const Icon(Icons.loupe_rounded)
                            : const Icon(Icons.photo_library),
                        label: _isButtonDisabled
                            ? Text("Recognize Details")
                            : Text('Gallery'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: _isButtonDisabled
                            ? _sendPhoto
                            : _takePictureFromGallery,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
