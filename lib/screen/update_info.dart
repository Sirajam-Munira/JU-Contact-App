import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ju_contact/widgets/update_tfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/students.dart';
import '../widgets/appbar.dart';
import '../widgets/colors.dart';
import '../widgets/notes.dart';
import '../widgets/text_fields.dart';

class UpdateInfo extends StatefulWidget {
  UpdateInfo({
    Key? key,
    required this.students,
    required this.index,
    required this.oBatch,
  }) : super(key: key);

  List<StudentModel>? students;
  int? index;
  String? oBatch;

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController expertise = TextEditingController();
  TextEditingController batch = TextEditingController();

  bool loaded = false, opacity = false;
  String? mobile, uname;

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uname = preferences.getString("userName");
    if(uname!.isNotEmpty){
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
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
          Notes(text: "Update User Info"),
          UpdateTextField(
              text: widget.students![widget.index!].name,
              controller: name,
              type: TextInputType.name,
              hintText: "Enter Name"),
          UpdateTextField(
              text: widget.students![widget.index!].email,
              controller: email,
              type: TextInputType.emailAddress,
              hintText: "Enter Email"),
          UpdateTextField(
              text: widget.students![widget.index!].phone,
              controller: phone,
              type: TextInputType.phone,
              hintText: "Enter Mobile Number"),
          UpdateTextField(
              text: widget.students![widget.index!].department!,
              controller: department,
              type: TextInputType.text,
              hintText: "Enter Department"),
          UpdateTextField(
              text: widget.students![widget.index!].address!,
              controller: address,
              type: TextInputType.text,
              hintText: "Enter Address"),
          UpdateTextField(
              text: widget.students![widget.index!].expertise!,
              controller: expertise,
              type: TextInputType.text,
              hintText: widget.oBatch == "students"
                  ? "Expertises(separated by comma)"
                  : "Designation"),
          Visibility(
            visible: true,
            child: UpdateTextField(
                text: widget.students![widget.index!].batch!.toString(),
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
                onTap: () async {
                  if (name.text.isEmpty) {
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
                      content: widget.oBatch == "students"
                          ? Text('Expertises Required')
                          : Text("Designation Required"),
                    ));
                  } else {
                    String update =
                        "$url/${widget.oBatch!.trim()}/${email.text.toString().trim()}";

                    await http
                        .put(Uri.parse(update),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, dynamic>{
                              'name': name.text.toString().trim(),
                              'email': email.text.toString().trim(),
                              'phone': phone.text.toString().trim(),
                              'department': department.text.toString().trim(),
                              'address': address.text.toString().trim(),
                              'expertise': expertise.text.toString().trim(),
                              'batch': batch.text.toString().trim(),
                            }))
                        .then((value) {
                      // name.clear();
                      // email.clear();
                      // phone.clear();
                      // department.clear();
                      // address.clear();
                      // expertise.clear();
                      // batch.clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User updated Successfully'),
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
