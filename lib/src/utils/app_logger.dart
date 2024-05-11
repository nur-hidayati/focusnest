import 'package:logger/logger.dart';

class AppLogger {
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 300,
      colors: true,
      printEmojis: true,
    ),
  );

  static void logDebug(String message) {
    logger.d(message);
  }

  static void logInfo(String message) {
    logger.i(message);
  }

  static void logWarning(String message) {
    logger.w(message);
  }

  static void logError(String message) {
    logger.e(message);
  }

  static void logTrace(String message) {
    logger.t(message);
  }

  static void logFatal(String message) {
    logger.f(message);
  }
}
