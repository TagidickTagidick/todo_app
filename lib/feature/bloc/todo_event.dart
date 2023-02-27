part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class InitTodo extends TodoEvent {
  const InitTodo({required this.context});

  final BuildContext context;

  @override
  List<Object> get props => [context];
}

class SetTodo extends TodoEvent {
  const SetTodo({required this.list});

  final TodoListModel list;

  @override
  List<Object> get props => [list];
}

class Submit extends TodoEvent {
  const Submit({
    required this.text,
    required this.importance,
    required this.deadline
  });

  final String text;
  final String importance;
  final int? deadline;

  @override
  List<Object> get props => [text, importance, deadline!];
}

class VisibilityChanged extends TodoEvent {
  const VisibilityChanged();

  @override
  List<Object> get props => [];
}

class ToggleTodo extends TodoEvent {
  const ToggleTodo({required this.id, required this.value});

  final String id;
  final bool value;

  @override
  List<Object> get props => [id, value];
}

class DeleteTodo extends TodoEvent {
  const DeleteTodo({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class EditTodo extends TodoEvent {
  const EditTodo({
    required this.id,
    required this.text,
    required this.importance,
    required this.deadline
  });

  final String id;
  final String text;
  final String importance;
  final int? deadline;

  @override
  List<Object> get props => [id, text, importance, deadline!];
}

class TextChanged extends TodoEvent {
  const TextChanged({required this.value});

  final bool value;

  @override
  List<Object> get props => [value];
}

class ImportanceChanged extends TodoEvent {
  const ImportanceChanged({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class MakeItToChanged extends TodoEvent {
  const MakeItToChanged({required this.value});

  final bool value;

  @override
  List<Object> get props => [value];
}

class DateTimeChanged extends TodoEvent {
  const DateTimeChanged({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object> get props => [dateTime];
}