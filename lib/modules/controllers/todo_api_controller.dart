import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_todo/services/api_service.dart';
import 'package:my_todo/constants/app_urls.dart';
import 'package:my_todo/models/task_item.dart';
import 'package:my_todo/models/todo_item.dart';

import '../../models/deleted_item.dart';

class TodoApiController extends GetxController {
  final _api = ApiService();

  // ====================== Variables =====================
  var tasks = <TaskItem>[].obs;
  final deleteHistory = <DeletedItem>[].obs;

  var isLoading = false.obs;

  final RxInt selectedFilter = 0.obs;

  int get activeCount => tasks.where((t) => !t.isDone.value).length;
  int get doneCount => tasks.where((t) => t.isDone.value).length;

  // ===================== Methods =====================
  Future<void> fetchTasks() async {
   try{
     isLoading(true);
     var response = await _api.request(
       endpoint: AppUrls.getAllTasks,
       method: HttpMethod.get,
     );

     if(response != null && response.statusCode == 200){
       tasks.value = (response.data as List)
           .map((e) => TaskItem.fromJson(e))
           .toList();
     }
   } catch(e){
     print(e);
   } finally {
     isLoading(false);
   }
  }

  void addTask(TodoItem item) {

  }

  void deleteTodo(TaskItem item) {

  }

  void toggleDone(TaskItem item) {
    item.isDone.value = !item.isDone.value;
    tasks.refresh();
    HapticFeedback.lightImpact();
  }


  void setFilter(int index) => selectedFilter.value = index;

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
