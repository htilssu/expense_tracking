import 'package:logger/logger.dart' as logger_lib;

class Logger {
  static logger_lib.Logger logger = logger_lib.Logger();

  static void info(dynamic message) {
    logger.i(message);
  }

  static void warn(dynamic message) {
    logger.w(message);
  }
}
