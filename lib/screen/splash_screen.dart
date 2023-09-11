import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/screen/administration.dart';
import 'package:ju_contact/screen/home_page.dart';
import 'package:ju_contact/screen/login.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/registration_model.dart';
import '../models/students.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  bool isLogged = false;
  String? names, department, emails;

  getId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString("userID") != null) {
      isLogged = true;
      String? id = preferences.getString("userID");
      String urlid = "$url/users/byid/" + id!;
      final responseid = await http.get(Uri.parse(urlid));
      if (responseid.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(responseid.body);
        RegistrationModel model = RegistrationModel.fromJson(map);
        String email = "$url/students/byemail/" + model.email!;
        final responsemail = await http.get(Uri.parse(email));
        if (responsemail.statusCode == 200) {
          Map<String, dynamic> map1 = jsonDecode(responsemail.body);
          StudentModel student = StudentModel.fromJson(map1);
          names = student.name!;
          department = student.department!;
          emails = student.email!;
        } else {
          print(responsemail.statusCode);
        }
      } else if (responseid.statusCode == 400) {
        const snackBar = SnackBar(content: Text("Email not registered!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print(responseid.statusCode);
      }
    } else {
      isLogged = false;
    }
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getId();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => isLogged ? HomePage() : Login()));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 100),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Container(
              height: 20.0,
              width: MediaQuery.of(context).size.width / 1.5,
              child: LinearProgressIndicator(
                backgroundColor: primary,
                color: secondary,
                value: controller.value,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 20),
              child: Image.asset(image)),
          Text(
            "Jahangirnagar University Contact App",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
