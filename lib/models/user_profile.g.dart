// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      username: fields[1] as String,
      bio: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
      genrePreferences: (fields[4] as Map?)?.cast<String, int>(),
      contentTypePreferences: (fields[5] as Map?)?.cast<String, int>(),
      totalFavorites: fields[6] as int,
      totalWatched: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.genrePreferences)
      ..writeByte(5)
      ..write(obj.contentTypePreferences)
      ..writeByte(6)
      ..write(obj.totalFavorites)
      ..writeByte(7)
      ..write(obj.totalWatched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
