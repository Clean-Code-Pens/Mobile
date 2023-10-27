import 'package:clean_code/Provider/Database/db_provider.dart';
import 'package:clean_code/Services/auth_service.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/category_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/RegisterScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ndaftarne service
void setupLocator() {
  GetIt.I.registerLazySingleton(() => EventService());
  GetIt.I.registerLazySingleton(() => CategoryService());
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => MeetingService());
}

Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<bool> checkAuth() async {
  String? accessToken = await getAccessToken();
  return accessToken != null;
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Code',
      debugShowCheckedModeBanner: false,
      home:
          LoginScreen(),
          // RegisterScreen(),
          // HomeScreen(),
      home: FutureBuilder<bool>(
        future:
            checkAuth(), // Assume you have a function that checks authentication.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking authentication status, show a loading indicator.
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              // Handle errors if any.
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.data == true) {
                // User is authenticated, navigate to the authenticated screen.
                return HomeScreen();
              } else {
                // User is not authenticated, navigate to the login or onboarding screen.
                return LoginScreen();
              }
            }
          }
        },
      ),
      // LoginScreen(),
      // RegisterScreen(),
      // HomeScreen(),
      // CreateEvent(),
      // DetailEvent(),
    );
  }
}
