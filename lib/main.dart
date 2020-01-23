import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:onepress/model/onepress_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'language/Models/ScopeModelWrapper.dart';

var locale = 'ar';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => OnePresservice());
}

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(new ScopeModelWrapper());
  Admob.initialize(getAppId());
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  OneSignal.shared.init("2a12eacc-e0d9-47d8-afd7-81a0ddfad715", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });
}

String getAppId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-9035590506445700~3467890345';
  }
  return null;
}
