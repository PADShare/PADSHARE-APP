// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamUsers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamUserModel _$TeamUserFromJson(Map<String, dynamic> json) {
  return TeamUserModel(
    phone: json['phone'] as String,
    user: json['user'] as String,
    imageurl: json['imageurl'] as String,
    teamID: json['teamID'] as String,
    teamName: json['teamName'] as String,
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _$TeamUserToJson(TeamUserModel instance) =>
    <String, dynamic>{
      'teamName': instance.teamName,
      'phone': instance.phone,
      'teamID': instance.teamID,
      'imageurl': instance.imageurl,
      'userId': instance.userId,
      'user': instance.user,
    };
