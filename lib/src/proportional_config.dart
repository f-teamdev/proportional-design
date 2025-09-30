import 'package:flutter/material.dart';
import 'device_detector.dart';

/// Estratégias de escala disponíveis
enum ScalingStrategy {
  /// Escala linear simples (comportamento padrão atual)
  linear,

  /// Escala adaptativa por tipo de dispositivo
  adaptive,

  /// Escala baseada em aspect ratio
  aspectRatio,

  /// Escala baseada em densidade de pixels
  density,

  /// Escala seguindo Material Design guidelines
  material,
}

/// Configuração global do sistema proporcional
class ProportionalConfig {
  ProportionalConfig._();

  // Dimensões base padrão (atual: 402x874)
  static Size _baseSize = const Size(402.0, 874.0);

  // Dimensões base por tipo de dispositivo
  static final Map<DeviceType, Size> _baseSizesByDevice = {
    DeviceType.phone: const Size(375, 812), // iPhone X
    DeviceType.tablet: const Size(768, 1024), // iPad
    DeviceType.desktop: const Size(1920, 1080), // Desktop HD
    DeviceType.foldable: const Size(673, 841), // Galaxy Fold unfolded
  };

  // Estratégia de escala padrão
  static ScalingStrategy _defaultStrategy = ScalingStrategy.adaptive;

  // Fatores de escala por dispositivo (para estratégia adaptativa)
  static final Map<DeviceType, double> _scaleFactors = {
    DeviceType.phone: 1.0,
    DeviceType.tablet: 1.2,
    DeviceType.desktop: 1.0,
    DeviceType.foldable: 1.1,
  };

  /// Define o tamanho base de referência
  static void setBaseSize(Size size) {
    if (size.width <= 0 || size.height <= 0) {
      throw ArgumentError('Base size must have positive dimensions');
    }
    _baseSize = size;
  }

  /// Retorna o tamanho base atual
  static Size get baseSize => _baseSize;

  /// Define o tamanho base para um tipo de dispositivo específico
  static void setBaseSizeForDevice(DeviceType deviceType, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      throw ArgumentError('Base size must have positive dimensions');
    }
    _baseSizesByDevice[deviceType] = size;
  }

  /// Retorna o tamanho base para um tipo de dispositivo
  static Size getBaseSizeForDevice(DeviceType deviceType) {
    return _baseSizesByDevice[deviceType] ?? _baseSize;
  }

  /// Define a estratégia de escala padrão
  static void setDefaultStrategy(ScalingStrategy strategy) {
    _defaultStrategy = strategy;
  }

  /// Retorna a estratégia padrão
  static ScalingStrategy get defaultStrategy => _defaultStrategy;

  /// Define o fator de escala para um tipo de dispositivo
  static void setScaleFactor(DeviceType deviceType, double factor) {
    if (factor <= 0) {
      throw ArgumentError('Scale factor must be positive');
    }
    _scaleFactors[deviceType] = factor;
  }

  /// Retorna o fator de escala para um tipo de dispositivo
  static double getScaleFactor(DeviceType deviceType) {
    return _scaleFactors[deviceType] ?? 1.0;
  }

  /// Reseta todas as configurações para os valores padrão
  static void reset() {
    _baseSize = const Size(402.0, 874.0);
    _defaultStrategy = ScalingStrategy.adaptive;
    _baseSizesByDevice.clear();
    _baseSizesByDevice.addAll({
      DeviceType.phone: const Size(375, 812),
      DeviceType.tablet: const Size(768, 1024),
      DeviceType.desktop: const Size(1920, 1080),
      DeviceType.foldable: const Size(673, 841),
    });
    _scaleFactors.clear();
    _scaleFactors.addAll({
      DeviceType.phone: 1.0,
      DeviceType.tablet: 1.2,
      DeviceType.desktop: 1.0,
      DeviceType.foldable: 1.1,
    });
  }

  /// Retorna informações sobre a configuração atual
  static Map<String, dynamic> get info => {
        'baseSize': '${_baseSize.width}x${_baseSize.height}',
        'defaultStrategy': _defaultStrategy.toString(),
        'scaleFactors':
            _scaleFactors.map((key, value) => MapEntry(key.toString(), value)),
        'baseSizesByDevice': _baseSizesByDevice.map(
          (key, value) =>
              MapEntry(key.toString(), '${value.width}x${value.height}'),
        ),
      };
}
