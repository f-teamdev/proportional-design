import 'package:flutter/material.dart';

/// Sistema de validação robusto para valores proporcionais
class ProportionalValidator {
  ProportionalValidator._();

  /// Valida porcentagem (0.0 a 1.0)
  static void validatePercentage(double percentage, {String? paramName}) {
    if (percentage < 0.0 || percentage > 1.0) {
      throw ArgumentError(
        'Percentage must be between 0.0 and 1.0, got $percentage',
        paramName ?? 'percentage',
      );
    }
  }

  /// Valida que um valor é positivo
  static void validatePositive(double value, String parameterName) {
    if (value < 0) {
      throw ArgumentError(
        '$parameterName must be positive, got $value',
        parameterName,
      );
    }
  }

  /// Valida que um valor não é zero
  static void validateNonZero(double value, String parameterName) {
    if (value == 0) {
      throw ArgumentError(
        '$parameterName cannot be zero',
        parameterName,
      );
    }
  }

  /// Valida tamanho de tela
  static void validateScreenSize(Size size) {
    if (size.width <= 0 || size.height <= 0) {
      throw ArgumentError(
        'Screen size must be positive, got ${size.width}x${size.height}',
        'size',
      );
    }
  }

  /// Valida que um contexto tem MediaQuery
  static bool hasMediaQuery(BuildContext context) {
    try {
      MediaQuery.of(context);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Valida valor dentro de um range
  static void validateRange(
    double value,
    double min,
    double max,
    String parameterName,
  ) {
    if (value < min || value > max) {
      throw ArgumentError(
        '$parameterName must be between $min and $max, got $value',
        parameterName,
      );
    }
  }

  /// Valida EdgeInsets
  static void validateEdgeInsets(EdgeInsets insets) {
    if (insets.left < 0 ||
        insets.right < 0 ||
        insets.top < 0 ||
        insets.bottom < 0) {
      throw ArgumentError(
        'EdgeInsets values must be non-negative',
        'insets',
      );
    }
  }
}

/// Classe para fornecer valores seguros com fallbacks
class ProportionalSafeValues {
  ProportionalSafeValues._();

  /// Retorna valor seguro de porcentagem (clampado entre 0 e 1)
  static double safePercentage(double percentage) {
    return percentage.clamp(0.0, 1.0);
  }

  /// Retorna valor positivo seguro (mínimo 0)
  static double safePositive(double value) {
    return value < 0 ? 0.0 : value;
  }

  /// Retorna valor não-zero seguro
  static double safeNonZero(double value, {double fallback = 1.0}) {
    return value == 0 ? fallback : value;
  }

  /// Retorna valor dentro de um range seguro
  static double safeRange(double value, double min, double max) {
    return value.clamp(min, max);
  }

  /// Retorna EdgeInsets seguro (valores não-negativos)
  static EdgeInsets safeEdgeInsets(EdgeInsets insets) {
    return EdgeInsets.only(
      left: safePositive(insets.left),
      right: safePositive(insets.right),
      top: safePositive(insets.top),
      bottom: safePositive(insets.bottom),
    );
  }
}
