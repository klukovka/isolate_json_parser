import 'dart:isolate';

import 'package:async/async.dart';
import 'package:isolate_json_parser/services/photo_provider.dart';

import '../models/photo.dart';

Stream<List<Photo>> sendAndReseivePhotos() async* {
  final port = ReceivePort();
  try {
    final photosJson = await PhotoProvider().getPhotos();

    final isolate = await Isolate.spawn(_readAndParseJson, port.sendPort);

    final events = StreamQueue(port);

    List<Photo> photos = [];

    // The first message from the spawned isolate is a SendPort. This port is
    // used to communicate with the spawned isolate.
    SendPort sendPort = await events.next;

    for (final photo in photosJson) {
      // Send the next filename to be read and parsed
      sendPort.send(photo);

      // Receive the parsed JSON
      Photo message = await events.next;

      // Add the result to the stream returned by this async* function.
      photos.add(message);
      yield photos;
    }

    // Send a signal to the spawned isolate indicating that it should exit.
    sendPort.send(null);

    // Dispose the StreamQueue.
    await events.cancel();
    isolate.kill();
  } catch (error) {
    throw Exception('Error with photos');
  }
}

Future<void> _readAndParseJson(SendPort port) async {
  // Send a SendPort to the main isolate so that it can send JSON strings to
  // this isolate.
  final commandPort = ReceivePort();
  port.send(commandPort.sendPort);

  // Wait for messages from the main isolate.
  await for (final message in commandPort) {
    if (message == null) {
      // Exit if the main isolate sends a null message, indicating there are no
      // more files to read and parse.
      break;
    }
    // Read and decode the file.
    final photo = Photo.fromMap(message);

    // Send the result to the main isolate.
    port.send(photo);
  }
}
