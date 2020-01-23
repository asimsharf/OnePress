import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customviews/progress_dialog.dart';
import '../futures/app_futures.dart';
import '../models/base/EventObject.dart';
import '../pages/LoginPage.dart';
import '../utils/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  ProgressDialog progressDialog =
      ProgressDialog.getProgressDialog(ProgressDialogTitles.USER_REGISTER);

  TextEditingController nameController = new TextEditingController(text: "");
  TextEditingController emailController = new TextEditingController(text: "");
  TextEditingController phoneController = new TextEditingController(text: "");
  TextEditingController passwordController =
      new TextEditingController(text: "");

  bool isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          _loginContainer(context),
          progressDialog,
        ],
      ),
    );
  }

  Widget _loginContainer(BuildContext context) {
    return new Container(
        child: new ListView(
      children: <Widget>[
        new Center(
          child: new Column(
            children: <Widget>[
              _appIcon(),
              _formContainer(context),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _appIcon() {
    return new Container(
      child: new Image(
        image: new AssetImage("assets/logo.png"),
        height: 170.0,
        width: 170.0,
      ),
      margin: EdgeInsets.only(top: 10.0),
    );
  }

  Widget _formContainer(BuildContext context) {
    return new Container(
      child: new Form(
        child: new Theme(
          data: new ThemeData(primarySwatch: Colors.red),
          child: Container(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: new Column(
              children: <Widget>[
                _nameContainer(),
                _phoneContainer(),
                _emailContainer(),
                _passwordContainer(),
                _registerButtonContainer(),
                _loginNowLabel(),
              ],
            ),
          ),
        ),
      ),
      margin: EdgeInsets.only(top: 5.0, left: 25.0, right: 25.0),
    );
  }

  Widget _nameContainer() {
    return new Container(
      height: 70.0,
      color: Colors.white,
      child: new TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'الاسم بالكامل',
          labelStyle: TextStyle(
            fontFamily: 'jazeera',
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.text,
      ),
      margin: EdgeInsets.only(bottom: 5.0),
    );
  }

  Widget _emailContainer() {
    return new Container(
      color: Colors.white,
      height: 70.0,
      child: new TextFormField(
        controller: emailController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail_outline),
            labelText: 'البريد الالكتروني',
            fillColor: Colors.red,
            labelStyle: TextStyle(
              fontFamily: 'jazeera',
              fontWeight: FontWeight.bold,
            )),
        keyboardType: TextInputType.emailAddress,
      ),
      margin: EdgeInsets.only(bottom: 5.0),
    );
  }

  Widget _passwordContainer() {
    return new Container(
        height: 70.0,
        color: Colors.white,
        child: new TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'كلمة المرور',
              fillColor: Colors.red,
              labelStyle: TextStyle(
                fontFamily: 'jazeera',
                fontWeight: FontWeight.bold,
              )),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        margin: EdgeInsets.only(bottom: 5.0));
  }

  Widget _phoneContainer() {
    return new Container(
      color: Colors.white,
      height: 70.0,
      child: new TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: 'موبايل',
              labelStyle: TextStyle(
                fontFamily: 'jazeera',
                fontWeight: FontWeight.bold,
              )),
          keyboardType: TextInputType.phone),
      margin: EdgeInsets.only(bottom: 5.0),
    );
  }

  Widget _registerButtonContainer() {
    return new Container(
      width: double.infinity,
      child: new MaterialButton(
        height: 40.0,
        minWidth: 100.0,
        color: Colors.red,
        splashColor: Colors.redAccent,
        textColor: Colors.white,
        child: new Icon(FontAwesomeIcons.signInAlt),
        padding: EdgeInsets.all(15.0),
        onPressed: _registerButtonAction,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget _loginNowLabel() {
    return new GestureDetector(
      onTap: _goToLoginScreen,
      child: new Container(
          child: new Text(
            'لديك حساب',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'jazeera',
            ),
          ),
          margin: EdgeInsets.only(bottom: 30.0)),
    );
  }

  void _registerButtonAction() {
    if (nameController.text == "") {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            'يرجى إدخال الإسم ',
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

    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            'يرجى إدخال البريد الإلكتروني',
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

    if (!isValidEmail(emailController.text)) {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            'يرجى كتابة بريد صحيح',
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

    if (phoneController.text == "") {
      globalKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
            "يرجى إدخال رقم الهاتف",
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
            'يرجى إدخال كلمة المرور',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'jazeera',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).requestFocus(new FocusNode());
    progressDialog.showProgress();
    _registerUser(
      nameController.text,
      emailController.text,
      passwordController.text,
      phoneController.text,
    );
  }

  void _registerUser(
      String name, String email, String password, String phone) async {
    EventObject eventObject = await registerUser(name, email, password, phone);
    switch (eventObject.id) {
      case 1:
        {
          setState(() {
            globalKey.currentState.showSnackBar(
              new SnackBar(
                content: new Text(
                  'تم إنشاء حساب بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'jazeera',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
            progressDialog.hideProgress();
            _goToLoginScreen();
          });
        }
        break;
      case 2:
        {
          setState(
            () {
              globalKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    'المستخدم موجود مسبقاً',
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
          setState(() {
            globalKey.currentState.showSnackBar(
              new SnackBar(
                content: new Text(
                  "لم يتم إنشاء الحساب يرجى المحاوله مرى إخرى",
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
          });
        }
        break;
    }
  }

  void _goToLoginScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new LoginPage()),
    );
  }
}
