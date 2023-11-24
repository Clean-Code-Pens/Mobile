import 'package:clean_code/models/profile_model.dart';

class UserModel {
  int? id;
  String? name;
  String? email;
  ProfileModel? profile;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profile,
  });
}
