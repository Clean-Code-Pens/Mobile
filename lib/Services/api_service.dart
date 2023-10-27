import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
  final String _url = 'https://activity-connect.projectdira.my.id/public/api/auth/login';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? tokenString = localStorage.getString('token');
    if (tokenString != null) {
      token = jsonDecode(tokenString)['token'];
    }
  }

  auth(data, apiURL) async {
    Uri fullUrl = Uri.parse(_url + apiURL);
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiURL) async {
    Uri fullUrl = Uri.parse(_url + apiURL);
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}