part of 'todo_bloc.dart';

class TodoState extends Equatable {
  const TodoState({
    required this.todoListModel,
    required this.isVisible,
    required this.importance,
    required this.makeItTo,
    required this.dateTime,
    required this.canDelete
  });

  final TodoListModel todoListModel;
  final bool isVisible;
  final String importance;
  final bool makeItTo;
  final DateTime dateTime;
  final bool canDelete;

  TodoState copyWith({
    required TodoListModel todoListModel,
    required bool isVisible,
    required String importance,
    required bool makeItTo,
    required DateTime dateTime,
    required bool canDelete
  }) => TodoState(
      todoListModel: todoListModel,
      isVisible: isVisible,
    importance: importance,
    makeItTo: makeItTo,
    dateTime: dateTime,
    canDelete: canDelete,
  );

  @override
  List<Object> get props => [
    todoListModel,
    isVisible,
    importance,
    makeItTo,
    dateTime,
    canDelete
  ];
}