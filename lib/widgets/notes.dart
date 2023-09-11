import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ju_contact/widgets/colors.dart';

class Notes extends StatelessWidget {
  Notes({Key? key, required this.text}) : super(key: key);

  String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width / 2.5,
      alignment: Alignment.center,
      //margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Text(
        text!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
