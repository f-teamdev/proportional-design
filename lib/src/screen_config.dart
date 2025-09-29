import 'package:flutter/material.dart';
import 'package:proportional_design/proportional_design.dart';

class ScreenConfig {
  static bool _isStatusBarDisabled = false;
  static bool _isNavigationBarDisabled = false;
  static double _forcedStatusBarHeight = 0.0;
  static double _forcedBottomPadding = 0.0;

  static void setStatusBarDisabled(bool disabled) {
    _isStatusBarDisabled = disabled;
  }

  static void setNavigationBarDisabled(bool disabled) {
    _isNavigationBarDisabled = disabled;
  }

  static bool get isStatusBarDisabled => _isStatusBarDisabled;
  static bool get isNavigationBarDisabled => _isNavigationBarDisabled;

  static void setForcedStatusBarHeight(double height) {
    _forcedStatusBarHeight = height;
  }

  static void setForcedBottomPadding(double padding) {
    _forcedBottomPadding = padding;
  }

  static double get forcedStatusBarHeight => _forcedStatusBarHeight;
  static double get forcedBottomPadding => _forcedBottomPadding;

  static void reset() {
    _isStatusBarDisabled = false;
    _isNavigationBarDisabled = false;
    _forcedStatusBarHeight = 0.0;
    _forcedBottomPadding = 0.0;
  }
}

extension ScreenConfigExtension on BuildContext {
  double getAvailableHeightWithConfig({
    bool useSafeAreaTop = true,
    bool useSafeAreaBottom = true,
  }) {
    final effectiveUseSafeAreaTop =
        useSafeAreaTop && !ScreenConfig.isStatusBarDisabled;
    final effectiveUseSafeAreaBottom =
        useSafeAreaBottom && !ScreenConfig.isNavigationBarDisabled;

    return getAvailableHeight(
      useSafeAreaTop: effectiveUseSafeAreaTop,
      useSafeAreaBottom: effectiveUseSafeAreaBottom,
    );
  }

  double getAvailableHeightPercentageWithConfig(
    double percentage, {
    bool useSafeAreaTop = true,
    bool useSafeAreaBottom = true,
  }) {
    final availableHeight = getAvailableHeightWithConfig(
      useSafeAreaTop: useSafeAreaTop,
      useSafeAreaBottom: useSafeAreaBottom,
    );
    return availableHeight * percentage;
  }
}
