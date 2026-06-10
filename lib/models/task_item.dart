import 'package:get/get.dart';

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    required this.isDone,
  });

  final int? id;
  final String? title;
  final String? description;
  final int? priority;
  final DateTime? createdAt;
  final RxBool isDone;

  factory TaskItem.fromJson(Map<String, dynamic> json){
    return TaskItem(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      priority: json["priority"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      isDone: RxBool(json["is_done"] ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    "title": title,
    "description": description,
    "priority": priority,
    "created_at": createdAt?.toIso8601String(),
    "is_done": isDone.value,
  };

}
