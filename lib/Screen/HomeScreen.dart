// import 'dart:js_util';

import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Models/login_model.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Services/auth_service.dart';
import 'package:clean_code/Services/category_service.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // nyeluk service e di dadekno variabel
  AuthService get serviceLogin => GetIt.I<AuthService>();
  EventService get serviceEvent => GetIt.I<EventService>();
  CategoryService get serviceCategory => GetIt.I<CategoryService>();

  // deklarasi variabel dinggo nyimpen return api
  APIResponse<LoginModel>? _apiLogin;
  APIResponse<List<CategoryModel>>? _apiCategory;
  APIResponse<List<EventModel>>? _apiEventList;
  List<APIResponse<List<EventModel>>>? _apiEventCategoryList;

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

    // Login Consume =============================
    // Nde main.dart enek ndaftarne service
    // terus mari didaftarne nde halaman nyeluk service e di dadekno variabel
    // terus deklarasi variabel dinggo nyimpen return api
    // mari ngunu diceluk nde kene njalanke api
    // hasil e wes sesuai variabel sing dingge nyimpen data.
    // file file sing digunakno Service/auth_service.dart, Models/login_model.dart

    _apiLogin = await serviceLogin.login();

    print(_apiLogin?.data?.access_token);
    //============================================

    _apiCategory = await serviceCategory.getCategoryList();

    // int? categoryLength = _apiCategory?.data.length;
    // List idsCategory = [];
    // for (var i = 0; i < categoryLength!; i++) {
    //   idsCategory.add(_apiCategory?.data?[i].id);
    // }
    // _apiEventCategoryList =
    //     await serviceEvent.getEventCategoryListLimit(idsCategory);

    _apiEventList = await serviceEvent.getEventListLimit(3);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  List<Widget> kategori() {
    List<Widget> tabs = [];
    for (var i = 0; i < 3; i++) {
      final tab = Tab(
        text: _apiCategory?.data[i]?.name ?? 'Not Found',
      );
      tabs.add(tab);
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ActivityConnect',
          style: TextStyle(color: Color(0xFF3188FA)),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => print("image clicked"),
            icon: CircleAvatar(
              radius: 55.0,
              backgroundImage: ExactAssetImage('assets/masjid-nabawi-1.jpg'),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (_) {
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
                                  image:
                                      AssetImage("assets/masjid-nabawi-1.jpg"),
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
                          tabs: kategori(),
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
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 100,
                              child: ListView.builder(
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    if (index == 3) {
                                      return InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                size: 25,
                                                color: Color(0xFF3188FA),
                                              ),
                                              Text(
                                                'See More',
                                                style: TextStyle(
                                                    color: Color(0xFF3188FA)),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () => print("seemore"),
                                      );
                                    }
                                    return InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(_apiEventList
                                                    ?.data[index]?.imgUrl ??
                                                'Not Found'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              _apiEventList
                                                      ?.data[index]?.name ??
                                                  'Not Found',
                                              // child: Text(
                                              //   _apiEventList
                                              //           ?.data[index]?.name ??
                                              //       'Not Found',
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
                                              builder: (context) => DetailEvent(
                                                idEvent: _apiEventList
                                                        ?.data[index]?.id ??
                                                    0,
                                              ),
                                            ));
                                      },
                                    );
                                  }),
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 100,
                              child: ListView.builder(
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    if (index == 3) {
                                      return InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                size: 25,
                                                color: Color(0xFF3188FA),
                                              ),
                                              Text(
                                                'See More',
                                                style: TextStyle(
                                                    color: Color(0xFF3188FA)),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () => print("seemore"),
                                      );
                                    }
                                    return InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(_apiEventList
                                                    ?.data[index]?.imgUrl ??
                                                'Not Found'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              _apiEventList
                                                      ?.data[index]?.name ??
                                                  'Not Found',
                                              // child: Text(
                                              //   _apiEventList
                                              //           ?.data[index]?.name ??
                                              //       'Not Found',
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
                                              builder: (context) => DetailEvent(
                                                idEvent: _apiEventList
                                                        ?.data[index]?.id ??
                                                    0,
                                              ),
                                            ));
                                      },
                                    );
                                  }),
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 100,
                              child: ListView.builder(
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    if (index == 3) {
                                      return InkWell(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                size: 25,
                                                color: Color(0xFF3188FA),
                                              ),
                                              Text(
                                                'See More',
                                                style: TextStyle(
                                                    color: Color(0xFF3188FA)),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () => print("seemore"),
                                      );
                                    }
                                    return InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(_apiEventList
                                                    ?.data[index]?.imgUrl ??
                                                'Not Found'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              _apiEventList
                                                      ?.data[index]?.name ??
                                                  'Not Found',
                                              // child: Text(
                                              //   _apiEventList
                                              //           ?.data[index]?.name ??
                                              //       'Not Found',
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
                                              builder: (context) => DetailEvent(
                                                idEvent: _apiEventList
                                                        ?.data[index]?.id ??
                                                    0,
                                              ),
                                            ));
                                      },
                                    );
                                  }),
                            ),
                          ],
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
                      Container(
                        width: double.maxFinite,
                        height: 100,
                        child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              if (index == 5 - 1) {
                                return InkWell(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_circle_right_outlined,
                                          size: 25,
                                          color: Color(0xFF3188FA),
                                        ),
                                        Text(
                                          'See More',
                                          style: TextStyle(
                                              color: Color(0xFF3188FA)),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () => print("seemore"),
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
                                      image: AssetImage(
                                          "assets/masjid-nabawi-1.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: const Text(
                                        'Konser Noah',
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
                                onTap: () => print("jnad"),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Color(0xFF3188FA),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateEvent()));
        },
        child: Icon(Icons.add),
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
        },
      ),
    );
  }
}