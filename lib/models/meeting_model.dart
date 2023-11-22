import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/user_model.dart';

class MeetingModel {
  int? id;
  String? name;
  String? description;
  UserModel? user;
  EventModel? event;
  String? id_event;
  String? people_need;

  MeetingModel({
    this.id,
    this.name,
    this.description,
    this.user,
    this.event,
    this.id_event,
    this.people_need,
  });
}

// class MeetingCreateModel
