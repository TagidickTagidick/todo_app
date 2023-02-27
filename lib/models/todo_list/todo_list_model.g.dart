// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoListModelAdapter extends TypeAdapter<TodoListModel> {
  @override
  final int typeId = 0;

  @override
  TodoListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoListModel(
      status: fields[0] as String,
      list: (fields[1] as List).cast<TodoModel>(),
      revision: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TodoListModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.list)
      ..writeByte(2)
      ..write(obj.revision);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TodoListModel _$$_TodoListModelFromJson(Map<String, dynamic> json) =>
    _$_TodoListModel(
      status: json['status'] as String,
      list: (json['list'] as List<dynamic>)
          .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      revision: json['revision'] as int,
    );

Map<String, dynamic> _$$_TodoListModelToJson(_$_TodoListModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'list': instance.list.map((e) => e.toJson()).toList(),
      'revision': instance.revision,
    };
