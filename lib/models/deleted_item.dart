import 'package:my_todo/models/task_item.dart';

class DeletedItem {
  final TaskItem item;
  final DateTime deletedAt;
  DeletedItem({required this.item, required this.deletedAt});

  Map<String, dynamic> toJson() => {
    'item': item.toJson(),
    'deletedAt': deletedAt.toIso8601String(),
  };

  factory DeletedItem.fromJson(Map<String, dynamic> json) => DeletedItem(
    item: TaskItem.fromJson(Map<String, dynamic>.from(json['item'])),
    deletedAt: DateTime.parse(json['deletedAt']),
  );
}
