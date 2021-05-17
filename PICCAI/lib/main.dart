import 'package:flutter/material.dart';
// import 'home.dart';
import 'splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PICCAI',
      theme: ThemeData.dark(),
      home: MySplash()
    );
  }
}




