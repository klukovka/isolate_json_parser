import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isolate_json_parser/isolates/main_isolate.dart';
import 'package:isolate_json_parser/pages/home_page/views/photo_item.dart';

import '../../models/photo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<Photo>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = sendAndReseivePhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Json Parser'),
      ),
      body: _buildDataVeiw(),
    );
  }

  Widget _buildDataVeiw() {
    return StreamBuilder<List<Photo>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        return Column(
          children: [
            _buildButtons(),
            Expanded(
              child: _buildPhotos(snapshot),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhotos(AsyncSnapshot<List<Photo>> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final data = snapshot.data;
        if (data == []) {
          return const Center(
            child: Text('List is empty'),
          );
        }
        if (data != null) {
          for (final photo in data) {
            return PhotoItem(photo: photo);
          }
        }
        return const SizedBox.shrink();
      },
      itemCount: snapshot.data?.length ?? 0,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 12);
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _stream = sendAndReseivePhotos();
            });
          },
          child: const Text('Load again'),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            setState(() {
              final streamController = StreamController<List<Photo>>();
              _stream = streamController.stream;
              streamController.sink.add([]);
            });
          },
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
