import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:http/http.dart' as http;

class EventService {
  static const API = 'https://activity-connect.projectdira.my.id/public/api/';
  static const headers = {};

  Future<APIResponse<List<EventModel>>> getEventList() {
    // return http.Request("get", Uri.parse('${API}event/1'));
    // return http.get(Uri.parse('${API}event/1'));

    return http.get(Uri.parse('${API}event/1')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final events = <EventModel>[];
        jsonData["data"].forEach((k, item) {
          final event = EventModel(
              id: item['id'],
              name: item['name'],
              description: item['description']);
          events.add(event);
        });
        return APIResponse<List<EventModel>>(data: events, errorMessage: '');
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<EventModel>> getDetailEvent() {
    return http.get(Uri.parse('${API}event/1')).then((data) {
      if (data.statusCode == 200) {
        final item = jsonDecode(data.body)['data'];
        final event = EventModel(
            id: item['id'],
            name: item['name'],
            description: item['description']);
        return APIResponse<EventModel>(data: event, errorMessage: '');
      }
      return APIResponse<EventModel>(
          data: EventModel(id: 2, name: '', description: ''),
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<EventModel>(
        data: EventModel(id: 2, name: '', description: ''),
        error: true,
        errorMessage: 'An error occured'));
  }
}
