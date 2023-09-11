import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ju_contact/models/students.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:ju_contact/widgets/text_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddInfo extends StatefulWidget {
  AddInfo({Key? key}) : super(key: key);

  @override
  State<AddInfo> createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController expertise = TextEditingController();
  TextEditingController batch = TextEditingController();

  String? chosen, uname;
  bool opacity = false, oBatch = false, loaded = false;

  getInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uname = preferences.getString("userName");
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
      appBar: AppsBars(
        username: loaded ? uname : "loading..",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Notes(text: "Add User Info"),
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
                    if (chosen == "students") {
                      oBatch = true;
                    } else {
                      oBatch = false;
                    }
                  });
                },
              ),
            ),
          ),
          TextFields(
              controller: name,
              type: TextInputType.name,
              hintText: "Enter Name"),
          TextFields(
              controller: email,
              type: TextInputType.emailAddress,
              hintText: "Enter Email"),
          TextFields(
              controller: phone,
              type: TextInputType.phone,
              hintText: "Enter Mobile Number"),
          TextFields(
              controller: department,
              type: TextInputType.text,
              hintText: "Enter Department"),
          TextFields(
              controller: address,
              type: TextInputType.text,
              hintText: "Enter Address"),
          TextFields(
              controller: expertise,
              type: TextInputType.text,
              hintText:
                  oBatch ? "Expertises(separated by comma)" : "Designation"),
          Visibility(
            visible: oBatch,
            child: TextFields(
                controller: batch,
                type: TextInputType.number,
                hintText: "Enter Batch(Numbers only)"),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (opacity) {
                        opacity = false;
                      } else {
                        opacity = true;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: opacity,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("julogo.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: InkWell(
                onTap: () {
                  if (chosen == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Choose User Type'),
                    ));
                  } else if (name.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Name Required'),
                    ));
                  } else if (email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Email Required'),
                    ));
                  } else if (phone.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Mobile Required'),
                    ));
                  } else if (department.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Department Required'),
                    ));
                  } else if (address.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Address Required'),
                    ));
                  } else if (expertise.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: oBatch
                          ? Text('Expertises Required')
                          : Text("Designation Required"),
                    ));
                  } else {
                    String url = "http://192.168.0.11:3000/${chosen!.trim()}";
                    StudentModel student = StudentModel(
                      name: name.text.toString().trim(),
                      email: email.text.toString().trim(),
                      phone: phone.text.toString().trim(),
                      department: department.text.toString().trim(),
                      address: address.text.toString().trim(),
                      expertise: expertise.text.toString().trim(),
                      batch: batch.text.toString().trim(),
                    );

                    http
                        .post(Uri.parse(url),
                            headers: {
                              "Content-type": "application/json;charset=UTF-8"
                            },
                            body: jsonEncode(student))
                        .then((value) {
                      name.clear();
                      email.clear();
                      phone.clear();
                      department.clear();
                      address.clear();
                      expertise.clear();
                      batch.clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User Added Successfully'),
                      ));
                    });
                  }
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
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
