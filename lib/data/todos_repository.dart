import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/utils/constants/services_constants.dart';
import 'todos_api.dart';
import '../models/todo_list/todo_list_model.dart';
import '../models/todo/todo_model.dart';

class TodosRepository extends TodosApi {

  Box<int>? box;

  final Logger logger = Logger();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Future<bool> addTodo(TodoModel todoModel) async {
    try {
      final Response response = await post(
          Uri.parse('$baseUrl/list'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
            'X-Last-Known-Revision': box!.get("revision").toString()
          },
          body: jsonEncode({
            "status": "ok",
            "element": todoModel.toJson()
          })
      );
      if (response.statusCode == 200) {
        // analytics.logEvent(
        //     name: 'test_event',
        //     parameters: <String, dynamic>{'id': (max + 1).toString()}
        // );
        box!.put("revision", box!.get("revision")! + 1);
        return true;
      }
      else {
        return false;
      }
    }
    catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<TodoListModel?> getTodo() async {
    box = await Hive.openBox<int>("revision");
    if (box!.isEmpty) {
      box!.put("revision", 0);
    }
    try {
      final Response response = await get(
          Uri.parse('$baseUrl/list'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
            'X-Last-Known-Revision': box!.get("revision").toString()
          }
      );
      if (response.statusCode == 200) {
        TodoListModel todoListModel = TodoListModel
            .fromJson(jsonDecode(response.body));
        box!.put("revision", todoListModel.revision);
        return todoListModel;
      } else {
        return null;
      }
    }
    catch (e) {
      logger.e(e);
      return null;
    }
  }

  @override
  Future<bool> putTodo(TodoModel todoModel) async {
    try {
      final Response response = await put(
          Uri.parse('$baseUrl/list/${todoModel.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
            'X-Last-Known-Revision': box!.get("revision").toString()
          },
          body: jsonEncode({
            "status": "ok",
            "element": todoModel.toJson()
          })
      );
      if (response.statusCode == 200) {
        if (todoModel.done) {
          analytics.logEvent(
              name: 'test_event',
              parameters: <String, dynamic>{'id': todoModel.id}
          );
        }
        box!.put('revision', box!.get("revision")! + 1);
        return true;
      }
      else {
        return false;
      }
    }
    catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> deleteTodo(String id) async {
    try {
      final Response response = await delete(
          Uri.parse('$baseUrl/list/$id'),
          headers: {
            'Authorization': token,
            'X-Last-Known-Revision': box!.get("revision").toString()
          }
      );
      if (response.statusCode == 200) {
        analytics.logEvent(
            name: 'test_event',
            parameters: <String, dynamic>{'id': id}
        );
        box!.put('revision', box!.get("revision")! + 1);
        return true;
      }
      else {
        return false;
      }
    }
    catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> request(String url, Object? body) async {
    try {
      final Response response = await put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
            'X-Last-Known-Revision': box!.get("revision").toString()
          },
          body: body
      );
      if (response.statusCode == 200) {
        box!.put('revision', box!.get("revision")! + 1);
        return true;
      }
      else {
        return false;
      }
    }
    catch (e) {
      logger.e(e);
      return false;
    }
  }
}