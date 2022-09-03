// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weeks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeksModel _$WeeksModelFromJson(Map<String, dynamic> json) {
  return WeeksModel(
    id: json['id'] as int,
    title: json['title'] as String,
    date: json['date'] as String,
  );
}

Map<String, dynamic> _$WeeksModelToJson(WeeksModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
    };
