import 'dart:math';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/meeting_model.dart';
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
  APIResponse<List<RequestModel>>? _apiRequestMeeting;
  APIResponse? _apiJoinMeeting;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents(widget.idMeeting);

    super.initState();
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  _fetchEvents(idMeeting) async {
    setState(() {
      _isLoading = true;
    });
    _apiDetailMeeting = await meetingService.getDetailMeeting(idMeeting);
    _apiRequestMeeting = await meetingService.getRequestMeeting(idMeeting);
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

  List<Widget> listRequest() {
    List<Widget> requests = [];
    if (_apiDetailMeeting?.data?.ownership == 'mine') {
      List<Widget> requests = [];
      // List<Widget> requests = [];
      int requestLength = _apiRequestMeeting?.data?.length ?? 0;
      // print(_apiRequestMeeting?.data.length);
      for (var i = 0; i < requestLength; i++) {
        int id_meeting = _apiDetailMeeting?.data?.id ?? 0;
        final request = Container(
          margin: EdgeInsets.symmetric(vertical: 5),
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
            child: InkWell(
              onTap: () {
                // print('cek');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestProfile(
                        idUser: _apiRequestMeeting?.data?[i].user?.id ?? 0,
                        idMeeting: _apiDetailMeeting?.data?.id ?? 0,
                      ),
                    ));
              },
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blueGrey,
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/masjid-nabawi-1.jpg"),
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
                                    _apiRequestMeeting?.data?[i].user?.name ??
                                        'Not Found',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Align(
                    //     alignment: Alignment
                    //         .centerRight, // Set alignment to center right
                    //     child: Row(
                    //       children: [
                    //         InkWell(
                    //           onTap: () {},
                    //           child: Icon(Icons.check),
                    //         ),
                    //         InkWell(
                    //           onTap: () {},
                    //           child: Icon(Icons.close),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   // Rest of your code...
                    // )
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              APIResponse<RequestModel> _apiRequest =
                                  await meetingService.acceptRequest(
                                      _apiRequestMeeting?.data?[i].id ?? 0);
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
                            child: Icon(Icons.check),
                          ),
                          SizedBox(
                              width:
                                  8), // Add some spacing between the icons if needed
                          InkWell(
                            onTap: () async {
                              APIResponse<RequestModel> _apiRequest =
                                  await meetingService.rejectRequest(
                                      _apiRequestMeeting?.data?[i].id ?? 0);
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
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        requests.add(request);
      }
      return requests;
    }
    return requests;
    // setState(() {
    //   requests = button();
    // });
    // return requests;
  }

  @override
  Widget button() {
    // Widget buttons = ;
    if (_apiDetailMeeting?.data?.ownership != 'mine') {
      return Column(
        children: [
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
                  .joinMeet(_apiDetailMeeting?.data?.id.toString() ?? '0');
              if (_apiJoinMeeting != null) {
                if (_apiJoinMeeting?.error == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(_apiJoinMeeting?.errorMessage ?? 'Error'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                      content: Text('Berhasil request join meeting'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFFF0000),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Report Meeting',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            onTap: () async {
              _apiJoinMeeting = await meetingService
                  .reportMeet(_apiDetailMeeting?.data?.id.toString() ?? '0');
              if (_apiJoinMeeting != null) {
                if (_apiJoinMeeting?.error == true) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(_apiJoinMeeting?.errorMessage ?? 'Error'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                      content: Text('Berhasil report meeting'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          )
        ],
      );
      // buttons.add(button);
    } else {
      return InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFFF0000),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'End Meeting',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        onTap: () async {
          _apiJoinMeeting = await meetingService
              .joinMeet(_apiDetailMeeting?.data?.id.toString() ?? '0');
          if (_apiJoinMeeting != null) {
            if (_apiJoinMeeting?.error == true) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(_apiJoinMeeting?.errorMessage ?? 'Error'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
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
                  content: Text('Berhasil request join meeting'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        },
      );
    }
    // return buttons;
  }

  // @override
  // List<Widget> listRequest(requestJoin) {
  //   List<Widget> meetings = [];
  //   // int categoryLength = requestJoin != null ? requestJoin.data.length : 0;
  //   int meetingLength = requestJoin?.data?.length ?? 0;
  //   // print(requestJoin?.data.length);
  //   for (var i = 0; i < meetingLength; i++) {
  //     int id_meeting = requestJoin?.data?.meetings?[i].id ?? 0;
  //     final meeting = Column(
  //       children: [
  //         InkWell(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.all(Radius.circular(10)),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 2,
  //                   blurRadius: 3,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.all(10),
  //               child: Container(
  //                 child: Row(
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Padding(
  //                         padding: EdgeInsets.only(right: 8),
  //                         child: Column(
  //                           children: [
  //                             Icon(Icons.person),
  //                             Text(
  //                               requestJoin?.data?.meetings?[i].user?.name ??
  //                                   'Not Found',
  //                               style: TextStyle(fontSize: 10),
  //                             )
  //                           ],
  //                         ),
  //                         // child: Icon(Icons.person),
  //                       ),
  //                     ),
  //                     Expanded(
  //                         child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.centerLeft,
  //                           child: Text(
  //                             requestJoin?.data?.meetings?[i].name ??
  //                                 'Not Found',
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                         Align(
  //                           alignment: Alignment.centerLeft,
  //                           child: Row(
  //                             children: [
  //                               Align(
  //                                 alignment: Alignment.centerLeft,
  //                                 child: Padding(
  //                                   padding: EdgeInsets.only(right: 8),
  //                                   child: Icon(
  //                                     Icons.people,
  //                                     size: 15,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Text(requestJoin
  //                                       ?.data?.meetings?[i].people_need ??
  //                                   'Not Found')
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => DetailMeeting(
  //                     idMeeting: requestJoin?.data?.meetings?[i].id ?? 0,
  //                   ),
  //                 ));
  //           },
  //         ),
  //         SizedBox(
  //           height: 8,
  //         )
  //       ],
  //     );
  //     meetings.add(meeting);
  //   }
  //   print(meetings);
  //   return meetings;
  //   // return ;
  // }

  @override
  Widget owner() {
    Widget owner = Container();
    if (_apiDetailMeeting?.data?.ownership != 'mine') {
      owner = Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blueGrey,
                image: DecorationImage(
                  image: AssetImage("assets/masjid-nabawi-1.jpg"),
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
                    _apiDetailMeeting?.data?.user?.name ?? 'Not Found',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return owner;
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
                  owner(),
                  // Row(
                  //   children: [
                  //     Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Container(
                  //         margin: EdgeInsets.only(right: 10),
                  //         width: 40,
                  //         height: 40,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(40),
                  //           color: Colors.blueGrey,
                  //           image: DecorationImage(
                  //             image: AssetImage("assets/masjid-nabawi-1.jpg"),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Align(
                  //             alignment: Alignment.centerLeft,
                  //             child: Text(
                  //               _apiDetailMeeting?.data?.user?.name ??
                  //                   'Not Found',
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 15,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(Icons.person),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    _apiDetailMeeting?.data?.people_need ??
                                        'Not Found',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    ' people',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              // Text(
                              //   _apiDetailMeeting?.data?.people_need ??
                              //       'Not Found' + ' person',
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: TextStyle(fontWeight: FontWeight.w400),
                              // ),
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
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(Icons.event_available),
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
                  // SizedBox(height: 3),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Color.fromRGBO(255, 0, 0, 0),
                          ),
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
                                _apiDetailMeeting?.data?.event?.description ??
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.location_on_outlined,
                            // color: Colors.white,
                          ),
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
                                _apiDetailMeeting?.data?.event?.place ??
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
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.alarm,
                            // color: Colors.white,
                          ),
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
                                _apiDetailMeeting?.data?.event?.date ??
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
                  // Container(
                  //   width: double.maxFinite,
                  //   height: double.maxFinite,
                  //   child: Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: InkWell(
                  //       child: Container(
                  //         margin: EdgeInsets.symmetric(horizontal: 2.0),
                  //         width: double.maxFinite,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Color(0xFF3188FA),
                  //         ),
                  //         child: Align(
                  //           alignment: Alignment.center,
                  //           child: Padding(
                  //             padding: EdgeInsets.only(top: 10, bottom: 10),
                  //             child: Text(
                  //               'New Meeting',
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => CreateMeeting(
                  //                     idEvent:
                  //                         _apiDetailMeeting?.data?.event?.id ??
                  //                             0)));
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(margin: EdgeInsets.only(top: 20), child: button()
                      // Column(
                      //   children: [
                      //     InkWell(
                      //       child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 2.0),
                      //         width: double.maxFinite,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Color(0xFF3188FA),
                      //         ),
                      //         child: Align(
                      //           alignment: Alignment.center,
                      //           child: Padding(
                      //             padding: EdgeInsets.only(top: 10, bottom: 10),
                      //             child: Text(
                      //               'Join',
                      //               style: TextStyle(color: Colors.white),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       onTap: () async {
                      //         _apiJoinMeeting = await meetingService.joinMeet(
                      //             _apiDetailMeeting?.data?.id.toString() ?? '0');
                      //         if (_apiJoinMeeting != null) {
                      //           if (_apiJoinMeeting?.error == true) {
                      //             showDialog(
                      //               context: context,
                      //               builder: (context) => AlertDialog(
                      //                 title: Text('Error'),
                      //                 content: Text(
                      //                     _apiJoinMeeting?.errorMessage ??
                      //                         'Error'),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () =>
                      //                         Navigator.of(context).pop(),
                      //                     child: Text('OK'),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           } else {
                      //             showDialog(
                      //               context: context,
                      //               builder: (context) => AlertDialog(
                      //                 title: Text('Success'),
                      //                 content:
                      //                     Text('Berhasil request join meeting'),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () =>
                      //                         Navigator.of(context).pop(),
                      //                     child: Text('OK'),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           }
                      //         }
                      //       },
                      //     ),
                      //     SizedBox(
                      //       height: 8,
                      //     ),
                      //     InkWell(
                      //       child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 2.0),
                      //         width: double.maxFinite,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Color(0xFFFF0000),
                      //         ),
                      //         child: Align(
                      //           alignment: Alignment.center,
                      //           child: Padding(
                      //             padding: EdgeInsets.only(top: 10, bottom: 10),
                      //             child: Text(
                      //               'Report Meeting',
                      //               style: TextStyle(color: Colors.white),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       onTap: () async {
                      //         _apiJoinMeeting = await meetingService.reportMeet(
                      //             _apiDetailMeeting?.data?.id.toString() ?? '0');
                      //         if (_apiJoinMeeting != null) {
                      //           if (_apiJoinMeeting?.error == true) {
                      //             showDialog(
                      //               context: context,
                      //               builder: (context) => AlertDialog(
                      //                 title: Text('Error'),
                      //                 content: Text(
                      //                     _apiJoinMeeting?.errorMessage ??
                      //                         'Error'),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () =>
                      //                         Navigator.of(context).pop(),
                      //                     child: Text('OK'),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           } else {
                      //             showDialog(
                      //               context: context,
                      //               builder: (context) => AlertDialog(
                      //                 title: Text('Success'),
                      //                 content: Text('Berhasil report meeting'),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () =>
                      //                         Navigator.of(context).pop(),
                      //                     child: Text('OK'),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           }
                      //         }
                      //       },
                      //     )
                      //   ],
                      // ),
                      ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: listRequest(),
                  ),
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
