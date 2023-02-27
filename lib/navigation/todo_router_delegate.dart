import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/navigation/todo_route_config.dart';
import '../feature/bloc/todo_bloc.dart';
import '../feature/presentation/screens/add_todo_screen.dart';
import '../feature/presentation/screens/todo_screen.dart';
import '../models/todo/todo_model.dart';

class TodoRouterDelegate extends RouterDelegate<TodoRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TodoRouteConfig> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  TodoRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  TodoModel? _todoModel;

  bool _isAddTodo = false;

  @override
  TodoRouteConfig get currentConfiguration {
    if (_isAddTodo) {
      return TodoRouteConfig.addTodo();
    }
    else {
      return TodoRouteConfig.main();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => TodoBloc(),
      child: Navigator(
          key: navigatorKey,
          pages: [
            MaterialPage(
                child: TodoScreen(
                  handleItemTapped: _handleItemTapped
                )
            ),
            if (_isAddTodo)
              MaterialPage(
                  child: AddTodoScreen(
                    todoModel: _todoModel,
                    handleItemTapped: _popTodo,
                    save: _save
                  )
              )
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            if (_isAddTodo) {
              _isAddTodo = false;
              notifyListeners();
              return true;
            }

            return true;
          }
      )
  );

  @override
  Future<void> setNewRoutePath(TodoRouteConfig configuration) async {
    if (configuration.isAddTodoPage) {
      _isAddTodo = true;
    }
    else {
      _isAddTodo = false;
    }
    return;
  }

  void _handleItemTapped(TodoModel? todoModel) {
    _isAddTodo = true;
    _todoModel = todoModel;
    notifyListeners();
  }

  void _popTodo() {
    _isAddTodo = false;
    notifyListeners();
  }

  void _save(Function() save) {
    save();
    _isAddTodo = false;
    notifyListeners();
  }
}