// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ServerAPI with ChangeNotifier {
  static Future<http.Response> sendPhoto(File pickedImage) async {
    Image img = Image.asset(pickedImage.path);
    Uint8List imageBytes =
        (await rootBundle.load(pickedImage.path)).buffer.asUint8List();
    String base64Image = base64Encode(imageBytes);

    final url = Uri.parse('http://192.168.31.234:5000/proccessImage');
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
