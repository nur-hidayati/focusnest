import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnest/src/utils/timestamp_converter.dart';

void main() {
  const timestampConverter = TimestampConverter();
  const timestampNullableConverter = TimestampNullableConverter();

  group('TimestampConverter', () {
    test('should convert from Timestamp to DateTime', () {
      final timestamp = Timestamp.now();
      expect(timestampConverter.fromJson(timestamp), isA<DateTime>());
    });

    test('should convert from DateTime to Timestamp', () {
      final dateTime = DateTime.now();
      expect(timestampConverter.toJson(dateTime), isA<Timestamp>());
    });
  });

  group('TimestampNullableConverter', () {
    test('should convert from Timestamp to DateTime when Timestamp is not null',
        () {
      final timestamp = Timestamp.now();
      expect(timestampNullableConverter.fromJson(timestamp), isA<DateTime>());
    });

    test('should return null when Timestamp is null', () {
      expect(timestampNullableConverter.fromJson(null), isNull);
    });

    test('should convert from DateTime to Timestamp when DateTime is not null',
        () {
      final dateTime = DateTime.now();
      expect(timestampNullableConverter.toJson(dateTime), isA<Timestamp>());
    });

    test('should return null when DateTime is null', () {
      expect(timestampNullableConverter.toJson(null), isNull);
    });
  });
}
