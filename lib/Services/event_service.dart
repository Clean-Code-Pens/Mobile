import 'dart:convert';

import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  static String baseurl = AppUrl.baseurl;
  static String API = AppUrl.apiurl;
  // static const headers = {
  //   'Authorization':
  //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FjdGl2aXR5LWNvbm5lY3QucHJvamVjdGRpcmEubXkuaWQvcHVibGljL2FwaS9hdXRoL2xvZ2luIiwiaWF0IjoxNjk4NDI3MzUwLCJleHAiOjE2OTg0MzA5NTAsIm5iZiI6MTY5ODQyNzM1MCwianRpIjoiOUN2THZTb28xZk9BeDFJTSIsInN1YiI6IjUiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.1W5jYKoi4C7Gnk-zOeEMMQEO_vhBiSkZpx9aPKlOYis',
  // };
  // Future<String> access_token = getAccessToken();

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<APIResponse<List<EventModel>>> getEventList() {
    return http.get(Uri.parse('${API}/event/')).then((data) {
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

  Future<APIResponse<EventModel>> createEvent(event_category_id, name, place,
      address, date, description, imageFile) async {
    final event = {
      'name': name,
      'event_category_id': event_category_id,
      'description': description,
      'date': date,
      'place': place,
      'address': address,
    };
    Uri url = Uri.parse('${API}/event/create');
    var request = http.MultipartRequest('POST', url);
    String? access_token = await getAccessToken();
    request.headers['Authorization'] = 'Bearer ${access_token}';
    event.forEach((key, value) {
      request.fields[key] = value;
    });
    if (imageFile != null) {
      MediaType? mediaType;
      if (imageFile.path.toLowerCase().endsWith('.jpg') ||
          imageFile.path.toLowerCase().endsWith('.jpeg')) {
        mediaType = MediaType('image', 'jpeg');
      } else if (imageFile.path.toLowerCase().endsWith('.png')) {
        mediaType = MediaType('image', 'png');
      } else {
        return APIResponse<EventModel>(
            data: EventModel(),
            error: true,
            errorMessage: 'Format file/gambar tidak didukung');
      }
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: mediaType, // Adjust the content type as needed
      ));
      try {
        final response = await request.send();
        var responseBody = await response.stream.toBytes();
        // return APIResponse<EventModel>(
        //     data: EventModel(),
        //     errorMessage: String.fromCharCodes(responseBody));
        final jsonData = jsonDecode(String.fromCharCodes(responseBody));
        if (response.statusCode == 200) {
          // print('Image uploaded successfully');
          final create_meeting_info = EventModel(
            id: jsonData['data']['id'],
            name: jsonData['data']['name'],
            description: jsonData['data']['description'],
            imgUrl: baseurl + jsonData['data']["image"],
            place: jsonData['data']['place'],
            address: jsonData['data']['address'],
            date: DateFormat('EEEE, MMMM d y')
                .format(DateTime.parse(jsonData['data']['date'])),
          );
          return APIResponse<EventModel>(
              data: create_meeting_info,
              errorMessage:
                  'token : ${access_token}, response code : ${response.statusCode}');
        } else {
          // print('Failed to upload image. Status code: ${response.statusCode}');
          if (jsonData['message'].length > 1) {
            return APIResponse<EventModel>(
                data: EventModel(),
                error: true,
                errorMessage: 'Semua inputan harus diisi');
          }
          return APIResponse<EventModel>(
              data: EventModel(),
              error: true,
              errorMessage: '${jsonData["message"]}');
        }
      } catch (e) {
        return APIResponse<EventModel>(
            data: EventModel(), error: true, errorMessage: 'An error occured');
      }
    } else {
      // print('Failed to upload image. Status code: ${response.statusCode}');
      return APIResponse<EventModel>(
          data: EventModel(),
          error: true,
          errorMessage: 'Semua inputan harus diisi');
    }

    // return http.MultipartRequest('POST',Uri.parse('${API}/meet/create'))
    // // return http
    // //     .post(Uri.parse('${API}/meet/create'), headers: headers, body: user)
    //     .then((data) {
    //   //   return APIResponse<EventModel>(
    //   //       data: EventModel(), errorMessage: jsonDecode(data.body).toString());
    //   // });
    //   if (data.statusCode == 200) {
    //     final jsonData = jsonDecode(data.body);
    //     final create_meeting_info = EventModel(
    //       id: jsonData['data']['id'],
    //       name: jsonData['data']['name'],
    //       id_event: jsonData['data']['event_id'],
    //       id_user: jsonData['data']['user_id'],
    //       description: jsonData['data']['description'],
    //       people_need: jsonData['data']['people_need'],
    //     );
    //     return APIResponse<EventModel>(
    //         data: create_meeting_info, errorMessage: '');
    //   }
    //   return APIResponse<EventModel>(
    //       data: EventModel(), error: true, errorMessage: 'An error occured');
    // }).catchError((_) => APIResponse<EventModel>(
    //         data: EventModel(), error: true, errorMessage: 'An error occured'));
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
        final jsonData = jsonDecode(data.body)['data'];
        final meets = jsonDecode(data.body)['data']['meets'];
        final listMeet = <MeetingModel>[];
        for (var i = 0; i < meets.length; i++) {
          final meet = MeetingModel(
            id: meets[i]['id'],
            name: meets[i]['name'],
            description: meets[i]['description'],
            user: UserModel(
                id: meets[i]['user']['id'], name: meets[i]['user']['name']),
            id_event: meets[i]['event_id'],
            people_need: meets[i]['people_need'],
          );
          listMeet.add(meet);
        }
        // meets.forEach((k, item) {
        // });
        // String image = API + item["image"];
        final event = EventModel(
          id: jsonData['id'],
          name: jsonData['name'],
          description: jsonData['description'],
          place: jsonData['place'],
          address: jsonData['address'],
          date: DateFormat('EEEE, MMMM d y')
              .format(DateTime.parse(jsonData['date'])),
          imgUrl: baseurl + jsonData["image"],
          meetings: listMeet,
        );
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

  Future<APIResponse<List<EventModel>>> searchEvent(keyword) async {
    // final body = {
    //   'query': keyword,
    // };
    // return http.post(Uri.parse('${API}/event/search'), body: body).then((data) {
    //   return APIResponse<List<EventModel>>(
    //       data: [], errorMessage: jsonDecode(data.body).toString());
    // });
    // String? access_token = await getAccessToken();
    // final headers = {
    //   'Authorization': 'Bearer ${access_token}',
    // };
    final body = {
      'query': keyword,
    };
    return http.post(Uri.parse('${API}/event/search'), body: body).then((data) {
      //   return APIResponse<EventModel>(
      //   // data: EventModel(), errorMessage: jsonDecode(data.body).toString());
      // });
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
        // return APIResponse<List<EventModel>>(data: events, errorMessage: '');
        return APIResponse<List<EventModel>>(
            data: events, errorMessage: jsonDecode(data.body).toString());
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
        data: [], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<List<EventModel>>> getMyEventList() async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    // final body = {
    //   'query': keyword,
    // };
    return http
        .post(Uri.parse('${API}/event/my'), headers: headers)
        .then((data) {
      //   return APIResponse<EventModel>(
      //   // data: EventModel(), errorMessage: jsonDecode(data.body).toString());
      // });
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
        // return APIResponse<List<EventModel>>(data: events, errorMessage: '');
        return APIResponse<List<EventModel>>(data: events, errorMessage: '');
      }
      return APIResponse<List<EventModel>>(
          data: [], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<EventModel>>(
            data: [], error: true, errorMessage: 'An error occured'));
  }
}
