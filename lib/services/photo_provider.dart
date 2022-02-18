import 'dart:convert';
import 'package:http/http.dart' as http;

class PhotoProvider {
  // http://jsonplaceholder.typicode.com/photos

  Future<List<dynamic>> getPhotos() async {
    final responce =
        await http.get(Uri.http('jsonplaceholder.typicode.com', 'photos'));
    if (responce.statusCode == 200) {
      return json.decode(responce.body);
    } else {
      throw Exception('Error with photos');
    }
  }
}
