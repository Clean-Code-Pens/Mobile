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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMeeting extends StatefulWidget {
  // int idEvent;

  // AllMeeting({required this.idEvent});

  @override
  _AllMeetingState createState() => _AllMeetingState();
  // _AllMeetingState createState() => _AllMeetingState(this.idEvent);
}

class _AllMeetingState extends State<AllMeeting> with TickerProviderStateMixin {
  // int? idEvent;

  // _DetailEventState(id) {
  //   this.idEvent = id;
  // }
  TextEditingController keywordSearch = TextEditingController();

  int _selectedIndex = 0;

  List<MeetingModel> meetings = [];
  List<MeetingModel> filteredMeetings = [];

  MeetingService get service => GetIt.I<MeetingService>();
  APIResponse<List<MeetingModel>>? _apiMeeting;
  // APIResponse<List<EventModel>>? _apiEventSearch;

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

    final APIResponse<List<MeetingModel>> _apiMeeting =
        await service.getMeetingList();

    List<MeetingModel> data = _apiMeeting.data;
    List<MeetingModel> itemList = data.map((item) => item).toList();

    setState(() {
      meetings = itemList;
      filteredMeetings = itemList;
    });
    // _apiMeeting = await service.getMeetingList();
    // print(_apiEvent?.errorMessage);
    setState(() {
      _isLoading = false;
    });
  }

  void filterMeetings(String query) async {
    final APIResponse<List<MeetingModel>> _apiEventSearch =
        await service.searchMeeting(query);

    List<MeetingModel> data = _apiEventSearch.data;

    print('cek filter');
    print(_apiEventSearch.errorMessage);

    setState(() {
      filteredMeetings = data;
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
  List<Widget> listMeeting() {
    List<Widget> events = [];
    // int categoryLength = _apiDetailEvent != null ? _apiDetailEvent.data.length : 0;
    int meetingLength = filteredMeetings.length;
    // int meetingLength = _apiMeeting?.data?.length ?? 0;
    // print(_apiDetailEvent?.data.length);
    for (var i = 0; i < meetingLength; i++) {
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
                            image: AssetImage('assets/carousel.png'),
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
                              filteredMeetings[i].name ?? 'Not Found',
                              // _apiMeeting?.data[i]?.name ?? 'Not Found',
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
                              filteredMeetings[i].description ?? 'Not Found',
                              // _apiMeeting?.data[i]?.description ?? 'Not Found',
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
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 15,
                                    ),
                                    Text(
                                      filteredMeetings[i].user?.name ??
                                          'Not Found',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
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
                                    Row(
                                      children: [
                                        Text(
                                          filteredMeetings[i].people_need ??
                                              // _apiMeeting?.data[i]?.people_need ??
                                              '0' + ' people',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          ' people',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
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
                builder: (context) => DetailMeeting(
                  idMeeting: filteredMeetings[i].id ?? 0,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3188FA)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Meet Up',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (_) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                height: 50,
                child: TextField(
                  controller: keywordSearch,
                  onChanged: (value) {
                    filterMeetings(value);
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 16),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: "Find your meeting",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: listMeeting(),
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
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => EventScreen()));
                  },
                ),
                const SizedBox(width: 24),
                IconButton(
                  tooltip: 'My Meetings',
                  icon: const Icon(Icons.supervised_user_circle_sharp),
                  onPressed: () {
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) =>MeetingScreen()));
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
