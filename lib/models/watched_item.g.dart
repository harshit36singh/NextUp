// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchedItemAdapter extends TypeAdapter<WatchedItem> {
  @override
  final int typeId = 2;

  @override
  WatchedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedItem(
      id: fields[0] as String,
      title: fields[1] as String,
      watchedDate: fields[2] as DateTime?,
      privateNote: fields[3] as String?,
      contentType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchedItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.watchedDate)
      ..writeByte(3)
      ..write(obj.privateNote)
      ..writeByte(4)
      ..write(obj.contentType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
