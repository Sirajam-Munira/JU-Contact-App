import 'package:flutter/material.dart';
import 'package:ju_contact/screen/add_info.dart';
import 'package:ju_contact/screen/home_page.dart';
import 'package:ju_contact/screen/login.dart';
import 'package:ju_contact/screen/members.dart';
import 'package:ju_contact/screen/person.dart';
import 'package:ju_contact/screen/register.dart';
import 'package:ju_contact/screen/show_categories.dart';
import 'package:ju_contact/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JU Contact',
      home: SplashScreen(),
      //home: AddInfo(),
      //home: HomePage(),
    );
  }
}
