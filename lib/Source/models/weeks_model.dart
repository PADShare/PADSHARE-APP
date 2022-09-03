import 'package:json_annotation/json_annotation.dart';

part 'weeks_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WeeksModel{
  final int id;
  final String title;
  final String date;

  WeeksModel({this.id,this.title, this.date});
  factory WeeksModel.fromJson(Map<String,dynamic> json) => _$WeeksModelFromJson(json);
  Map<String, dynamic> tojson() => _$WeeksModelToJson(this);
}