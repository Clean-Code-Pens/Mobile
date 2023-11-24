import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailEvent extends StatefulWidget {
  int idEvent;

  DetailEvent({required this.idEvent});

  @override
  _DetailEventState createState() => _DetailEventState();
  // _DetailEventState createState() => _DetailEventState(this.idEvent);
}

class _DetailEventState extends State<DetailEvent>
    with TickerProviderStateMixin {
  // int? idEvent;

  // _DetailEventState(id) {
  //   this.idEvent = id;
  // }

  int _selectedIndex = 0;

  EventService get service => GetIt.I<EventService>();
  APIResponse<EventModel>? _apiDetailEvent;

  MeetingService get meetingService => GetIt.I<MeetingService>();
  APIResponse<MeetingModel>? _apiDetailMeeting;
  APIResponse? _apiJoinMeeting;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents(widget.idEvent);
    super.initState();
  }

  _fetchEvents(idEvent) async {
    setState(() {
      _isLoading = true;
    });
    _apiDetailEvent = await service.getDetailEvent(idEvent);
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
  List<Widget> listMeeting() {
    List<Widget> meetings = [];
    // int categoryLength = _apiDetailEvent != null ? _apiDetailEvent.data.length : 0;
    int meetingLength = _apiDetailEvent?.data?.meetings?.length ?? 0;
    // print(_apiDetailEvent?.data.length);
    for (var i = 0; i < meetingLength; i++) {
      int id_meeting = _apiDetailEvent?.data?.meetings?[i].id ?? 0;
      final meeting = Column(
        children: [
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              Icon(Icons.person),
                              Text(
                                _apiDetailEvent
                                        ?.data?.meetings?[i].user?.name ??
                                    'Not Found',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          // child: Icon(Icons.person),
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
                              _apiDetailEvent?.data?.meetings?[i].name ??
                                  'Not Found',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.people,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Text(_apiDetailEvent
                                        ?.data?.meetings?[i].people_need ??
                                    'Not Found')
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            onTap: () async {
              _apiDetailMeeting =
                  await meetingService.getDetailMeeting(id_meeting);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(
                      child: Text(_apiDetailEvent?.data?.meetings?[i].name ??
                          'Not Found'),
                    ),
                    // content: Text('Ajukan pertemuan'),
                    content: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.person),
                                    // child: Icon(Icons.person),
                                  ),
                                ),
                                Text(_apiDetailEvent
                                        ?.data?.meetings?[i].user?.name ??
                                    'Not Found')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.people,
                                      size: 15,
                                    ),
                                    // child: Icon(Icons.person),
                                  ),
                                ),
                                Text(
                                    '${_apiDetailEvent?.data?.meetings?[i].people_need ?? '0'} orang')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _apiDetailEvent
                                        ?.data?.meetings?[i].description ??
                                    '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF3188FA),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    'Join',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              _apiJoinMeeting = await meetingService
                                  .joinMeet(id_meeting.toString());
                              if (_apiJoinMeeting != null) {
                                if (_apiJoinMeeting?.error == true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          _apiJoinMeeting?.errorMessage ??
                                              'Error'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Success'),
                                      content:
                                          Text('Berhasil request join meeting'),
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
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Center()
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop(); // Close the modal
                      //   },
                      //   child: Text('Iya'),
                      // ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(
            height: 8,
          )
        ],
      );
      meetings.add(meeting);
    }
    print(meetings);
    return meetings;
    // return ;
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
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Color(0xFF3188FA),
            ),
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
                        image: NetworkImage(
                            _apiDetailEvent?.data?.imgUrl ?? 'Not Found'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_apiDetailEvent?.data?.name ?? 'Not Found'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.location_on_outlined),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _apiDetailEvent?.data?.place ?? 'Not Found',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              _apiDetailEvent?.data?.address ?? 'Not Found',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.access_time_outlined),
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
                              _apiDetailEvent?.data?.date ?? 'Not Found',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     'Sursjdbawdnjw dawd qkwdb abayadiasdiuasidaisdb',
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // )
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    // child: Text('Deskripsi'),
                    child:
                        Text(_apiDetailEvent?.data?.description ?? 'Not Found'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF3188FA),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'New Meeting',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateMeeting(
                                  idEvent: _apiDetailEvent?.data?.id ?? 0)));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: listMeeting(),
                  ),
                  // InkWell(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           spreadRadius: 2,
                  //           blurRadius: 3,
                  //           offset: Offset(0, 3),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Padding(
                  //       padding: EdgeInsets.all(10),
                  //       child: Container(
                  //         child: Row(
                  //           children: [
                  //             Align(
                  //               alignment: Alignment.centerLeft,
                  //               child: Padding(
                  //                 padding: EdgeInsets.only(right: 8),
                  //                 child: Icon(Icons.access_time_outlined),
                  //               ),
                  //             ),
                  //             Expanded(
                  //                 child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Align(
                  //                   alignment: Alignment.centerLeft,
                  //                   child: Text(
                  //                     _apiDetailEvent?.data?.date ??
                  //                         'Not Found',
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 Align(
                  //                   alignment: Alignment.centerLeft,
                  //                   child: Text(
                  //                     'Sursjdbawdnjw dawd qkwdb abayadiasdiuasidaisdb',
                  //                     maxLines: 1,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 )
                  //               ],
                  //             ))
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Center(
                  //             child: Text('Modal Title'),
                  //           ),
                  //           content: Text('Ajukan pertemuan'),
                  //           // content: Container(
                  //           //   child: Column(
                  //           //     children: [

                  //           //     ],
                  //           //   ),
                  //           // ),
                  //           actions: <Widget>[
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context)
                  //                     .pop(); // Close the modal
                  //               },
                  //               child: Text('Iya'),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
          );
        },
      ),
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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
