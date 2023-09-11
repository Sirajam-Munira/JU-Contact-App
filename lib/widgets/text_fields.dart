import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  TextFields({
    Key? key,
    required this.controller,
    required this.type,
    required this.hintText,
  }) : super(key: key);

  TextEditingController? controller;
  TextInputType? type;
  String? hintText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 1.5,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.black26,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          keyboardType: type,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.black26,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
