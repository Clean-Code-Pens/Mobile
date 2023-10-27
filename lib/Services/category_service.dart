import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CategoryService {
  static const baseurl = 'https://activity-connect.projectdira.my.id/public';
  static const API = 'https://activity-connect.projectdira.my.id/public/api';
  static const headers = {};

  Future<APIResponse<List<CategoryModel>>> getCategoryList() {
    return http.get(Uri.parse('${API}/event-category/')).then((data) {
      // return APIResponse<List<CategoryModel>>(
      //     data: [], errorMessage: jsonDecode(data.body).toString());
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final categories = <CategoryModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final category = CategoryModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
          );
          categories.add(category);
        }
        // jsonData["data"].forEach((k, item) {
        //   final category = CategoryModel(
        //     id: item['id'],
        //     name: item['name'],
        //   );
        //   categories.add(category);
        // });
        return APIResponse<List<CategoryModel>>(
            data: categories, errorMessage: '');
      }
      return APIResponse<List<CategoryModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<CategoryModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }
}
