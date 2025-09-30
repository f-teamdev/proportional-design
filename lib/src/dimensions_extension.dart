import 'dart:math';
import 'package:flutter/material.dart';
import 'package:proportional_design/src/screen_config.dart';
import 'package:proportional_design/src/device_detector.dart';
import 'package:proportional_design/src/proportional_cache.dart';
import 'package:proportional_design/src/proportional_logger.dart';
import 'package:proportional_design/src/proportional_validator.dart';
import 'package:proportional_design/src/proportional_config.dart';

/// Extension para gerenciar dimensões da tela com estratégias adaptativas
/// Layout base padrão: 402x874 (configurável via ProportionalConfig)
extension DimensionsExtension on BuildContext {
  /// Dimensões do layout original (design base) - mantidas para compatibilidade
  static const double _originalWidth = 402.0;
  static const double _originalHeight = 874.0;

  /// Obtém a MediaQuery do contexto
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  /// Obtém a altura total da tela
  double get screenHeight => _mediaQuery.size.height;

  /// Obtém a largura total da tela
  double get screenWidth => _mediaQuery.size.width;

  // ==================== SAFE AREAS ====================

  double get statusBarHeight {
    if (ScreenConfig.forcedStatusBarHeight > 0) {
      return ScreenConfig.forcedStatusBarHeight;
    }
    return _mediaQuery.systemGestureInsets.top;
  }

  double get bottomPadding {
    if (ScreenConfig.forcedBottomPadding > 0) {
      return ScreenConfig.forcedBottomPadding;
    }
    return _mediaQuery.systemGestureInsets.bottom;
  }

  /// Verifica se a status bar está visível
  bool get isStatusBarVisible => _mediaQuery.viewPadding.top > 0;

  /// Verifica se a navigation bar está visível
  bool get isNavigationBarVisible => _mediaQuery.viewPadding.bottom > 0;

  double getAvailableHeight({
    bool useSafeAreaTop = true,
    bool useSafeAreaBottom = true,
  }) {
    final effectiveStatusBarHeight = useSafeAreaTop ? statusBarHeight : 0;
    final effectiveBottomPadding = useSafeAreaBottom ? bottomPadding : 0;
    final availableHeight =
        screenHeight - effectiveStatusBarHeight - effectiveBottomPadding;

    // Logging condicional
    ProportionalLogger.logDimensions('Available Height Calculation', {
      'availableHeight': availableHeight,
      'screenHeight': screenHeight,
      'statusBarHeight': statusBarHeight,
      'bottomPadding': bottomPadding,
      'useSafeAreaTop': useSafeAreaTop,
      'useSafeAreaBottom': useSafeAreaBottom,
    });

    return availableHeight;
  }

  double getFullScreenHeight() {
    return getAvailableHeight(useSafeAreaTop: false, useSafeAreaBottom: true);
  }

  double getHeightWithoutNavigationBar() {
    return getAvailableHeight(useSafeAreaTop: true, useSafeAreaBottom: false);
  }

  double getFullScreenHeightWithoutBars() {
    return getAvailableHeight(useSafeAreaTop: false, useSafeAreaBottom: false);
  }

  // ==================== CÁLCULOS PROPORCIONAIS MELHORADOS ====================

  /// Calcula tamanho proporcional com estratégia adaptativa
  double getProportionalSizeAdaptive(
    double originalPixels, {
    bool isWidth = true,
    ScalingStrategy? strategy,
  }) {
    final effectiveStrategy = strategy ?? ProportionalConfig.defaultStrategy;

    switch (effectiveStrategy) {
      case ScalingStrategy.linear:
        return _getLinearSize(originalPixels, isWidth: isWidth);
      case ScalingStrategy.adaptive:
        return _getAdaptiveSize(originalPixels, isWidth: isWidth);
      case ScalingStrategy.aspectRatio:
        return _getAspectRatioSize(originalPixels, isWidth: isWidth);
      case ScalingStrategy.density:
        return _getDensitySize(originalPixels, isWidth: isWidth);
      case ScalingStrategy.material:
        return _getMaterialSize(originalPixels, isWidth: isWidth);
    }
  }

  /// Escala linear simples (comportamento original)
  double _getLinearSize(double originalPixels, {required bool isWidth}) {
    final cacheKey = ProportionalCache.generateKey(
      originalPixels,
      isWidth,
      isWidth ? screenWidth : screenHeight,
      prefix: 'linear',
    );

    return ProportionalCache.getCachedSize(cacheKey, () {
      final baseSize = ProportionalConfig.baseSize;
      final baseDimension = isWidth ? baseSize.width : baseSize.height;
      final currentDimension = isWidth ? screenWidth : screenHeight;
      return (originalPixels / baseDimension) * currentDimension;
    });
  }

  /// Escala adaptativa por tipo de dispositivo
  double _getAdaptiveSize(double originalPixels, {required bool isWidth}) {
    final deviceType = this.deviceType;
    final cacheKey = ProportionalCache.generateDeviceKey(
      originalPixels,
      deviceType.toString(),
      isWidth,
    );

    return ProportionalCache.getCachedSize(cacheKey, () {
      final baseSize = ProportionalConfig.getBaseSizeForDevice(deviceType);
      final baseDimension = isWidth ? baseSize.width : baseSize.height;
      final currentDimension = isWidth ? screenWidth : screenHeight;
      final scaleFactor = ProportionalConfig.getScaleFactor(deviceType);

      return (originalPixels / baseDimension) * currentDimension * scaleFactor;
    });
  }

  /// Escala baseada em aspect ratio
  double _getAspectRatioSize(double originalPixels, {required bool isWidth}) {
    final cacheKey = ProportionalCache.generateKey(
      originalPixels,
      isWidth,
      isWidth ? screenWidth : screenHeight,
      prefix: 'aspect',
    );

    return ProportionalCache.getCachedSize(cacheKey, () {
      final baseSize = ProportionalConfig.baseSize;
      final baseDimension = isWidth ? baseSize.width : baseSize.height;
      final currentDimension = isWidth ? screenWidth : screenHeight;

      final currentRatio = screenWidth / screenHeight;
      final originalRatio = baseSize.width / baseSize.height;
      final ratioFactor = sqrt(currentRatio / originalRatio);

      return (originalPixels / baseDimension) * currentDimension * ratioFactor;
    });
  }

  /// Escala baseada em densidade de pixels
  double _getDensitySize(double originalPixels, {required bool isWidth}) {
    final cacheKey = ProportionalCache.generateKey(
      originalPixels,
      isWidth,
      isWidth ? screenWidth : screenHeight,
      prefix: 'density',
    );

    return ProportionalCache.getCachedSize(cacheKey, () {
      final pixelRatio = _mediaQuery.devicePixelRatio;
      final textScaler = _mediaQuery.textScaler.scale(1.0);

      final densityFactor = pixelRatio / 2.0;
      final linearSize = _getLinearSize(originalPixels, isWidth: isWidth);

      return linearSize * densityFactor * textScaler;
    });
  }

  /// Escala seguindo Material Design guidelines
  double _getMaterialSize(double originalPixels, {required bool isWidth}) {
    final breakpoint = this.breakpoint;
    final cacheKey = ProportionalCache.generateKey(
      originalPixels,
      isWidth,
      isWidth ? screenWidth : screenHeight,
      prefix: 'material_${breakpoint.toString()}',
    );

    return ProportionalCache.getCachedSize(cacheKey, () {
      switch (breakpoint) {
        case MaterialBreakpoint.compact:
          return _getCompactSize(originalPixels, isWidth: isWidth);
        case MaterialBreakpoint.medium:
          return _getMediumSize(originalPixels, isWidth: isWidth);
        case MaterialBreakpoint.expanded:
          return _getExpandedSize(originalPixels, isWidth: isWidth);
      }
    });
  }

  double _getCompactSize(double originalPixels, {required bool isWidth}) {
    final baseSize = ProportionalConfig.baseSize;
    final baseDimension = isWidth ? baseSize.width : baseSize.height;
    final currentDimension = isWidth ? screenWidth : screenHeight;
    final scaleFactor = min(currentDimension / baseDimension, 1.2);
    return originalPixels * scaleFactor;
  }

  double _getMediumSize(double originalPixels, {required bool isWidth}) {
    final baseSize = ProportionalConfig.baseSize;
    final baseDimension = isWidth ? baseSize.width : baseSize.height;
    final currentDimension = isWidth ? screenWidth : screenHeight;
    final scaleFactor = currentDimension / baseDimension;
    return originalPixels * scaleFactor * 1.1;
  }

  double _getExpandedSize(double originalPixels, {required bool isWidth}) {
    final density = _mediaQuery.devicePixelRatio;
    final baseSize = ProportionalConfig.baseSize;
    final baseDimension = isWidth ? baseSize.width : baseSize.height;
    final currentDimension = isWidth ? screenWidth : screenHeight;
    final scaleFactor = (currentDimension / baseDimension) * (density / 2.0);
    return originalPixels * scaleFactor;
  }

  // ==================== MÉTODOS COMPATÍVEIS COM API ANTIGA ====================

  double getProportionalSize(double originalPixels, {bool isWidth = true}) {
    return getProportionalSizeAdaptive(
      originalPixels,
      isWidth: isWidth,
      strategy: ProportionalConfig.defaultStrategy,
    );
  }

  double getProportionalWidth(double originalWidth) {
    return getProportionalSize(originalWidth, isWidth: true);
  }

  double getProportionalHeight(double originalHeight) {
    return getProportionalSize(originalHeight, isWidth: false);
  }

  // ==================== PORCENTAGENS COM VALIDAÇÃO ====================

  double getWidthPercentage(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage,
          paramName: 'width percentage');
      final baseSize = ProportionalConfig.baseSize;
      return getProportionalWidth(baseSize.width * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getWidthPercentage', e);
      final safePercentage = ProportionalSafeValues.safePercentage(percentage);
      final baseSize = ProportionalConfig.baseSize;
      return getProportionalWidth(baseSize.width * safePercentage);
    }
  }

  double getHeightPercentage(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage,
          paramName: 'height percentage');
      final baseSize = ProportionalConfig.baseSize;
      return getProportionalHeight(baseSize.height * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getHeightPercentage', e);
      final safePercentage = ProportionalSafeValues.safePercentage(percentage);
      final baseSize = ProportionalConfig.baseSize;
      return getProportionalHeight(baseSize.height * safePercentage);
    }
  }

  double getAvailableHeightPercentage(
    double percentage, {
    bool useSafeAreaTop = true,
    bool useSafeAreaBottom = true,
  }) {
    try {
      ProportionalValidator.validatePercentage(percentage);
      final availableHeight = getAvailableHeight(
        useSafeAreaTop: useSafeAreaTop,
        useSafeAreaBottom: useSafeAreaBottom,
      );
      final availableHeightRatio = availableHeight / screenHeight;
      final baseSize = ProportionalConfig.baseSize;
      final originalAvailableHeight = baseSize.height * availableHeightRatio;
      return getProportionalHeight(originalAvailableHeight * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getAvailableHeightPercentage', e);
      return 0.0;
    }
  }

  // ==================== INFORMAÇÕES DA TELA ====================

  Map<String, dynamic> getScreenInfo() {
    return {
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'statusBarHeight': statusBarHeight,
      'bottomPadding': bottomPadding,
      'isStatusBarVisible': isStatusBarVisible,
      'isNavigationBarVisible': isNavigationBarVisible,
      'availableHeight': getAvailableHeight(),
      'fullScreenHeight': getFullScreenHeight(),
      'aspectRatio': screenWidth / screenHeight,
      'deviceType': deviceType.toString(),
      'breakpoint': breakpoint.toString(),
      'pixelRatio': _mediaQuery.devicePixelRatio,
    };
  }

  // ==================== ORIENTAÇÃO E DISPOSITIVO ====================

  bool get isLandscape => screenWidth > screenHeight;
  bool get isPortrait => screenWidth < screenHeight;
  double get minDimension =>
      screenWidth < screenHeight ? screenWidth : screenHeight;
  double get maxDimension =>
      screenWidth > screenHeight ? screenWidth : screenHeight;

  /// Mantido para compatibilidade - usar deviceType preferencialment
  bool get isTablet => isTabletDevice;
  bool get isPhone => isPhoneDevice;

  // Novos breakpoints (usar breakpoint)
  bool get isSmallScreen => breakpoint == MaterialBreakpoint.compact;
  bool get isMediumScreen => breakpoint == MaterialBreakpoint.medium;
  bool get isLargeScreen => breakpoint == MaterialBreakpoint.expanded;

  String get screenBreakpoint {
    switch (breakpoint) {
      case MaterialBreakpoint.compact:
        return 'compact';
      case MaterialBreakpoint.medium:
        return 'medium';
      case MaterialBreakpoint.expanded:
        return 'expanded';
    }
  }

  int get responsiveColumns {
    switch (deviceType) {
      case DeviceType.phone:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
      case DeviceType.foldable:
        return 2;
    }
  }

  // ==================== TIPOGRAFIA ====================

  double getProportionalFontSize(double originalFontSize) {
    return getProportionalSize(originalFontSize, isWidth: false);
  }

  double getFontSizePercentage(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage);
      return getProportionalFontSize(_originalHeight * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getFontSizePercentage', e);
      return getProportionalFontSize(_originalHeight * 0.02); // Fallback: 2%
    }
  }

  double getFontSizeByMinDimension(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage);
      final originalMinDimension =
          _originalWidth < _originalHeight ? _originalWidth : _originalHeight;
      return getProportionalFontSize(originalMinDimension * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getFontSizeByMinDimension', e);
      return getProportionalFontSize(_originalWidth * 0.04); // Fallback: 4%
    }
  }

  double getResponsiveFontSize(double baseSize, {double scaleFactor = 1.0}) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    final textScaler = _mediaQuery.textScaler;
    return baseSize * scaleFactor * textScaler.scale(1.0) * (pixelRatio / 3.0);
  }

  double getResponsiveFontSizeByBreakpoint({
    double small = 14.0,
    double medium = 16.0,
    double large = 18.0,
  }) {
    if (isSmallScreen) return getProportionalFontSize(small);
    if (isMediumScreen) return getProportionalFontSize(medium);
    return getProportionalFontSize(large);
  }

  // ==================== ESPAÇAMENTO ====================

  double getProportionalSpacing(double originalSpacing) {
    return getProportionalSize(originalSpacing, isWidth: true);
  }

  double getSpacingPercentage(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage);
      return getProportionalSpacing(_originalWidth * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getSpacingPercentage', e);
      return 0.0;
    }
  }

  double getResponsiveSpacing(double baseSpacing) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    return baseSpacing * (pixelRatio / 3.0);
  }

  double getResponsiveSpacingByBreakpoint({
    double small = 8.0,
    double medium = 16.0,
    double large = 24.0,
  }) {
    if (isSmallScreen) return getProportionalSpacing(small);
    if (isMediumScreen) return getProportionalSpacing(medium);
    return getProportionalSpacing(large);
  }

  // ==================== PADDING ====================

  double getProportionalPadding(double originalPadding) {
    return getProportionalSize(originalPadding, isWidth: true);
  }

  EdgeInsets getProportionalEdgeInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left != null
          ? getProportionalPadding(left)
          : getProportionalPadding(horizontal ?? all ?? 0),
      right: right != null
          ? getProportionalPadding(right)
          : getProportionalPadding(horizontal ?? all ?? 0),
      top: top != null
          ? getProportionalPadding(top)
          : getProportionalPadding(vertical ?? all ?? 0),
      bottom: bottom != null
          ? getProportionalPadding(bottom)
          : getProportionalPadding(vertical ?? all ?? 0),
    );
  }

  EdgeInsets getProportionalEdgeInsetsAll(double padding) {
    return EdgeInsets.all(getProportionalPadding(padding));
  }

  EdgeInsets getProportionalEdgeInsetsSymmetric({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal != null ? getProportionalPadding(horizontal) : 0,
      vertical: vertical != null ? getProportionalPadding(vertical) : 0,
    );
  }

  // ==================== MARGIN ====================

  double getProportionalMargin(double originalMargin) {
    return getProportionalSize(originalMargin, isWidth: true);
  }

  EdgeInsets getProportionalMarginInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left != null
          ? getProportionalMargin(left)
          : getProportionalMargin(horizontal ?? all ?? 0),
      right: right != null
          ? getProportionalMargin(right)
          : getProportionalMargin(horizontal ?? all ?? 0),
      top: top != null
          ? getProportionalMargin(top)
          : getProportionalMargin(vertical ?? all ?? 0),
      bottom: bottom != null
          ? getProportionalMargin(bottom)
          : getProportionalMargin(vertical ?? all ?? 0),
    );
  }

  // ==================== BORDER RADIUS ====================

  double getProportionalBorderRadius(double originalRadius) {
    return getProportionalSize(originalRadius, isWidth: true);
  }

  BorderRadius getProportionalBorderRadiusAll(double radius) {
    final proportionalRadius = getProportionalBorderRadius(radius);
    return BorderRadius.circular(proportionalRadius);
  }

  BorderRadius getProportionalBorderRadiusCustom({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return BorderRadius.only(
      topLeft: topLeft != null
          ? Radius.circular(getProportionalBorderRadius(topLeft))
          : Radius.zero,
      topRight: topRight != null
          ? Radius.circular(getProportionalBorderRadius(topRight))
          : Radius.zero,
      bottomLeft: bottomLeft != null
          ? Radius.circular(getProportionalBorderRadius(bottomLeft))
          : Radius.zero,
      bottomRight: bottomRight != null
          ? Radius.circular(getProportionalBorderRadius(bottomRight))
          : Radius.zero,
    );
  }

  // ==================== WIDGETS SIZE ====================

  double getProportionalWidgetSize(double originalSize, {bool isWidth = true}) {
    return getProportionalSize(originalSize, isWidth: isWidth);
  }

  Size getProportionalSizeObject(double width, double height) {
    return Size(getProportionalWidth(width), getProportionalHeight(height));
  }

  // ==================== ÍCONES ====================

  double getProportionalIconSize(double originalIconSize) {
    return getProportionalSize(originalIconSize, isWidth: true);
  }

  double getIconSizePercentage(double percentage) {
    try {
      ProportionalValidator.validatePercentage(percentage);
      return getProportionalIconSize(_originalWidth * percentage);
    } catch (e) {
      ProportionalLogger.logError('Error in getIconSizePercentage', e);
      return 24.0; // Fallback icon size
    }
  }

  // ==================== BORDAS ====================

  double getProportionalBorderWidth(double originalBorderWidth) {
    return getProportionalSize(originalBorderWidth, isWidth: true);
  }

  BorderSide getProportionalBorderSide({
    double width = 1.0,
    Color color = Colors.black,
    BorderStyle style = BorderStyle.solid,
  }) {
    return BorderSide(
      width: getProportionalBorderWidth(width),
      color: color,
      style: style,
    );
  }

  // ==================== SOMBRAS ====================

  Offset getProportionalShadowOffset(double dx, double dy) {
    return Offset(
      getProportionalSize(dx, isWidth: true),
      getProportionalSize(dy, isWidth: false),
    );
  }

  double getProportionalShadowBlurRadius(double originalBlurRadius) {
    return getProportionalSize(originalBlurRadius, isWidth: true);
  }

  BoxShadow getProportionalBoxShadow({
    double dx = 0.0,
    double dy = 0.0,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    Color color = Colors.black,
  }) {
    return BoxShadow(
      offset: getProportionalShadowOffset(dx, dy),
      blurRadius: getProportionalShadowBlurRadius(blurRadius),
      spreadRadius: getProportionalSize(spreadRadius, isWidth: true),
      color: color,
    );
  }

  // ==================== GRADIENTES ====================

  List<double> getProportionalGradientStops(List<double> originalStops) {
    return originalStops
        .map((stop) => getProportionalSize(stop, isWidth: true))
        .toList();
  }

  // ==================== ANIMAÇÕES ====================

  Duration getResponsiveAnimationDuration(int baseDuration) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    final adjustedDuration = (baseDuration * (pixelRatio / 3.0)).round();
    return Duration(milliseconds: adjustedDuration);
  }
}

/// Extension para facilitar o uso de dimensões proporcionais
extension DimensionsHelper on num {
  double get dp => toDouble();
  double get sp => toDouble();
}
