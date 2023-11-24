import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/MyMeetingScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/Notification1Screen.dart.txt';
import 'package:clean_code/Screen/notificationScreen.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEvent extends StatefulWidget {
  // int idEvent;

  // MyEvent({required this.idEvent});

  @override
  _MyEventState createState() => _MyEventState();
  // _MyEventState createState() => _MyEventState(this.idEvent);
}

class _MyEventState extends State<MyEvent> with TickerProviderStateMixin {
  // int? idEvent;

  // _DetailEventState(id) {
  //   this.idEvent = id;
  // }
  TextEditingController keywordSearch = TextEditingController();

  int _selectedIndex = 0;

  EventService get service => GetIt.I<EventService>();
  APIResponse<List<EventModel>>? _apiEvent;
  APIResponse<List<EventModel>>? _apiEventSearch;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents();
    // _fetchEvents(widget.idEvent);
    super.initState();
  }

  _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    _apiEvent = await service.getMyEventList();
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
  List<Widget> listEvent() {
    List<Widget> events = [];
    // int categoryLength = _apiDetailEvent != null ? _apiDetailEvent.data.length : 0;
    int eventLength = _apiEvent?.data?.length ?? 0;
    // print(_apiDetailEvent?.data.length);
    for (var i = 0; i < eventLength; i++) {
      // Container(
      //   margin: EdgeInsets.symmetric(horizontal: 5.0)
      // )
      final event = InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                                _apiEvent?.data?[i].imgUrl ?? 'Not Found'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _apiEvent?.data?[i].name ?? 'Not Found',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _apiEvent?.data?[i].description ?? 'Not Found',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  _apiEvent?.data?[i].date ?? 'Not Found',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                Text(
                                  ' - ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _apiEvent?.data?[i].place ?? 'Not Found',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(children: <Widget>[
                    Expanded(child: Divider()),
                  ]),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailEvent(
                  idEvent: _apiEvent?.data?[i].id ?? 0,
                ),
              ));
        },
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
        centerTitle: true,
        title: Text(
          'My Event',
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
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Color(0xFF3188FA)),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     'My Event',
      //     style: TextStyle(color: Color(0xFF3188FA)),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: Builder(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: listEvent(),
                ),
              )
            ],
          );
        },
      ),
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
