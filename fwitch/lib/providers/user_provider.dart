import 'package:flutter/foundation.dart';
import 'package:fwitch/models/user.dart';

class UserProvider extends ChangeNotifier {
  MyUser _user = MyUser(uid: '', username: '', email: '', name: '');
  MyUser get user => _user; 
  setUser(MyUser user) {
    _user = user;
    notifyListeners();
  }
}
