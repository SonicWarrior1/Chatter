import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeController extends GetxController {
  RxBool darkTheme = Get.isDarkMode.obs;
}
