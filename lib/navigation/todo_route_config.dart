class TodoRouteConfig {
  final bool isAddTodo;

  TodoRouteConfig.main()
      : isAddTodo = false;

  TodoRouteConfig.addTodo()
      : isAddTodo = true;

  bool get isMainPage => isAddTodo == false;

  bool get isAddTodoPage => isAddTodo == true;
}