import 'dart:async';
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
import 'package:onepress/model/SingleNews.dart';

import 'comments.dart';

class NewsDetails extends StatefulWidget {
  final String id;

  NewsDetails({this.id});

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  bool _loading = false;

  ///Future to fetch all the Last News
  SingleNews _modelSingleNews;

  Future<SingleNews> getSingleNews() async {
    String link = "http://sudanews.sudagoras.com//api.php?news_id=${widget.id}";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    setState(() {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        _modelSingleNews = SingleNews.fromMap(data);
        _loading = false;
      }
    });
    return _modelSingleNews;
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  Future<void> _shareImageFromUrl() async {
    try {
      var request = await HttpClient()
          .getUrl(Uri.parse('${_modelSingleNews.newsApp[0].newsImageB}'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      await Share.files(
        '${_modelSingleNews.newsApp[0].newsTitle}',
        {
          'onepress.png': bytes.buffer.asUint8List(),
        },
        '*/*',
        text:
            '${_modelSingleNews.newsApp[0].newsTitle} \n \t${_parseHtmlString(_modelSingleNews.newsApp[0].newsDescription)} \n لتحميل تطبيق One Press إضغط هنا ${Uri.parse('https://play.google.com/store/apps/details?id=com.sudagoras.onepress')}',
      );
    } catch (e) {
      print('Share Image error: $e');
    }
  }

  double _volume = 15.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.getSingleNews();
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: _loading
          ? new Center(child: new CircularProgressIndicator())
          : CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.white),
                  expandedHeight: 250.0,
                  elevation: 0.1,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FadeInImage.assetNetwork(
                      placeholder: 'assets/place_holder_big.png',
                      image: "${_modelSingleNews.newsApp[0].newsImageB}",
                      imageScale: 10.0,
                      placeholderScale: 5.0,
                      fit: BoxFit.fill,
                    ),
                    centerTitle: true,
                    title: Text(
                      "One Press",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'jazeera',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "${_modelSingleNews.newsApp[0].newsTitle}",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: 'jazeera',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.red,
                              size: 10.0,
                            ),
                            label: Text(
                              "${DateFormat('y-MM-dd').format(DateTime.parse(_modelSingleNews.newsApp[0].newsDate))}",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 8.0,
                                fontFamily: 'jazeera',
                              ),
                            ),
                          ),
                          FlatButton.icon(
                            onPressed: () async => await _shareImageFromUrl(),
                            icon: Icon(
                              Icons.share,
                              color: Colors.red,
                              size: 10.0,
                            ),
                            label: Text(
                              "مشاركة",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 8.0,
                                fontFamily: 'jazeera',
                              ),
                            ),
                          ),
                          FlatButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.red,
                              size: 10.0,
                            ),
                            label: Text(
                              " ${_modelSingleNews.newsApp[0].newsViews}  مشاهدات",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 8.0,
                                fontFamily: 'jazeera',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "حجم الخط",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: Colors.red,
                                inactiveColor: Colors.transparent,
                                value: _volume,
                                min: 15.0,
                                max: 30.0,
                                divisions: 30,
                                label: '${(_volume).round()}',
                                onChanged: (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Text(
                          "${_parseHtmlString(_modelSingleNews.newsApp[0].newsDescription)}",
                          style: TextStyle(
                            fontFamily: 'jazeera',
                            fontWeight: FontWeight.w400,
                            fontSize: _volume,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: Container(
                          height: 250.0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "أخبار زات صله",
                                    style: TextStyle(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      fontFamily: 'jazeera',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: _loading
                                    ? new Center(
                                        child: new CircularProgressIndicator())
                                    : _relatedNews(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 20.0, top: 5.0, bottom: 5.0),
                        child: Container(
                          height: 250.0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "التعليقات",
                                    style: TextStyle(
                                      color: Colors.redAccent.withOpacity(0.8),
                                      fontFamily: 'jazeera',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (_, ___, ____) =>
                                              new Comments(
                                            userComment: _modelSingleNews
                                                .newsApp[0].userComments,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "إضافة تعليق",
                                      style: TextStyle(
                                        color:
                                            Colors.redAccent.withOpacity(0.8),
                                        fontFamily: 'jazeera',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: _loading
                                    ? new Center(
                                        child: new CircularProgressIndicator(),
                                      )
                                    : _commentListView(context),
                              ),
                            ],
                          ),
                        ),
                      ),
//                      InkWell(
//                        onTap: () {
//                          Navigator.of(context).push(
//                            PageRouteBuilder(
//                              pageBuilder: (_, ___, ____) => new Comments(),
//                            ),
//                          );
//                        },
//                        child: Text(
//                          "إضافة تعليق",
//                          style: TextStyle(
//                            color: Colors.redAccent.withOpacity(0.8),
//                            fontFamily: 'jazeera',
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _commentListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _modelSingleNews.newsApp[0].userComments.length,
      itemBuilder: (BuildContext context, int index) {
        final _commentObj = _modelSingleNews.newsApp[0].userComments[index];
        try {
          if (_commentObj.userName == null || _commentObj.commentText == null) {
            return Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "assets/IlustrasiMessage.png",
                            height: 150.0,
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
          } else {
            return ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
              title: Text("${_commentObj.userName}"),
              subtitle: Text("${_commentObj.commentText}"),
            );
          }
        } catch (e) {
          return null;
        }
      },
    );
  }

  Widget _relatedNews() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _modelSingleNews.newsApp[0].SingleNews.length,
      itemBuilder: (BuildContext context, int index) {
        final _relatedNewsObj = _modelSingleNews.newsApp[0].SingleNews[index];
        try {
          if (_relatedNewsObj.userComments == null) {
            _relatedNewsObj.userComments = [];
          }
        } catch (Exception) {
          return null;
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetails(
                  id: _relatedNewsObj.id,
                ),
              ),
            );
          },
          child: FavoriteItem(
            image: "${_relatedNewsObj.newsImageB}",
            title: "${_relatedNewsObj.newsTitle}",
            Salary: "\$ 10",
            Views: "${_relatedNewsObj.newsViews}",
            NewsDateTime: "${_relatedNewsObj.newsDate}",
          ),
        );
      },
    );
  }
}

/// class Item for card in "top rated products"
class FavoriteItem extends StatelessWidget {
  String image, Views, Salary, title, NewsDateTime;

  FavoriteItem(
      {this.image, this.Views, this.Salary, this.title, this.NewsDateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              ),
            ]),
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 300.0,

                  child: CachedNetworkImage(
                    imageUrl: "$image",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
//                  child: FadeInImage.assetNetwork(
//                    placeholder: 'assets/place_holder_big.png',
//                    image: "$image",
//                    imageScale: 10.0,
//                    placeholderScale: 5.0,
//                    fit: BoxFit.fill,
//                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    title.length < 50 ? title : title.substring(0, 50),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      letterSpacing: 0.5,
                      color: Colors.black54,
                      fontFamily: 'jazeera',
                      fontWeight: FontWeight.w500,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        color: Colors.red,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "${DateFormat('y-MM-dd').format(DateTime.parse(NewsDateTime))}",
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.red,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        Views,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.red,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "مشاركة",
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
