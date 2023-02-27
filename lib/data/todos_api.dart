import '../models/todo/todo_model.dart';
import '../models/todo_list/todo_list_model.dart';

abstract class TodosApi {
  Future<bool> addTodo(TodoModel todoModel);

  Future<TodoListModel?> getTodo();

  Future<bool> putTodo(TodoModel todoModel);

  Future<bool> deleteTodo(String id);

  Future<bool> request(String url, Object? body);
}