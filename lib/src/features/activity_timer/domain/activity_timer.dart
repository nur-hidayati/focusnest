import 'package:json_annotation/json_annotation.dart';

part 'activity_timer.g.dart';

@JsonSerializable()
class ActivityTimer {
  final String id;
  final String userId;
  final String activityLabel;
  final int actualDurationInSeconds;
  final int targetedDurationInSeconds;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime createdDate;

  ActivityTimer({
    required this.id,
    required this.userId,
    required this.activityLabel,
    required this.actualDurationInSeconds,
    required this.targetedDurationInSeconds,
    required this.startDateTime,
    required this.endDateTime,
    required this.createdDate,
  });

  factory ActivityTimer.fromJson(Map<String, dynamic> json) =>
      _$ActivityTimerFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityTimerToJson(this);
}
