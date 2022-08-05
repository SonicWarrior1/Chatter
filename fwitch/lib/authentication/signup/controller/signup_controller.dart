import 'package:flutter/cupertino.dart';
import 'package:fwitch/authentication/authMethods.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passworController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void signup() async {
    bool res = await _authMethods.signupUser(
        emailController.text, usernameController.text, passworController.text);
    if (res) {
      Get.toNamed('/home');
    }
  }
}
