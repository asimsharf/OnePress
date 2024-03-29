import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class AppSharedPreferences {
///////////////////////////////////////////////////////////////////////////////
  static Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

///////////////////////////////////////////////////////////////////////////////
  static Future<bool> isUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(SharedPreferenceKeys.IS_USER_LOGGED_IN);
    } catch (Exception) {
      print(Exception.toString());
      false;
    }
  }

  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(SharedPreferenceKeys.IS_USER_LOGGED_IN, isLoggedIn);
  }

///////////////////////////////////////////////////////////////////////////////

  static Future<bool> setInSession(String key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Object> getFromSession(String str) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(str);
    } catch (Exception) {
      return null;
    }
  }
}
