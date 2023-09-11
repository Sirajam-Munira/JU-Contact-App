import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/students.dart';
import 'package:ju_contact/screen/person.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../widgets/colors.dart';

class BatchList extends StatefulWidget {
  BatchList({Key? key, required this.department, required this.batch})
      : super(key: key);

  String? department;
  int? batch;

  @override
  State<BatchList> createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
  String? uname, uemail, udepartment;
  bool loaded = false;

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

    String urlemail = "$url/students/byemail/$uemail";
    final response = await http.get(Uri.parse(urlemail));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      StudentModel student = StudentModel.fromJson(map);
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
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonList(
                info: "Students Information",
                department: widget.department,
                email: uemail,
                name: uname,
                batch: widget.batch.toString(),
              ),
            ));
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: bg,
              child: Icon(
                Icons.category,
                color: textcolor,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Batch ${widget.batch!}",
                style: TextStyle(
                  color: textcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textcolor,
            ),
          ],
        ),
      ),
    );
  }
}
