import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailMeeting extends StatefulWidget {
  int idMeeting;

  DetailMeeting({required this.idMeeting});

  @override
  _DetailMeetingState createState() => _DetailMeetingState();
  // _DetailMeetingState createState() => _DetailMeetingState(this.idMeeting);
}

class _DetailMeetingState extends State<DetailMeeting>
    with TickerProviderStateMixin {
  // int? idMeeting;

  // _DetailEventState(id) {
  //   this.idMeeting = id;
  // }

  int _selectedIndex = 0;

  // EventService get service => GetIt.I<EventService>();
  // APIResponse<EventModel>? _apiDetailMeeting;

  MeetingService get meetingService => GetIt.I<MeetingService>();
  APIResponse<MeetingModel>? _apiDetailMeeting;
  APIResponse? _apiJoinMeeting;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents(widget.idMeeting);
    super.initState();
  }

  _fetchEvents(idMeeting) async {
    setState(() {
      _isLoading = true;
    });
    _apiDetailMeeting = await meetingService.getDetailMeeting(idMeeting);
    setState(() {
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
          'ActivityConnect',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(
                      child: Text('Logout Confirm'),
                    ),
                    content: Text('Apakah anda yakin akan keluar?'),
                    // content: Container(
                    //   child: Column(
                    //     children: [

                    //     ],
                    //   ),
                    // ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          removeAccessToken(); // Close the modal
                        },
                        child: Text('Logout'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the modal
                        },
                        child: Text('Batal'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.person,
              color: Color(0xFF3188FA),
            ),
            // icon: CircleAvatar(
            //   radius: 55.0,
            //   backgroundImage: ExactAssetImage('assets/masjid-nabawi-1.jpg'),
            // ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                      image: DecorationImage(
                        image: AssetImage("assets/masjid-nabawi-1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _apiDetailMeeting?.data?.name ?? 'Not Found',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        _apiDetailMeeting?.data?.description ?? 'Not Found'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.location_on_outlined),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _apiDetailMeeting?.data?.name ?? 'Not Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.location_on_outlined),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _apiDetailMeeting?.data?.event?.name ??
                                    'Not Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 3),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _apiDetailMeeting?.data?.event?.name ??
                                    'Not Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
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
