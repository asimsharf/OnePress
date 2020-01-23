import 'package:flutter/material.dart';
import 'package:onepress/pages/startPage.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopeModelWrapper extends StatefulWidget {
  @override
  _ScopeModelWrapperState createState() => _ScopeModelWrapperState();
}

class _ScopeModelWrapperState extends State<ScopeModelWrapper> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: AppModel(),
      child: StartPage(),
    );
  }
}

class AppModel extends Model {
  Locale _appLocale = Locale('ar');

  Locale get appLocal => _appLocale;

  void changeDirection() {
    print('Scoped Model has been Invoked');
    if (_appLocale == Locale("ar")) {
      _appLocale = Locale("en");
    } else {
      _appLocale = Locale("ar");
    }
    notifyListeners();
  }
}
