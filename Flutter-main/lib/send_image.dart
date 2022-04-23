// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Send with ChangeNotifier {
  // File storedImage;

  // Send(this.storedImage);

  Future<void> sendPhoto(File storedImage) async {
    if (storedImage == null) {
      print('Oops...');
    } else {
      List<int> imageBytes = await storedImage.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      final url = Uri.parse('http://127.0.0.1:5000/proccessImage');
      http
          .post(
        url,
        body: json.encode({
          'image': base64Image,
        }),
      )
          .then(
        (response) {
          print(json.decode(response.body));
          //add to list
          // _items.insert(0, newProduct); // at the start of the list
        },
      );
    }
  }
}
