import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({
    Key? key,
     // this.text,
     // this.onChanged,
     // this.hintText,
  }) : super(key: key);

  // String? text;
  // ValueChanged<String>? onChanged;
  // String? hintText;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.black),
          // suffixIcon: widget.text!.isNotEmpty
          //     ? InkWell(
          //   child: Icon(Icons.close, color: Colors.black),
          //   onTap: () {
          //     controller.clear();
          //     //widget.onChanged!('');
          //     FocusScope.of(context).requestFocus(FocusNode());
          //   },
          // )
          //     : null,
          //hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black),
        //onChanged: widget.onChanged,
      ),
    );
  }
}
