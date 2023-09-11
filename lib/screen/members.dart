import 'package:flutter/material.dart';
import 'package:ju_contact/screen/about_department.dart';
import 'package:ju_contact/screen/batch.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/screen/person.dart';
import 'package:ju_contact/screen/show_categories.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/colors.dart';

class MemberList extends StatefulWidget {
  MemberList({Key? key, required this.departments}) : super(key: key);

  String? departments;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String? uname, uemail, udepartment;
  bool loaded = false;

  var member = [
    'Teachers Information',
    'Students Information',
    'Staffs Information',
    'About Department',
  ];

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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(
        selected: "",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              image,
              height: 150,
              width: 150,
            ),
          ),
          Notes(text: widget.departments),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.only(top: 20),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: member.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => member[index] ==
                                        "About Department"
                                    ? AboutDepartment(
                                        department: widget.departments,
                                      )
                                    : member[index] == "Students Information"
                                        ? ShowCategories(
                                            department: widget.departments,
                                          )
                                        : PersonList(
                                            info: member[index],
                                            department: widget.departments,
                                            name: uname,
                                            email: uemail,
                                          )));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.green)),
                          child: Text(
                            "${member[index]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
