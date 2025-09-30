import 'package:flutter/material.dart';

/// Breakpoints baseados no Material Design 3
enum MaterialBreakpoint {
  /// Telas compactas - < 600dp (phones)
  compact,

  /// Telas médias - 600dp - 840dp (tablets pequenos, foldables)
  medium,

  /// Telas expandidas - > 840dp (tablets grandes, desktops)
  expanded,
}

/// Tipos de dispositivo
enum DeviceType {
  /// Smartphone - largura < 600dp
  phone,

  /// Tablet - 600dp <= largura < 1200dp
  tablet,

  /// Desktop - largura >= 1200dp
  desktop,

  /// Dispositivo dobrável
  foldable,
}

/// Detector inteligente de dispositivos seguindo padrões Material Design 3
class DeviceDetector {
  DeviceDetector._();

  /// Detecta o tipo de dispositivo baseado nas dimensões da tela
  static DeviceType detectDevice(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final longestSide = size.longestSide;

    // Lógica inteligente baseada em dimensões reais
    // Desktop: menor lado >= 1200dp
    if (shortestSide >= 1200) {
      return DeviceType.desktop;
    }

    // Tablet: menor lado >= 600dp E lado maior >= 900dp
    if (shortestSide >= 600 && longestSide >= 900) {
      return DeviceType.tablet;
    }

    // Phone: qualquer outro caso
    return DeviceType.phone;
  }

  /// Retorna o breakpoint Material Design 3 baseado na largura atual
  static MaterialBreakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return MaterialBreakpoint.compact;
    } else if (width < 840) {
      return MaterialBreakpoint.medium;
    } else {
      return MaterialBreakpoint.expanded;
    }
  }

  /// Verifica se é um tablet (qualquer orientação)
  static bool isTablet(BuildContext context) {
    return detectDevice(context) == DeviceType.tablet;
  }

  /// Verifica se é um phone (qualquer orientação)
  static bool isPhone(BuildContext context) {
    return detectDevice(context) == DeviceType.phone;
  }

  /// Verifica se é um desktop
  static bool isDesktop(BuildContext context) {
    return detectDevice(context) == DeviceType.desktop;
  }

  /// Retorna informações detalhadas sobre o dispositivo
  static Map<String, dynamic> getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceType = detectDevice(context);
    final breakpoint = getBreakpoint(context);

    return {
      'deviceType': deviceType.toString(),
      'breakpoint': breakpoint.toString(),
      'width': size.width,
      'height': size.height,
      'shortestSide': size.shortestSide,
      'longestSide': size.longestSide,
      'aspectRatio': size.width / size.height,
      'isPortrait': size.height > size.width,
      'isLandscape': size.width > size.height,
    };
  }
}

/// Extension para facilitar acesso aos métodos de detecção
extension DeviceDetectorExtension on BuildContext {
  /// Retorna o tipo de dispositivo atual
  DeviceType get deviceType => DeviceDetector.detectDevice(this);

  /// Retorna o breakpoint Material Design 3 atual
  MaterialBreakpoint get breakpoint => DeviceDetector.getBreakpoint(this);

  /// Verifica se é um tablet
  bool get isTabletDevice => DeviceDetector.isTablet(this);

  /// Verifica se é um phone
  bool get isPhoneDevice => DeviceDetector.isPhone(this);

  /// Verifica se é um desktop
  bool get isDesktopDevice => DeviceDetector.isDesktop(this);

  /// Retorna informações detalhadas do dispositivo
  Map<String, dynamic> get deviceInfo => DeviceDetector.getDeviceInfo(this);
}
