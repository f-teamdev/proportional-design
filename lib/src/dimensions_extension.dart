import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:proportional_design/src/screen_config.dart';

/// Extension para gerenciar dimensões da tela
/// Layout base desenvolvido em 402x874
extension DimensionsExtension on BuildContext {
  /// Dimensões do layout original (design base)
  static const double _originalWidth = 402.0;
  static const double _originalHeight = 874.0;

  /// Obtém a MediaQuery do contexto
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  /// Obtém a altura total da tela
  double get screenHeight => _mediaQuery.size.height;

  /// Obtém a largura total da tela
  double get screenWidth => _mediaQuery.size.width;

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

    log('=== Screen Dimensions Debug (systemGestureInsets) ===');
    log('availableHeight: $availableHeight');
    log('screenHeight: $screenHeight');
    log('statusBarHeight: $statusBarHeight');
    log('bottomPadding: $bottomPadding');
    log('useSafeAreaTop: $useSafeAreaTop');
    log('useSafeAreaBottom: $useSafeAreaBottom');
    log('==============================');

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

  double getProportionalSize(double originalPixels, {bool isWidth = true}) {
    final baseDimension = isWidth ? _originalWidth : _originalHeight;
    final currentDimension = isWidth ? screenWidth : screenHeight;
    return (originalPixels / baseDimension) * currentDimension;
  }

  double getProportionalWidth(double originalWidth) {
    return getProportionalSize(originalWidth, isWidth: true);
  }

  double getProportionalHeight(double originalHeight) {
    return getProportionalSize(originalHeight, isWidth: false);
  }

  double getWidthPercentage(double percentage) {
    assert(
      percentage >= 0.0 && percentage <= 1.0,
      'Percentage must be between 0.0 and 1.0',
    );
    return getProportionalWidth(_originalWidth * percentage);
  }

  double getHeightPercentage(double percentage) {
    assert(
      percentage >= 0.0 && percentage <= 1.0,
      'Percentage must be between 0.0 and 1.0',
    );
    return getProportionalHeight(_originalHeight * percentage);
  }

  double getAvailableHeightPercentage(
    double percentage, {
    bool useSafeAreaTop = true,
    bool useSafeAreaBottom = true,
  }) {
    assert(
      percentage >= 0.0 && percentage <= 1.0,
      'Percentage must be between 0.0 and 1.0',
    );
    final availableHeight = getAvailableHeight(
      useSafeAreaTop: useSafeAreaTop,
      useSafeAreaBottom: useSafeAreaBottom,
    );
    final availableHeightRatio = availableHeight / screenHeight;
    final originalAvailableHeight = _originalHeight * availableHeightRatio;
    return getProportionalHeight(originalAvailableHeight * percentage);
  }

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
    };
  }

  bool get isLandscape => screenWidth > screenHeight;
  bool get isPortrait => screenWidth < screenHeight;
  double get minDimension =>
      screenWidth < screenHeight ? screenWidth : screenHeight;
  double get maxDimension =>
      screenWidth > screenHeight ? screenWidth : screenHeight;

  double getProportionalFontSize(double originalFontSize) {
    return getProportionalSize(originalFontSize, isWidth: false);
  }

  double getFontSizePercentage(double percentage) {
    assert(
      percentage >= 0.0 && percentage <= 1.0,
      'Percentage must be between 0.0 and 1.0',
    );
    return getProportionalFontSize(_originalHeight * percentage);
  }

  double getFontSizeByMinDimension(double percentage) {
    assert(
      percentage >= 0.0 && percentage <= 1.0,
      'Percentage must be between 0.0 and 1.0',
    );
    final originalMinDimension =
        _originalWidth < _originalHeight ? _originalWidth : _originalHeight;
    return getProportionalFontSize(originalMinDimension * percentage);
  }

  double getResponsiveFontSize(double baseSize, {double scaleFactor = 1.0}) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    final textScaler = _mediaQuery.textScaler;
    return baseSize * scaleFactor * textScaler.scale(1.0) * (pixelRatio / 3.0);
  }

  double getProportionalSpacing(double originalSpacing) {
    return getProportionalSize(originalSpacing, isWidth: true);
  }

  double getSpacingPercentage(double percentage) {
    return getProportionalSpacing(_originalWidth * percentage);
  }

  double getResponsiveSpacing(double baseSpacing) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    return baseSpacing * (pixelRatio / 3.0);
  }

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
          : (horizontal ?? all ?? 0),
      right: right != null
          ? getProportionalPadding(right)
          : (horizontal ?? all ?? 0),
      top: top != null ? getProportionalPadding(top) : (vertical ?? all ?? 0),
      bottom: bottom != null
          ? getProportionalPadding(bottom)
          : (vertical ?? all ?? 0),
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
      left:
          left != null ? getProportionalMargin(left) : (horizontal ?? all ?? 0),
      right: right != null
          ? getProportionalMargin(right)
          : (horizontal ?? all ?? 0),
      top: top != null ? getProportionalMargin(top) : (vertical ?? all ?? 0),
      bottom: bottom != null
          ? getProportionalMargin(bottom)
          : (vertical ?? all ?? 0),
    );
  }

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

  double getProportionalWidgetSize(double originalSize, {bool isWidth = true}) {
    return getProportionalSize(originalSize, isWidth: isWidth);
  }

  Size getProportionalSizeObject(double width, double height) {
    return Size(getProportionalWidth(width), getProportionalHeight(height));
  }

  double getProportionalIconSize(double originalIconSize) {
    return getProportionalSize(originalIconSize, isWidth: true);
  }

  double getIconSizePercentage(double percentage) {
    return getProportionalIconSize(_originalWidth * percentage);
  }

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

  List<double> getProportionalGradientStops(List<double> originalStops) {
    return originalStops
        .map((stop) => getProportionalSize(stop, isWidth: true))
        .toList();
  }

  Duration getResponsiveAnimationDuration(int baseDuration) {
    final pixelRatio = _mediaQuery.devicePixelRatio;
    final adjustedDuration = (baseDuration * (pixelRatio / 3.0)).round();
    return Duration(milliseconds: adjustedDuration);
  }

  bool get isSmallScreen => screenWidth < 400;
  bool get isMediumScreen => screenWidth >= 400 && screenWidth < 800;
  bool get isLargeScreen => screenWidth >= 800;

  // Adicionar detecção específica para tablets
  bool get isTablet => screenWidth >= 600;
  bool get isPhone => screenWidth < 600;

  String get screenBreakpoint {
    if (isSmallScreen) return 'small';
    if (isMediumScreen) return 'medium';
    return 'large';
  }

  int get responsiveColumns {
    if (isSmallScreen) return 1;
    if (isMediumScreen) return 2;
    return 3;
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

  double getResponsiveFontSizeByBreakpoint({
    double small = 14.0,
    double medium = 16.0,
    double large = 18.0,
  }) {
    if (isSmallScreen) return getProportionalFontSize(small);
    if (isMediumScreen) return getProportionalFontSize(medium);
    return getProportionalFontSize(large);
  }
}

// Extension para facilitar o uso de dimensões proporcionais
extension DimensionsHelper on num {
  double get dp => toDouble();
  double get sp => toDouble();
}
