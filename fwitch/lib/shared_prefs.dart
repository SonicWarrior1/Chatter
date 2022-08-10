import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String loginStatus = "login_status";

  static Future<void> setUsername(String value) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setString("username", value);
  }

  static Future<String?> getUsername() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString("username");
  }

  static Future<void> setLoginStatus(bool status) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setBool(loginStatus, status);
  }

  static Future<bool?> getLoginStatus() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getBool(loginStatus);
  }
}
