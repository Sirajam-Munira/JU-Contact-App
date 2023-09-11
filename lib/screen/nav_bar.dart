import 'package:flutter/material.dart';
import 'package:ju_contact/screen/about_department.dart';
import 'package:ju_contact/screen/admin.dart';
import 'package:ju_contact/screen/home_page.dart';
import 'package:ju_contact/screen/login.dart';
import 'package:ju_contact/screen/person.dart';
import 'package:ju_contact/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  NavBar(
      {Key? key,
      required this.selected,
      required this.name,
      required this.department,
      required this.email})
      : super(key: key);

  String? selected, name, department, email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name!),
            accountEmail: Text("$department\n$email"),
            currentAccountPicture: Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(45),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
                height: 60,
                width: 60,
              ),
            ),
            decoration: BoxDecoration(
              color: secondary,
              //image: DecorationImage(image: AssetImage("julogo.png")),
            ),
          ),
          ListTile(
            tileColor:
                selected == "home" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.home,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              selected == "home"
                  ? Navigator.pop(context)
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Your Department",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            tileColor:
                selected == "teachers" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.person,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Teachers Info",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              selected == "teachers"
                  ? Navigator.pop(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonList(
                              info: "Teachers Information",
                              department: department,
                              email: email,
                              name: name)));
            },
          ),
          ListTile(
            tileColor:
                selected == "students" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.school,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Students Info",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            tileColor:
                selected == "staffs" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.person,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Staffs Info",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              selected == "staffs"
                  ? Navigator.pop(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonList(
                              info: "Staffs Information",
                              department: department,
                              email: email,
                              name: name)));
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Jahangirnagar University",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            tileColor:
                selected == "about" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.group_outlined,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "About JU",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutDepartment(department: "JU")));
            },
          ),
          ListTile(
            tileColor:
                selected == "admin" ? Colors.grey[300] : Colors.transparent,
            leading: Icon(
              Icons.admin_panel_settings,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Admin",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Admins()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              createDialog(context);
            },
          )
        ],
      ),
    );
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Are You Sure?",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Are you sure to log out from this device?",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: secondary,
                    fontSize: 14,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.remove("userID");
                  preferences.remove("userName");
                  preferences.remove("userEmail");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: secondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceAround,
          );
        });
  }
}
