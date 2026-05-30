import '../constants/app_enums.dart';

class TodoItem {
  final String id;
  String title;
  String? description;
  bool isDone;
  Priority priority;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.priority = Priority.medium,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone,
    'priority': priority.index,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isDone: json['isDone'] ?? false,
    priority: Priority.values[json['priority'] ?? 1],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
