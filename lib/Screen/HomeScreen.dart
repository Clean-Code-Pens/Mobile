// import 'dart:js_util';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/login_model.dart';
import 'package:clean_code/Models/meeting_model.dart';
import 'package:clean_code/Screen/AllEventScreen.dart';
import 'package:clean_code/Screen/AllMeetingScreen.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/DetailMeetingScreen.dart';
import 'package:clean_code/Screen/MyEventScreen.dart';
import 'package:clean_code/Screen/MyMeetingScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Services/auth_service.dart';
import 'package:clean_code/Services/category_service.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:clean_code/Services/meeting_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int limitList = 5;

  // nyeluk service e di dadekno variabel
  AuthService get serviceLogin => GetIt.I<AuthService>();
  EventService get serviceEvent => GetIt.I<EventService>();
  MeetingService get serviceMeeting => GetIt.I<MeetingService>();
  CategoryService get serviceCategory => GetIt.I<CategoryService>();

  // deklarasi variabel dinggo nyimpen return api
  // APIResponse<LoginModel>? _apiLogin;
  APIResponse<List<CategoryModel>>? _apiCategory;
  APIResponse<List<MeetingModel>>? _apiMeetingList;

  bool _isLoading = false;

  @override
  void initState() {
    _fetchEvents();
    super.initState();
  }

  _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    _apiCategory = await serviceCategory.getCategoryList();

    _apiMeetingList = await serviceMeeting.getMeetingListLimit(limitList);

    setState(() {
      _isLoading = false;
    });
  }

  int itemCountCarousel(length) {
    if (length >= limitList) {
      return length + 1;
    }
    return length;
  }

  @override
  List<Widget> tab() {
    List<Widget> tabs = [];
    // int categoryLength = _apiCategory != null ? _apiCategory.data.length : 0;
    int categoryLength = _apiCategory?.data?.length ?? 0;
    // print(_apiCategory?.data.length);
    for (var i = 0; i < categoryLength; i++) {
      final tab = Tab(
        text: _apiCategory?.data?[i].name ?? 'Not Found',
      );
      tabs.add(tab);
    }
    print(tabs);
    return tabs;
  }

  @override
  List<Widget> tabChild() {
    List<Widget> childs = [];
    // int categoryLength = _apiCategory != null ? _apiCategory.data.length : 0;
    int categoryLength = _apiCategory?.data?.length ?? 0;
    // print(_apiCategory?.data.length);
    for (var i = 0; i < categoryLength; i++) {
      // final tab = Widget(key: ,)
      // final apiEventList = await serviceEvent.getEventCategoryListLimit(
      //     _apiCategory?.data[i]?.id ?? 0, 3);
      // ;
      // print("==============");
      // print(apiEventList);
      final tab = eventCategoryList(_apiCategory?.data?[i].id ?? 0);
      childs.add(tab);
      // final tab = eventCategoryList(apiEventList);
    }
    return childs;
  }

  @override
  Widget eventCategoryList(idCategory) {
    return Scaffold(
      body: FutureBuilder<APIResponse<List<EventModel>>>(
        future: serviceEvent.getEventCategoryListLimit(idCategory, limitList),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, display a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data?.data == null) {
            // If there's no data, display a message
            return Text('No data available');
          } else {
            // Data is available, build your UI using the snapshot.data
            List<EventModel> eventList = snapshot.data!.data!;
            int eventCategoryLength = eventList.length;

            final eventCategory = Container(
              width: double.maxFinite,
              height: 100,
              child: ListView.builder(
                  itemCount: itemCountCarousel(eventCategoryLength),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    if (index == limitList) {
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                size: 25,
                                color: Color(0xFF3188FA),
                              ),
                              Text(
                                'See More',
                                style: TextStyle(color: Color(0xFF3188FA)),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllEvent(),
                              ));
                        },
                      );
                    }
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                                eventList[index].imgUrl ?? 'Not Found'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              eventList[index].name ?? 'Not Found',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailEvent(
                                idEvent: eventList[index].id ?? 0,
                              ),
                            ));
                      },
                    );
                  }),
            );
            return eventCategory;
          }
        },
      ),
    );
  }

  // @override
  // List<Widget> eventCategoryList() {
  //   List<Widget> eventsCategory = [];
  //   int categoryLength = _apiCategory?.data?.length ?? 0;
  //   // print(categoryLength);
  //   for (var i = 0; i < categoryLength; i++) {
  //     int eventCategoryLength = _apiEventCategoryList?[i].data?.length ?? 0;
  //     final eventCategory = Container(
  //       width: double.maxFinite,
  //       height: 100,
  //       child: ListView.builder(
  //           itemCount: itemCountCarousel(eventCategoryLength),
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (_, index) {
  //             if (index == 3) {
  //               return InkWell(
  //                 child: Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 2.0),
  //                   width: 100,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.white,
  //                   ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         Icons.arrow_circle_right_outlined,
  //                         size: 25,
  //                         color: Color(0xFF3188FA),
  //                       ),
  //                       Text(
  //                         'See More',
  //                         style: TextStyle(color: Color(0xFF3188FA)),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 onTap: () => print("seemore"),
  //               );
  //             }
  //             return InkWell(
  //               child: Container(
  //                 margin: EdgeInsets.symmetric(horizontal: 2.0),
  //                 width: 100,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.white,
  //                   image: DecorationImage(
  //                     image: NetworkImage(
  //                         _apiEventCategoryList?[i].data[index]?.imgUrl ??
  //                             'Not Found'),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 child: Padding(
  //                   padding: EdgeInsets.all(5.0),
  //                   child: Align(
  //                     alignment: Alignment.bottomLeft,
  //                     child: Text(
  //                       _apiEventCategoryList?[i].data[index]?.name ??
  //                           'Not Found',
  //                       // child: Text(
  //                       //   _apiEventList
  //                       //           ?.data[index]?.name ??
  //                       //       'Not Found',
  //                       style: TextStyle(
  //                         fontSize: 12.0,
  //                         // fontFamily: "Explora",
  //                         color: Colors.white,
  //                         // fontWeight: FontWeight.w900),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               onTap: () {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => DetailEvent(
  //                         idEvent:
  //                             _apiEventCategoryList?[i].data[index]?.id ?? 0,
  //                       ),
  //                     ));
  //               },
  //             );
  //           }),
  //     );
  //     eventsCategory.add(eventCategory);
  //   }
  //   print(eventsCategory);
  //   return eventsCategory;
  // }

  @override
  Widget meetings() {
    int meetingLength = _apiMeetingList?.data?.length ?? 0;
    return Container(
      width: double.maxFinite,
      height: 100,
      child: ListView.builder(
          itemCount: itemCountCarousel(meetingLength),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            if (index == limitList) {
              return InkWell(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 25,
                        color: Color(0xFF3188FA),
                      ),
                      Text(
                        'See More',
                        style: TextStyle(color: Color(0xFF3188FA)),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllMeeting(),
                      ));
                },
              );
            }
            return InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/carousel.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      _apiMeetingList?.data?[index].name ?? 'Not Found',
                      style: TextStyle(
                        fontSize: 12.0,
                        // fontFamily: "Explora",
                        color: Colors.white,
                        // fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMeeting(
                        idMeeting: _apiMeetingList?.data?[index].id ?? 0,
                      ),
                    ));
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController =
        TabController(length: _apiCategory?.data?.length ?? 0, vsync: this);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ActivityConnect',
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
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    // height: 200.0,
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(
                      seconds: 1,
                    ),
                  ),
                  items: [1, 2, 3, 4, 5].map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/hero.png"),
                                  fit: BoxFit.cover,
                                ),
                                // borderRadius: BorderRadius.only(
                                //   bottomLeft: Radius.circular(40),
                                //   bottomRight: Radius.circular(40),
                                // ),
                                color: Color(0xFF3188FA)),
                            // child: Center(
                            //   child: Text(
                            //     'text $i',
                            //     style: TextStyle(fontSize: 16.0),
                            //   ),
                            // ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Event',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.maxFinite,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: tab(),
                          // [
                          //   Tab(
                          //     text: 'sdawd',
                          //   ),
                          //   Tab(
                          //     text: 'sdawd',
                          //   ),
                          //   Tab(
                          //     text: 'sdawd',
                          //   ),
                          // ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 100,
                        child: TabBarView(
                          controller: _tabController,
                          children: tabChild(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Meetings',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      meetings(),
                    ],
                  ),
                ),
              ],
            ),
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
