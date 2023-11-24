import 'dart:convert';
// import 'dart:html';

import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Models/user_model.dart';
import 'package:clean_code/models/profile_model.dart';
import 'package:clean_code/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingService {
  static String baseurl = AppUrl.baseurl;
  static String API = AppUrl.apiurl;
  // static const baseurl = 'https://activity-connect.projectdira.my.id/public';
  // static const API = 'https://activity-connect.projectdira.my.id/public/api';
  // static const headers = {
  //   'Authorization':
  //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FjdGl2aXR5LWNvbm5lY3QucHJvamVjdGRpcmEubXkuaWQvcHVibGljL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNjk4NDA2NDk0LCJleHAiOjE2OTg0MTAwOTQsIm5iZiI6MTY5ODQwNjQ5NCwianRpIjoiWFJhSWRoYUhQc2JPT2VkdyIsInN1YiI6IjMiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.MBwKnNOD42L56ftw6rYVWqtUr8XQ1HdWJmaIxhmt0JU',
  // };

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

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<APIResponse<List<MeetingModel>>> getMeetingList() {
    return http.get(Uri.parse('${API}/meet')).then((data) {
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
            user: UserModel(
                id: jsonData["data"][i]['user']['id'],
                name: jsonData["data"][i]['user']['name']),
            event: EventModel(
                id: jsonData["data"][i]['event']['id'],
                name: jsonData["data"][i]['event']['name'],
                description: jsonData["data"][i]['event']['description']),
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
            user: UserModel(
                id: jsonData["data"][i]['user']['id'],
                name: jsonData["data"][i]['user']['name']),
            event: EventModel(
                id: jsonData["data"][i]['event']['id'],
                name: jsonData["data"][i]['event']['name'],
                place: jsonData["data"][i]['event']['place'],
                date: DateFormat('EEEE, MMMM d y').format(
                    DateTime.parse(jsonData["data"][i]['event']['date'])),
                description: jsonData["data"][i]['event']['description']),
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
      id_event, title, description, people) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
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
      //   // data: MeetingModel(), errorMessage: jsonDecode(data.body).toString());
      // });
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        // final jsonData = jsonDecode(data.body);
        final create_meeting_info = MeetingModel(
          id: jsonData['data']['id'],
          name: jsonData['data']['name'],
          id_event: jsonData['data']['event_id'],
          user: UserModel(),
          description: jsonData['data']['description'],
          people_need: jsonData['data']['people_need'],
        );
        return APIResponse<MeetingModel>(
            data: create_meeting_info, errorMessage: '');
      } else {
        if (jsonData['message'].length > 1) {
          return APIResponse<MeetingModel>(
              data: MeetingModel(),
              error: true,
              errorMessage: '${jsonData["message"]}');
        } else if (jsonData['error'][0] == "22001") {
          return APIResponse<MeetingModel>(
              data: MeetingModel(),
              error: true,
              errorMessage: '${jsonData['error'][2]}');
        }
        return APIResponse<MeetingModel>(
            data: MeetingModel(),
            error: true,
            errorMessage: '${jsonData["message"]}');
      }
      // return APIResponse<MeetingModel>(
      //     data: MeetingModel(), error: true, errorMessage: 'An error occured');
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
  Future<APIResponse<UserModel>> getRequestProfile(int idUser) async {
    // String? user_id = await getUserId();
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'user_id': idUser.toString(),
    };
    return http
        .post(Uri.parse('${API}/profile/orang'), body: post, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        // final requests = <RequestModel>[];
        var user = UserModel(
          id: jsonData["data"]['id'],
          name: jsonData["data"]['name'],
          email: jsonData["data"]['email'],
        );
        if (jsonData["data"]["profile"] != null) {
          user.profile = ProfileModel(
            id: jsonData["data"]["profile"]['id'],
            address: jsonData["data"]["profile"]['addres'],
            profile_picture: jsonData["data"]["profile"]['profile_picture'],
            job: jsonData["data"]["profile"]['job'],
            no_hp: jsonData["data"]["profile"]['noHp'],
            gender: jsonData["data"]["profile"]['gender'],
          );
        }

        return APIResponse<UserModel>(
            data: user, errorMessage: jsonDecode(data.body).toString());
      }
      return APIResponse<UserModel>(
          data: UserModel(),
          error: true,
          errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<UserModel>(
            data: UserModel(), error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<RequestModel>>> getRequestMeeting(
      int idMeeting) async {
    // String? user_id = await getUserId();
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'meet_id': idMeeting.toString(),
    };
    return http
        .post(Uri.parse('${API}/meet-request/list'),
            body: post, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final requests = <RequestModel>[];
        // var ownership = 'other';
        for (var i = 0; i < jsonData["data"].length; i++) {
          // if (user_id == jsonData["data"][i]['user']['id'].toString()) {
          //   ownership = 'mine';
          // }
          final request = RequestModel(
            id: jsonData["data"][i]['id'],
            user: UserModel(
              id: jsonData["data"][i]['user']['id'],
              name: jsonData["data"][i]['user']['name'],
              profile: ProfileModel(
                  profile_picture: jsonData["data"][i]['user']['profile']
                      ['profile_picture']),
            ),
          );
          requests.add(request);
        }

        return APIResponse<List<RequestModel>>(
            data: requests, errorMessage: jsonDecode(data.body).toString());
      }
      return APIResponse<List<RequestModel>>(
          data: [], error: true, errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<List<RequestModel>>(
            data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<RequestModel>> acceptRequest(int idRequest) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'id': idRequest.toString(),
    };
    return http
        .post(Uri.parse('${API}/meet-request/accept'),
            body: post, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final request = RequestModel(
          id: jsonData["data"]['id'],
          user: UserModel(
            id: int.parse(jsonData["data"]['user_id']),
          ),
        );

        return APIResponse<RequestModel>(
            data: request, errorMessage: '${jsonData["message"]}');
      }
      return APIResponse<RequestModel>(
          data: RequestModel(),
          error: true,
          errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<RequestModel>(
            data: RequestModel(),
            error: true,
            errorMessage: 'An error occured'));
  }

  Future<APIResponse<RequestModel>> rejectRequest(int idRequest) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'id': idRequest.toString(),
    };
    return http
        .post(Uri.parse('${API}/meet-request/reject'),
            body: post, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final request = RequestModel(
          id: jsonData["data"]['id'],
          user: UserModel(
            id: int.parse(jsonData["data"]['user_id']),
          ),
        );

        return APIResponse<RequestModel>(
            data: request, errorMessage: '${jsonData["message"]}');
      }
      return APIResponse<RequestModel>(
          data: RequestModel(),
          error: true,
          errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<RequestModel>(
            data: RequestModel(),
            error: true,
            errorMessage: 'An error occured'));
  }

  Future<APIResponse<MeetingModel>> getDetailMeeting(int idMeeting) async {
    String? user_id = await getUserId();
    return http.get(Uri.parse('${API}/meet/${idMeeting}')).then((data) {
      if (data.statusCode == 200) {
        final meets = jsonDecode(data.body)['data'];
        // final listMeet = <MeetingModel>[];
        var ownership = 'other';
        if (user_id == meets['user']['id'].toString()) {
          ownership = 'mine';
        }
        final meet = MeetingModel(
          id: meets['id'],
          ownership: ownership,
          name: meets['name'],
          description: meets['description'],
          user: UserModel(
            id: meets['user']['id'],
            name: meets['user']['name'],
            profile: ProfileModel(
              profile_picture: meets['user']['profile']['profile_picture'],
            ),
          ),
          event: EventModel(
              id: meets['event']['id'],
              name: meets['event']['name'],
              place: meets['event']['place'],
              date: DateFormat('EEEE, MMMM d y')
                  .format(DateTime.parse(meets['event']['date'])),
              description: meets['event']['description']),
          id_event: meets['event_id'],
          people_need: meets['people_need'],
        );

        return APIResponse<MeetingModel>(data: meet, errorMessage: 'cek');
      }
      return APIResponse<MeetingModel>(
          data: MeetingModel(),
          error: true,
          errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<MeetingModel>(
        data: MeetingModel(), error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse> joinMeet(String idMeeting) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'meet_id': idMeeting,
    };
    return http
        .post(Uri.parse('${API}/meet-request/create'),
            body: post, headers: headers)
        .then((data) {
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        return APIResponse(data: jsonDecode(data.body), errorMessage: '');
      } else {
        if (jsonData['message'] != '') {
          return APIResponse<MeetingModel>(
              data: MeetingModel(),
              error: true,
              errorMessage: '${jsonData['message']}');
        }
      }
      return APIResponse(
          data: MeetingModel(), error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse(
            data: MeetingModel(),
            error: true,
            errorMessage: 'An error occured'));
  }

  Future<APIResponse> reportMeet(String idMeeting) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'meet_id': idMeeting,
    };
    return http
        .post(Uri.parse('${API}/meet/report'), body: post, headers: headers)
        .then((data) {
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        return APIResponse(data: jsonDecode(data.body), errorMessage: '');
      } else {
        if (jsonData['message'] != '') {
          return APIResponse<MeetingModel>(
              data: MeetingModel(),
              error: true,
              errorMessage: '${jsonData['message']}');
        }
      }
      return APIResponse(
          data: MeetingModel(), error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse(
            data: MeetingModel(),
            error: true,
            errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<MeetingModel>>> searchMeeting(keyword) {
    final body = {
      'query': keyword,
    };
    return http.post(Uri.parse('${API}/meet/search'), body: body).then((data) {
      //   return APIResponse<List<MeetingModel>>(
      //       data: [], errorMessage: jsonDecode(data.body).toString());
      // });
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        final meetings = <MeetingModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final meeting = MeetingModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
            description: jsonData["data"][i]['description'],
            user: UserModel(
                id: jsonData["data"][i]['user']['id'],
                name: jsonData["data"][i]['user']['name']),
            event: EventModel(
                id: jsonData["data"][i]['event']['id'],
                name: jsonData["data"][i]['event']['name'],
                place: jsonData["data"][i]['event']['place'],
                date: DateFormat('EEEE, MMMM d y').format(
                    DateTime.parse(jsonData["data"][i]['event']['date'])),
                description: jsonData["data"][i]['event']['description']),
            id_event: jsonData["data"][i]['event_id'],
            people_need: jsonData["data"][i]['people_need'],
          );
          meetings.add(meeting);
        }
        // return APIResponse<List<EventModel>>(data: events, errorMessage: '');
        return APIResponse<List<MeetingModel>>(
            data: meetings, errorMessage: jsonDecode(data.body).toString());
      } else {
        if (jsonData['message'] != '') {
          return APIResponse<List<MeetingModel>>(
              data: [], error: true, errorMessage: '${jsonData['message']}');
        }
      }
      return APIResponse<List<MeetingModel>>(
          // data: [], error: true, errorMessage: jsonDecode(data.body).toString());
          data: [],
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<MeetingModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<MeetingModel>>> getMyMeetingCreated() async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    // final body = {
    //   'query': keyword,
    // };
    return http
        .post(Uri.parse('${API}/meet/my'), headers: headers)
        .then((data) {
      //   return APIResponse<List<MeetingModel>>(
      //       data: [], errorMessage: jsonDecode(data.body).toString());
      // });
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        final meetings = <MeetingModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final meeting = MeetingModel(
            id: jsonData["data"][i]['id'],
            name: jsonData["data"][i]['name'],
            description: jsonData["data"][i]['description'],
            user: UserModel(
                id: jsonData["data"][i]['user']['id'],
                name: jsonData["data"][i]['user']['name']),
            event: EventModel(
                id: jsonData["data"][i]['event']['id'],
                name: jsonData["data"][i]['event']['name'],
                place: jsonData["data"][i]['event']['place'],
                date: DateFormat('EEEE, MMMM d y').format(
                    DateTime.parse(jsonData["data"][i]['event']['date'])),
                description: jsonData["data"][i]['event']['description']),
            id_event: jsonData["data"][i]['event_id'],
            people_need: jsonData["data"][i]['people_need'],
            status: jsonData["data"][i]['status'],
          );
          meetings.add(meeting);
        }
        // return APIResponse<List<EventModel>>(data: events, errorMessage: '');
        return APIResponse<List<MeetingModel>>(
            data: meetings, errorMessage: jsonDecode(data.body).toString());
      } else {
        if (jsonData['message'] != '') {
          return APIResponse<List<MeetingModel>>(
              data: [], error: true, errorMessage: '${jsonData['message']}');
        }
      }
      return APIResponse<List<MeetingModel>>(
          // data: [], error: true, errorMessage: jsonDecode(data.body).toString());
          data: [],
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<MeetingModel>>(
            data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<MeetingModel>>> getMyMeetingJoin() async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    // final body = {
    //   'query': keyword,
    // };
    return http
        .post(Uri.parse('${API}/meet/my-join'), headers: headers)
        .then((data) {
      //   return APIResponse<List<MeetingModel>>(
      //       data: [], errorMessage: jsonDecode(data.body).toString());
      // });
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        final meetings = <MeetingModel>[];
        for (var i = 0; i < jsonData["data"].length; i++) {
          final meeting = MeetingModel(
            id: jsonData["data"][i]['meet']['id'],
            name: jsonData["data"][i]['meet']['name'],
            description: jsonData["data"][i]['meet']['description'],
            user: UserModel(
                id: jsonData["data"][i]['meet']['user']['id'],
                name: jsonData["data"][i]['meet']['user']['name']),
            event: EventModel(
                id: jsonData["data"][i]['meet']['event']['id'],
                name: jsonData["data"][i]['meet']['event']['name'],
                place: jsonData["data"][i]['meet']['event']['place'],
                date: DateFormat('EEEE, MMMM d y').format(DateTime.parse(
                    jsonData["data"][i]['meet']['event']['date'])),
                description: jsonData["data"][i]['meet']['event']
                    ['description']),
            id_event: jsonData["data"][i]['meet']['event_id'],
            people_need: jsonData["data"][i]['meet']['people_need'],
            status: jsonData["data"][i]['status'],
          );
          meetings.add(meeting);
        }
        // return APIResponse<List<EventModel>>(data: events, errorMessage: '');
        return APIResponse<List<MeetingModel>>(
            data: meetings, errorMessage: jsonDecode(data.body).toString());
      } else {
        if (jsonData['message'] != '') {
          return APIResponse<List<MeetingModel>>(
              data: [], error: true, errorMessage: '${jsonData['message']}');
        }
      }
      return APIResponse<List<MeetingModel>>(
          // data: [], error: true, errorMessage: jsonDecode(data.body).toString());
          data: [],
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<MeetingModel>>(
            data: [], error: true, errorMessage: 'An error occured'));
  }
}
