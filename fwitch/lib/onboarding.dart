// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:fwitch/authentication/login/controller/login_controller.dart';
import 'package:fwitch/authentication/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class onBoarding extends StatelessWidget {
  onBoarding({Key? key}) : super(key: key);
  SignUpController signUpController = Get.put(SignUpController());
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Chatter",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 30,
            ),
           
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: () {
                  loginController.clearControllers();
                  Get.toNamed('/login');
                },
                child: Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onSecondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                onPressed: () {
                  signUpController.clear();
                  Get.toNamed('/signup');
                },
                child: Text(
                  "Signup",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
