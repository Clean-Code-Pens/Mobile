import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:clean_code/Models/login_model.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:clean_code/Provider/Database/db_provider.dart';

class AuthService {
  static const baseurl = 'https://activity-connect.projectdira.my.id/public';
  static const API = 'https://activity-connect.projectdira.my.id/public/api';
  static const headers = {};

  Future<APIResponse<LoginModel>> login(email, password) {
    final user = {'email': email, 'password': password};
    return http.post(Uri.parse('${API}/auth/login'), body: user).then((data) {
      //   return APIResponse<LoginModel>(
      //       data: LoginModel(),
      //       errorMessage: jsonDecode(data.body)['data'].toString());
      // });
      if (data.statusCode == 201) {
        final jsonData = jsonDecode(data.body);
        final login_info = LoginModel(
          access_token: jsonData['data']['access_token'],
          user: UserModel(
              id: jsonData['data']['user']['id'],
              name: jsonData['data']['user']['name']),
        );
        return APIResponse<LoginModel>(data: login_info, errorMessage: '');
      }
      return APIResponse<LoginModel>(
          data: LoginModel(), error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<LoginModel>(
        data: LoginModel(), error: true, errorMessage: 'An error occured'));

    // return http.post(Uri.parse('${API}/auth/login'),
    //     {Login(email: 'hilmi@gmail.com', password: 'password')});
    //   return http.get(Uri.parse('${API}/auth/login')).then((data) {
    //     return APIResponse<LoginModel>(
    //         data: LoginModel(access_token: '', user: UserModel(id: 0, name: '')),
    //         errorMessage: jsonDecode(data.body).toString());
    //     // if (data.statusCode == 200) {
    //     //   final jsonData = jsonDecode(data.body);
    //     //   final login_info = LoginModel(access_token: js);
    //     //   // final categories = <CategoryModel>[];
    //     //   // for (var i = 0; i < jsonData["data"].length; i++) {
    //     //   //   final category = CategoryModel(
    //     //   //     id: jsonData["data"][i]['id'],
    //     //   //     name: jsonData["data"][i]['name'],
    //     //   //   );
    //     //   //   categories.add(category);
    //     //   // }
    //     //   // jsonData["data"].forEach((k, item) {
    //     //   //   final category = CategoryModel(
    //     //   //     id: item['id'],
    //     //   //     name: item['name'],
    //     //   //   );
    //     //   //   categories.add(category);
    //     //   // });
    //     //   return APIResponse<LoginModel>(
    //     //       data: login_info, errorMessage: '');
    //     // }
    //     // return APIResponse<LoginModel>(
    //     //     data: [], error: true, errorMessage: 'An error occured');
    //   }).catchError((_) => APIResponse<LoginModel>(
    //       data: LoginModel(access_token: '', user: UserModel(id: 0, name: '')),
    //       error: true,
    //       errorMessage: 'An error occured'));
  }
}

class Login {
  String email;
  String password;

  // Constructor
  Login({required this.email, required this.password});
}
