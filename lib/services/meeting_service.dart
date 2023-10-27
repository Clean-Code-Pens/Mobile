import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MeetingService {
  static const baseurl = 'https://activity-connect.projectdira.my.id/public';
  static const API = 'https://activity-connect.projectdira.my.id/public/api';
  static const headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FjdGl2aXR5LWNvbm5lY3QucHJvamVjdGRpcmEubXkuaWQvcHVibGljL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNjk4NDA2NDk0LCJleHAiOjE2OTg0MTAwOTQsIm5iZiI6MTY5ODQwNjQ5NCwianRpIjoiWFJhSWRoYUhQc2JPT2VkdyIsInN1YiI6IjMiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.MBwKnNOD42L56ftw6rYVWqtUr8XQ1HdWJmaIxhmt0JU',
  };

  // Future<APIResponse<List<MeetingModel>>> getMeetingList() {
  //   return http.get(Uri.parse('${API}/meet/')).then((data) {
  //     if (data.statusCode == 200) {
  //       final jsonData = jsonDecode(data.body);
  //       final events = <MeetingModel>[];
  //       jsonData["data"].forEach((k, item) {
  //         final event = MeetingModel(
  //           id: item['id'],
  //           name: item['name'],
  //           description: item['description'],
  //           id: baseurl + item['image'],
  //           place: item['place'],
  //           address: item['address'],
  //           date: DateFormat('EEEE, MMMM d y')
  //               .format(DateTime.parse(item['date'])),
  //         );
  //         events.add(event);
  //       });
  //       return APIResponse<List<MeetingModel>>(data: events, errorMessage: '');
  //     }
  //     return APIResponse<List<MeetingModel>>(
  //         data: [], error: true, errorMessage: 'An error occured');
  //   }).catchError((_) => APIResponse<List<MeetingModel>>(
  //       data: [], error: true, errorMessage: 'An error occured'));
  // }

  Future<APIResponse<List<MeetingModel>>> getMeetingListLimit(limit) {
    return http.get(Uri.parse('${API}/meet?limit=${limit}')).then((data) {
      // return APIResponse<List<MeetingModel>>(
      //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final meetings = <MeetingModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final meeting = MeetingModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
            description: jsonData["data"][i]['description'],
            id_user: jsonData["data"][i]['user_id'],
            id_event: jsonData["data"][i]['event_id'],
            people_need: jsonData["data"][i]['people_need'],
          );
          meetings.add(meeting);
        }
        return APIResponse<List<MeetingModel>>(
            data: meetings, errorMessage: '');
      }
      return APIResponse<List<MeetingModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<MeetingModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<MeetingModel>> createMeeting(
      id_event, title, description, people) {
    final user = {
      'event_id': id_event,
      'name': title,
      'description': description,
      'people_need': people
    };
    return http
        .post(Uri.parse('${API}/meet/create'), headers: headers, body: user)
        .then((data) {
      //   return APIResponse<MeetingModel>(
      //       data: MeetingModel(), errorMessage: jsonDecode(data.body).toString());
      // });
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final create_meeting_info = MeetingModel(
          id: jsonData['data']['id'],
          name: jsonData['data']['name'],
          id_event: jsonData['data']['event_id'],
          id_user: jsonData['data']['user_id'],
          description: jsonData['data']['description'],
          people_need: jsonData['data']['people_need'],
        );
        return APIResponse<MeetingModel>(
            data: create_meeting_info, errorMessage: '');
      }
      return APIResponse<MeetingModel>(
          data: MeetingModel(), error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<MeetingModel>(
            data: MeetingModel(),
            error: true,
            errorMessage: 'An error occured'));

    // return http.post(Uri.parse('${API}/auth/login'),
    //     {Login(email: 'hilmi@gmail.com', password: 'password')});
    //   return http.get(Uri.parse('${API}/auth/login')).then((data) {
    //     return APIResponse<MeetingModel>(
    //         data: MeetingModel(access_token: '', user: UserModel(id: 0, name: '')),
    //         errorMessage: jsonDecode(data.body).toString());
    //     // if (data.statusCode == 200) {
    //     //   final jsonData = jsonDecode(data.body);
    //     //   final login_info = MeetingModel(access_token: js);
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
    //     //   return APIResponse<MeetingModel>(
    //     //       data: login_info, errorMessage: '');
    //     // }
    //     // return APIResponse<MeetingModel>(
    //     //     data: [], error: true, errorMessage: 'An error occured');
    //   }).catchError((_) => APIResponse<MeetingModel>(
    //       data: MeetingModel(access_token: '', user: UserModel(id: 0, name: '')),
    //       error: true,
    //       errorMessage: 'An error occured'));
  }

  // Future<APIResponse<List<MeetingModel>>> getEventCategoryListLimit(
  //     idCategory, limit) {
  //   return http
  //       .get(Uri.parse('${API}/event/by-category/${idCategory}?limit=${limit}'))
  //       .then((data) {
  //     // return APIResponse<List<MeetingModel>>(
  //     //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
  //     if (data.statusCode == 200) {
  //       final jsonData = jsonDecode(data.body);
  //       final events = <MeetingModel>[];
  //       for (var i = 0; i < jsonData["data"].length; i++) {
  //         final event = MeetingModel(
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
  //       return APIResponse<List<MeetingModel>>(
  //           data: events, errorMessage: events.toString());
  //     }
  //     return APIResponse<List<MeetingModel>>(
  //         data: [], error: true, errorMessage: 'An error occured');
  //   }).catchError((_) => APIResponse<List<MeetingModel>>(
  //           data: [], error: true, errorMessage: 'An error occured'));
  // }

  // Future<List<MeetingModel>> fetchDataSynchronously(idCategori, limit) {
  //   return http
  //       .get(Uri.parse('${API}/event/by-category/${idCategori}?limit=${limit}'))
  //       .then((data) {
  //     // return APIResponse<List<MeetingModel>>(
  //     //     data: [], errorMessage: jsonDecode(data.body)['data'].toString());
  //     if (data.statusCode == 200) {
  //       final jsonData = jsonDecode(data.body);
  //       final events = <MeetingModel>[];
  //       for (var i = 0; i < jsonData["data"].length; i++) {
  //         final event = MeetingModel(
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
  //     return <MeetingModel>[];
  //   }).catchError((_) => <MeetingModel>[]);
  // }

  // Future<APIResponse<MeetingModel>> getDetailEvent(int idEvent) {
  //   return http.get(Uri.parse('${API}/event/${idEvent}')).then((data) {
  //     if (data.statusCode == 200) {
  //       final item = jsonDecode(data.body)['data'];
  //       // String image = API + item["image"];
  //       final event = MeetingModel(
  //           id: item['id'],
  //           name: item['name'],
  //           description: item['description'],
  //           place: item['place'],
  //           address: item['address'],
  //           date: DateFormat('EEEE, MMMM d y')
  //               .format(DateTime.parse(item['date'])),
  //           imgUrl: baseurl + item["image"]);
  //       return APIResponse<MeetingModel>(data: event, errorMessage: '');
  //     }
  //     return APIResponse<MeetingModel>(
  //         data: MeetingModel(
  //             id: 2,
  //             name: '',
  //             description: '',
  //             imgUrl: '',
  //             place: '',
  //             address: '',
  //             date: ''),
  //         error: true,
  //         errorMessage: 'An error occured');
  //   }).catchError((_) => APIResponse<MeetingModel>(
  //       data: MeetingModel(
  //           id: 2,
  //           name: '',
  //           description: '',
  //           imgUrl: '',
  //           place: '',
  //           address: '',
  //           date: ''),
  //       error: true,
  //       errorMessage: 'An error occured'));
  // }
}
