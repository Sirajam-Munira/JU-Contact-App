import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/students.dart';
import 'package:ju_contact/screen/batch.dart';
import 'package:ju_contact/screen/members.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/screen/person.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:ju_contact/widgets/information.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/colors.dart';

class ShowCategories extends StatefulWidget {
  ShowCategories({Key? key, required this.department}) : super(key: key);

  String? department;

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  String? id, uname, uemail, udepartment;
  List<int> batchList = [];
  bool loaded = false, loaded1 = false;

  getBatchs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uname = preferences.getString("userName");
    uemail = preferences.getString("userEmail");
    udepartment = preferences.getString("userDepartment");
    if (uname!.isNotEmpty) {
      setState(() {
        loaded = true;
      });
    }

    String urldep = "$url/students/bydepartment/${widget.department}/";
    final response = await http.get(Uri.parse(urldep));
    if (response.statusCode == 200) {
      List<StudentModel> students = (json.decode(response.body) as List)
          .map((jsons) => StudentModel.fromJson(jsons))
          .toList();
      for (int i = 0; i < students.length; i++) {
        batchList.add(int.parse(students[i].batch!));
      }
      batchList = batchList.toSet().toList();
      batchList.sort((a, b) => b.compareTo(a));
      if (batchList[0].toString().isNotEmpty) {
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
    getBatchs();
  }

  @override
  Widget build(BuildContext context) {
    return (!loaded1 && !loaded)
        ? CircularProgressIndicator()
        : Scaffold(
            drawer: NavBar(
              selected: "",
              name: uname,
              department: udepartment,
              email: uemail,
            ),
            appBar: AppsBars(
              username: uname,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Notes(
                  text: "List of Batches",
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: batchList.length,
                        itemBuilder: (context, index) {
                          return BatchList(
                            department: widget.department,
                            batch: batchList[index],
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
  }
}
