import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/deleted_item.dart';
import '../../models/task_item.dart';
import '../../repositories/task_repository.dart';
import '../../utils/utils.dart';

class TodoApiController extends GetxController {
  final _repository = TaskRepository();

  var tasks = <TaskItem>[].obs;
  var isLoading = false.obs;
  final deleteHistory = <DeletedItem>[].obs;
  final RxInt selectedFilter = 0.obs;

  int get activeCount => tasks.where((t) => !t.isDone.value).length;
  int get doneCount => tasks.where((t) => t.isDone.value).length;

  Future<void> fetchTasks() async {
    isLoading(true);

    try {
      tasks.value = await _repository.getAllTasks();
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(TaskItem item) async {
    Utils.showLoader();

    var itemJson = item.toJson();

    print(itemJson);

    try {
      final task = await _repository.addTask(itemJson);

      if (task != null) {
        tasks.add(task);
        Utils.toastMessage('Task Added Successfully!');
      }
    } finally {
      Utils.hideLoader();
    }
  }

  Future<void> updateTask(TaskItem task) async {
    try {
      Utils.showLoader();

      final updatedTask = await _repository.updateTask({
        "id": task.id,
        "title": task.title,
        "description": task.description,
        "priority": task.priority,
        "created_at": task.createdAt?.toIso8601String(),
        "is_done": task.isDone.value,
      });

      if (updatedTask != null) {
        final index = tasks.indexWhere((e) => e.id == updatedTask.id);

        if (index != -1) {
          tasks[index] = updatedTask;
          tasks.refresh();
        }

        Utils.toastMessage('Task Updated Successfully!');
      }
    } catch (e) {
      print(e);
    } finally {
      Utils.hideLoader();
    }
  }

  Future<void> deleteTodo(int taskId) async {
    Utils.showLoader();

    try {
      final success = await _repository.deleteTask(taskId);

      if (success) {
        tasks.removeWhere((e) => e.id == taskId);
        Utils.toastMessage('Task Deleted Successfully!');
      }
    } finally {
      Utils.hideLoader();
    }
  }



  void toggleDone(TaskItem item) async{
    item.isDone.value = !item.isDone.value;

    await updateTask(item);

    tasks.refresh();
    HapticFeedback.lightImpact();
  }

  void setFilter(int index) {
    selectedFilter.value = index;
  }

  List<TaskItem> get filtered {
    switch (selectedFilter.value) {
      case 1:
        return tasks.where((t) => !t.isDone.value).toList();
      case 2:
        return tasks.where((t) => t.isDone.value).toList();
      default:
        return List.from(tasks);
    }
  }
}