import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.userid,
    this.token,
  });

  String? userid, token;

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        userid: json["userid"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "token": token,
      };
}
