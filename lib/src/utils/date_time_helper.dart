import 'package:intl/intl.dart';

DateTime addDays(DateTime dateTime, int days) {
  return dateTime.add(Duration(days: days));
}

DateTime subtractDays(DateTime dateTime, int days) {
  return dateTime.subtract(Duration(days: days));
}

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

String formatTime(DateTime dateTime) {
  return DateFormat.jm().format(dateTime);
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
}
