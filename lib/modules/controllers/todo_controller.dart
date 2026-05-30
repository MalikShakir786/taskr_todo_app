import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_todo/services/api_service.dart';

import '../../constants/app_enums.dart';
import '../../models/deleted_item.dart';
import '../../models/todo_item.dart';


class TodoController extends GetxController {
  final _box = GetStorage();

  static const _todosKey = 'todos';
  static const _historyKey = 'delete_history';

  final RxList<TodoItem> todos = <TodoItem>[].obs;
  final RxList<DeletedItem> deleteHistory = <DeletedItem>[].obs;
  final RxInt selectedFilter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }


  void _loadFromStorage() {
    // Load todos
    final rawTodos = _box.read<List>(_todosKey);
    if (rawTodos != null) {
      todos.value = rawTodos
          .map((e) => TodoItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      // Default seed data on first launch
      todos.value = [
        TodoItem(
          id: '1',
          title: 'Design the new landing page',
          description: 'Focus on hero section and typography',
          priority: Priority.high,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        TodoItem(
          id: '2',
          title: 'Review pull requests',
          priority: Priority.medium,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        TodoItem(
          id: '3',
          title: 'Buy groceries',
          description: 'Milk, eggs, bread, coffee',
          priority: Priority.low,
          isDone: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      _saveTodos();
    }

    // Load delete history
    final rawHistory = _box.read<List>(_historyKey);
    if (rawHistory != null) {
      deleteHistory.value = rawHistory
          .map((e) => DeletedItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  void _saveTodos() {
    _box.write(_todosKey, todos.map((t) => t.toJson()).toList());
  }

  void _saveHistory() {
    _box.write(_historyKey, deleteHistory.map((d) => d.toJson()).toList());
  }

  List<TodoItem> get filtered {
    switch (selectedFilter.value) {
      case 1:
        return todos.where((t) => !t.isDone).toList();
      case 2:
        return todos.where((t) => t.isDone).toList();
      default:
        return List.from(todos);
    }
  }

  int get activeCount => todos.where((t) => !t.isDone).length;
  int get doneCount => todos.where((t) => t.isDone).length;

  void addTodo(TodoItem item) {
    todos.insert(0, item);
    _saveTodos();
    HapticFeedback.mediumImpact();
  }

  void toggleDone(TodoItem item) {
    item.isDone = !item.isDone;
    todos.refresh();
    _saveTodos();
    HapticFeedback.lightImpact();
  }

  void deleteTodo(TodoItem item) {
    final idx = todos.indexOf(item);
    final deleted = DeletedItem(item: item, deletedAt: DateTime.now());
    todos.remove(item);
    deleteHistory.insert(0, deleted);
    _saveTodos();
    _saveHistory();
    HapticFeedback.mediumImpact();

    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E2A),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          const Icon(Icons.delete_outline_rounded,
              color: Color(0xFFFF4F5E), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"${item.title.length > 28 ? '${item.title.substring(0, 28)}…' : item.title}" deleted',
              style: const TextStyle(
                  color: Colors.white70, fontFamily: 'Courier', fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () {
              todos.insert(idx, item);
              deleteHistory.remove(deleted);
              _saveTodos();
              _saveHistory();
              Get.closeCurrentSnackbar();
            },
            child: const Text(
              'UNDO',
              style: TextStyle(
                color: Color(0xFFE8FF47),
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }

  void restoreFromHistory(DeletedItem d) {
    todos.insert(0, d.item);
    deleteHistory.remove(d);
    _saveTodos();
    _saveHistory();
    HapticFeedback.mediumImpact();
  }

  void removePermanently(DeletedItem d) {
    deleteHistory.remove(d);
    _saveHistory();
  }

  void clearAllHistory() {
    deleteHistory.clear();
    _saveHistory();
  }

  void setFilter(int index) => selectedFilter.value = index;
}