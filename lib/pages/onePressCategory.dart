import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onepress/model/CategoryModel.dart';

import 'newsByCategory.dart';

class OnePressCategory extends StatefulWidget {
  @override
  _OnePressCategoryState createState() => _OnePressCategoryState();
}

class _OnePressCategoryState extends State<OnePressCategory> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  bool _loading = false;

  ///Future to fetch all the Last News
  CategoryModel _modelCategoryModel;

  Future<CategoryModel> getCategoryModel() async {
    String link = "http://sudanews.sudagoras.com//api.php?cat_list";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    setState(() {
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        _modelCategoryModel = CategoryModel.fromMap(data);
        _loading = false;
      }
    });
    return _modelCategoryModel;
  }

  Future<Null> _refresh() {
    return getCategoryModel().then(
      (modelCen) {
        setState(
          () => _modelCategoryModel = modelCen,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshIndicatorKey.currentState.show(),
    );
    setState(() {
      this.getCategoryModel();
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: new IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            "مجلات One Press",
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
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: _loading
              ? new Center(child: new CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.only(top: 0.0),
                        sliver: SliverFixedExtentList(
                          itemExtent: 145.0,
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var _categoryObj =
                                  _modelCategoryModel.newsApp[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsByCategory(
                                          cat_id: _categoryObj.cid,
                                          categoryName:
                                              _categoryObj.categoryName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 130.0,
                                    width: 400.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Hero(
                                      tag: 'hero-tag-${_categoryObj.cid}',
                                      child: Material(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${_categoryObj.categoryImage}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black26,
                                                  BlendMode.colorBurn,
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                color: Colors.black12
                                                    .withOpacity(0.1),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.black54,
                                                    blurRadius: 1.0,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _categoryObj.categoryName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'jazeera',
                                                    fontSize: 35.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _modelCategoryModel.newsApp.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
