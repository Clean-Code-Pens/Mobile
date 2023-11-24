import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/DetailMeetingScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:clean_code/Services/profile_service.dart';
import 'package:clean_code/models/notif_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  // int idEvent;

  // Notification({required this.idEvent});

  @override
  _NotificationState createState() => _NotificationState();
  // _NotificationState createState() => _NotificationState(this.idEvent);
}

class _NotificationState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  // int? idEvent;

  // _DetailEventState(id) {
  //   this.idEvent = id;
  // }

  int _selectedIndex = 0;

  ProfileService get serviceProfile => GetIt.I<ProfileService>();
  APIResponse<List<NotifModel>>? _apiNotif;

  @override
  void initState() {
    _fetchAPI();
    super.initState();
  }

  _fetchAPI() async {
    // setState(() {
    //   _isLoading = true;
    // });
    _apiNotif = await serviceProfile.getNotif();
    print('cek notif');
    print(_apiNotif?.data.length);
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
  List<Widget> listNotif() {
    List<Widget> events = [];
    int meetingLength = _apiNotif?.data?.length ?? 0;
    for (var i = 0; i < meetingLength; i++) {
      final event = Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(
            Icons.info_outline,
            color: Colors.blue, // Change the color as needed
          ),
          title: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_apiNotif?.data?[i].description ?? '',
                      style: TextStyle(fontSize: 12)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_apiNotif?.data?[i].date ?? '',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      );
      events.add(event);
    }
    print(events);
    return events;
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
          'Notification',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (_) {
          return Container(
            margin: EdgeInsets.all(10),
            child:
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: _apiNotif?.data?.length ?? 0,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Card(
                //       elevation: 3,
                //       margin: EdgeInsets.symmetric(vertical: 8),
                //       child: ListTile(
                //         leading: Icon(
                //           Icons.info_outline,
                //           color: Colors.blue, // Change the color as needed
                //         ),
                //         title: Container(
                //           child: Column(
                //             children: [
                //               Align(
                //                 alignment: Alignment.centerLeft,
                //                 child: Text(
                //                     _apiNotif?.data?[index].description ?? '',
                //                     style: TextStyle(fontSize: 12)),
                //               ),
                //               Align(
                //                 alignment: Alignment.centerLeft,
                //                 child: Text(_apiNotif?.data?[index].date ?? '',
                //                     style: TextStyle(fontSize: 12)),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                ListView(
              children: listNotif(),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateEvent()));
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   color: Theme.of(context).colorScheme.primary,
      //   child: IconTheme(
      //     data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: <Widget>[
      //           IconButton(
      //             tooltip: 'Home',
      //             icon: const Icon(Icons.home),
      //             onPressed: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => HomeScreen()));
      //             },
      //           ),
      //           IconButton(
      //             tooltip: 'My Events',
      //             icon: const Icon(Icons.event_available),
      //             onPressed: () {
      //               // Navigator.push(
      //               //     context, MaterialPageRoute(builder: (context) => EventScreen()));
      //             },
      //           ),
      //           const SizedBox(width: 24),
      //           IconButton(
      //             tooltip: 'My Meetings',
      //             icon: const Icon(Icons.supervised_user_circle_sharp),
      //             onPressed: () {
      //               // Navigator.push(
      //               //     context, MaterialPageRoute(builder: (context) =>MeetingScreen()));
      //             },
      //           ),
      //           IconButton(
      //             tooltip: 'Profile',
      //             icon: const Icon(Icons.person_rounded),
      //             onPressed: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => ProfileScreen()));
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  // void updateButtonState(String text) {
  //   // if text field has a value and button is inactive
  //   setState(() {
  //     _apiMeeting = _searchEventList(text);
  //   });
  // }

  // _searchEventList(text) async {
  //   // if (text != null && text.length > 0) {
  //   //   print(text);
  //   //   _apiMeeting = await service.searchEvent(text);
  //   //   return _apiMeeting?.errorMessage;
  //   // } else if ((text == null || text.length == 0)) {
  //   //   print(text);
  //   //   _apiMeeting = await service.getEventList();
  //   //   return _apiMeeting;
  //   // }
  // }
}

class EventMeeting {}
