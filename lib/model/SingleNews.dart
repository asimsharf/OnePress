// To parse this JSON data, do
//
//     final SingleNews = SingleNewsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

SingleNews SingleNewsFromJson(String str) =>
    SingleNews.fromMap(json.decode(str));

String SingleNewsToJson(SingleNews data) => json.encode(data.toMap());

class SingleNews {
  List<NewsApp> newsApp;

  SingleNews({
    this.newsApp,
  });

  factory SingleNews.fromMap(Map<String, dynamic> json) => SingleNews(
        newsApp:
            List<NewsApp>.from(json["NEWS_APP"].map((x) => NewsApp.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "NEWS_APP": List<dynamic>.from(newsApp.map((x) => x.toMap())),
      };
}

class NewsApp {
  String cid;
  String categoryName;
  String id;
  String catId;
  String newsType;
  String newsTitle;
  String videoUrl;
  String videoId;
  String newsImageB;
  String newsImageS;
  String newsDescription;
  String newsDate;
  String newsViews;
  List<GalleyImage> galleyImage;
  List<NewsApp> SingleNews;
  List<UserComment> userComments;

  NewsApp({
    this.cid,
    this.categoryName,
    this.id,
    this.catId,
    this.newsType,
    this.newsTitle,
    this.videoUrl,
    this.videoId,
    this.newsImageB,
    this.newsImageS,
    this.newsDescription,
    this.newsDate,
    this.newsViews,
    this.galleyImage,
    this.SingleNews,
    this.userComments,
  });

  factory NewsApp.fromMap(Map<String, dynamic> json) => NewsApp(
        cid: json["cid"],
        categoryName: json["category_name"],
        id: json["id"],
        catId: json["cat_id"],
        newsType: json["news_type"],
        newsTitle: json["news_title"],
        videoUrl: json["video_url"],
        videoId: json["video_id"],
        newsImageB: json["news_image_b"],
        newsImageS: json["news_image_s"],
        newsDescription: json["news_description"],
        newsDate: json["news_date"],
        newsViews: json["news_views"],
        galleyImage: json["galley_image"] == null
            ? []
            : List<GalleyImage>.from(
                json["galley_image"].map((x) => GalleyImage.fromMap(x))),
        SingleNews: json["related_news"] == null
            ? []
            : List<NewsApp>.from(
                json["related_news"].map((x) => NewsApp.fromMap(x))),
        userComments: json["user_comments"] == null
            ? []
            : List<UserComment>.from(
                json["user_comments"].map((x) => UserComment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cid": cid,
        "category_name": categoryName,
        "id": id,
        "cat_id": catId,
        "news_type": newsType,
        "news_title": newsTitle,
        "video_url": videoUrl,
        "video_id": videoId,
        "news_image_b": newsImageB,
        "news_image_s": newsImageS,
        "news_description": newsDescription,
        "news_date": newsDate,
        "news_views": newsViews,
        "galley_image": galleyImage == null
            ? []
            : List<dynamic>.from(galleyImage.map((x) => x.toMap())),
        "related_news": SingleNews == null
            ? Text("nlsdf")
            : List<dynamic>.from(SingleNews.map((x) => x.toMap())),
        "user_comments": userComments == null
            ? []
            : List<dynamic>.from(userComments.map((x) => x.toMap())),
      };
}

class GalleyImage {
  String imageName;

  GalleyImage({
    this.imageName,
  });

  factory GalleyImage.fromMap(Map<String, dynamic> json) => GalleyImage(
        imageName: json["image_name"],
      );

  Map<String, dynamic> toMap() => {
        "image_name": imageName,
      };
}

class UserComment {
  String newsId;
  String userName;
  String commentText;

  UserComment({
    this.newsId,
    this.userName,
    this.commentText,
  });

  factory UserComment.fromMap(Map<String, dynamic> json) => UserComment(
        newsId: json["news_id"],
        userName: json["user_name"],
        commentText: json["comment_text"],
      );

  Map<String, dynamic> toMap() => {
        "news_id": newsId,
        "user_name": userName,
        "comment_text": commentText,
      };
}
