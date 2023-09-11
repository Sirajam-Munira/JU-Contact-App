import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ju_contact/models/admin_model.dart';
import 'package:ju_contact/models/chairmanship.dart';
import 'package:ju_contact/screen/update_info.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/students.dart';
import '../widgets/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'nav_bar.dart';

class PersonList extends StatefulWidget {
  const PersonList({
    Key? key,
    required this.info,
    required this.department,
    required this.email,
    required this.name,
    this.batch,
  }) : super(key: key);

  final String? info, department, name, email, batch;

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  bool loaded = false, oBatch = false;
  int count = 0, nai = 0;
  String? pName, pEmail, pPhone, person, adminid, areason;

  //
  TextEditingController query = TextEditingController();
  List<StudentModel>? students, filterStudents;
  String searchText = "";

  _PersonListState() {
    query.addListener(() {
      if (query.text.isEmpty) {
        setState(() {
          searchText = "";
          filterStudents = students;
           buildList();
        });
      } else {
        setState(() {
          searchText = query.text;
          buildList();
        });
      }
    });
  }

  Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  getPerson(BuildContext context, String dep) async {
    String? persons, head;
    dep = dep.replaceAll(' ', '');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString("userID");

    if (widget.info == "Teachers Information") {
      person = "teachers";
      persons = "$url/$person/department/$dep";
      head = "$url/chairmans/department/$dep/department";
    } else if (widget.info == "Staffs Information") {
      person = "staffs";
      persons = "$url/$person/department/$dep";
      head = "$url/chairmans/department/$dep/staff";
    } else {
      person = "students";
      setState(() {
        oBatch = true;
      });
      persons = "$url/$person/department/$dep/${widget.batch}";
      head = "$url/chairmans/department/$dep/${widget.batch}";
    }

    final responsehead = await http.get(Uri.parse(head));
    if (responsehead.statusCode == 200) {
      List<ChairmanModel> chairman = (json.decode(responsehead.body) as List)
          .map((e) => ChairmanModel.fromJson(e))
          .toList();
      if (chairman[0].userid!.isNotEmpty) {
        final responseid = await http.get(Uri.parse(persons));
        if (responseid.statusCode == 200) {
          students = (json.decode(responseid.body) as List)
              .map((json) => StudentModel.fromJson(json))
              .toList();
          setState(() {
            filterStudents = students;
          });

          for (int i = 0; i < students!.length; i++) {
            if (students![i].id == chairman[0].userid) {
              count = i;
            }
          }
          if (students![0].name!.isNotEmpty) {
            setState(() {
              loaded = true;
            });
          }
        } else if (responseid.statusCode == 400) {
          const snackBar = SnackBar(content: Text("Email not registered!"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          print(responseid.statusCode);
        }
      }
    }

    String admin = "$url/admins/byid/$userid";
    final response = await http.get(Uri.parse(admin));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      AdminModel adminss = AdminModel.fromJson(map);
      adminid = adminss.adminid!;
      areason = adminss.reason!;
    }
  }

  buildList() {
    if (searchText.isNotEmpty || searchText != "") {
      List<StudentModel> tempList = [];
      for (int i = 0; i < filterStudents!.length; i++) {
        if (filterStudents![i]
            .name!
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          tempList.add(filterStudents![i]);
        }
      }
      filterStudents = tempList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPerson(context, widget.department!);
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? const SizedBox(
            height: 100, width: 100, child: CircularProgressIndicator())
        : Scaffold(
            drawer: NavBar(
              selected: person!.isNotEmpty ? person : "home",
              name: widget.name,
              department: widget.department,
              email: widget.email,
            ),
            appBar: AppsBars(
              username: widget.name!,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Notes(text: widget.info),
                  Container(
                    height: 42,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: query,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText: "Search by name"),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Center(
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width - 10,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: Image.asset(
                                image,
                                fit: BoxFit.fill,
                                height: 40,
                                width: 40,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                createDialog(context, 0);
                              },
                              onLongPress: () {
                                if (adminid != null && areason == "central") {
                                  confirmDialog(context, count);
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 120,
                                height: 60,
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Name: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          filterStudents![count].name!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Mobile: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          filterStudents![count].phone!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Email: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          filterStudents![count].email!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    String url =
                                        'tel:${filterStudents![count].phone!}';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(90),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add_call,
                                      color: secondary,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Tap to Call",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            students == null ? 0 : filterStudents!.length,
                        itemBuilder: (context, index) {
                          return Visibility(
                            visible: index == count ? false : true,
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width - 10,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: secondary),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(90),
                                    ),
                                    child: Image.asset(
                                      image,
                                      fit: BoxFit.fill,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      createDialog(context, index);
                                    },
                                    onLongPress: () {
                                      if (adminid != null &&
                                          areason == "central") {
                                        confirmDialog(context, index);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      height: 60,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Name: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                filterStudents![index].name!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Mobile: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                filterStudents![index].phone!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Email: ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                filterStudents![index].email!,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          String url =
                                              'tel:${filterStudents![index].phone!}';
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          margin: const EdgeInsets.only(top: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.add_call,
                                            color: secondary,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Tap to Call",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  createDialog(BuildContext context, int index) {
    String allInfo =
        "Name: ${filterStudents![index].name}\nEmail: ${filterStudents![index].email}\n"
        "Mobile: ${filterStudents![index].phone}\nAddress: ${filterStudents![index].address}\n"
        "Expertise: ${filterStudents![index].expertise}";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Press any button to COPY!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                allInfo,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.only(right: 24),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              InkWell(
                onTap: () async {
                  String url = filterStudents![index].email!;
                  if (await canLaunch("mailto:$url")) {
                    await launch("mailto:$url");
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  "SEND EMAIL",
                  style: TextStyle(
                    color: secondary,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: () {
                    copyToClipboard(context, filterStudents![index].email!);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "COPY EMAIL ADDRESS",
                    style: TextStyle(
                      color: secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: () {
                    copyToClipboard(context, filterStudents![index].phone!);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "COPY MOBILE NUMBER",
                    style: TextStyle(
                      color: secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: () {
                    copyToClipboard(context, allInfo);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "COPY ALL INFO",
                    style: TextStyle(
                      color: secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  confirmDialog(context, int index) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("What do you like to do?"),
            content: Text(
                "Choose one of the buttons for the user ${filterStudents![index].name}"),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: secondary),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateInfo(
                                students: filterStudents!,
                                index: count,
                                oBatch: person,
                              )));
                },
                child: Text(
                  "UPDATE",
                  style: TextStyle(color: secondary),
                ),
              ),
            ],
          );
        });
  }
}
