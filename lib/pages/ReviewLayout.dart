import 'package:flutter/material.dart';

class ReviewsAll extends StatefulWidget {
  @override
  _ReviewsAllState createState() => _ReviewsAllState();
}

class _ReviewsAllState extends State<ReviewsAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "التعليقات",
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'jazeera',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    height: 45.0,
                    width: 45.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                  ),
                  title: Text(
                    "محمد على احمد على",
                    style: TextStyle(
                      fontFamily: 'jazeera',
                      color: Colors.black54,
                      letterSpacing: 0.3,
                      wordSpacing: 0.5,
                    ),
                  ),
                  subtitle: Text(
                    'من اجمل ما وجدت على شبكة الانترنت تطبيق ون بريس الاخباري',
                    style: TextStyle(
                      fontFamily: 'jazeera',
                      color: Colors.black54,
                      letterSpacing: 0.3,
                      wordSpacing: 0.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 15.0,
                    bottom: 7.0,
                  ),
                  child: _line(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}
