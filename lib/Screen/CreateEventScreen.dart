import 'dart:io';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/category_model.dart';
import 'package:clean_code/Models/event_models.dart';
import 'package:clean_code/Screen/DetailEventScreen.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/loginScreen.dart';
import 'package:clean_code/Services/category_service.dart';
import 'package:clean_code/Services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  int _selectedIndex = 0;
  List<String> categoryList = ['Category 1', 'Category 2', 'Category 3'];

  CategoryService get serviceCategory => GetIt.I<CategoryService>();
  APIResponse<List<CategoryModel>>? _apiCategory;
  EventService get serviceEvent => GetIt.I<EventService>();
  APIResponse<EventModel>? _apiEventCreate;

  XFile? _selectedImage;
  DateTime? selectedDateTime;
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    _fetchAPI();
    super.initState();
  }

  _fetchAPI() async {
    setState(() {
      _isLoading = true;
    });
    _apiCategory = await serviceCategory.getCategoryList();
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
  List<DropdownMenuItem<String>> category() {
    List<DropdownMenuItem<String>> tabs = [];
    int categoryLength = _apiCategory?.data?.length ?? 0;
    for (var i = 0; i < categoryLength; i++) {
      final tab = DropdownMenuItem<String>(
        value: _apiCategory?.data?[i].id.toString(),
        child: Text(_apiCategory?.data?[i].name ?? 'Not Found'),
      );
      tabs.add(tab);
    }
    // print(tabs);
    return tabs;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        // print(formattedDateTime);

        setState(() {
          selectedDateTime = combinedDateTime;
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      final formattedDate = "${dateTime.toLocal()}".split(' ')[0];
      final formattedTime =
          "${TimeOfDay.fromDateTime(dateTime).format(context)}";
      return "$formattedDate $formattedTime";
    } else {
      return "Select Date and Time";
    }
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
            onPressed: () => removeAccessToken(),
            icon: CircleAvatar(
              radius: 55.0,
              backgroundImage: ExactAssetImage('assets/masjid-nabawi-1.jpg'),
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Builder(builder: (_) {
        if (_isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create New Event',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Category'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
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
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: category(),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Select Category",
                          hintStyle: TextStyle(color: Color(0xff7A7A7A)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Create a New Event'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Enter Event Name",
                            hintStyle: TextStyle(color: Color(0xff7A7A7A))),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Location'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: locationController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Enter Location",
                            hintStyle: TextStyle(color: Color(0xff7A7A7A))),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Address'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: addressController,
                        keyboardType: TextInputType.streetAddress,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Enter Address",
                            hintStyle: TextStyle(color: Color(0xff7A7A7A))),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Date and Time'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDateTime(context);
                      },
                      child: Container(
                        width: double.infinity,
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
                          padding: EdgeInsets.all(15),
                          child: Text(
                            _formatDateTime(selectedDateTime),
                            style: TextStyle(
                              color: selectedDateTime != null
                                  ? Colors.black
                                  : Color(0xff7A7A7A),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Description'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: descriptionController,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Enter Description",
                          hintStyle: TextStyle(color: Color(0xff7A7A7A)),
                        ),
                        minLines: 3,
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Upload Image'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _selectedImage == null
                              ? Center(
                                  child: Text('Tap to select an image'),
                                )
                              : Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final location = locationController.text;
                      final address = addressController.text;
                      final description = descriptionController.text;
                      final date =
                          DateFormat('yyyy-MM-dd').format(selectedDateTime!);
                      final category = selectedCategory.toString();
                      print(_selectedImage);

                      if (name.isEmpty ||
                          location.isEmpty ||
                          address.isEmpty ||
                          date.isEmpty ||
                          category.isEmpty ||
                          // _selectedImage == XFile ||
                          description.isEmpty) {
                        final errorMessage = 'Semua field harus diisi.';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      // Lanjutkan dengan permintaan login ke server
                      _apiEventCreate = await serviceEvent.createEvent(
                          category,
                          name,
                          location,
                          address,
                          date,
                          description,
                          _selectedImage);
                      if (_apiEventCreate != null) {
                        print(_apiEventCreate?.errorMessage);
                        if (_apiEventCreate?.error == true) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  _apiEventCreate?.errorMessage ?? 'Error'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailEvent(
                                    idEvent: _apiEventCreate?.data.id ?? 0),
                              ));
                        }
                      }
                      // ...
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                    ),
                    child: Text(
                      "New Meeting",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 50),
                    ),
                  ),
                ),
                // InkWell(
                //   child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 2.0),
                //     width: double.maxFinite,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Color(0xFF3188FA),
                //     ),
                //     child: Align(
                //       alignment: Alignment.center,
                //       child: Padding(
                //         padding: EdgeInsets.only(top: 15, bottom: 15),
                //         child: Text(
                //           'Upload Event',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                //   onTap: () => print("seemore"),
                // ),
              ],
            ),
          ),
        );
      }),
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
