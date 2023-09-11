import 'package:flutter/material.dart';

import 'colors.dart';

class AppsBars extends StatelessWidget implements PreferredSizeWidget {
  AppsBars({Key? key, required this.username}) : super(key: key);

  String? username;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: textcolor),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username!,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Text(
            "Welcome To Jagangirnagar University",
            style: TextStyle(fontSize: 12, color: textcolor),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
