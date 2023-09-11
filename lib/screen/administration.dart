import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ju_contact/models/students.dart';
import 'package:ju_contact/screen/nav_bar.dart';
import 'package:ju_contact/screen/update_info.dart';
import 'package:ju_contact/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/admin_model.dart';
import '../widgets/colors.dart';

class Administration extends StatefulWidget {
  Administration({Key? key, required this.department}) : super(key: key);

  String? department;

  @override
  State<Administration> createState() => _AdministrationState();
}

class _AdministrationState extends State<Administration> {
  TextEditingController query = TextEditingController();
  List<StudentModel>? admins, filterAdmins;
  String? adminid, areason, uname, uemail, udepartment;
  String searchText = "";
  bool loaded = false;

  _AdministrationState() {
    query.addListener(() {
      if (query.text.isEmpty) {
        setState(() {
          searchText = "";
          filterAdmins = admins;
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

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userid = preferences.getString("userID");
    uname = preferences.getString("userName");
    uemail = preferences.getString("userEmail");
    udepartment = preferences.getString("userDepartment");

    String user = "$url/administrations/department/${widget.department!.toLowerCase()}";
    print(user);
    final response = await http.get(Uri.parse(user));
    if (response.statusCode == 200) {
      admins = (json.decode(response.body) as List)
          .map((e) => StudentModel.fromJson(e))
          .toList();
      setState(() {
        filterAdmins = admins;
      });

      if (admins![0].name!.isNotEmpty) {
        loaded = true;
      }
    }

    String admin = "$url/admins/byid/$userid";
    final aresponse = await http.get(Uri.parse(admin));
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(aresponse.body);
      AdminModel adminss = AdminModel.fromJson(map);
      adminid = adminss.adminid!;
      areason = adminss.reason!;
    }
  }

  buildList() {
    if (searchText.isNotEmpty || searchText != "") {
      List<StudentModel> tempList = [];
      for (int i = 0; i < filterAdmins!.length; i++) {
        if (filterAdmins![i]
            .name!
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          tempList.add(filterAdmins![i]);
        }
      }
      filterAdmins = tempList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
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
      appBar: AppsBars(
        username: loaded ? uname : "loading..",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                margin: const EdgeInsets.only(bottom: 5),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: admins == null ? 0 : filterAdmins!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width - 10,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              if (adminid != null && areason == "central") {
                                confirmDialog(context, index);
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
                                        filterAdmins![index].name!,
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
                                        filterAdmins![index].phone!,
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
                                        filterAdmins![index].email!,
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
                                  String url = 'tel:${filterAdmins![index].phone!}';
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
        "Name: ${filterAdmins![index].name}\nEmail: ${filterAdmins![index].email}\n"
        "Mobile: ${filterAdmins![index].phone}\nAddress: ${filterAdmins![index].address}\n"
        "Expertise: ${filterAdmins![index].expertise}";
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
                  String url = filterAdmins![index].email!;
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
                    copyToClipboard(context, filterAdmins![index].email!);
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
                    copyToClipboard(context, filterAdmins![index].phone!);
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
                "Choose one of the buttons for the user ${filterAdmins![index].name}"),
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
                                students: filterAdmins!,
                                index: index,
                                oBatch: "",
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
