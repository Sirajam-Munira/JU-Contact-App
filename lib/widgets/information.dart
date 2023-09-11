import 'package:flutter/material.dart';
import 'package:ju_contact/screen/administration.dart';
import 'package:ju_contact/screen/members.dart';
import 'package:ju_contact/screen/show_categories.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:ju_contact/widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationLayout extends StatelessWidget {
  InformationLayout(
      {Key? key, required this.text, required this.icons, this.departments})
      : super(key: key);

  String? text;
  List<String>? departments;
  IconData? icons;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (text == "Departments") {
          createDialog(context, departments!);
        } else if (text == "Your Department") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MemberList(
                        departments: "IIT",
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Administration(department: text)));
        }
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
                icons ?? Icons.category,
                color: textcolor,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text!,
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

  createDialog(BuildContext context, List<String> departments) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Select One!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: departments.length,
                  itemBuilder: (context, index) {
                    print(departments.length);
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemberList(
                                      departments: departments[index],
                                    )));
                      },
                      title: Text(departments[index]),
                    );
                  }),
            ),
          );
        });
  }
}
