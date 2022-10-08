import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fwitch/onboarding.dart';

import '../../home/views/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key,required this.home}) : super(key: key);
  final bool home;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>widget.home==true? const HomeScreen():onBoarding())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
            ),
          ],
        ),
      ],
    ));
  }
}
