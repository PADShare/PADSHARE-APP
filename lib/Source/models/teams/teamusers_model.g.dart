// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamusers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamUsersModel _$TeamUsersFromJson(Map<String, dynamic> json) {
  return TeamUsersModel(
    id: json['id'] as int,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$TeamUsersToJson(TeamUsersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };
