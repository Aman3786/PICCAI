import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      image: Image.asset('assets/logo.png'),
      photoSize: 50,
      backgroundColor: Colors.white,
      loaderColor: Colors.redAccent,
    );
  }
}
