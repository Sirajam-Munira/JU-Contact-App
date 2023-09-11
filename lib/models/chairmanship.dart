// To parse this JSON data, do
//
//     final chairmanModel = chairmanModelFromJson(jsonString);

import 'dart:convert';

ChairmanModel chairmanModelFromJson(String str) => ChairmanModel.fromJson(json.decode(str));

String chairmanModelToJson(ChairmanModel data) => json.encode(data.toJson());

class ChairmanModel {
  ChairmanModel({
    this.userid,
    this.department,
    this.batch,
  });

  String? userid;
  String? department;
  String? batch;

  factory ChairmanModel.fromJson(Map<String, dynamic> json) => ChairmanModel(
    userid: json["userid"],
    department: json["department"],
    batch: json["batch"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "department": department,
    "batch": batch,
  };
}
