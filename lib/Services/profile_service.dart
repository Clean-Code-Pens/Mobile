import 'dart:convert';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const baseurl = 'https://activity-connect.naradika.my.id/public';
  static const API = 'https://activity-connect.naradika.my.id/public/api';

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<APIResponse<ProfileModel>> getDetailProfile() async {
    try {
      final String? accessToken = await getAccessToken();
      if (accessToken == null) {
        // Handle jika token akses tidak tersedia
        return APIResponse<ProfileModel>(
          data: ProfileModel(),
          error: true,
          errorMessage: 'Access token is not available.',
        );
      }

      final response = await http.get(
        Uri.parse('${API}/profile/my'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final profiles = jsonDecode(response.body)['data'];
        final profile = ProfileModel(
          name: profiles['name'],
          email: profiles['email'],
        );

        return APIResponse<ProfileModel>(data: profile, errorMessage: '');
      } else {
        // Handle jika respons status code bukan 200 OK
        return APIResponse<ProfileModel>(
          data: ProfileModel(),
          error: true,
          errorMessage: 'Failed to get profile data. Status code: ${response
              .statusCode}',
        );
      }
    } catch (error) {
      // Handle jika terjadi kesalahan selama proses permintaan
      return APIResponse<ProfileModel>(
        data: ProfileModel(),
        error: true,
        errorMessage: 'An error occurred: $error',
      );
    }
  }
}
