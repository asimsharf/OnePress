import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/SingleNews.dart';

class Comments extends StatefulWidget {
  List<UserComment> userComment;

  Comments({
    this.userComment,
  });

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: Text(
          "التعليقات",
          style: TextStyle(
            fontFamily: 'jazeera',
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),

      /// body in chat like a list in a message
      body: Container(
        color: Colors.white,
        child: new Column(children: <Widget>[
          new Flexible(
            child: _messages.length > 0
                ? Container(
                    child: new ListView.builder(
                      itemCount: _messages.length,
                      reverse: true,
                      padding: new EdgeInsets.all(10.0),
                      itemBuilder: (_, int index) {
                        return _messages[index];
                      },
                    ),
                  )
                : NoMessage(),
          ),

          /// Line
          new Divider(height: 1.5),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(
              color: Theme.of(ctx).cardColor,
              boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.black12)],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                        controller: _textController,
                        onChanged: (String txt) {
                          setState(() {
                            _isWriting = txt.length > 0;
                          });
                        },
                        onSubmitted: _submitMsg,
                        decoration: new InputDecoration.collapsed(
                          hintText: "أكتب تعليق هنا ...",
                          hintStyle: TextStyle(
                            fontFamily: 'jazeera',
                            fontSize: 16.0,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : new IconButton(
                          icon: new Icon(Icons.message),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)),
                )
              : null),
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(
          milliseconds: 800,
        ),
      ),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});

  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.all(00.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(1.0),
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                        color: Colors.red.withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.all(00.0),
                      child: ListTile(
                        leading: Container(
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/logo.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        title: Text(
                          "OnePress",
                          style: TextStyle(
                            fontFamily: 'jazeera',
                            color: Colors.white,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 0.5,
                          ),
                        ),
                        subtitle: Text(
                          txt,
                          style: TextStyle(
                            fontFamily: 'jazeera',
                            color: Colors.white,
                            letterSpacing: 0.3,
                            wordSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/IlustrasiMessage.png",
                    height: 220.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "لا توجد تعليقات حتى اﻷن",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black12,
                  fontSize: 17.0,
                  fontFamily: 'jazeera',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
