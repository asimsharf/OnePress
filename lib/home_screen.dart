import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onepress/Account/UserLoginRegister/pages/LoginPage.dart';
import 'package:onepress/Account/UserLoginRegister/utils/app_shared_preferences.dart';
import 'package:onepress/model/ImmedaitNews.dart';
import 'package:onepress/pages/newsDetails.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'model/NewsModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKeyS =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyOne =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyTow =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyThree =
      new GlobalKey<RefreshIndicatorState>();

  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  Icon _searchIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  String userName = '';
  String userEamil = '';
  String userImage = '';
  bool isLogIn = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (userName == null || userEamil == null) {
      await initUserProfile();
    }
  }

  Future<void> loginChech() async {
    try {
      String name = await AppSharedPreferences.getFromSession('userName');
      String email = await AppSharedPreferences.getFromSession('userEmail');
      bool islogedIn = await AppSharedPreferences.isUserLoggedIn();
      setState(() {
        userName = name != null ? name : 'إسم المستخدم';
        userEamil = email != null ? email : 'البريد اﻹلكتروني';
        isLogIn = islogedIn != null ? islogedIn : false;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> initUserProfile() async {
    try {
      String name = await AppSharedPreferences.getFromSession('userName');
      String email = await AppSharedPreferences.getFromSession('userEmail');
      bool logedIn = await AppSharedPreferences.isUserLoggedIn();
      setState(() {
        userName = name != null ? name : 'اسم المستخدم';
        userEamil = email != null ? email : 'البريد الالكتروني';
        isLogIn = logedIn != null ? false : logedIn;
      });
    } catch (e) {
      return;
    }
  }

  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  TabController _controller;
  bool _loading = false;

  ///Future to fetch all the Last News
  List<NewsModel> _modelLastNews = <NewsModel>[];

  Future<List<NewsModel>> getLastNews() async {
    String link = "http://sudanews.sudagoras.com//api.php?latest";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    setState(() {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["NEWS_APP"] as List;

        _modelLastNews =
            rest.map<NewsModel>((rest) => NewsModel.fromJson(rest)).toList();
        _loading = false;
      }
    });
    return _modelLastNews;
  }

  Future<Null> _refreshLastNews() {
    return getLastNews().then(
      (modelCen) {
        setState(
          () => _modelLastNews = modelCen,
        );
      },
    );
  }

  ///Future to fetch all the Last News
  List<HomeNews> _modelHomeNews = <HomeNews>[];

  Future<List<HomeNews>> getHomeNews() async {
    String link = "http://sudanews.sudagoras.com//api.php?home";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    setState(() {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["NEWS_APP"]['featured_news'] as List;

        _modelHomeNews =
            rest.map<HomeNews>((rest) => HomeNews.fromJson(rest)).toList();
        _loading = false;
      }
    });
    return _modelHomeNews;
  }

  Future<Null> _refreshHomeNews() {
    return getHomeNews().then(
      (modelCen) {
        setState(
          () => _modelHomeNews = modelCen,
        );
      },
    );
  }

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

  Future<Null> _refreshMostReadNews() {
    return getMostReadNews().then(
      (modelCen) {
        setState(
          () => _modelMostReadNews = modelCen,
        );
      },
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Video Ended"),
          content: Text("Thank you for trying the plugin!"),
        );
      },
    );
  }

  void getLastNewsNames() async {
    try {
      final response =
          await dio.get('http://sudanews.sudagoras.com//api.php?latest');
      List<NewsModel> tempList = <NewsModel>[];
      for (int i = 0; i < response.data["NEWS_APP"].length; i++) {
        var rest = response.data["NEWS_APP"] as List;

        _modelLastNews =
            rest.map<NewsModel>((rest) => NewsModel.fromJson(rest)).toList();
//        _modelLastNews =  List<NewsModel>.from(rest.where((i) => i.flag == true));
        tempList.add(
          NewsModel.fromJson(
            response.data["NEWS_APP"][i],
          ),
        );
      }
      setState(
        () {
          if (response.statusCode == 200) {
            names = tempList;
            names.shuffle();
            _modelLastNews = names;
          }
        },
      );
    } catch (Exception) {
      return null;
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
            fillColor: Colors.white,
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: 'بحث بإسم ...',
            labelStyle: TextStyle(
              fontFamily: 'jazeera',
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              fontFamily: 'jazeera',
              color: Colors.white,
            ),
          ),
        );
      } else {
        this._searchIcon = new Icon(
          Icons.search,
          color: Colors.white,
        );
        this._appBarTitle = new Text(
          "One Press",
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'jazeera',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        );
        _modelLastNews = names;
        _filter.clear();
      }
    });
  }

  _HomeScreenState() {
    _filter.addListener(
      () {
        if (_filter.text.isEmpty) {
          setState(
            () {
              _searchText = "";
              _modelLastNews = names;
            },
          );
        } else {
          setState(
            () {
              _searchText = _filter.text;
            },
          );
        }
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

    int _resNewsyear = publishedDateTime.toUtc().year;
    int _resNewsmonth = publishedDateTime.toUtc().month;
    int _resNewsweekday = publishedDateTime.toUtc().weekday;
    int _resNewshour = publishedDateTime.toUtc().hour;
    int _resNewsminute = publishedDateTime.toUtc().minute;

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

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshIndicatorKeyOne.currentState.show(),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshIndicatorKeyTow.currentState,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshIndicatorKeyThree.currentState,
    );
    _controller = new TabController(
      length: 3,
      vsync: this,
    );

    setState(() {
      this.getLastNewsNames();
      this.getLastNews();
      this.getHomeNews();
      this.getMostReadNews();
      this.loginChech();
      _loading = true;
    });
  }

  final List<String> images = [
    'assets/bg.jpeg',
    'assets/bg1.jpeg',
    'assets/bg2.jpg',
  ];

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  _buildDrawer(BuildContext context) {
    final String image = "assets/logo.png";
    return ClipPath(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: BoxDecoration(color: primary, boxShadow: [
          BoxShadow(
            color: Colors.redAccent,
          )
        ]),
        width: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: _door(),
                ),
                Container(
                  height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent,
                        Colors.redAccent,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 43,
                    backgroundImage: AssetImage(image),
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  "One Press",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'jazeera',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  userName != null ? userName : 'إسم المستخدم',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'jazeera',
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 30.0),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(Icons.home, "الرئيسية"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                _buildDivider(),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(Icons.developer_board, "أخر اﻷخبار"),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed('LastNewsPage');
                  },
                ),
                _buildDivider(),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(
                    Icons.more,
                    "اﻷكثر قراءة",
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, 'MostReadNews');
                  },
                ),
                _buildDivider(),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(
                    Icons.book,
                    "مجلة One Press",
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, 'OnePressCategory');
                  },
                ),
//                _buildDivider(),
//                InkWell(
//                  splashColor: Colors.red,
//                  child: _buildRow(
//                    Icons.favorite,
//                    "المفضلة",
//                  ),
//                  onTap: () {
//                    Navigator.popAndPushNamed(context, 'favourite');
//                  },
//                ),
//                _buildDivider(),
//                InkWell(
//                  splashColor: Colors.red,
//                  child: _buildRow(
//                    Icons.person,
//                    "الصفحة الشخصية",
//                  ),
//                  onTap: () {
//                    Navigator.popAndPushNamed(context, 'ProfilePage');
//                  },
//                ),
//                _buildDivider(),
//                InkWell(
//                  splashColor: Colors.red,
//                  child: _buildRow(
//                    Icons.person,
//                    "اﻹشعارات",
//                  ),
//                  onTap: () {
//                    Navigator.popAndPushNamed(context, 'OneSignalPage');
//                  },
//                ),
//                _buildDivider(),
//                InkWell(
//                  splashColor: Colors.red,
//                  child: _buildRow(Icons.settings, "اﻹعدادات"),
//                  onTap: () {
//                    Navigator.popAndPushNamed(context, 'Settings');
//                  },
//                ),
                _buildDivider(),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(
                    Icons.share,
                    "مشاركة التطبيق",
                  ),
                  onTap: () async {
                    try {
                      Share.text(
                          'قم بتحميل تطبيق One Press اﻹخباري الان',
                          '${Uri.parse('https://play.google.com/store/apps/details?id=com.sudagoras.onepress')}',
                          'text/plain');
                    } catch (e) {
                      print('error: $e');
                    }
                  },
                ),
                _buildDivider(),
                InkWell(
                  splashColor: Colors.red,
                  child: _buildRow(
                    Icons.info,
                    "حول التطبيق",
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('aboutApps');
                  },
                ),
//                _buildDivider(),
//                InkWell(
//                  splashColor: Colors.red,
//                  child: _buildRow(
//                    Icons.info,
//                    "YoutubeMainPlayer",
//                  ),
//                  onTap: () {
//                    Navigator.of(context).pushNamed('YoutubeMainPlayer');
//                  },
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  Widget _buildSlider() {
//    return Container(
//      padding: EdgeInsets.only(bottom: 0.0),
//      height: 150.0,
//      child: Container(
//        child: Swiper(
//          autoplay: true,
//          itemBuilder: (BuildContext context, int index) {
//            return new Image.asset(
//              images[index],
//              fit: BoxFit.cover,
//            );
//          },
//          itemCount: 3,
//          pagination: new SwiperPagination(),
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      drawer: _buildDrawer(context),
      body: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("assets/stack_bg.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child: new TabBarView(
          controller: _controller,
          children: <Widget>[
            ///
            /// Tap Last news
            /// show all the last news
            /// over here
            ///
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKeyOne,
                        onRefresh: _refreshLastNews,
                        child: _loading
                            ? new Center(
                                child: new CircularProgressIndicator(),
                              )
                            : _buildLastNews(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///
            /// Tap Immediate news
            /// show all the Immediate news
            /// over here
            ///

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKeyTow,
                        onRefresh: _refreshHomeNews,
                        child: _loading
                            ? new Center(
                                child: new CircularProgressIndicator(),
                              )
                            : _buildImmediateNews(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///
            /// Tap Most Read news
            /// show all the Most Read news
            /// over here
            ///

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKeyThree,
                        onRefresh: _refreshMostReadNews,
                        child: _loading
                            ? new Center(child: new CircularProgressIndicator())
                            : _buildMostReadNews(),
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

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'jazeera',
      fontSize: 16.0,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: active,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.red,
              elevation: 5.0,
              shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "10+",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'jazeera',
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  /// _Builder for Last News
  /// The Container showen over
  /// here
  Widget _buildLastNews() {
    Widget _buildLastNewsList;

    if (_modelLastNews.length > 0) {
      if (_searchText.isNotEmpty) {
        List<NewsModel> tempList = <NewsModel>[];
        for (int i = 0; i < _modelLastNews.length; i++) {
          if (_modelLastNews[i]
              .newsTitle
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
            tempList.add(_modelLastNews[i]);
          }
        }
        _modelLastNews = tempList;
      }
      _buildLastNewsList = ListView.builder(
        itemCount: _modelLastNews.length,
        itemBuilder: (BuildContext context, int index) {
          final _lastNewsObj = _modelLastNews[index];
          print(_lastNewsObj.newsDate);
          print("Published since ********: ${_since(_lastNewsObj.newsDate)}");
          print(
              "time Ago Since Date *********:+ ${timeAgoSinceDate(_lastNewsObj.newsDate)}");
          print("timeAgo ****************: + ${timeago.format(
            DateTime.parse(_lastNewsObj.newsDate),
            locale: 'ar',
            clock: DateTime.now(),
          )}");
          String _parseHtmlString(String htmlString) {
            var document = parse(htmlString);
            String parsedString =
                parse(document.body.text).documentElement.text;
            return parsedString;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetails(
                    id: _lastNewsObj.id,
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
//                      Padding(
//                        padding: const EdgeInsets.all(5.0),
//                        child: Container(
//
//                          child: YoutubePlayer(
//                            context: context,
//                            source: "T6O4XByNORA",
//                            quality: YoutubeQuality.HD,
//                            aspectRatio: 16 / 9,
//                            autoPlay: true,
//                            loop: false,
//                            reactToOrientationChange: true,
//                            startFullScreen: false,
//                            controlsActiveBackgroundOverlay: true,
//                            controlsTimeOut: Duration(seconds: 4),
//                            playerMode: YoutubePlayerMode.DEFAULT,
////                        callbackController: (controller) {
////                          _videoController = controller;
////                        },
//                            onError: (error) {
//                              print(error);
//                            },
//                            onVideoEnded: () => _showThankYouDialog(),
//                          ),
//                        ),
//                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/logo.png',
                            image: "${_lastNewsObj.newsImageS}",
                            imageScale: 10.0,
                            placeholderScale: 5.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${_lastNewsObj.newsTitle}",
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
                          //"${_since(_lastNewsObj.newsDate)}",

                          timeago.format(
                            DateTime.parse(_lastNewsObj.newsDate),
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
                          "${_parseHtmlString(_lastNewsObj.newsDescription)}",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
//                      softWrap: true,
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
                              imageUrl: "${_lastNewsObj.newsImageB}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                          "${_lastNewsObj.newsDate.substring(0, 9).toString()}",
//                                          "${DateFormat('y-MM-dd').format(DateTime.parse(_lastNewsObj.newsDate))}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8.0,
                                          ),
                                        ),
                                      ),
                                      FlatButton.icon(
                                        splashColor: Colors.redAccent,
                                        onPressed: () async {
                                          var request = await HttpClient()
                                              .getUrl(Uri.parse(
                                                  '${_lastNewsObj.newsImageB}'));
                                          var response = await request.close();
                                          Uint8List bytes =
                                              await consolidateHttpClientResponseBytes(
                                                  response);

                                          await Share.files(
                                            '${_lastNewsObj.newsTitle}',
                                            {
                                              'onepress.png':
                                                  bytes.buffer.asUint8List(),
                                            },
                                            '*/*',
                                            text:
                                                '${_lastNewsObj.newsTitle} \n \t${_parseHtmlString(_lastNewsObj.newsDescription)} \n لتحميل تطبيق One Press إضغط هنا ${Uri.parse('https://play.google.com/store/apps/details?id=com.sudagoras.onepress')}',
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
                                          " ${_lastNewsObj.newsViews}  مشاهدات",
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
    } else {
      _buildLastNewsList = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(Icons.hourglass_empty),
            ),
            Text(
              'عفواً لا مقالات مشابه !',
              style: TextStyle(
                fontFamily: 'jazeera',
                fontSize: 20.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return _buildLastNewsList;
  }

  /// _Builder for Immediate News
  /// The Container showen over
  /// here
  Widget _buildImmediateNews() {
    return ListView.builder(
      itemCount: _modelHomeNews.length,
      itemBuilder: (BuildContext context, int index) {
        final _lastNewsObj = _modelHomeNews[index];

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
                  id: _lastNewsObj.id,
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
                          image: "${_lastNewsObj.newsImageS}",
                          imageScale: 10.0,
                          placeholderScale: 5.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${_lastNewsObj.newsTitle}",
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
//                        "${_since(_lastNewsObj.newsDate)}",
                        timeago.format(
                          DateTime.parse(_lastNewsObj.newsDate),
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
                        "${_parseHtmlString(_lastNewsObj.newsDescription)}",
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
                            imageUrl: "${_lastNewsObj.newsImageB}",
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
                                        "${DateFormat('y-MM-dd').format(DateTime.parse(_lastNewsObj.newsDate))}",
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
                                                '${_lastNewsObj.newsImageB}'));
                                        var response = await request.close();
                                        Uint8List bytes =
                                            await consolidateHttpClientResponseBytes(
                                                response);

                                        await Share.files(
                                          '${_lastNewsObj.newsTitle}',
                                          {
                                            'onepress.png':
                                                bytes.buffer.asUint8List(),
                                          },
                                          '*/*',
                                          text:
                                              '${_lastNewsObj.newsTitle} \n \t${_parseHtmlString(_lastNewsObj.newsDescription)} \n لتحميل تطبيق One Press إضغط هنا ${Uri.parse('https://play.google.com/store/apps/details?id=com.sudagoras.onepress')}',
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
                                        " ${_lastNewsObj.newsViews}  مشاهدات",
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

  ///_dood() widget to
  ///sh the Login Logout
  ///Icon ot the Top of the page
  Widget _door() {
    if (isLogIn == true) {
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.green,
            ),
            onPressed: () {
              AppSharedPreferences.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );
    }
  }

  Widget _appBarTitle = new Text(
    "One Press",
    style: new TextStyle(
      color: Colors.white,
      fontFamily: 'jazeera',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.3,
    ),
  );

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      iconTheme: new IconThemeData(
        color: Colors.white,
      ),
      title: _appBarTitle,
//      leading: new IconButton(
//        alignment: Alignment.centerLeft,
//        icon: _searchIcon,
//        onPressed: _searchPressed,
//      ),
      actions: <Widget>[
        IconButton(
          onPressed: _searchPressed,
          icon: _searchIcon,
        ),
      ],
      bottom: new TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'jazeera',
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
        tabs: const <Tab>[
          const Tab(text: 'اخر الأخبار'),
          const Tab(text: 'عاجل'),
          const Tab(text: 'الأكثر قراءة'),
        ],
      ),
    );
  }
}
