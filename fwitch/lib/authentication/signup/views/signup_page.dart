import 'package:flutter/material.dart';
import 'package:fwitch/authentication/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);
  final signupController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: SingleChildScrollView(
            child: Form(
              key: signupController.formKey,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: signupController.isSigningUp.isTrue
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 100,
                                child: Image.asset("assets/chat.png")),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: signupController.nameController,
                              decoration: const InputDecoration(
                                label: Text("Name"),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: signupController.usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Username";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                label: Text("Username"),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: signupController.emailController,
                              validator: (value) {
                                if (RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)) {
                                  return null;
                                } else {
                                  return "Please enter valid email";
                                }
                              },
                              decoration: const InputDecoration(
                                label: Text("Email"),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: signupController.passworController,
                              decoration: const InputDecoration(
                                label: Text("Password"),
                              ),
                              validator: (String? value) {            
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password.'.tr;
                                }
                                return null;
                              },
                              obscureText: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offNamed('/login');
                                  },
                                  child: const Text(
                                    "Already have an Account ?",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: SizedBox(
                                width: 200,
                                height: 40,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: () {
                                    if (signupController.formKey.currentState!
                                        .validate()) {
                                      signupController.signup(context);
                                    }
                                  },
                                  child: Text(
                                    "Signup",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
