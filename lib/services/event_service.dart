import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventService {
  static const baseurl = 'https://activity-connect.projectdira.my.id/public';
  static const API = 'https://activity-connect.projectdira.my.id/public/api';
  static const headers = {};

  Future<APIResponse<List<EventModel>>> getEventList() {
    return http.get(Uri.parse('${API}/event/')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final events = <EventModel>[];
        jsonData["data"].forEach((k, item) {
          final event = EventModel(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            imgUrl: baseurl + item['image'],
            place: item['place'],
            address: item['address'],
            date: DateFormat('EEEE, MMMM d y')
                .format(DateTime.parse(item['date'])),
          );
          events.add(event);
        });
        return APIResponse<List<EventModel>>(data: events, errorMessage: '');
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<EventModel>>> getEventListLimit(limit) {
    return http.get(Uri.parse('${API}/event?limit=${limit}')).then((data) {
      // return APIResponse<List<EventModel>>(
      //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final events = <EventModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final event = EventModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
            description: jsonData["data"][i]['description'],
            imgUrl: baseurl + jsonData["data"][i]['image'],
            place: jsonData["data"][i]['place'],
            address: jsonData["data"][i]['address'],
            date: DateFormat('EEEE, MMMM d y')
                .format(DateTime.parse(jsonData["data"][i]['date'])),
          );
          events.add(event);
        }
        return APIResponse<List<EventModel>>(
            data: events, errorMessage: events.toString());
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<EventModel>>> getEventCategoryListLimit(
      idCategory, limit) {
    return http
        .get(Uri.parse('${API}/event/by-category/${idCategory}?limit=${limit}'))
        .then((data) {
      // return APIResponse<List<EventModel>>(
      //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final events = <EventModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final event = EventModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
            description: jsonData["data"][i]['description'],
            imgUrl: baseurl + jsonData["data"][i]['image'],
            place: jsonData["data"][i]['place'],
            address: jsonData["data"][i]['address'],
            date: DateFormat('EEEE, MMMM d y')
                .format(DateTime.parse(jsonData["data"][i]['date'])),
          );
          events.add(event);
        }
        return APIResponse<List<EventModel>>(
            data: events, errorMessage: events.toString());
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
            data: [], error: true, errorMessage: 'An error occured'));
  }

  // Future<List<EventModel>> fetchDataSynchronously(idCategori, limit) {
  //   return http
  //       .get(Uri.parse('${API}/event/by-category/${idCategori}?limit=${limit}'))
  //       .then((data) {
  //     // return APIResponse<List<EventModel>>(
  //     //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
  //     if (data.statusCode == 200) {
  //       final jsonData = jsonDecode(data.body);
  //       final events = <EventModel>[];
  //       for (var i = 0; i < jsonData["data"].length; i++) {
  //         final event = EventModel(
  //           id: jsonData["data"][i]['id'],
  //           name: jsonData["data"][i]['name'],
  //           description: jsonData["data"][i]['description'],
  //           imgUrl: baseurl + jsonData["data"][i]['image'],
  //           place: jsonData["data"][i]['place'],
  //           address: jsonData["data"][i]['address'],
  //           date: DateFormat('EEEE, MMMM d y')
  //               .format(DateTime.parse(jsonData["data"][i]['date'])),
  //         );
  //         events.add(event);
  //       }
  //       return events;
  //     }
  //     return <EventModel>[];
  //   }).catchError((_) => <EventModel>[]);
  // }

  Future<APIResponse<EventModel>> getDetailEvent(int idEvent) {
    return http.get(Uri.parse('${API}/event/${idEvent}')).then((data) {
      if (data.statusCode == 200) {
        final item = jsonDecode(data.body)['data'];
        // String image = API + item["image"];
        final event = EventModel(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            place: item['place'],
            address: item['address'],
            date: DateFormat('EEEE, MMMM d y')
                .format(DateTime.parse(item['date'])),
            imgUrl: baseurl + item["image"]);
        return APIResponse<EventModel>(data: event, errorMessage: '');
      }
      return APIResponse<EventModel>(
          data: EventModel(
              id: 2,
              name: '',
              description: '',
              imgUrl: '',
              place: '',
              address: '',
              date: ''),
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<EventModel>(
        data: EventModel(
            id: 2,
            name: '',
            description: '',
            imgUrl: '',
            place: '',
            address: '',
            date: ''),
        error: true,
        errorMessage: 'An error occured'));
  }
}
