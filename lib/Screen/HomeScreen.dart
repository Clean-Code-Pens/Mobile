// import 'dart:js_util';

import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:clean_code/Screen/CreateEventScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

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
      body: SingleChildScrollView(
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
                              image: AssetImage("assets/masjid-nabawi-1.jpg"),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      tabs: [
                        Tab(
                          text: "Category 1",
                        ),
                        Tab(
                          text: "Category 2",
                        ),
                        Tab(
                          text: "Category 3",
                        )
                      ],
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailEvent()));
                                  },
                                );
                              }),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
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
                                          'Expo Surabaya',
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
                                            builder: (context) =>
                                                DetailEvent()));
                                  },
                                );
                              }),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
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
                                          'Workshop IT',
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
                                            builder: (context) =>
                                                DetailEvent()));
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                                      style:
                                          TextStyle(color: Color(0xFF3188FA)),
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
                                  image:
                                      AssetImage("assets/masjid-nabawi-1.jpg"),
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
