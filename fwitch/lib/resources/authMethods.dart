// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitch/models/user.dart' as model;
import 'package:fwitch/providers/user_provider.dart';
import 'package:fwitch/global_widgets/toast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
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
        model.MyUser user = model.MyUser(
            username: username.trim(),
            email: email.trim(),
            uid: creds.user!.uid,
            name: name.trim());
        await _userRef.doc(creds.user!.uid).set(user.toMap());
        await Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
        Toast.yoToast("Danm", "SignUp Succesful", context);
      }
    } on FirebaseAuthException catch (e) {
      Toast.yoToast("", e.message.toString(), context);
    }
    return res;
  }

  // googleSingin() async {
  //   User? user;
  //   final GoogleSignIn googleSignIn = GoogleSignIn();

  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn();

  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     try {
  //       final UserCredential userCredential =
  //           await _auth.signInWithCredential(credential);

  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // handle the error here
  //       } else if (e.code == 'invalid-credential') {
  //         // handle the error here
  //       }
  //     } catch (e) {
  //       // handle the error here
  //     }
  //   }

  //   return user;
  // }

  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    bool res = false;
    try {
      UserCredential creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (creds.user != null) {
        await Provider.of<UserProvider>(context, listen: false)
            .setUser(model.MyUser.fromMap(
          await getCurrentUser(creds.user!.uid) ?? {},
        ));
      }
      res = true;
    } on FirebaseAuthException catch (e) {
      Toast.yoToast("", e.message.toString(), context);
    }
    return res;
  }

  Future<String> resetPassword({required String email}) async {
    String res = "";
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => res = "success");
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/onBoarding');
  }
}
