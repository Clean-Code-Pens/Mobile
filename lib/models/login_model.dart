class LoginModel {
  String? access_token;
  UserModel? user;

  LoginModel({
    this.access_token,
    this.user,
  });
}

class UserModel {
  int id;
  String name;

  UserModel({
    required this.id,
    required this.name,
  });
}
