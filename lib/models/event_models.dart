import 'package:clean_code/Models/meeting_model.dart';

class EventModel {
  int? id;
  String? name;
  String? description;
  String? imgUrl;
  String? place;
  String? address;
  String? date;
  List<MeetingModel>? meetings;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.imgUrl,
    this.place,
    this.address,
    this.date,
    this.meetings,
  });
}
