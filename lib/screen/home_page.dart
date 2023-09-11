import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/faculties.dart';
import 'package:ju_contact/models/info.dart';
import 'package:ju_contact/screen/administration.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/students.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? id, uname, uemail, udepartment;
  bool loaded = false, loaded1 = false;

  List<Information> categories = [];
  List<String> faculties = [];

  _HomePageState() {
    categories.add(Information(
      category: "Your Department",
      icons: Icons.person,
    ));
    categories.add(Information(
      category: "Administration",
      icons: Icons.admin_panel_settings_outlined,
    ));
    categories.add(Information(
      category: "Departments",
      icons: Icons.school_outlined,
    ));
    // categories.add(Information(
    //   category: "Institutes",
    //   icons: Icons.cast_for_education_outlined,
    // ));
    categories.add(Information(
      category: "Center",
      icons: Icons.person,
    ));
    categories.add(Information(
      category: "Office",
      icons: Icons.person,
    ));
    categories.add(Information(
      category: "Accommodation",
      icons: Icons.person,
    ));
    categories.add(Information(
      category: "Library",
      icons: Icons.person,
    ));
  }

  // getId() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   id = preferences.getString("userID");
  //   String url = "http://192.168.0.11:3000/users/byid/" + id!;
  //   final responseid = await http.get(Uri.parse(url));
  //   if (responseid.statusCode == 200) {
  //     Map<String, dynamic> map = jsonDecode(responseid.body);
  //     RegistrationModel model = RegistrationModel.fromJson(map);
  //     String email =
  //         "http://192.168.0.11:3000/students/byemail/" + model.email!;
  //     final responsemail = await http.get(Uri.parse(email));
  //     if (responsemail.statusCode == 200) {
  //       Map<String, dynamic> map1 = jsonDecode(responsemail.body);
  //       StudentModel student = StudentModel.fromJson(map1);
  //     } else {
  //       print(responsemail.statusCode);
  //     }
  //   } else if (responseid.statusCode == 400) {
  //     const snackBar = SnackBar(content: Text("Email not registered!"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     print(responseid.statusCode);
  //   }
  // }

  getInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uname = preferences.getString("userName");
    uemail = preferences.getString("userEmail");
    udepartment = preferences.getString("userDepartment");
    if (uname!.isNotEmpty) {
      setState(() {
        loaded = true;
      });
    }

    String department = "$url/students/";
    final response = await http.get(Uri.parse(department));
    if (response.statusCode == 200) {
      List<StudentModel> students = (json.decode(response.body) as List)
          .map((jsons) => StudentModel.fromJson(jsons))
          .toList();
      for (int i = 0; i < students.length; i++) {
        if (students[i].department != null) {
          faculties.add(students[i].department!.trim());
          faculties = faculties.toSet().toList();
        }
      }
      if (faculties[0].isNotEmpty) {
        setState(() {
          loaded1 = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavBar(
          selected: "home",
          name: loaded ? uname : "loading..",
          department: loaded ? udepartment : "loading..",
          email: loaded ? uemail : "loading..",
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: textcolor),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loaded ? uname! : "loading..",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                "Welcome To Jagangirnagar University",
                style: TextStyle(fontSize: 12, color: textcolor),
              )
            ],
          ),
        ),
        body: (!loaded && !loaded1)
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        image,
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 150,
                      width: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return categories[index].category == "Departments"
                                ? InformationLayout(
                                    text: categories[index].category,
                                    icons: categories[index].icons,
                                    departments: faculties,
                                  )
                                : InformationLayout(
                                    text: categories[index].category,
                                    icons: categories[index].icons,
                                  );
                          }),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
