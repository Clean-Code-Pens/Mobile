import 'package:clean_code/Models/user_model.dart';

class MeetingModel {
  int? id;
  String? name;
  String? description;
  UserModel? user;
  String? id_event;
  String? people_need;

  MeetingModel({
    this.id,
    this.name,
    this.description,
    this.user,
    this.id_event,
    this.people_need,
  });
}

// class MeetingCreateModel
