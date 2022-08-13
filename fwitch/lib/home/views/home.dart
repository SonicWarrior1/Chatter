import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fwitch/Feed%20Screen/views/feed_screen.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/home/controller/home_controller.dart';
import 'package:fwitch/live/views/go_live_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class home extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  final HomeController homeController = HomeController();
  home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: AppBar(actions: [
            IconButton(
              icon:
                  Icon(Get.isDarkMode ? Icons.sunny : Icons.wb_sunny_outlined),
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
          body: IndexedStack(
            index: homeController.pageindex.value,
            // alignment: Alignment.center,
            children: [FeedScreen(), GoLiveScreen(), Text("c")],
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: homeController.setPage,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.secondary,
              currentIndex: homeController.pageindex.value,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Following"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_rounded), label: "Go Live"),
                BottomNavigationBarItem(icon: Icon(Icons.copy), label: "Browse")
              ]));
    });
  }
}
