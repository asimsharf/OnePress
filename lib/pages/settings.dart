import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "اﻹعدادات",
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
      body: Center(
        child: Text('This is main page nav'),
      ),
    );
  }
}
