import 'package:flutter/foundation.dart';
import 'package:my_todo/constants/app_urls.dart';
import 'package:my_todo/models/task_item.dart';
import 'package:my_todo/services/api_service.dart';
import 'package:my_todo/utils/utils.dart';

List<TaskItem> parseTaskItems(List<dynamic> json) {
  return json.map((e) => TaskItem.fromJson(e)).toList();
}

class TaskRepository {
  final _api = ApiService();

  Future<List<TaskItem>> getAllTasks() async {
    try {
      final response = await _api.request(
        endpoint: AppUrls.getAllTasks,
        method: HttpMethod.get,
      );

      if (response != null &&
          response.statusCode == 200 &&
          response.data != null) {

        return await compute<List<dynamic>, List<TaskItem>>(
          parseTaskItems,
          response.data as List,
        );
      } else {
        Utils.toastMessage('An error occurred!');
      }
    } catch (e, stk) {
      print(stk);
      print(e);
      Utils.toastMessage('Failed to fetch tasks');
    }

    return [];
  }

  Future<TaskItem?> addTask(Map<String, dynamic> body) async {
    try {
      final response = await _api.request(
        endpoint: AppUrls.addTask,
        method: HttpMethod.post,
        data: body,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return TaskItem.fromJson(response.data['task']);
      } else {
        Utils.toastMessage('An error occurred!');
      }
    } catch (e, stk) {
      print(stk);
      print(e);
      Utils.toastMessage('Failed to add task');
    }

    return null;
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      final response = await _api.request(
        endpoint: '${AppUrls.deleteTask}/$taskId',
        method: HttpMethod.delete,
      );

      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        Utils.toastMessage('An error occurred!');
      }
    } catch (e, stk) {
      print(stk);
      print(e);
      Utils.toastMessage('Failed to delete task');
    }

    return false;
  }

  Future<TaskItem?> updateTask(Map<String, dynamic> body) async {
    try {
      final response = await _api.request(
        endpoint: AppUrls.updateTask,
        method: HttpMethod.put,
        data: body
      );

      if (response != null && response.statusCode == 200) {
        return TaskItem.fromJson(response.data);
      } else {
        Utils.toastMessage('An error occurred!');
      }
    } catch (e, stk) {
      print(stk);
      print(e);
      Utils.toastMessage('Failed to update task');
    }

    return null;
  }
}