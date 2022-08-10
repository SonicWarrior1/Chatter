import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/user.dart' as model;
import 'package:fwitch/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  // RxString uid = "".obs;
  // RxString username = "".obs;
  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

  Future<bool> signupUser(String email, String username, String password,
      String name, BuildContext context) async {
    bool res = false;
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (creds.user != null) {
        model.User user = model.User(
            username: username.trim(),
            email: email.trim(),
            uid: creds.user!.uid,
            name: name.trim());
        await _userRef.doc(creds.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user);
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

  // getUserDetails() {
  //   var currentUser = _auth.currentUser;
  //   uid.value = currentUser!.uid;
  // }

  googleSingin() async {
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    bool res = false;
    try {
      UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (creds.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(model.User.fromMap(
          await getCurrentUser(creds.user!.uid) ?? {},
        ));
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Damn",
        "${e.message}",
      );
    }
    return res;
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/onBoarding');
  }
}
