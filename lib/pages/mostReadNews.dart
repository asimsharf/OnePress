import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onepress/model/NewsModel.dart';
import 'package:onepress/pages/newsDetails.dart';
import 'package:timeago/timeago.dart' as timeago;

class MostReadNews extends StatefulWidget {
  @override
  _MostReadNewsState createState() => _MostReadNewsState();
}

class _MostReadNewsState extends State<MostReadNews> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _loading = false;

  ///Future to fetch all the Most Read News
  List<NewsModel> _modelMostReadNews = <NewsModel>[];

  Future<List<NewsModel>> getMostReadNews() async {
    String link = "http://sudanews.sudagoras.com//api.php?most_view_news";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    setState(() {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["NEWS_APP"] as List;

        _modelMostReadNews =
            rest.map<NewsModel>((rest) => NewsModel.fromJson(rest)).toList();

        _loading = false;
      }
    });
    return _modelMostReadNews;
  }

  Future<Null> _refresh() {
    return getMostReadNews().then(
      (modelCen) {
        setState(
          () => _modelMostReadNews = modelCen,
        );
      },
    );
  }

  String _since(String dateTime) {
    String published = '';
    DateTime nowDateTime = new DateTime.now();
    DateTime publishedDateTime = DateTime.parse(dateTime);

    int _year = nowDateTime.year;
    int _month = nowDateTime.month;
    int _weekday = nowDateTime.weekday;
    int _hour = nowDateTime.hour;
    int _minute = nowDateTime.minute;

    int _resNewsyear = publishedDateTime.year;
    int _resNewsmonth = publishedDateTime.month;
    int _resNewsweekday = publishedDateTime.weekday;
    int _resNewshour = publishedDateTime.hour;
    int _resNewsminute = publishedDateTime.minute;

    if (_resNewsyear < _year) {
      published = 'منذ ' + (_year - _resNewsyear).toString() + ' سنة';
    } else if (_resNewsmonth < _month) {
      published = 'منذ ' + (_month - _resNewsmonth).toString() + ' شهر';
    } else if (_resNewsweekday < _weekday) {
      published = 'منذ ' + (_weekday - _resNewsweekday).toString() + ' اسبوع';
    } else if (_resNewshour < _hour) {
      published = 'منذ ' + (_hour - _resNewshour).toString() + ' ساعة';
    } else if (_resNewsminute < _minute) {
      published = 'منذ ' + (_minute - _resNewsminute).toString() + ' دقيقة';
    }

    return published;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshIndicatorKey.currentState.show(),
    );
    setState(() {
      this.getMostReadNews();
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: new IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          "اﻷكثر قراءة",
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
      body: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("assets/stack_bg.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: _loading
                        ? new Center(child: new CircularProgressIndicator())
                        : _buildMostReadNews(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// _Builder for Most Readed News
  /// The Container showen over
  /// here
  Widget _buildMostReadNews() {
    return ListView.builder(
      itemCount: _modelMostReadNews.length,
      itemBuilder: (BuildContext context, int index) {
        final _mostReadNewsObj = _modelMostReadNews[index];

        String _parseHtmlString(String htmlString) {
          var document = parse(htmlString);
          String parsedString = parse(document.body.text).documentElement.text;
          return parsedString;
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetails(
                  id: _mostReadNewsObj.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 30.0,
                        width: 30.0,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/logo.png',
                          image: "${_mostReadNewsObj.newsImageS}",
                          imageScale: 10.0,
                          placeholderScale: 5.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${_mostReadNewsObj.newsTitle}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        style: new TextStyle(
                          fontFamily: 'jazeera',
                          color: Colors.red,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
//                        "${_since(_mostReadNewsObj.newsDate)}",
                        timeago.format(
                          DateTime.parse(_mostReadNewsObj.newsDate),
                          locale: 'ar',
                        ),
                        style: new TextStyle(
                          color: Colors.grey,
                          fontFamily: 'jazeera',
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${_parseHtmlString(_mostReadNewsObj.newsDescription)}",
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: new TextStyle(
                          color: Colors.black,
                          fontFamily: 'jazeera',
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          constraints:
                              const BoxConstraints.expand(height: 120.0),
                          child: CachedNetworkImage(
                            imageUrl: "${_mostReadNewsObj.newsImageB}",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    FlatButton.icon(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                        size: 10.0,
                                      ),
                                      label: Text(
                                        "${DateFormat('y-MM-dd').format(DateTime.parse(_mostReadNewsObj.newsDate))}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.0,
                                        ),
                                      ),
                                    ),
                                    FlatButton.icon(
                                      splashColor: Colors.redAccent,
                                      onPressed: () async {
                                        var request = await HttpClient().getUrl(
                                            Uri.parse(
                                                '${_mostReadNewsObj.newsImageB}'));
                                        var response = await request.close();
                                        Uint8List bytes =
                                            await consolidateHttpClientResponseBytes(
                                                response);

                                        await Share.files(
                                          '${_mostReadNewsObj.newsTitle}',
                                          {
                                            'onepress.png':
                                                bytes.buffer.asUint8List(),
                                          },
                                          '*/*',
                                          text:
                                              '${_mostReadNewsObj.newsTitle} \n \t${_parseHtmlString(_mostReadNewsObj.newsDescription)} \n لتحميل تطبيق One Press إضغط هنا ${Uri.parse('https://play.google.com/store/apps/details?id=com.sudagoras.onepress')}',
                                        );
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 10.0,
                                      ),
                                      label: Text(
                                        "مشاركة",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.0,
                                        ),
                                      ),
                                    ),
                                    FlatButton.icon(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 10.0,
                                      ),
                                      label: Text(
                                        " ${_mostReadNewsObj.newsViews}  مشاهدات",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
