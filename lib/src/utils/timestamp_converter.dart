import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Provide functionality for converting between Timestamp and DateTime objects.
// The TimestampConverter class handles non-nullable Timestamp and DateTime objects,
// while the TimestampNullableConverter class handles nullable Timestamp and DateTime objects.
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate().toLocal();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object.toUtc());
}

class TimestampNullableConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampNullableConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate().toLocal();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object.toUtc());
}
