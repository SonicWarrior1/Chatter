import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/authentication/authMethods.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  loginUser() async {
    bool res =
        await _authMethods.loginUser(loginEmail.text, loginPassword.text);
    if (res) {
      Get.toNamed('/home');
    }
  }

  googleLogin() async {
    User? user = await _authMethods.googleSingin();
    if (user != null) {
      Get.toNamed('/home');
    }
  }
}
