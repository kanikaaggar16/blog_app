import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'authentication.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return new MaterialApp(
      title: "BLog App",

      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),

      home: Mapping(auth: Auth(),),

    );
  }
}

