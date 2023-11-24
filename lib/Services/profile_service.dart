import 'dart:convert';

import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/user_model.dart';
// import 'package:clean_code/Models/profile_model.dart';
import 'package:clean_code/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static String baseurl = AppUrl.baseurl;
  static String API = AppUrl.apiurl;

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<APIResponse<UserModel>> getDetailProfile() async {
    String? user_id = await getUserId();
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final post = {
      'user_id': user_id,
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
            address: jsonData["data"]["profile"]['address'],
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

  Future<APIResponse<UserModel>> changeProfilePicture(imageFile) async {
    // final event = {
    //   'name': name,
    //   'event_category_id': event_category_id,
    //   'description': description,
    //   'date': date,
    //   'place': place,
    //   'address': address,
    // };
    Uri url = Uri.parse('${API}/profile/update-foto');
    var request = http.MultipartRequest('POST', url);
    String? access_token = await getAccessToken();
    request.headers['Authorization'] = 'Bearer ${access_token}';
    // event.forEach((key, value) {
    //   request.fields[key] = value;
    // });
    if (imageFile != null) {
      MediaType? mediaType;
      if (imageFile.path.toLowerCase().endsWith('.jpg') ||
          imageFile.path.toLowerCase().endsWith('.jpeg')) {
        mediaType = MediaType('image', 'jpeg');
      } else if (imageFile.path.toLowerCase().endsWith('.png')) {
        mediaType = MediaType('image', 'png');
      } else {
        return APIResponse<UserModel>(
            data: UserModel(),
            error: true,
            errorMessage: 'Format file/gambar tidak didukung');
      }
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        imageFile.path,
        contentType: mediaType, // Adjust the content type as needed
      ));
      try {
        final response = await request.send();
        var responseBody = await response.stream.toBytes();
        // return APIResponse<UserModel>(
        //     data: UserModel(),
        //     errorMessage: String.fromCharCodes(responseBody));
        final jsonData = jsonDecode(String.fromCharCodes(responseBody));
        if (response.statusCode == 200) {
          var user = UserModel(
            id: jsonData["data"]['user']['id'],
            name: jsonData["data"]['user']['name'],
            email: jsonData["data"]['user']['email'],
            profile: ProfileModel(
              id: jsonData["data"]['id'],
              address: jsonData["data"]['address'],
              profile_picture: jsonData["data"]['profile_picture'],
              job: jsonData["data"]['job'],
              no_hp: jsonData["data"]['noHp'],
              gender: jsonData["data"]['gender'],
            ),
          );
          return APIResponse<UserModel>(
              data: user,
              errorMessage:
                  'token : ${access_token}, response code : ${response.statusCode}');
        } else {
          // print('Failed to upload image. Status code: ${response.statusCode}');
          if (jsonData['message'].length > 1) {
            return APIResponse<UserModel>(
                data: UserModel(),
                error: true,
                errorMessage: 'Semua inputan harus diisi');
          }
          return APIResponse<UserModel>(
              data: UserModel(),
              error: true,
              errorMessage: '${jsonData["message"]}');
        }
      } catch (e) {
        return APIResponse<UserModel>(
            data: UserModel(), error: true, errorMessage: 'An error occured');
      }
    } else {
      // print('Failed to upload image. Status code: ${response.statusCode}');
      return APIResponse<UserModel>(
          data: UserModel(),
          error: true,
          errorMessage: 'Semua inputan harus diisi');
    }
  }

  Future<APIResponse<UserModel>> updateProfile(
      name, address, gender, job, noHp) async {
    String? access_token = await getAccessToken();
    final headers = {
      'Authorization': 'Bearer ${access_token}',
    };
    final user = {
      'name': name,
      'addres': address,
      'gender': gender,
      'job': job,
      'noHp': noHp
    };
    return http
        .post(Uri.parse('${API}/profile/update'), headers: headers, body: user)
        .then((data) {
      //   return APIResponse<UserModel>(
      //   // data: UserModel(), errorMessage: jsonDecode(data.body).toString());
      // });
      final jsonData = jsonDecode(data.body);
      if (data.statusCode == 200) {
        // final jsonData = jsonDecode(data.body);
        var user = UserModel(
          id: jsonData["data"]['user']['id'],
          name: jsonData["data"]['user']['name'],
          email: jsonData["data"]['user']['email'],
          profile: ProfileModel(
            id: jsonData["data"]['profile']['id'],
            address: jsonData["data"]['profile']['address'],
            profile_picture: jsonData["data"]['profile']['profile_picture'],
            job: jsonData["data"]['profile']['job'],
            no_hp: jsonData["data"]['profile']['noHp'],
            gender: jsonData["data"]['profile']['gender'],
          ),
        );
        return APIResponse<UserModel>(data: user, errorMessage: '');
      } else {
        if (jsonData['message'].length > 1) {
          return APIResponse<UserModel>(
              data: UserModel(),
              error: true,
              errorMessage: '${jsonData["message"]}');
        } else if (jsonData['error'] == "01000") {
          return APIResponse<UserModel>(
              data: UserModel(),
              error: true,
              errorMessage: '${jsonData['error'][2]}');
        }
        return APIResponse<UserModel>(
            data: UserModel(),
            error: true,
            errorMessage: '${jsonData["message"]}');
      }
      // return APIResponse<UserModel>(
      //     data: UserModel(), error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<UserModel>(
            data: UserModel(), error: true, errorMessage: 'An error occured'));
  }

  // Future<APIResponse<ProfileModel>> getDetailProfile() async {
  //   try {
  //     final String? accessToken = await getAccessToken();
  //     if (accessToken == null) {
  //       // Handle jika token akses tidak tersedia
  //       return APIResponse<ProfileModel>(
  //         data: ProfileModel(),
  //         error: true,
  //         errorMessage: 'Access token is not available.',
  //       );
  //     }

  //     final response = await http.get(
  //       Uri.parse('${API}/profile/my'),
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final profiles = jsonDecode(response.body)['data'];
  //       final profile = ProfileModel(
  //         name: profiles['name'],
  //         email: profiles['email'],
  //       );

  //       return APIResponse<ProfileModel>(data: profile, errorMessage: '');
  //     } else {
  //       // Handle jika respons status code bukan 200 OK
  //       return APIResponse<ProfileModel>(
  //         data: ProfileModel(),
  //         error: true,
  //         errorMessage:
  //             'Failed to get profile data. Status code: ${response.statusCode}',
  //       );
  //     }
  //   } catch (error) {
  //     // Handle jika terjadi kesalahan selama proses permintaan
  //     return APIResponse<ProfileModel>(
  //       data: ProfileModel(),
  //       error: true,
  //       errorMessage: 'An error occurred: $error',
  //     );
  //   }
  // }
}
