import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onepress/Account/UserLoginRegister/pages/SplashLogin.dart';
import 'package:onepress/Account/UserLoginRegister/pages/register_page.dart';
import 'package:onepress/Library/carousel_pro/src/carousel_pro.dart';
import 'package:onepress/pages/newsDetails.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../home_screen.dart';

class ChoseLogin extends StatefulWidget {
  @override
  _ChoseLoginState createState() => _ChoseLoginState();
}

/// Component Widget this layout UI
class _ChoseLoginState extends State<ChoseLogin> with TickerProviderStateMixin {
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setNotificationReceivedHandler(
      (notification) {
        var notify = notification.payload.additionalData;
        if (notify["new_id"] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetails(id: notify["new_id"]),
            ),
          );
        }
      },
    );

    OneSignal.shared.setNotificationOpenedHandler(
      (notification) {
        var notify = notification.notification.payload.additionalData;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetails(id: notify["new_id"]),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    OneSignal.shared.setNotificationOpenedHandler(
      (notification) {
        var notify = notification.notification.payload.additionalData;
        if (notify["new_id"] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetails(id: notify["new_id"]),
            ),
          );
        }
      },
    );
    OneSignal.shared.setNotificationReceivedHandler(
      (notification) {
        var notify = notification.payload.additionalData;
        if (notify["new_id"] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetails(id: notify["new_id"]),
            ),
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  /// Declare Animation
  AnimationController animationController;
  var tapLogin = 0;
  var tapSignup = 0;

  @override

  /// Declare animation in initState
  void initState() {
    // TODO: implement initState

    super.initState();

    /// Animation proses duration
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addStatusListener(
            (statuss) {
              if (statuss == AnimationStatus.dismissed) {
                setState(() {
                  tapLogin = 0;
                  tapSignup = 0;
                });
              }
            },
          );

    initPlatformState();
  }

  /// To dispose animation controller
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    // TODO: implement dispose
  }

  /// Playanimation set forward reverse
  Future<Null> _Playanimation() async {
    try {
      await animationController.forward();
      await animationController.reverse();
    } on TickerCanceled {}
  }

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    mediaQuery.devicePixelRatio;
    mediaQuery.size.height;
    mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ///
          /// Set background image slider
          ///
          Container(
            color: Colors.white,
            child: new Carousel(
              boxFit: BoxFit.cover,
              autoplay: true,
              animationDuration: Duration(milliseconds: 300),
              dotSize: 0.0,
              dotSpacing: 16.0,
              dotBgColor: Colors.transparent,
              showIndicator: false,
              overlayShadow: false,
              images: [
                AssetImage('assets/stack_bg.png'),
                AssetImage("assets/stack_bg.png"),
                AssetImage('assets/stack_bg.png'),
                AssetImage("assets/stack_bg.png"),
              ],
            ),
          ),
          Container(
            /// Set Background image in layout (Click to open code)
            decoration: BoxDecoration(
//              image: DecorationImage(
//                  image: AssetImage('assets/img/girl.png'), fit: BoxFit.cover)
                ),
            child: Container(
              /// Set gradient color in image (Click to open code)
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.3),
                    Color.fromRGBO(0, 0, 0, 0.4)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                ),
              ),

              /// Set component layout
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Container(
                            alignment: AlignmentDirectional.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: mediaQuery.padding.top + 50.0,
                                  ),
                                ),
                                Center(
                                  /// Animation text treva shop accept from splashscreen layout (Click to open code)
                                  child: Hero(
                                    tag: "One",
                                    child: Text(
                                      "One Press",
                                      style: TextStyle(
                                        fontFamily: 'jazeera',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 32.0,
                                        letterSpacing: 0.4,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Padding Text "Get best product in treva shop" (Click to open code)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 160.0,
                                      right: 160.0,
                                      top: mediaQuery.padding.top + 190.0,
                                      bottom: 10.0),
                                  child: Container(
                                    color: Colors.white,
                                    height: 0.5,
                                  ),
                                ),

                                /// to set Text "get best product...." (Click to open code)
                                Text(
                                  "أحصل على أخر اﻷخبار",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: 'jazeera',
                                    letterSpacing: 1.3,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 250.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              /// To create animation if user tap == animation play (Click to open code)
                              tapLogin == 0
                                  ? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            tapLogin = 1;
                                          });
                                          _Playanimation();
                                          return tapLogin;
                                        },
                                        child: ButtonCustom(txt: "إنشاء حساب"),
                                      ),
                                    )
                                  : AnimationSplashSignup(
                                      animationController:
                                          animationController.view,
                                    ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0,
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    /// To set white line (Click to open code)
                                    Container(
                                      color: Colors.white,
                                      height: 0.2,
                                      width: 80.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                      ),

                                      /// navigation to home screen if user click "OR SKIP" (Click to open code)
                                      child: InkWell(
                                        splashColor: Colors.redAccent,
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  HomeScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "أو تخطى",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'jazeera',
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// To set white line (Click to open code)
                                    Container(
                                      color: Colors.white,
                                      height: 0.2,
                                      width: 80.0,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 70.0,
                                ),
                              ),
                            ],
                          ),

                          /// To create animation if user tap == animation play (Click to open code)
                          tapSignup == 0
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        tapSignup = 1;
                                      });
                                      _Playanimation();
                                      return tapSignup;
                                    },
                                    child: ButtonCustom(txt: "تسجيل دخول"),
                                  ),
                                )
                              : AnimationSplashLogin(
                                  animationController: animationController.view,
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Button Custom widget
class ButtonCustom extends StatelessWidget {
  @override
  String txt;
  GestureTapCallback ontap;

  ButtonCustom({this.txt});

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white,
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            width: 300.0,
            height: 52.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Center(
                child: Text(
              txt,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'jazeera',
                  letterSpacing: 0.5),
            )),
          );
        }),
      ),
    );
  }
}

/// Set Animation Login if user click button login
class AnimationSplashLogin extends StatefulWidget {
  AnimationSplashLogin({
    Key key,
    this.animationController,
  })  : animation = new Tween(
          end: 900.0,
          begin: 70.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        super(key: key);

  final AnimationController animationController;
  final Animation animation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.0),
      child: Container(
        height: animation.value,
        width: animation.value,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: animation.value < 600 ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  @override
  _AnimationSplashLoginState createState() => _AnimationSplashLoginState();
}

/// Set Animation Login if user click button login
class _AnimationSplashLoginState extends State<AnimationSplashLogin> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.addListener(() {
      if (widget.animation.isCompleted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => new SplashLogin(),
          ),
        );
      }
    });
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: widget._buildAnimation,
    );
  }
}

/// Set Animation signup if user click button signup
class AnimationSplashSignup extends StatefulWidget {
  AnimationSplashSignup({Key key, this.animationController})
      : animation = new Tween(
          end: 900.0,
          begin: 70.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        super(key: key);

  final AnimationController animationController;
  final Animation animation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.0),
      child: Container(
        height: animation.value,
        width: animation.value,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: animation.value < 600 ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  @override
  _AnimationSplashSignupState createState() => _AnimationSplashSignupState();
}

/// Set Animation signup if user click button signup
class _AnimationSplashSignupState extends State<AnimationSplashSignup> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.addListener(() {
      if (widget.animation.isCompleted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => new RegisterPage(),
          ),
        );
      }
    });
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: widget._buildAnimation,
    );
  }
}
