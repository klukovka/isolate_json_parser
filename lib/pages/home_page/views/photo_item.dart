import 'package:flutter/material.dart';
import 'package:isolate_json_parser/models/photo.dart';

class PhotoItem extends StatelessWidget {
  final Photo photo;

  const PhotoItem({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(photo.title),
          Image.network(photo.url),
        ],
      ),
    );
  }
}
