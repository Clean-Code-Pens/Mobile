import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<String> notifications = [
    "Notification 1",
    "Notification 2",
    "Notification 3",
    // Add more notifications as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // ListView.builder for displaying notifications as cards
              ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.blue, // Change the color as needed
                      ),
                      title: Text(
                        notifications[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
