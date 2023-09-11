import 'dart:convert';

List<RegistrationModel> registrationModelFromJson(String str) => List<RegistrationModel>.from(json.decode(str).map((x) => RegistrationModel.fromJson(x)));

String registrationModelToJson(List<RegistrationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegistrationModel {
  RegistrationModel({
    this.id,
    this.email,
    this.phone,
    this.password,
  });

  String? id,email,phone,password;

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
    id: json["_id"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "phone": phone,
    "password": password,
  };
}
