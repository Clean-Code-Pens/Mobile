import 'package:clean_code/Screen/CreateEventScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Screen/EditProfileScreen.dart';
import 'package:clean_code/Screen/ChangePasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  Future<void> removeAccessToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
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
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/carousel.png"),
                ),
                SizedBox(height: 10),
                Text('Named', style: TextStyle(fontSize: 20)),
                Text('Named', style: TextStyle(fontSize: 15)),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => EditProfile()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      side: BorderSide.none,
                      shape: StadiumBorder(),
                    ),
                    child: Text("Edit Profile", style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      side: BorderSide.none,
                      shape: StadiumBorder(),
                    ),
                    child: Text("Change Password", style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text('Logout Confirm'),
                            ),
                            content: Text('Apakah anda yakin akan keluar?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  removeAccessToken(context); // Close the modal
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      side: BorderSide.none,
                      shape: StadiumBorder(),
                    ),
                    child: Text("Logout", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
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
