import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// ```dart
/// logger.d('Debug log');
/// logger.i('Info log');
/// logger.w('Warning log');
/// logger.e('Error log');
/// ```
class GsLogger {
  factory GsLogger() => _instance;

  GsLogger._() {
    _logger = Logger(
      printer: PrettyPrinter(
        colors: false,
        noBoxingByDefault: true,
        methodCount: 0,
      ),
    );
  }

  late Logger _logger;

  static final GsLogger _instance = GsLogger._();

  /// Log a message at level [LogLevel.debug].
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [LogLevel.info].
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [LogLevel.warning].
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [LogLevel.error].
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [LogLevel.critical].
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  @visibleForTesting
  set setLogger(Logger logger) {
    _logger = logger;
  }
}
