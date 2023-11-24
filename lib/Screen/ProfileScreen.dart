import 'dart:io';
import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/user_model.dart';
import 'package:clean_code/Screen/ChangePasswordScreen.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/EditProfileScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/MyEventScreen.dart';
import 'package:clean_code/Screen/MyMeetingScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Screen/notificationScreen.dart';
import 'package:clean_code/Services/category_service.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  ProfileService get serviceProfile => GetIt.I<ProfileService>();
  APIResponse<UserModel>? _apiProfile;

  bool _isLoading = false;
  String profile_picture = '';

  @override
  void initState() {
    _fetchAPI();
    super.initState();
  }

  _fetchAPI() async {
    setState(() {
      _isLoading = true;
    });
    _apiProfile = await serviceProfile.getDetailProfile();
    setState(() {
      final String path_profile_picture =
          _apiProfile?.data?.profile?.profile_picture ?? 'notfound';
      profile_picture = AppUrl.baseurl + path_profile_picture;
      _isLoading = false;
    });
  }

  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () => removeAccessToken(),
          //   icon: Icon(Icons.exit_to_app),
          //   color: Color(0xFF3188FA),
          // ),
          // SizedBox(width: 5), // Spasi antara gambar dan tombol logout

          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
            },
            icon: Icon(
              Icons.notifications,
              color: Color(0xFF3188FA),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     'ActivityConnect',
      //     style: TextStyle(color: Color(0xFF3188FA)),
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {},
      //       icon: Icon(
      //         Icons.notifications,
      //         color: Color(0xFF3188FA),
      //       ),
      //     )
      //   ],
      //   backgroundColor: Colors.white,
      // ),
      body: Builder(builder: (_) {
        if (_isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   radius: 60,
                    //   backgroundImage: NetworkImage(
                    //       _apiProfile?.data?.profile?.profile_picture ??
                    //           'Not Found'),
                    // ),
                    // SizedBox(height: 10),
                    // Text(
                    //   _apiProfile?.data?.name ?? (""),
                    //   style: TextStyle(fontSize: 20),
                    // ),
                    // Text(
                    //   _apiProfile?.data?.email ?? (""),
                    //   style: TextStyle(fontSize: 15),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.blueGrey,
                                  image: DecorationImage(
                                    image: NetworkImage(profile_picture),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                _apiProfile?.data?.name ?? 'Not Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                _apiProfile?.data?.email ?? 'Not Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        child: Text("Edit Profile",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        child: Text("Change Password",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text('Logout Confirm'),
                                ),
                                content: Text('Apakah anda yakin akan keluar?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      removeAccessToken(); // Close the modal
                                    },
                                    child: Text('Logout'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the modal
                                    },
                                    child: Text('Batal'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        child: Text("Logout",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateEvent()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  tooltip: 'Home',
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                IconButton(
                  tooltip: 'My Events',
                  icon: const Icon(Icons.event_available),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyEvent()));
                  },
                ),
                const SizedBox(width: 24),
                IconButton(
                  tooltip: 'My Meetings',
                  icon: const Icon(Icons.supervised_user_circle_sharp),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyMeeting()));
                  },
                ),
                IconButton(
                  tooltip: 'Profile',
                  icon: const Icon(Icons.person_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
