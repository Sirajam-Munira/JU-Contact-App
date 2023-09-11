// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

StudentModel studentModelFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  StudentModel({
    this.id,
    this.email,
    this.expertise,
    this.address,
    this.name,
    this.phone,
    this.department,
    this.batch,
  });

  String? email, id;
  String? expertise;
  String? address;
  String? name;
  String? phone;
  String? department;
  String? batch;

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["_id"],
        email: json["email"],
        expertise: json["expertise"],
        address: json["address"],
        name: json["name"],
        phone: json["phone"],
        department: json["department"],
        batch: json["batch"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "expertise": expertise,
        "address": address,
        "name": name,
        "phone": phone,
        "department": department,
        "batch": batch,
      };
}
