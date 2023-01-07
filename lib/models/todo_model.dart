import 'dart:convert';

TodoModel TodoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String TodoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
  TodoModel({
    this.id,
    this.text,
    this.completed,
    this.createdAt,
  });

  int? id;
  String? text;
  int? completed;
  DateTime? createdAt;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        text: json["text"],
        completed: json["completed"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "completed": completed,
        "created_at": createdAt!.toIso8601String(),
      };
}
