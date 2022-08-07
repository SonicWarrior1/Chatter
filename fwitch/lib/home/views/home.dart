import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fwitch/authentication/authMethods.dart';

class home extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: ElevatedButton(
        child: Text("Press"),
        onPressed: () {
          _authMethods.getUserDetails();
        },
      ),
    );
  }
}
