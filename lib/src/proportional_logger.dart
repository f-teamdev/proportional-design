import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Sistema de logging condicional para o package
class ProportionalLogger {
  ProportionalLogger._();

  static bool _debugMode = kDebugMode;
  static bool _verboseMode = false;

  /// Habilita/desabilita o modo debug
  static void setDebugMode(bool enabled) => _debugMode = enabled;

  /// Habilita/desabilita o modo verbose
  static void setVerboseMode(bool enabled) => _verboseMode = enabled;

  /// Retorna se o modo debug está ativo
  static bool get isDebugMode => _debugMode;

  /// Retorna se o modo verbose está ativo
  static bool get isVerboseMode => _verboseMode;

  /// Log básico (apenas em debug mode)
  static void log(String message, {bool verbose = false}) {
    if (!_debugMode) return;
    if (verbose && !_verboseMode) return;

    developer.log('ProportionalDesign: $message');
  }

  /// Log de informações de dimensões
  static void logDimensions(String context, Map<String, dynamic> data) {
    if (!_verboseMode) return;

    final buffer = StringBuffer();
    buffer.writeln('=== $context ===');
    data.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    buffer.writeln('==================');

    developer.log(buffer.toString());
  }

  /// Log de erro (sempre ativo, mesmo em release)
  static void logError(String message,
      [Object? error, StackTrace? stackTrace]) {
    developer.log(
      'ProportionalDesign ERROR: $message',
      error: error,
      stackTrace: stackTrace,
      level: 1000, // Error level
    );
  }

  /// Log de aviso
  static void logWarning(String message) {
    if (!_debugMode) return;
    developer.log('ProportionalDesign WARNING: $message', level: 900);
  }

  /// Log de informação detalhada
  static void logInfo(String message) {
    if (!_verboseMode) return;
    developer.log('ProportionalDesign INFO: $message', level: 800);
  }
}
