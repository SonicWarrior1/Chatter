// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwitch/authentication/login/views/login_page.dart';
import 'package:fwitch/authentication/signup/views/signup_page.dart';
import 'package:fwitch/home/views/home.dart';
import 'package:fwitch/home/views/search.dart';
import 'package:fwitch/onboarding.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';

import 'package:fwitch/theme.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'models/user.dart' as model;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDfacIaxinbnuA2KDcvpXOzGEeQ89koJ0w",
            authDomain: "fwitch-8e933.firebaseapp.com",
            projectId: "fwitch-8e933",
            storageBucket: "fwitch-8e933.appspot.com",
            messagingSenderId: "458236514278",
            appId: "1:458236514278:web:c6073e600dac9c7414d027"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/onBoarding': (context) => onBoarding(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen()
    
      },
      title: "Fwitch",
      home: FutureBuilder(
        future: AuthMethods()
            .getCurrentUser(FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : null)
            .then((value) {
          if (value != null) {
            Provider.of<UserProvider>(context, listen: false).setUser(
              model.MyUser.fromMap(value),
            );
          }
          return value;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return onBoarding();
        },
      ),
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
