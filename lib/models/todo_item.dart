import '../constants/app_constants.dart';

class TodoItem {
  final String id;
  String title;
  String? note;
  bool isDone;
  Priority priority;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.note,
    this.isDone = false,
    this.priority = Priority.medium,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'isDone': isDone,
    'priority': priority.index,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
    id: json['id'],
    title: json['title'],
    note: json['note'],
    isDone: json['isDone'] ?? false,
    priority: Priority.values[json['priority'] ?? 1],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
