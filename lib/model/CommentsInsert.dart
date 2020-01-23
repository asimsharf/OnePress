import 'package:flutter/foundation.dart';

class CommentsInsert {
  String news_id;
  String user_name;
  String comment_text;

  CommentsInsert({
    @required this.news_id,
    @required this.user_name,
    @required this.comment_text,
  });

  Map<String, dynamic> toJson() {
    return {
      "news_id": news_id,
      "noteContent": user_name,
      "comment_text": comment_text,
    };
  }
}
