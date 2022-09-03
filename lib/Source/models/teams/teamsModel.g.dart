// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamsModel _$TeamsFromJson(Map<String, dynamic> json) {
  return TeamsModel(
    postCount: json['postCount'] as int,
    listusers: (json['listusers'] as List)
        ?.map((e) => e == null
            ? null
            : TeamUserModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TeamsToJson(TeamsModel instance) =>
    <String, dynamic>{
      'postCount': instance.postCount,
      'listusers': instance.listusers?.map((e) => e?.toJson())?.toList(),
    };
