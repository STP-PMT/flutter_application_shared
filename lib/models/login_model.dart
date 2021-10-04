// To parse required this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

List<LoginModel> loginModelFromJson(String str) {
  return List<LoginModel>.from(json.decode(str).map((x) {
    return LoginModel.fromJson(x);
  }));
}

String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModel {
  LoginModel({
    required this.message,
    required this.token,
  });

  String message;
  String token;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
      };
}
