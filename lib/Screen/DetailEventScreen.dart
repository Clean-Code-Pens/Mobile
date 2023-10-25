import 'package:clean_code/models/api_response.dart';
import 'package:clean_code/models/event_models.dart';
import 'package:clean_code/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class DetailEvent extends StatefulWidget {
  @override
  _DetailEventState createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<EventModel> event = [];

  EventService get service => GetIt.instance<EventService>();

  late APIResponse<List<EventModel>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getEventList();
    print(_apiResponse.errorMessage);
    setState(() {
      _isLoading = false;
    });
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
                  color: Colors.amber,
                  image: DecorationImage(
                    image: AssetImage("assets/masjid-nabawi-1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_apiResponse.data[0].name),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Surabaya'),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text('Sursjdbawdnjw dawd qkwdb abaya fhghfgghgj'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Surabaya'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sursjdbawdnjw dawd qkwdb abaya'),
                      ),
                    ],
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Wednesday, October 18, 2023'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sursjdbawdnjw dawd qkwdb abaya'),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_apiResponse.data[0].description),
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
                onTap: () => print("seemore"),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.album),
                      title: Text('The Enchanted Nightingale'),
                      subtitle:
                          Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
