// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromMap(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toMap());

class CategoryModel {
  List<NewsApp> newsApp;

  CategoryModel({
    this.newsApp,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
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
  String categoryImage;
  String categoryImageThumb;

  NewsApp({
    this.cid,
    this.categoryName,
    this.categoryImage,
    this.categoryImageThumb,
  });

  factory NewsApp.fromMap(Map<String, dynamic> json) => NewsApp(
        cid: json["cid"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        categoryImageThumb: json["category_image_thumb"],
      );

  Map<String, dynamic> toMap() => {
        "cid": cid,
        "category_name": categoryName,
        "category_image": categoryImage,
        "category_image_thumb": categoryImageThumb,
      };
}
