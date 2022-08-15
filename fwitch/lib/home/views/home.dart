import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/home/controller/home_controller.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  final HomeController homeController = HomeController();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(Get.isDarkMode ? Icons.sunny : Icons.wb_sunny_outlined),
          onPressed: () {
            Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          },
        ),
        Tooltip(
          message: "Sign Out",
          child: IconButton(
              onPressed: () {
                _authMethods.signout();
              },
              icon: Icon(Icons.logout)),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/search');
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
