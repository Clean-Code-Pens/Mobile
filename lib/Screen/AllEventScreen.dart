import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
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

class AllEvent extends StatefulWidget {
  // int idEvent;

  // AllEvent({required this.idEvent});

  @override
  _AllEventState createState() => _AllEventState();
  // _AllEventState createState() => _AllEventState(this.idEvent);
}

class _AllEventState extends State<AllEvent> with TickerProviderStateMixin {
  // int? idEvent;

  // _DetailEventState(id) {
  //   this.idEvent = id;
  // }
  TextEditingController keywordSearch = TextEditingController();

  int _selectedIndex = 0;

  List<EventModel> events = [];
  List<EventModel> filteredEvents = [];

  EventService get service => GetIt.I<EventService>();

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

    final APIResponse<List<EventModel>> _apiEvent =
        await service.getEventList();

    List<EventModel> data = _apiEvent.data;
    List<EventModel> itemList = data.map((item) => item).toList();

    setState(() {
      events = itemList;
      filteredEvents = itemList;
    });
    // if (_apiEvent.error == false) {
    //   // Assuming the API returns a JSON array of items
    // } else {
    //   throw Exception('Failed to load data');
    // }
    // _apiEvent = await service.getEventList();
    // print(_apiEvent?.errorMessage);
    setState(() {
      _isLoading = false;
    });
  }

  void filterEvents(String query) async {
    final APIResponse<List<EventModel>> _apiEventSearch =
        await service.searchEvent(query);

    List<EventModel> data = _apiEventSearch.data;

    print('cek filter');
    print(_apiEventSearch.errorMessage);

    setState(() {
      filteredEvents = data;
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
    // int eventLength = _apiEvent?.data?.length ?? 0;
    int eventLength = filteredEvents.length;
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
                                filteredEvents[i].imgUrl ?? 'Not Found'),
                            // _apiEvent?.data[i]?.imgUrl ?? 'Not Found'),
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
                              filteredEvents[i].name ?? 'Not Found',
                              // _apiEvent?.data[i]?.name ?? 'Not Found',
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
                              filteredEvents[i].description ?? 'Not Found',
                              // _apiEvent?.data[i]?.description ?? 'Not Found',
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
                                  filteredEvents[i].date ?? 'Not Found',
                                  // _apiEvent?.data[i]?.date ?? 'Not Found',
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
                                      filteredEvents[i].place ?? 'Not Found',
                                      // _apiEvent?.data[i]?.place ?? 'Not Found',
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
                  idEvent: filteredEvents[i].id ?? 0,
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
          'Events',
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
                    filterEvents(value);
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
                    hintText: "Find your event",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: listEvent(),
                ),
              )
            ],
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
  //     _apiEvent = _searchEventList(text);
  //   });
  // }

  // _searchEventList(text) async {
  //   if (text != null && text.length > 0) {
  //     print(text);
  //     _apiEvent = await service.searchEvent(text);
  //     return _apiEvent?.errorMessage;
  //   } else if ((text == null || text.length == 0)) {
  //     print(text);
  //     _apiEvent = await service.getEventList();
  //     return _apiEvent;
  //   }
  // }
}
