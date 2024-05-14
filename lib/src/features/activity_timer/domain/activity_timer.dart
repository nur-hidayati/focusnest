class ActivityTimer {
  final String id;
  final String activityLabel;
  final int durationInSeconds;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime createdDate;

  ActivityTimer({
    required this.id,
    required this.activityLabel,
    required this.durationInSeconds,
    required this.startDateTime,
    required this.endDateTime,
    required this.createdDate,
  });
}
