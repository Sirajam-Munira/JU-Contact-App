import 'dart:convert';

DepartmentModel departmentModelFromJson(String str) =>
    DepartmentModel.fromJson(json.decode(str));

String departmentModelToJson(DepartmentModel data) =>
    json.encode(data.toJson());

class DepartmentModel {
  DepartmentModel({
    this.department,
    this.about,
  });

  String? department;
  String? about;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(
        department: json["department"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "department": department,
        "about": about,
      };
}
