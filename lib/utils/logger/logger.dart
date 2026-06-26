import 'package:logger/logger.dart';

// class _CustomLogger extends LogPrinter {
//   dynamic className;
//
//   _CustomLogger(this.className);
//
//   _CustomLogger.only();
//
//   @override
//   List<String> log(LogEvent event) {
//     final String? emoji = PrettyPrinter.defaultLevelEmojis[event.level];
//     final AnsiColor? color = PrettyPrinter.defaultLevelColors[event.level];
//     if (className == null) return [color!('$emoji ${event.message}')];
//     return [color!('$emoji $className - ${event.message}')];
//   }
// }
//
// class Log {
//   /// info level
//   Log(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).i(message);
//   }
//
//   /// Log only
//   Log.o(dynamic message) {
//     Logger(printer: _CustomLogger.only()).i(message);
//   }
//
//   /// debug level
//   Log.d(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).d(message);
//   }
//
//   /// error level
//   Log.e(final dynamic runtimeType, dynamic message, [StackTrace? stackTrace]) {
//     if (stackTrace != null) {
//       Logger(printer: _CustomLogger(runtimeType)).e('$message\n$stackTrace');
//       return;
//     }
//
//     Logger(printer: _CustomLogger(runtimeType)).e(message);
//   }
//
//   /// trace level
//   Log.t(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).t(message);
//   }
//
//   /// warning level
//   Log.w(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).w(message);
//   }
//
//   /// info level
//   Log.i(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).i(message);
//   }
//
//   /// fatal level
//   Log.f(final dynamic runtimeType, dynamic message) {
//     Logger(printer: _CustomLogger(runtimeType)).f(message);
//   }
// }

class AppLogger {
  // 1. Single instance for the whole app
  static final _logger = Logger(
    filter: ProductionFilter(), // Only log in debug mode
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
    output: ConsoleOutput(), // Use the default console output
    level: Level.debug, // Log all messages at or above this level
  );

  // Private constructor to prevent instantiation
  AppLogger._();

  static void d(dynamic message, [dynamic tag]) {
    _logger.d(_format(message, tag));
  }

  static void i(dynamic message, [dynamic tag]) {
    _logger.i(_format(message, tag));
  }

  static void w(dynamic message, [dynamic tag]) {
    _logger.w(_format(message, tag));
  }

  static void e(
    dynamic message, [
    dynamic tag,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  // Helper to format the message with the Class Name/Tag
  static String _format(dynamic message, dynamic tag) {
    final String prefix = tag != null ? '[$tag] ' : '';
    return '$prefix$message';
  }

  // Inside the Log class
  // static void i(dynamic message, [dynamic tag]) {
  //   if (bool.fromEnvironment('dart.vm.product')) return; // Simple way to check for release mode
  //   _logger.i(_format(message, tag));
  // }
}
