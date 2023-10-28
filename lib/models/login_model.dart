import 'package:clean_code/Models/user_model.dart';

class LoginModel {
  String? access_token;
  UserModel? user;

  LoginModel({
    this.access_token,
    this.user,
  });
}
