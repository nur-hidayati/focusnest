import 'package:intl/intl.dart';

// Contains utility functions for manipulating and formatting DateTime and Duration objects
DateTime addDays(DateTime dateTime, int days) {
  return dateTime.add(Duration(days: days));
}

DateTime subtractDays(DateTime dateTime, int days) {
  return dateTime.subtract(Duration(days: days));
}

// Format Duration object into a string in the format HH:MM:SS i.e. "1:02:02"
// If the duration is less than an hour, it formats it as MM:SS i.e. "12:02".
String formatDurationToHms(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

// Formats Duration into a human-readable string
// It displays the duration in hours and minutes i.e. "1 hour 2 minutes" and "2 minutes".

String formatDurationsToReadable(Duration duration) {
  String formattedTime = "";

  if (duration.inHours > 0) {
    formattedTime +=
        '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'}';
  }
  int remainingMinutes = duration.inMinutes.remainder(60);
  if (remainingMinutes > 0) {
    if (formattedTime.isNotEmpty) formattedTime += ' ';
    formattedTime +=
        '$remainingMinutes ${remainingMinutes == 1 ? 'minute' : 'minutes'}';
  }
  return formattedTime;
}

// Formats DateTime into HH:MM i.e. "1.30 PM".
String formatTime(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

// Formats DateTime into 'd MMM yyyy, h:mm a' i.e. "1 Jan 2022, 1:30 PM" .
String formatDateTime(DateTime dateTime) {
  return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
}
