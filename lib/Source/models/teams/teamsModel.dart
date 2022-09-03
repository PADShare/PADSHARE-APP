

import 'package:json_annotation/json_annotation.dart';
import 'package:padshare/Source/models/teams/teamUsers.dart';

part 'teamsModel.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamsModel {
  final int postCount;
  final List<TeamUserModel> listusers;


  TeamsModel({this.postCount, this.listusers});
  factory TeamsModel.fromJson(Map<String,dynamic> json) => _$TeamsFromJson(json);
  Map<String,dynamic> toJson() => _$TeamsToJson(this);




}