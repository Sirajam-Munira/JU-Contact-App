import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/registration_model.dart';
import 'package:ju_contact/models/students.dart';
import 'package:ju_contact/models/token.dart';
import 'package:ju_contact/screen/login.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/texts.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  String? sEmail, sPassword, chosen;
  bool isVisible = true, oBatch = false;

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: Image.asset(image),
            ),
            Center(
              child: Texts(
                text: "Jahangirnagar University",
                size: 24,
                color: secondary,
                weight: FontWeight.w700,
              ),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 3,
              margin: EdgeInsets.only(top: 15, bottom: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Texts(
                  text: "Register",
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: chosen,
                  focusColor: Colors.transparent,
                  style: TextStyle(color: Colors.black),
                  items: <String>[
                    'teachers',
                    'students',
                    'staffs',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  hint: Text(
                    "Select User Type",
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: 16,
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      chosen = value;
                      // if (chosen == "students") {
                      //   oBatch = true;
                      // } else {
                      //   oBatch = false;
                      // }
                    });
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black26,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    hintText: "Enter Mobile Number",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black26,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: password,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black26,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: screen / 6),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          try {
                            if (email.text.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text("Email Required!"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (phone.text.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text("Mobile Required!"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (phone.text.length != 11) {
                              const snackBar = SnackBar(
                                  content: Text("Mobile must be 11 digits!"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (password.text.isEmpty) {
                              const snackBar =
                                  SnackBar(content: Text("Password Required!"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              updateToServer(
                                  email.text, phone.text, password.text);
                              email.clear();
                              phone.clear();
                              password.clear();
                            }
                          } on Exception catch (e) {
                            // TODO
                            print(e.toString());
                          }
                        });
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            )),
                        child: Texts(
                          text: "Sign Up",
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Texts(
                      text: "Already have an account?",
                      size: 14,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary,
                          ),
                          child: Texts(
                            text: "Sign In",
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateToServer(email, phone, password) {
    String login = "$url/users/login/";
    String token = "$url/token/";
    String id = "$url/users/byemail/$email";
    String verify = "$url/$chosen/byemail/$email";
    RegistrationModel model = RegistrationModel(
      email: email,
      phone: phone,
      password: password,
    );

    try {
      http.get(Uri.parse(verify)).then((value) {
        Map<String, dynamic> map = jsonDecode(value.body);
        StudentModel student = StudentModel.fromJson(map);
        if (value.statusCode == 200 && student.phone == phone) {
          http
              .post(Uri.parse(login),
                  headers: {"Content-type": "application/json;charset=UTF-8"},
                  body: jsonEncode(model))
              .then((value) async {
            var access = jsonDecode(value.body);
            var response = await http.get(Uri.parse(id));
            Map<String, dynamic> map = jsonDecode(response.body);
            RegistrationModel model2 = RegistrationModel.fromJson(map);

            TokenModel tokens = TokenModel(
              userid: model2.id,
              token: access["access_token"],
            );

            http.post(Uri.parse(token),
                headers: {"Content-type": "application/json;charset=UTF-8"},
                body: jsonEncode(tokens));
          });

          const snackBar = SnackBar(content: Text("Successful! Please Login!"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {}
      });
    } on Exception catch (e) {
      // TODO
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
