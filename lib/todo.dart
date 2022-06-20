import 'dart:convert';

List<TodoResponse> categoryResponseFromJson(String str) =>
    List<TodoResponse>.from(
        json.decode(str).map((x) => TodoResponse.fromJson(x)));

String categoryResponseToJson(List<TodoResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoResponse {
  TodoResponse({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  int userId;
  int id;
  String title;
  bool completed;

  factory TodoResponse.fromJson(Map<String, dynamic> json) => TodoResponse(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
