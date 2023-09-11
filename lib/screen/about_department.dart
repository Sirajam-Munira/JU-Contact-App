import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ju_contact/models/admin_model.dart';
import 'package:ju_contact/models/department_model.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AboutDepartment extends StatefulWidget {
  const AboutDepartment({Key? key, required this.department}) : super(key: key);

  final String? department;

  @override
  State<AboutDepartment> createState() => _AboutDepartmentState();
}

class _AboutDepartmentState extends State<AboutDepartment> {
  String? aboutDep, uname, uemail, udepartment;
  bool loaded = false;

  getAbout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uname = preferences.getString("userName");
    uemail = preferences.getString("userEmail");
    udepartment = preferences.getString("userDepartment");

    String about = "$url/departments/department/${widget.department!.trim()}";
    print(about);
    final response = await http.get(Uri.parse(about));
    if (response.statusCode == 200) {
      print(response.body);
      List<DepartmentModel> department = (json.decode(response.body) as List)
          .map((jsons) => DepartmentModel.fromJson(jsons))
          .toList();
      aboutDep = department[0].about!;
      if (aboutDep!.isNotEmpty && uname!.isNotEmpty) {
        setState(() {
          loaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        selected: widget.department == "JU" ? "about" : "",
        name: loaded ? uname : "loading..",
        department: loaded ? udepartment : "loading..",
        email: loaded ? uemail : "loading..",
      ),
      appBar: AppsBars(
        username: loaded ? uname : "loading..",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                image,
                height: 150,
                width: 150,
              ),
            ),
            Notes(
              text: "About ${widget.department}",
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  loaded ? aboutDep! : "loading..",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
