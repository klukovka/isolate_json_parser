import 'package:flutter/material.dart';
import 'package:isolate_json_parser/pages/home_page/home_page.dart';

class IsolateJsonParserApp extends StatelessWidget {
  const IsolateJsonParserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate Json Parser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
