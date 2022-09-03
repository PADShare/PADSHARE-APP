
import 'package:json_annotation/json_annotation.dart';

part 'teamusers_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamUsersModel{
  final int id;
  final String name;
  final String avatar;

  TeamUsersModel({this.id, this.name, this.avatar});
  factory TeamUsersModel.fromJson(Map<String, dynamic> json) => _$TeamUsersFromJson(json);
  Map<String,dynamic> toJson() => _$TeamUsersToJson(this);

}