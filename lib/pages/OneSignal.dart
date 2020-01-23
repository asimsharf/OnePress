import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:onepress/pages/newsDetails.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalPage extends StatefulWidget {
  @override
  _OneSignalPageState createState() => new _OneSignalPageState();
}

class _OneSignalPageState extends State<OneSignalPage> {
  String _debugLabelString = "";

//  String _emailAddress;
//  String _externalUserId;
  bool _enableConsentButton = true;

  /// CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    /// will be called whenever a notification is received
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
    OneSignal.shared.setNotificationReceivedHandler(
      (notification) {
        this.setState(
          () {
            _debugLabelString =
                "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
          },
        );
      },
    );

    /// will be called whenever a notification is opened/button pressed.
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
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) {
        this.setState(
          () {
            Navigator.popAndPushNamed(context, 'OnePressCategory');
            _debugLabelString =
                "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
          },
        );
      },
    );

    /// will be called whenever the subscription changes
    ///(ie. user gets registered with OneSignal and gets a user ID)
    OneSignal.shared.setSubscriptionObserver(
      (OSSubscriptionStateChanges changes) {
        print(
          "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}",
        );
      },
    );

    /// will be called whenever the permission changes
    /// (ie. user taps Allow on the permission prompt in iOS)
    OneSignal.shared.setPermissionObserver(
      (OSPermissionStateChanges changes) {
        print(
          "PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}",
        );
      },
    );

    /// will be called whenever then user's email subscription changes
    /// (ie. OneSignal.setEmail(email) is called and the user gets registered
    OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges changes) {
        print(
          "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}",
        );
      },
    );

    /// NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .init("2a12eacc-e0d9-47d8-afd7-81a0ddfad715", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(
      () {
        _enableConsentButton = requiresConsent;
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

//  void _handlePromptForPushPermission() {
//    print("Prompting for Permission");
//    OneSignal.shared.promptUserForPushNotificationPermission().then(
//      (accepted) {
//        print("Accepted permission: $accepted");
//      },
//    );
//  }
//
//  void _handleGetPermissionSubscriptionState() {
//    print("Getting permissionSubscriptionState");
//    OneSignal.shared.getPermissionSubscriptionState().then(
//      (status) {
//        this.setState(
//          () {
//            _debugLabelString = status.jsonRepresentation();
//          },
//        );
//      },
//    );
//  }
//
//  void _handleSendNotification() async {
//    var status = await OneSignal.shared.getPermissionSubscriptionState();
//
//    var playerId = status.subscriptionStatus.userId;
//
//    var imgUrlString =
//        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";
//
//    var notification = OSCreateNotification(
//      playerIds: [playerId],
//      content: "this is a test from OneSignal's Flutter SDK",
//      heading: "Test Notification",
//      iosAttachments: {"id1": imgUrlString},
//      bigPicture: imgUrlString,
//      buttons: [
//        OSActionButton(text: "test1", id: "id1"),
//        OSActionButton(text: "test2", id: "id2")
//      ],
//    );
//
//    var response = await OneSignal.shared.postNotification(notification);
//
//    this.setState(
//      () {
//        _debugLabelString = "Sent notification with response: $response";
//
//        print(_debugLabelString);
//      },
//    );
//  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'الإشعارات',
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'jazeera',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: new Table(
            children: [
//              new TableRow(
//                children: [
//                  new OneSignalButton("Prompt for Push Permission",
//                      _handlePromptForPushPermission, !_enableConsentButton)
//                ],
//              ),
//              new TableRow(
//                children: [
//                  new OneSignalButton(
//                      "Print Permission Subscription State",
//                      _handleGetPermissionSubscriptionState,
//                      !_enableConsentButton)
//                ],
//              ),
              new TableRow(
                children: [
                  Container(
                    height: 8.0,
                  )
                ],
              ),
//              new TableRow(
//                children: [
//                  new OneSignalButton("Post Notification",
//                      _handleSendNotification, !_enableConsentButton)
//                ],
//              ),
              new TableRow(
                children: [
                  new Container(
                    child: new Text(
                      _debugLabelString,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                      ),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
//typedef void OnButtonPressed();
//
//class OneSignalButton extends StatefulWidget {
//  final String title;
//  final OnButtonPressed onPressed;
//  final bool enabled;
//
//  OneSignalButton(this.title, this.onPressed, this.enabled);
//
//  State<StatefulWidget> createState() => new OneSignalButtonState();
//}
//
//class OneSignalButtonState extends State<OneSignalButton> {
//  @override
//  Widget build(BuildContext context) {
//    return Table(
//      children: [
//        TableRow(
//          children: [
//            RaisedButton.icon(
//              color: Colors.redAccent,
//              icon: Icon(Icons.notifications),
//              textColor: Colors.red,
//              label: Text(widget.title),
//              onPressed: widget.enabled ? widget.onPressed : null,
//            )
//          ],
//        ),
//        TableRow(
//          children: [
//            Container(
//              height: 8.0,
//            )
//          ],
//        ),
//      ],
//    );
//  }
//}
