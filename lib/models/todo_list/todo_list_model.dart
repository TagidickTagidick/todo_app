import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/models/todo/todo_model.dart';
import 'package:hive/hive.dart';
part 'todo_list_model.freezed.dart';
part 'todo_list_model.g.dart';

@freezed
@HiveType(typeId: 0)
class TodoListModel with _$TodoListModel {

  @JsonSerializable(explicitToJson: true)
  const factory TodoListModel({
  @HiveField(0) required String status,
  @HiveField(1) required List<TodoModel> list,
  @HiveField(2) required int revision
  }) = _TodoListModel;

  factory TodoListModel.fromJson(Map<String, dynamic> json) =>
      _$TodoListModelFromJson(json);
}