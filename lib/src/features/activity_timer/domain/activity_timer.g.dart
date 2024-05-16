// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityTimer _$ActivityTimerFromJson(Map<String, dynamic> json) =>
    ActivityTimer(
      id: json['id'] as String,
      userId: json['userId'] as String,
      activityLabel: json['activityLabel'] as String,
      actualDurationInSeconds: (json['actualDurationInSeconds'] as num).toInt(),
      targetedDurationInSeconds:
          (json['targetedDurationInSeconds'] as num).toInt(),
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      createdDate: DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$ActivityTimerToJson(ActivityTimer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'activityLabel': instance.activityLabel,
      'actualDurationInSeconds': instance.actualDurationInSeconds,
      'targetedDurationInSeconds': instance.targetedDurationInSeconds,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'createdDate': instance.createdDate.toIso8601String(),
    };
