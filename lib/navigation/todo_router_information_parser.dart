
import 'package:flutter/material.dart';

import 'todo_route_config.dart';

class TodoRouterInformationParser
    extends RouteInformationParser<TodoRouteConfig> {
  @override
  Future<TodoRouteConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) {
      return TodoRouteConfig.main();
    }
    else {
      return TodoRouteConfig.addTodo();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(TodoRouteConfig configuration) {
    if (configuration.isAddTodoPage) {
      return const RouteInformation(location: '/add');
    }
    if (configuration.isMainPage) {
      return const RouteInformation(location: '/');
    }
    return null;
  }
}