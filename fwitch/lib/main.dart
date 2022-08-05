// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/authentication/login/views/login_page.dart';
import 'package:fwitch/authentication/signup/views/signup.dart';
import 'package:fwitch/home/views/home.dart';
import 'package:fwitch/onboarding.dart';
import 'package:fwitch/theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/': (context) => onBoarding(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home':(context)=>home(),
      },
      title: "Fwitch",
      // theme: MyTheme.lightTheme,
      theme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
