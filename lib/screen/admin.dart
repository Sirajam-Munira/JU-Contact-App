import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/admin_model.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/registration_model.dart';
import '../models/students.dart';
import 'add_info.dart';

class Admins extends StatefulWidget {
  const Admins({Key? key}) : super(key: key);

  @override
  State<Admins> createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  String? uname, uemail, udepartment, reason, uid;
  List<String> totalInfo = [];
  bool loaded = false, loaded1 = false, visible = false;
  List<AdminModel>? admin;

  getInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString("userID");
    uname = preferences.getString("userName");
    uemail = preferences.getString("userEmail");
    udepartment = preferences.getString("userDepartment");
    if (uname!.isNotEmpty) {
      setState(() {
        loaded = true;
      });
    }
  }

  getAdmins() async {
    String urladmin = "$url/admins/";
    final responseid = await http.get(Uri.parse(urladmin));
    if (responseid.statusCode == 200) {
      admin = (json.decode(responseid.body) as List)
          .map((json) => AdminModel.fromJson(json))
          .toList();
      for (int i = 0; i < admin!.length; i++) {
        if (admin![i].reason == "central") {
          if(admin![i].adminid==uid){
            setState(() {
              visible = true;
            });
          }
          String users =
              "$url/users/byid/${admin![i].adminid}";
          final responseuser = await http.get(Uri.parse(users));
          if (responseuser.statusCode == 200) {
            Map<String, dynamic> map = jsonDecode(responseuser.body);
            RegistrationModel registration = RegistrationModel.fromJson(map);
            String aEmail = registration.email!;
            String names = "$url/students/byemail/$aEmail";
            final responsemail = await http.get(Uri.parse(names));
            if (responsemail.statusCode == 200) {
              Map<String, dynamic> map1 = jsonDecode(responsemail.body);
              StudentModel student = StudentModel.fromJson(map1);
              totalInfo.add(
                  "Name: ${student.name!}\nEmail: ${student.email!}\nMobile: ${student.phone!}");
            }
          }
        }
      }
      if (totalInfo[totalInfo.length - 1].isNotEmpty) {
        setState(() {
          loaded1 = true;
        });
      }
    } else if (responseid.statusCode == 400) {
      const snackBar = SnackBar(content: Text("Email not registered!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print(responseid.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
    getAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        selected: "admin",
        name: loaded ? uname : "loading..",
        department: loaded ? udepartment : "loading..",
        email: loaded ? uemail : "loading..",
      ),
      appBar: AppsBars(
        username: loaded ? uname : "loading..",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Notes(text: "Admin Information"),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: totalInfo.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: secondary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        loaded1 ? totalInfo[index] : "loading..",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Visibility(
            visible: visible,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddInfo()));
              },
              child: Center(
                child: Container(
                  height: 30,
                  width: 100,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Add User",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
