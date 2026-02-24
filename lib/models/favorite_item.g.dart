// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteItemAdapter extends TypeAdapter<FavoriteItem> {
  @override
  final int typeId = 0;

  @override
  FavoriteItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteItem(
      id: fields[0] as String,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      releaseDate: fields[3] as DateTime,
      contentType: fields[4] as String,
      platform: fields[5] as String?,
      genres: (fields[6] as List?)?.cast<String>(),
      runtime: fields[7] as int?,
      overview: fields[8] as String?,
      notificationEnabled: fields[9] as bool,
      addedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.releaseDate)
      ..writeByte(4)
      ..write(obj.contentType)
      ..writeByte(5)
      ..write(obj.platform)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.runtime)
      ..writeByte(8)
      ..write(obj.overview)
      ..writeByte(9)
      ..write(obj.notificationEnabled)
      ..writeByte(10)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
