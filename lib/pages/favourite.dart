import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class favourite extends StatefulWidget {
  @override
  _favouriteState createState() => new _favouriteState();
}

class _favouriteState extends State<favourite> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "المفضلة",
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'jazeera',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    final int size = 10;

    List<Widget> _children = List<Widget>.generate(
      size,
      (int index) => _buildListItem(text: "Index: $index"),
    );

    _children.insert(
      2,
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: ClipRRect(
          // rounded corners ad.
          borderRadius: BorderRadius.circular(40.0),
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.LEADERBOARD,
          ),
        ),
      ),
    );

    return ListView(
      children: _children,
    );
  }

  Widget _buildListItem({String text}) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Card(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.all(16)),
              Text(
                "This is a test widget.",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getAppId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-9035590506445700~3467890345';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return '';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-9035590506445700~3467890345';
  }
  return null;
}
