import 'package:flutter/cupertino.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:fwitch/toast.dart';
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
  // googleLogin() async {
  //   isLoggingIn.value = true;
  //   User? user = await _authMethods.googleSingin();
  //   isLoggingIn.value = false;
  //   if (user != null) {
  //     Get.offAllNamed('/home');
  //   }
  // }
}
