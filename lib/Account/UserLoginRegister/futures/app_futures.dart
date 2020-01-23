import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onepress/Account/UserLoginRegister/models/UserProfile.dart';
import 'package:onepress/Account/UserLoginRegister/utils/app_shared_preferences.dart';

import '../models/base/EventObject.dart';
import '../utils/constants.dart';

var ratess = new Map();

var userName;
var userEamil;
var userImage;
bool isLogIn = false;

Future<String> getUserName() async {
  return await AppSharedPreferences.getFromSession('userName');
}

Future<String> getUserId() async {
  return await AppSharedPreferences.getFromSession('userId');
}

Future<EventObject> loginUser(String emailId, String password) async {
  try {
    bool logedIn = await AppSharedPreferences.isUserLoggedIn();
    print('this is firebase logedIn ' + logedIn.toString());
    final response = await http.get(
      "http://sudanews.sudagoras.com/api.php?users_login&email=" +
          emailId +
          "&password=" +
          password,
    );
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return new EventObject(
          id: EventConstants.LOGIN_USER_SUCCESSFUL,
          object: responseJson,
          message: 'تمت عمليه الدخول بنجاح',
        );
      } else {
        return new EventObject(
            id: EventConstants.LOGIN_USER_UN_SUCCESSFUL,
            message: 'عفواً خطأ في كلمة المرور او إسم المستخدم!');
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject(
        id: 0, message: 'Exception !!!!!!!!!!!!!!!!!!' + Exception.toString());
  }
}

Future<EventObject> registerUser(
    String name, String email, String password, String phone) async {
  try {
    final response = await http.get(
      'http://sudanews.sudagoras.com//api.php?user_register&name=$name&email=$email&password=$password&phone=$phone',
      headers: {'Content-Type': 'application/json'},
    );
    print('response : ' + response.body.toString());
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return new EventObject(
            id: EventConstants.LOGIN_USER_SUCCESSFUL,
            object: responseJson,
            message: 'تمت عمليه التسجيل بنجاح');
      } else {
        return new EventObject(
            id: EventConstants.LOGIN_USER_UN_SUCCESSFUL,
            message: 'عفواً خطأ في المدخلات ');
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    print('Exception' + Exception.toString());
    return EventObject(id: 0);
  }
}

dynamic getNotificatinData(dynamic token) {
  print('this is notification data :' + token.toString());
  print('message :' + token['message'].toString());
  print('title :' + token['title'].toString());
  print('line_one :' + token['line_one'].toString());
  print('line_two :' + token['line_two'].toString());
  print('line_three :' + token['line_three'].toString());
  return jsonDecode(token);
}

Future<EventObject> changePassword(
    String emailId, String oldPassword, String newPassword) async {
  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(
        'http://23.111.185.155:3000/api/auth/reset_password',
        body: _changePasswordToJson(emailId, oldPassword, newPassword),
        encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['code'] == 1) {
          return new EventObject(
              id: EventConstants.LOGIN_USER_SUCCESSFUL,
              object: responseJson,
              message: 'تم تغيير كلمة السر');
        } else if (responseJson['code'] == 2) {
          return new EventObject(
              id: 2,
              message: 'عفواً خطأ في كلمة المرور او إسم المستخدم!',
              object: responseJson);
        } else {
          return new EventObject(
              id: 3, message: 'عفواً خطأ جانب المخدم!', object: responseJson);
        }
      } else {
        return new EventObject(
            id: EventConstants.LOGIN_USER_UN_SUCCESSFUL,
            message: 'عفواً خطأ في كلمة المرور او إسم المستخدم!');
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}

String _changePasswordToJson(
    String emailId, String oldPassword, String newPassword) {
  var mapData = new Map();

  mapData["email"] = emailId;
  mapData["password"] = oldPassword;
  mapData["newPassword"] = newPassword;

  String json = jsonEncode(mapData);

  return json;
}

String _upDateToJson(
    String firstName, String lastName, String phone, String email) {
  var mapData = new Map();

  mapData["name.first"] = firstName;
  mapData["name.last"] = lastName;
  mapData["phone"] = phone;
  mapData["email"] = email;

  String json = jsonEncode(mapData);

  return json;
}

Future<EventObject> updateUserInfo(String firstName, String lastName,
    String phone, String email, String userId) async {
  String id = '';
  if (userId != null) {
    id = userId;
  }

  final _headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.put(
        'http://23.111.185.155:3000/api/client/' + id + '/update',
        headers: _headers,
        body: _upDateToJson(firstName, lastName, phone, email));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        Map<String, dynamic> responseJson = json.decode(response.body);

        if (responseJson['code'] == 1) {
          return new EventObject(
              id: EventConstants.LOGIN_USER_SUCCESSFUL,
              object: responseJson,
              message: 'تمت عمليه التعديل بنجاح');
        } else {
          return new EventObject(
              id: EventConstants.LOGIN_USER_UN_SUCCESSFUL,
              message: 'عفواً خطأ في كلمة المدخلات');
        }
      } else {
        return new EventObject(
            id: EventConstants.LOGIN_USER_UN_SUCCESSFUL,
            message: 'عفواً خطأ في المدخلات ');
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject(id: 0);
  }
}

Future<UserProfile> getUserProfile(String id) async {
  String link = "http://23.111.185.155:3000/api/client/" + id;
  var res = await http
      .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
  if (res.statusCode == 200) {
    var _UserProfile = json.decode(res.body);
    return UserProfile.fromMap(_UserProfile);
  } else {
    return UserProfile.fromMap(null);
  }
}
