import 'dart:convert';

import 'package:clean_code/Screen/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart%20';

class RegisterScreen extends StatefulWidget{
  @override
  _RegisterScreenState createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen>{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _isRegistering = false;
  bool _registrationSuccess = false;


  void registerUser() async {
    setState(() {
      _isRegistering = true;
      _registrationSuccess = false;
    });

    var url = "https://activity-connect.projectdira.my.id/public/api/auth/register";
    var data = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text
    };
    var bodyy = json.encode(data);
    var urlParse = Uri.parse(url);

    try {
      Response response = await http.post(
          urlParse,
          body: bodyy,
          headers: {
            "Content-Type": "application/json"
          }
      );

      if (response.statusCode == 201) {
        // Registrasi berhasil
        var dataa = jsonDecode(response.body);
        setState(() {
          _registrationSuccess = true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Registration successful: ${dataa['message']}"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 422) {
        // Error: Registrasi gagal
        var dataa = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Registration failed: ${dataa['message']}"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0, //
                decoration: BoxDecoration(
                  color: Color(0xfff2f3f7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
              ),
              _buildContainer(),
              if (_isRegistering) CircularProgressIndicator(), // Tampilkan loading jika sedang registrasi
              if (_registrationSuccess) Text("Registration successful!"), // Tampilkan pesan berhasil setelah registrasi
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Name",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 14),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: 50,
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16),
              prefixIcon: Icon(Icons.person, color: Colors.grey),
              hintText: "Name",
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 14),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: 50,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16),
              prefixIcon: Icon(Icons.person, color: Colors.grey),
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }



  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 14),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: passwordController, // Tambahkan ini
                  obscureText: _obscureText,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Confirm Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 14),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: confirmPasswordController, // Tambahkan ini
                  obscureText: _obscureText,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (passwordController.text == confirmPasswordController.text) {
           registerUser();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Password does not match."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(5),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
        ),
        child: Text(
          "Register",
          style: TextStyle(fontSize: MediaQuery.of(context).size.height / 50),
        ),
      ),
    );
  }

  // Widget _buildOr() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Container(
  //         child: Text(
  //           '- Or Register With -',
  //           style: TextStyle(
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget _buildGoogleButton() {
  //   return Container(
  //       padding: EdgeInsets.symmetric(vertical: 10),
  //       width: double.infinity,
  //       child: ElevatedButton(
  //         onPressed: () => print("Google Pressed"),
  //         style: ButtonStyle(
  //           elevation: MaterialStateProperty.all(5),
  //           shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           )),
  //           backgroundColor: MaterialStateProperty.all(Colors.white),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               'assets/google.png',
  //               height: 24,
  //               width: 24,
  //             ),
  //             SizedBox(width: 8),
  //             Text(
  //               "Continue With Google",
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: MediaQuery.of(context).size.height / 50,
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //   );
  // }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(),
          child: TextButton(
            onPressed: () {
              // Navigasi ke halaman login
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Already have an Account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 50,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Register",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildName(),
                      SizedBox(height: 10),
                      _buildEmail(),
                      SizedBox(height: 10),
                      _buildPassword(),
                      SizedBox(height: 10),
                      _buildConfirmPassword(),
                      SizedBox(height: 10),
                      _buildRegisterButton(),
                      // _buildOr(),
                      // _buildGoogleButton(),
                      _buildSignUpBtn(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}

