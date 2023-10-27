import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_code/Screen/CreateMeetingScreen.dart';

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
    print(_apiDetailEvent?.data.place);
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
                      color: Colors.amber,
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
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sursjdbawdnjw dawd qkwdb abayadiasdiuasidaisdb',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
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
                              builder: (context) => CreateMeeting()));
                    },
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
                          subtitle: Text(
                              'Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                      ],
                    ),
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
        },
      ),
    );
  }
}
