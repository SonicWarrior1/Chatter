// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/global_widgets/toast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RxBool isLoggingIn = false.obs;
  loginUser(BuildContext context) async {
    isLoggingIn.value = true;
    bool res = await _authMethods.loginUser(
        loginEmail.text, loginPassword.text, context);
    if (res) {
      Toast.yoToast("Danmm", "Login Sucess", context);
      Get.offAllNamed('/home');
      isLoggingIn.value = false;
      clearControllers();
    }
  }
  clearControllers() {
    loginEmail.clear();
    loginPassword.clear();
  }

  resetPassword(BuildContext context) async {
    if (loginEmail.text.isNotEmpty) {
      var res = await _authMethods.resetPassword(email: loginEmail.text);
      if (res == "success") {
        FocusManager.instance.primaryFocus?.unfocus();
        Toast.yoToast(
            "",
            "Reset Link has been sent Succesfully to your email address",
            context);
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        Toast.yoToast("", res, context);
      }
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      Toast.yoToast("", "Please fill the email field", context);
    }
  }

}
