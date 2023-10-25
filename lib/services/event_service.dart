import 'dart:convert';

import 'package:clean_code/models/api_response.dart';
import 'package:clean_code/models/event_models.dart';
import 'package:http/http.dart' as http;

class EventService {
  static const API = 'https://activity-connect.projectdira.my.id/public/api/';
  static const headers = {};

  Future<APIResponse<List<EventModel>>> getEventList() {
    // return http.Request("get", Uri.parse('${API}event/1'));
    // return http.get(Uri.parse('${API}event/1'));

    return http.get(Uri.parse('${API}event/1')).then((data) {
      // final jsonData = data.body.jsonDecode();
      // final events = <EventModel>[];
      // for (var item in jsonData) {
      //   final event = EventModel(
      //       id: data.statusCode.toString(),
      //       name: item['name'],
      //       description: item['description']);
      //   events.add(event);
      // }
      // return APIResponse<List<EventModel>>(
      //     data: [], errorMessage: data.statusCode.toString());
      // return APIResponse<List<EventModel>>(
      //     data: [],
      //     errorMessage: jsonDecode(data.body)["data"]['id'].toString());
      if (data.statusCode == 200) {
        // final jsonData = jsonDecode(data.body);
        final item = jsonDecode(data.body)['data'];
        final events = <EventModel>[];
        final event = EventModel(
            id: item['id'],
            name: item['name'],
            description: item['description']);
        // jsonData["data"].forEach((k, item) {
        events.add(event);
        // });
        return APIResponse<List<EventModel>>(data: events, errorMessage: '');
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
    // final events = [
    //   new EventModel(eventID: "1", a: "event1"),
    //   new EventModel(eventID: "2", a: "event2"),
    //   new EventModel(eventID: "3", a: "event3"),
    // ];
  }
}
