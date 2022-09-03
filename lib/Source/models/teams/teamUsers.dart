

import 'package:json_annotation/json_annotation.dart';

part 'teamUsers.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamUserModel {
 final String teamName;
 final String phone;
 final String teamID;
 final String imageurl;
 final String userId;
 final String user;


  TeamUserModel({this.phone, this.user, this.imageurl, this.teamID, this.teamName, this.userId});
  factory TeamUserModel.fromJson(Map<String,dynamic> json) => _$TeamUserFromJson(json);
  Map<String,dynamic> toJson() => _$TeamUserToJson(this);




}