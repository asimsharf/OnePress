import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onepress/model/CommentsInsert.dart';
import 'package:onepress/model/api_response.dart';

class OnePresservice {
  static const API = 'http://sudanews.sudagoras.com/';
  static const headers = {'Content-Type': 'application/json'};

  ///[POST]
  /// Create Single Note from the
  /// API [by ID]
  ///
  Future<APIResponse<bool>> createComments(CommentsInsert item) {
    return http
        .post(
            API +
                '/api_comment.php?news_id=3&user_name=admin&comment_text=test',
            headers: headers,
            body: json.encode(item.toJson()))
        .then(
      (data) {
        if (data.statusCode == 201) {
          return APIResponse<bool>(data: true);
        }
        return APIResponse<bool>(error: true, errorMessage: 'An error occured');
      },
    ).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }
}
