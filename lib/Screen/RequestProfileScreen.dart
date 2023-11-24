import 'dart:math';

import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Models/user_model.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/RequestProfileScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:clean_code/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProfile extends StatefulWidget {
  int idUser;
  int idMeeting;

  RequestProfile({required this.idUser, required this.idMeeting});

  @override
  _RequestProfileState createState() => _RequestProfileState();
  // _RequestProfileState createState() => _RequestProfileState(this.idMeeting);
}

class _RequestProfileState extends State<RequestProfile>
    with TickerProviderStateMixin {
  // int? idMeeting;

  // _DetailEventState(id) {
  //   this.idMeeting = id;
  // }

  int _selectedIndex = 0;
  String profile_picture = '/profilePicture/usericon.png';

  // EventService get service => GetIt.I<EventService>();
  // APIResponse<EventModel>? _apiDetailMeeting;

  MeetingService get meetingService => GetIt.I<MeetingService>();
  APIResponse<UserModel>? _apiRequestProfile;
  // APIResponse<List<RequestModel>>? _apiRequestMeeting;
  // APIResponse? _apiJoinMeeting;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents(widget.idUser);

    super.initState();
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  _fetchEvents(idUser) async {
    setState(() {
      _isLoading = true;
    });
    _apiRequestProfile = await meetingService.getRequestProfile(idUser);
    // print('cek user');
    // print(_apiRequestProfile
    //     ?.errorMessage); // _apiRequestMeeting = await meetingService.getRequestMeeting(idMeeting);
    setState(() {
      final String path_profile_picture =
          _apiRequestProfile?.data?.profile?.profile_picture ??
              '/profilePicture/usericon.png';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3188FA)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
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
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               title: Center(
      //                 child: Text('Logout Confirm'),
      //               ),
      //               content: Text('Apakah anda yakin akan keluar?'),
      //               // content: Container(
      //               //   child: Column(
      //               //     children: [

      //               //     ],
      //               //   ),
      //               // ),
      //               actions: <Widget>[
      //                 TextButton(
      //                   onPressed: () {
      //                     removeAccessToken(); // Close the modal
      //                   },
      //                   child: Text('Logout'),
      //                 ),
      //                 TextButton(
      //                   onPressed: () {
      //                     Navigator.of(context).pop(); // Close the modal
      //                   },
      //                   child: Text('Batal'),
      //                 ),
      //               ],
      //             );
      //           },
      //         );
      //       },
      //       icon: Icon(
      //         Icons.person,
      //         color: Color(0xFF3188FA),
      //       ),
      //       // icon: CircleAvatar(
      //       //   radius: 55.0,
      //       //   backgroundImage: ExactAssetImage('assets/masjid-nabawi-1.jpg'),
      //       // ),
      //     )
      //   ],
      //   backgroundColor: Colors.white,
      // ),
      body: Builder(
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 200,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.blueGrey,
                  //     image: DecorationImage(
                  //       image: AssetImage("assets/masjid-nabawi-1.jpg"),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
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
                              _apiRequestProfile?.data?.name ?? 'Not Found',
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
                              _apiRequestProfile?.data?.email ?? 'Not Found',
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
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _apiRequestProfile?.data?.profile?.no_hp ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _apiRequestProfile?.data?.profile?.address ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _apiRequestProfile?.data?.profile?.gender ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Job',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _apiRequestProfile?.data?.profile?.job ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Add some spacing between the icons if needed
                        InkWell(
                          onTap: () async {
                            APIResponse<RequestModel> _apiRequest =
                                await meetingService.rejectRequest(0);
                            if (_apiRequest?.errorMessage ==
                                'Berhasil Ditolak') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  // title: Text('Error'),
                                  content: Text(
                                      _apiRequest?.errorMessage ?? 'Error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFF0000),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            APIResponse<RequestModel> _apiRequest =
                                await meetingService.acceptRequest(0);
                            if (_apiRequest?.errorMessage ==
                                'Berhasil Disetujui') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  // title: Text('Error'),
                                  content: Text(
                                      _apiRequest?.errorMessage ?? 'Error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF3188FA),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF3188FA),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (_selectedIndex == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          }
        },
      ),
    );
  }
}
