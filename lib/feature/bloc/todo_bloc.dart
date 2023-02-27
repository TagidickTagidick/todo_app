import 'dart:io' show Platform;

import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/todos_repository.dart';
import '../../models/todo/todo_model.dart';
import '../../models/todo_list/todo_list_model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState(
      todoListModel: const TodoListModel(status: "ok", list: [], revision: 0),
      isVisible: true,
      importance: "low",
      makeItTo: false,
      dateTime: DateTime.now(),
      canDelete: false
  )) {
    on<InitTodo>(_onInitTodo);
    on<Submit>(_onSubmit);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<EditTodo>(_onEditTodo);
    on<VisibilityChanged>(_onVisibilityChanged);
    on<TextChanged>(_onTextChanged);
    on<ImportanceChanged>(_onImportanceChanged);
    on<MakeItToChanged>(_onMakeItToChanged);
    on<DateTimeChanged>(_onDateTimeChanged);
  }

  final TodosRepository todosRepository = TodosRepository();

  late final Box<TodoListModel> box;
  late final Box<int> boxRevision;

  final Flushbar flushbar = Flushbar(
      title:  "Что-то пошло не так",
      message:  "Проверьте подключение к интернету",
      duration:  const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP
  );

  late final String lastUpdatedBy;

  late final BuildContext context;

  int max = 0;

  TodoListModel todoListModel = const TodoListModel(
      status: "ok",
      list: [],
      revision: 0
  );

  bool isVisible = true;

  String importance = "low";

  bool makeItTo = false;

  DateTime dateTime = DateTime.now();

  bool canDelete = false;

  void saveData() {
    box.putAt(0, todoListModel);
  }

  void _onInitTodo(InitTodo event, Emitter<TodoState> emit) async {
    box = await Hive.openBox<TodoListModel>("todos");
    boxRevision = await Hive.openBox<int>("revision");
    if (box.values.isEmpty) {
      box.add(const TodoListModel(status: "ok", list: [], revision: 0));
    }
    todoListModel = box.getAt(0)!;
    context = event.context;
    for (int i = 0; i < todoListModel.list.length; i++) {
      if (int.parse(todoListModel.list[i].id) > max) {
        max = int.parse(todoListModel.list[i].id);
      }
    }
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
    TodoListModel? model = await todosRepository.getTodo();
    if (model == null) {
      flushbar.show(context);
    }
    else {
      todoListModel = model;
      saveData();
      emit(
          state.copyWith(
              todoListModel: todoListModel,
              isVisible: isVisible,
              importance: importance,
              makeItTo: makeItTo,
              dateTime: dateTime,
              canDelete: canDelete
          )
      );
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      lastUpdatedBy = iosDeviceInfo.identifierForVendor!;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      lastUpdatedBy = androidDeviceInfo.id;
    }
  }

  void _onSubmit(Submit event, Emitter<TodoState> emit) async {
    TodoModel model = TodoModel(
        id: (max + 1).toString(),
        text: event.text,
        importance: event.importance,
        deadline: event.deadline,
        done: false,
        color: "#FFFFFF",
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        changedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        lastUpdatedBy: lastUpdatedBy
    );
    todoListModel = TodoListModel(
        status: "ok",
        list: [
          ...todoListModel.list,
          model
        ],
        revision: boxRevision.get("revision")!
    );
    max++;
    saveData();
    bool data = await todosRepository.addTodo(model);
    if (!data) {
      flushbar.show(context);
    }
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    List<TodoModel> list = [];
    for (TodoModel todo in todoListModel.list) {
      if (todo.id == event.id) {
        TodoModel todoModel = TodoModel(
            id: todo.id,
            text: todo.text,
            importance: todo.importance,
            deadline: todo.deadline,
            done: event.value,
            color: todo.color,
            createdAt: todo.createdAt,
            changedAt: todo.changedAt,
            lastUpdatedBy: todo.lastUpdatedBy
        );
        list.add(todoModel);
        bool result = await todosRepository.putTodo(todoModel);
        if (!result) {
          flushbar.show(context);
        }
      }
      else {
        list.add(todo);
      }
    }
    todoListModel = TodoListModel(
        status: "ok",
        list: list,
        revision: boxRevision.get("revision")!
    );
    saveData();
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    todoListModel = TodoListModel(
        status: "ok",
        list: todoListModel.list.where((todo) => todo.id != event.id).toList(),
        revision: boxRevision.get("revision")!
    );
    saveData();
    bool data = await todosRepository.deleteTodo(event.id);
    if (!data) {
      flushbar.show(context);
    }
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onEditTodo(EditTodo event, Emitter<TodoState> emit) async {
    List<TodoModel> list = [];
    for (TodoModel todo in todoListModel.list) {
      if (todo.id == event.id) {
        TodoModel todoModel = TodoModel(
            id: todo.id,
            text: event.text,
            importance: event.importance,
            deadline: event.deadline,
            done: todo.done,
            color: todo.color,
            createdAt: todo.createdAt,
            changedAt: todo.changedAt,
            lastUpdatedBy: todo.lastUpdatedBy
        );
        list.add(todoModel);
        bool result = await todosRepository.putTodo(todoModel);
        if (!result) {
          flushbar.show(context);
        }
      }
      else {
        list.add(todo);
      }
    }
    todoListModel = TodoListModel(
        status: "ok",
        list: list,
        revision: boxRevision.get("revision")!
    );
    saveData();
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onVisibilityChanged(VisibilityChanged event, Emitter<TodoState> emit) {
    isVisible = !isVisible;
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onTextChanged(TextChanged event, Emitter<TodoState> emit) {
    canDelete = event.value;
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onImportanceChanged(ImportanceChanged event, Emitter<TodoState> emit) {
    switch (event.value) {
      case "low":
        importance = "Нет";
        break;
      case "basic":
        importance = "Низкий";
        break;
      case "important":
        importance = "!! Высокий";
        break;
      default:
        break;
    }
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onMakeItToChanged(MakeItToChanged event, Emitter<TodoState> emit) {
    makeItTo = event.value;
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }

  void _onDateTimeChanged(DateTimeChanged event, Emitter<TodoState> emit) {
    dateTime = event.dateTime;
    emit(
        state.copyWith(
            todoListModel: todoListModel,
            isVisible: isVisible,
            importance: importance,
            makeItTo: makeItTo,
            dateTime: dateTime,
            canDelete: canDelete
        )
    );
  }
}