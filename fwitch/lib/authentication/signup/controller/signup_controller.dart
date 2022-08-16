import 'package:flutter/cupertino.dart';
import 'package:fwitch/resources/authMethods.dart';

import 'package:get/get.dart';

class SignUpController extends GetxController {
  final AuthMethods _authMethods = AuthMethods();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passworController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void signup(BuildContext context) async {
    bool res = await _authMethods.signupUser(
        emailController.text,
        usernameController.text,
        passworController.text,
        nameController.text,
        context);

    if (res) {
      Get.offAllNamed('/home');
      clear();
    }
  }

  clear() {
    emailController.clear();
    passworController.clear();
    usernameController.clear();
    nameController.clear();
  }
}
