import 'dart:convert';

AdminModel adminModelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  AdminModel({
    this.adminid,
    this.reason,
  });

  String? adminid;
  String? reason;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        adminid: json["adminid"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "adminid": adminid,
        "reason": reason,
      };
}
