import 'package:flutter/foundation.dart';
import 'package:fwitch/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(uid: '', username: '', email: '', name: '');
  User get user => _user; 
  setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
