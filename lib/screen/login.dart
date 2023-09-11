import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/registration_model.dart';
import 'package:ju_contact/screen/home_page.dart';
import 'package:ju_contact/screen/register.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/texts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/students.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  addId(String id, String name, String email, String department) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userID", id);
    preferences.setString("userEmail", email);
    preferences.setString("userName", name);
    preferences.setString("userDepartment", department);
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? sEmail, sPassword;
  bool isVisible = true;

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
                  text: "Login First",
                  size: 14,
                  color: Colors.white,
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
                          if (email.text.isEmpty) {
                            const snackBar =
                                SnackBar(content: Text("Email Required!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else if (password.text.isEmpty) {
                            const snackBar =
                                SnackBar(content: Text("Password Required!"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            loginServer(email.text, password.text);
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
                          text: "Sign In",
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Texts(
                        text: "Forget Password",
                        size: 14,
                        color: primary,
                      ),
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
                      text: "Don't have any account?",
                      size: 14,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary,
                          ),
                          child: Texts(
                            text: "Register",
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

  loginServer(String email, String pass) async {
    String urlemail = "$url/users/byemail/$email";
    final response = await http.get(Uri.parse(urlemail));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        RegistrationModel model = RegistrationModel.fromJson(map);
        if (model.password == pass) {
          String email =
              "$url/students/byemail/${model.email!}";
          final responsemail = await http.get(Uri.parse(email));
          if (responsemail.statusCode == 200) {
            Map<String, dynamic> map1 = jsonDecode(responsemail.body);
            StudentModel student = StudentModel.fromJson(map1);
            addId(model.id!, student.name!, student.email!, student.department!);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            print(responsemail.statusCode);
          }
        } else {
          final snackBar = SnackBar(
            content: Text("Password is not correct!"),
            backgroundColor: primary,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else if (response.statusCode == 400) {
        const snackBar = SnackBar(content: Text("Email not registered!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on Exception catch (e) {
      // TODO
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
