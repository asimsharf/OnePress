import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onepress/home_screen.dart';

import '../customviews/progress_dialog.dart';
import '../futures/app_futures.dart';
import '../pages/register_page.dart';
import '../utils/app_shared_preferences.dart';
import '../utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog =
      ProgressDialog.getProgressDialog(ProgressDialogTitles.USER_LOG_IN);

  TextEditingController emailController = new TextEditingController(text: "");

  TextEditingController passwordController =
      new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[_loginContainer(), progressDialog],
      ),
    );
  }

  Widget _loginContainer() {
    return new Container(
      padding: const EdgeInsets.only(top: 120.0),
      child: new ListView(
        children: <Widget>[
          new Center(
            child: new Column(
              children: <Widget>[
                _appIcon(),
                _formContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appIcon() {
    return new Container(
      child: new Image(
        image: new AssetImage("assets/logo.png"),
        height: 170.0,
        width: 170.0,
      ),
      margin: EdgeInsets.only(top: 20.0),
    );
  }

  Widget _formContainer() {
    return new Container(
      child: new Form(
        child: new Theme(
          data: new ThemeData(primarySwatch: Colors.red),
          child: Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: new Column(
              children: <Widget>[
                _emailContainer(),
                _passwordContainer(),
                _loginButtonContainer(),
                _registerNowLabel(),
                _skipContainer(),
              ],
            ),
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
    );
  }

  Widget _skipContainer() {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      },
      child: Text(
        "تخطى",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'jazeera',
        ),
      ),
    );
  }

  Widget _emailContainer() {
    return new Container(
      color: Colors.white,
      child: new TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail_outline),
          labelText: 'اسم المستخدم',
          fillColor: Color(0xFF37505D),
          labelStyle: TextStyle(
            fontFamily: 'jazeera',
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      margin: EdgeInsets.only(bottom: 20.0),
    );
  }

  Widget _passwordContainer() {
    return new Container(
      color: Colors.white,
      child: new TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'كلمة المرور',
          fillColor: Color(0xFF37505D),
          labelStyle: TextStyle(
            fontFamily: 'jazeera',
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
      ),
      margin: EdgeInsets.only(bottom: 35.0),
    );
  }

  Widget _loginButtonContainer() {
    return new Container(
      width: double.infinity,
      child: new MaterialButton(
        height: 40.0,
        minWidth: 100.0,
        color: Colors.red,
        textColor: Colors.white,
        splashColor: Colors.redAccent,
        padding: EdgeInsets.all(15.0),
        onPressed: _loginButtonAction,
        child: new Icon(FontAwesomeIcons.signInAlt),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
      margin: EdgeInsets.only(bottom: 30.0),
    );
  }

  Widget _registerNowLabel() {
    return new GestureDetector(
      onTap: _goToRegisterScreen,
      child: new Container(
        child: new Text(
          'إنشاء حساب',
          style: TextStyle(
            color: Colors.redAccent,
            fontFamily: 'jazeera',
          ),
        ),
        margin: EdgeInsets.only(bottom: 30.0),
      ),
    );
  }

  Future _loginButtonAction() async {
    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            'ادخل البريد الالكتروني',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jazeera',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text == "") {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            'ادخل كلمةة المرور',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jazeera',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    FocusScope.of(context).requestFocus(
      new FocusNode(),
    );
    progressDialog.showProgress();
    _loginUser(emailController.text, passwordController.text, context);
  }

  void _loginUser(String emailId, String password, BuildContext context) async {
    var eventObject = await loginUser(emailId, password);
    Map<String, dynamic> user = eventObject.object;
//    print("###THE LOGIN DETAIL FROM RESPONSE IS:  " + user.toString());
//    print('###USER ID IS:  ' + user['NEWS_APP'][0]['user_id']);
//    print('###USER INFOS IS:  ' + user.toString());
//    print('###EVENT OBJECT ID IS:  ' + eventObject.object.toString());
    print('###EVENT OBJECT ID IS:  ' + eventObject.id.toString());
//    print('###EVENT OBJECT MESSAGE IS:  ' + eventObject.message.toString());
    switch (eventObject.id) {
      case 1:
        {
          setState(
            () {
              AppSharedPreferences.setUserLoggedIn(true);
              AppSharedPreferences.setInSession(
                'userName',
                user['NEWS_APP'][0]['name'].toString(),
              );
              AppSharedPreferences.setInSession(
                'userEmail',
                user['NEWS_APP'][0]['email'].toString(),
              );
              AppSharedPreferences.setInSession(
                'userId',
                user['NEWS_APP'][0]['user_id'].toString(),
              );

              globalKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    eventObject.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'jazeera',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              progressDialog.hideProgress();
              _goToHomeScreen();
            },
          );
        }
        break;
      case 2:
        {
          setState(
            () {
              globalKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    eventObject.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'jazeera',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              progressDialog.hideProgress();
            },
          );
        }
        break;

      case 0:
        {
          setState(
            () {
              globalKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    eventObject.message,
                    style: TextStyle(
                      color: Color(0xFF37505D),
                      fontFamily: 'jazeera',
                    ),
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
              progressDialog.hideProgress();
            },
          );
        }
        break;
    }
  }

  void _goToHomeScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
        builder: (context) => new HomeScreen(),
      ),
    );
  }

  void _goToRegisterScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
        builder: (context) => new RegisterPage(),
      ),
    );
  }
}
