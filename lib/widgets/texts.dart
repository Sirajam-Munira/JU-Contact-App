import 'package:flutter/material.dart';

class Texts extends StatelessWidget {
  Texts({Key? key, required this.text, this.size, this.weight, this.color}) : super(key: key);

  String? text;
  double? size;
  FontWeight? weight;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: size ?? 14,
        fontWeight: weight ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
    );
  }
}
