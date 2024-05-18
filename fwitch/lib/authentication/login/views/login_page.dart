// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fwitch/authentication/login/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key); 
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: loginController.formkey,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: loginController.isLoggingIn.isTrue
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 100,
                              child: Image.asset("assets/login.png")),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: loginController.loginEmail,
                            decoration: InputDecoration(
                              label: Text("Email"),
                            ),
                            validator: (value) {
                              if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)) {
                                return null;
                              } else {
                                return "Please enter valid email";
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: loginController.loginPassword,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text("Password"),
                            ),
                            onFieldSubmitted: (value) {
                              if (loginController.formkey.currentState!
                                  .validate()) {
                                loginController.loginUser(context);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password.'.tr;
                              }
                              return null;
                            },
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Get.offNamed("/signup");
                                        },
                                        child: Text(
                                          "Don't have an account ?",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          loginController
                                              .resetPassword(context);
                                        },
                                        child: Text(
                                          "Forgot Password",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              top: 20,
                            ),
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  if (loginController.formkey.currentState!
                                      .validate()) {
                                    loginController.loginUser(context);
                                  }
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
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
