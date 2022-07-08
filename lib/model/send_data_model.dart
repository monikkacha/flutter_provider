// To parse this JSON data, do
//
//     final sendDataModel = sendDataModelFromJson(jsonString);

import 'dart:convert';

SendDataModel sendDataModelFromJson(String str) =>
    SendDataModel.fromJson(json.decode(str));

String sendDataModelToJson(SendDataModel data) => json.encode(data.toJson());

class SendDataModel {
  SendDataModel({
    this.title,
    this.body,
    this.userId,
  });

  String? title;
  String? body;
  int? userId;

  factory SendDataModel.fromJson(Map<String, dynamic> json) => SendDataModel(
        title: json["title"],
        body: json["body"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "userId": userId,
      };
}
