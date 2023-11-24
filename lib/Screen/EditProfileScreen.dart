import 'dart:convert';
import 'dart:io';

import 'package:clean_code/Constants/app_url.dart';
import 'package:clean_code/Models/api_response.dart';
import 'package:clean_code/Models/user_model.dart';
import 'package:clean_code/Screen/HomeScreen.dart';
import 'package:clean_code/Screen/ProfileScreen.dart';
import 'package:clean_code/Services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart%20';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  List<String> genderList = ['Male', 'Female'];
  int _selectedIndex = 0;
  XFile? _selectedImage;
  String? selectedGender;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController noHpController = TextEditingController();

  ProfileService get serviceProfile => GetIt.I<ProfileService>();
  APIResponse<UserModel>? _apiProfile;

  bool _isLoading = false;
  String profile_picture = '';

  @override
  void initState() {
    _fetchAPI();
    super.initState();
  }

  String capitalize(String? input) {
    if (input == null || input.isEmpty) {
      return input!;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  _fetchAPI() async {
    setState(() {
      _isLoading = true;
    });
    _apiProfile = await serviceProfile.getDetailProfile();
    setState(() {
      nameController =
          TextEditingController(text: _apiProfile?.data?.name ?? '');
      emailController =
          TextEditingController(text: _apiProfile?.data?.email ?? '');
      addressController = TextEditingController(
          text: _apiProfile?.data?.profile?.address ?? '');
      genderController =
          TextEditingController(text: _apiProfile?.data?.profile?.gender ?? '');
      jobController =
          TextEditingController(text: _apiProfile?.data?.profile?.job ?? '');
      noHpController =
          TextEditingController(text: _apiProfile?.data?.profile?.no_hp ?? '');
      final String path_profile_picture =
          _apiProfile?.data?.profile?.profile_picture ?? 'notfound';
      profile_picture = AppUrl.baseurl + path_profile_picture;
      selectedGender = capitalize(_apiProfile?.data?.profile?.gender);
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = image;
    });
  }

  @override
  List<DropdownMenuItem<String>> gender() {
    List<DropdownMenuItem<String>> tabs = [];
    int genderLength = genderList.length ?? 0;
    for (var i = 0; i < genderLength; i++) {
      final tab = DropdownMenuItem<String>(
        value: genderList[i],
        child: Text(genderList[i]),
      );
      tabs.add(tab);
    }
    // print(tabs);
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
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
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _selectedImage == null
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Colors.blueGrey,
                                image: DecorationImage(
                                  image: NetworkImage(profile_picture),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                      Positioned(
                        bottom:
                            8, // Adjust this value to move the icon up or down
                        right:
                            8, // Adjust this value to move the icon left or right
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // GestureDetector(
                  //   onTap: _pickImage,
                  //   child: Stack(
                  //     alignment: Alignment.bottomRight,
                  //     children: [
                  //       ClipOval(
                  //         child: Container(
                  //           width: 150,
                  //           height: 150,
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey[200],
                  //             border: Border.all(color: Colors.grey),
                  //           ),
                  //           child: Center(
                  //             child: _selectedImage == null
                  //                 ? Container(
                  //                     margin: EdgeInsets.only(right: 10),
                  //                     width: 300,
                  //                     height: 300,
                  //                     decoration: BoxDecoration(
                  //                       borderRadius:
                  //                           BorderRadius.circular(300),
                  //                       color: Colors.blueGrey,
                  //                       image: DecorationImage(
                  //                         image: NetworkImage(profile_picture),
                  //                         fit: BoxFit.cover,
                  //                       ),
                  //                     ),
                  //                   )
                  //                 : ClipOval(
                  //                     child: Image.file(
                  //                       File(_selectedImage!.path),
                  //                       fit: BoxFit.cover,
                  //                       width: 150,
                  //                       height: 150,
                  //                     ),
                  //                   ),
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         bottom:
                  //             8, // Adjust this value to move the icon up or down
                  //         right:
                  //             8, // Adjust this value to move the icon left or right
                  //         child: GestureDetector(
                  //           onTap: _pickImage,
                  //           child: Container(
                  //             padding: EdgeInsets.all(4),
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Colors.white,
                  //             ),
                  //             child: Icon(
                  //               Icons.edit,
                  //               size: 20,
                  //               color: Colors.grey[800],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Name'),
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
                          hintText: _apiProfile?.data?.name ?? "Enter Name",
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
                    child: Text('Email'),
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
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: _apiProfile?.data?.email ?? "Enter Email",
                        hintStyle: TextStyle(color: Color(0xff7A7A7A)),
                        enabled: false,
                      ),
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
                    child: Text('Phone Number'),
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
                      controller: noHpController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: _apiProfile?.data?.profile?.no_hp ??
                              "Enter Phone Number",
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
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText: _apiProfile?.data?.profile?.address ??
                              "Enter Address",
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
                    child: Text('Gender'),
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
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      onChanged: (String? newValue) {
                        setState(() {
                          final value = newValue;
                          selectedGender = value!;
                        });
                      },
                      items: gender(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Select Gender",
                        hintStyle: TextStyle(color: Color(0xff7A7A7A)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
              // Column(
              //   children: [
              //     Align(
              //       alignment: Alignment.centerLeft,
              //       child: Text('Gender'),
              //     ),
              //     SizedBox(
              //       height: 10,
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.all(Radius.circular(10)),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey.withOpacity(0.5),
              //             spreadRadius: 2,
              //             blurRadius: 3,
              //             offset: Offset(0, 3), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       child: DropdownButtonFormField<String>(
              //         value: selectedGender,
              //         items: ["Male", "Female"].map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         onChanged: (String? value) {
              //           setState(() {
              //             selectedGender =
              //                 value ?? "Male"; // Default to Male if null
              //           });
              //         },
              //         style: TextStyle(color: Colors.black),
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(10),
              //           hintText: "Select Gender",
              //           hintStyle: TextStyle(color: Color(0xff7A7A7A)),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 15,
              //     )
              //   ],
              // ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Job'),
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
                      controller: jobController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          hintText:
                              _apiProfile?.data?.profile?.job ?? "Enter Job",
                          hintStyle: TextStyle(color: Color(0xff7A7A7A))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
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
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  // print('cek edit');
                  final name = nameController.text;
                  final address = addressController.text;
                  final gender = selectedGender?.toLowerCase();
                  final job = jobController.text;
                  final noHp = noHpController.text;

                  print('Type of the variable: ${gender.runtimeType}');
                  print('Value of the variable: ${gender}');
                  // DateTime selectedDate =
                  //     selectedDateTime ?? DateTime(1970, 1, 1);
                  // final date = DateFormat('yyyy-MM-dd')
                  //     .format(selectedDateTime ?? DateTime(1970, 1, 1));
                  // final category = selectedCategory.toString();
                  // print(_selectedImage);

                  // if (name.isEmpty ||
                  //     location.isEmpty ||
                  //     address.isEmpty ||
                  //     date.isEmpty ||
                  //     category.isEmpty ||
                  //     // _selectedImage == XFile ||
                  //     description.isEmpty) {
                  //   final errorMessage = 'Semua field harus diisi.';
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) => AlertDialog(
                  //       title: Text('Error'),
                  //       content: Text(errorMessage),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () => Navigator.of(context).pop(),
                  //           child: Text('OK'),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  //   return;
                  // }

                  // Lanjutkan dengan permintaan login ke server
                  if (_selectedImage != null) {
                    APIResponse<UserModel> _apiChangeProfilePicture =
                        await serviceProfile
                            .changeProfilePicture(_selectedImage);
                    if (_apiChangeProfilePicture != null) {
                      print(_apiChangeProfilePicture?.errorMessage);
                      if (_apiChangeProfilePicture?.error == true) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                _apiChangeProfilePicture?.errorMessage ??
                                    'Error'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        setState(() {
                          nameController = TextEditingController(
                              text: _apiChangeProfilePicture?.data?.name ?? '');
                          emailController = TextEditingController(
                              text:
                                  _apiChangeProfilePicture?.data?.email ?? '');
                          addressController = TextEditingController(
                              text: _apiChangeProfilePicture
                                      ?.data?.profile?.address ??
                                  '');
                          genderController = TextEditingController(
                              text: _apiChangeProfilePicture
                                      ?.data?.profile?.gender ??
                                  '');
                          jobController = TextEditingController(
                              text: _apiChangeProfilePicture
                                      ?.data?.profile?.job ??
                                  '');
                          noHpController = TextEditingController(
                              text: _apiChangeProfilePicture
                                      ?.data?.profile?.no_hp ??
                                  '');
                          final String path_profile_picture =
                              _apiChangeProfilePicture
                                      ?.data?.profile?.profile_picture ??
                                  'notfound';
                          profile_picture =
                              AppUrl.baseurl + path_profile_picture;
                          _selectedImage = null;
                        });
                      }
                    }
                  }
                  APIResponse<UserModel> _apiUpdateProfile =
                      await serviceProfile.updateProfile(
                          name, address, gender, job, noHp);
                  if (_apiUpdateProfile != null) {
                    print(_apiUpdateProfile?.errorMessage);
                    if (_apiUpdateProfile?.error == true) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content:
                              Text(_apiUpdateProfile?.errorMessage ?? 'Error'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        nameController = TextEditingController(
                            text: _apiUpdateProfile?.data?.name ?? '');
                        emailController = TextEditingController(
                            text: _apiUpdateProfile?.data?.email ?? '');
                        addressController = TextEditingController(
                            text: _apiUpdateProfile?.data?.profile?.address ??
                                '');
                        genderController = TextEditingController(
                            text:
                                _apiUpdateProfile?.data?.profile?.gender ?? '');
                        jobController = TextEditingController(
                            text: _apiUpdateProfile?.data?.profile?.job ?? '');
                        noHpController = TextEditingController(
                            text:
                                _apiUpdateProfile?.data?.profile?.no_hp ?? '');
                        final String path_profile_picture =
                            _apiUpdateProfile?.data?.profile?.profile_picture ??
                                'notfound';
                        profile_picture = AppUrl.baseurl + path_profile_picture;
                        _selectedImage = null;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Success'),
                          content: Text('Profile berhasil diupdate'),
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
                  // ...
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
