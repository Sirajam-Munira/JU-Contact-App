import 'package:flutter/material.dart';

class UpdateTextField extends StatefulWidget {
  UpdateTextField({
    Key? key,
    required this.controller,
    required this.type,
    required this.hintText,
    required this.text,
  }) : super(key: key);

  TextEditingController? controller;
  TextInputType? type;
  String? hintText, text;

  @override
  State<UpdateTextField> createState() => _UpdateTextFieldState();
}

class _UpdateTextFieldState extends State<UpdateTextField> {
  String? cText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller!.text = widget.text!;
    setState(() {
      if(cText!=null){
        widget.controller!.text = cText!;
        print(widget.controller!.text);
        print(cText);
      }
    });
  }

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
          controller: widget.controller,
          keyboardType: widget.type,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          onChanged: (string){
            cText = string;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
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
