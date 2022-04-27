// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as IMG;

class ServerAPI with ChangeNotifier {
  static Future<http.Response> sendPhoto(File pickedImage) async {
    // File imageCopy =
    // await pickedImage.copy(pickedImage.parent.path + '/tmp.jpg');
    // IMG.Image img = IMG.decodeImage(await imageCopy.readAsBytes());
    // IMG.Image thumbnail = IMG.copyResize(img, width: 256, height: 256);
    // await imageCopy.writeAsBytes(IMG.encodeJpg(thumbnail));
    Uint8List imageBytes =
        (await rootBundle.load(pickedImage.path)).buffer.asUint8List();
    String base64Image = base64Encode(imageBytes);

    final url = Uri.parse('http://10.192.18.34:5000/proccessImage');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({
        'image': base64Image,
      }),
    );
    return response;
  }
}
