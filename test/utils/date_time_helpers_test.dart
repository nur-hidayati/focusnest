import 'package:flutter_test/flutter_test.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';

void main() {
  group('DateTime Utilities', () {
    test('addDays should add the correct number of days', () {
      final dateTime = DateTime(2023, 1, 1);
      final result = addDays(dateTime, 5);
      expect(result, DateTime(2023, 1, 6));
    });

    test('subtractDays should subtract the correct number of days', () {
      final dateTime = DateTime(2023, 1, 10);
      final result = subtractDays(dateTime, 3);
      expect(result, DateTime(2023, 1, 7));
    });

    test('formatDurationToHms should format correctly', () {
      const duration1 = Duration(hours: 1, minutes: 2, seconds: 2);
      const duration2 = Duration(minutes: 12, seconds: 2);
      const duration3 = Duration(hours: 1, minutes: 2, seconds: 0);

      expect(formatDurationToHms(duration1), '01:02:02');
      expect(formatDurationToHms(duration2), '12:02');
      expect(formatDurationToHms(duration3), '01:02:00');
    });

    test('formatDurationsToReadable should format correctly', () {
      const duration1 = Duration(hours: 1, minutes: 2);
      const duration2 = Duration(minutes: 2);
      const duration3 = Duration(minutes: 1);
      const duration4 = Duration(hours: 2, minutes: 1);
      expect(formatDurationsToReadable(duration1), '1 hour 2 minutes');
      expect(formatDurationsToReadable(duration2), '2 minutes');
      expect(formatDurationsToReadable(duration3), '1 minute');
      expect(formatDurationsToReadable(duration4), '2 hours 1 minute');
    });

    test('formatTime should format time correctly', () {
      final dateTime = DateTime(2023, 1, 1, 13, 30);
      final actual = formatTime(dateTime);
      const expected = '1:30 PM';

      // Normalize whitespace by removing non-breaking spaces
      final normalizedActual = actual.replaceAll('\u202F', ' ');
      final normalizedExpected = expected.replaceAll('\u202F', ' ');

      expect(normalizedActual, normalizedExpected);
    });

    test('formatDateTime should format date and time correctly', () {
      final dateTime = DateTime(2023, 1, 1, 13, 30);
      expect(formatDateTime(dateTime), '1 Jan 2023, 1:30 PM');
    });
  });
}
