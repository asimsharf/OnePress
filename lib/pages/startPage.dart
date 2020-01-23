import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onepress/Account/UserLoginRegister/pages/SplashLogin.dart';
import 'package:onepress/home_screen.dart';
import 'package:onepress/language/Models/ScopeModelWrapper.dart';
import 'package:onepress/language/utils/app_Localization.dart';
import 'package:onepress/language/utils/app_LocalizationDeledate.dart';
import 'package:onepress/pages/AboutApps.dart';
import 'package:onepress/pages/ChoseLoginOrSignup.dart';
import 'package:onepress/pages/OneSignal.dart';
import 'package:onepress/pages/ReviewLayout.dart';
import 'package:onepress/pages/ShareContent.dart';
import 'package:onepress/pages/comments.dart';
import 'package:onepress/pages/favourite.dart';
import 'package:onepress/pages/lastNewsPage.dart';
import 'package:onepress/pages/mostReadNews.dart';
import 'package:onepress/pages/onePressCategory.dart';
import 'package:onepress/pages/profilePage.dart';
import 'package:onepress/pages/settings.dart';
import 'package:onepress/youtubeMan.dart';
import 'package:scoped_model/scoped_model.dart';

import 'SplachScreen.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'One Press',
        onGenerateTitle: (BuildContext context) =>
            DemoLocalizations.of(context).title['title'],
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("en", ""),
          Locale("ar", ""),
        ],
        locale: model.appLocal,
        theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
          backgroundColor: Colors.white,
          primaryColorLight: Colors.white,
          primaryColorBrightness: Brightness.light,
          fontFamily: 'jazeera',
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          "HomeScreen": (BuildContext context) => HomeScreen(),
          "ChoseLogin": (BuildContext context) => ChoseLogin(),
          "LastNewsPage": (BuildContext context) => LastNewsPage(),
          "MostReadNews": (BuildContext context) => MostReadNews(),
          "Settings": (BuildContext context) => Settings(),
          "favourite": (BuildContext context) => favourite(),
          "OnePressCategory": (BuildContext context) => OnePressCategory(),
          "ProfilePage": (BuildContext context) => ProfilePage(),
          "ShareContent": (BuildContext context) => ShareContent(),
          "OneSignalPage": (BuildContext context) => OneSignalPage(),
          "SplashLogin": (BuildContext context) => SplashLogin(),
          "aboutApps": (BuildContext context) => aboutApps(),
          "ReviewsAll": (BuildContext context) => ReviewsAll(),
          "Comments": (BuildContext context) => Comments(),
          "YoutubeMainPlayer": (BuildContext context) => YoutubeMainPlayer(),
        },
      ),
    );
  }
}
