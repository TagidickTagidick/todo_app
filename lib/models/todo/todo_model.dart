import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
@HiveType(typeId: 1)
class TodoModel with _$TodoModel {

  const factory TodoModel({
  @HiveField(0) required String id,
  @HiveField(1) required String text,
  @HiveField(2) required String importance,
  @HiveField(3) required int? deadline,
  @HiveField(4) required bool done,
  @HiveField(5) required String color,
  @JsonKey(name: 'created_at') @HiveField(6) required int createdAt,
  @JsonKey(name: 'changed_at') @HiveField(7) required int changedAt,
  @JsonKey(name: 'last_updated_by') @HiveField(8) required String lastUpdatedBy
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}