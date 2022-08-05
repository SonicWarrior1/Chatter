import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fwitch/models/user.dart' as model;
import 'package:get/get.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<bool> signupUser(
      String email, String username, String password) async {
    bool res = false;
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (creds.user != null) {
        model.User user = model.User(
            username: username.trim(),
            email: email.trim(),
            uid: creds.user!.uid);
        await _userRef.doc(creds.user!.uid).set(user.toMap());
        res = true;
        Get.snackbar("Damn", "Signup Succesfull");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Damn",
        "${e.message}",
      );
      print(e.message!);
    }
    return res;
  }
}
