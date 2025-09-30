import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proportional_design/proportional_design.dart';

void main() {
  group('ProportionalValidator Tests', () {
    test('should validate percentage correctly', () {
      expect(
        () => ProportionalValidator.validatePercentage(0.5),
        returnsNormally,
      );
      expect(
        () => ProportionalValidator.validatePercentage(0.0),
        returnsNormally,
      );
      expect(
        () => ProportionalValidator.validatePercentage(1.0),
        returnsNormally,
      );
    });

    test('should throw error for invalid percentage', () {
      expect(
        () => ProportionalValidator.validatePercentage(1.5),
        throwsArgumentError,
      );
      expect(
        () => ProportionalValidator.validatePercentage(-0.1),
        throwsArgumentError,
      );
    });

    test('should validate positive values', () {
      expect(
        () => ProportionalValidator.validatePositive(10.0, 'test'),
        returnsNormally,
      );
      expect(
        () => ProportionalValidator.validatePositive(0.0, 'test'),
        returnsNormally,
      );
    });

    test('should throw error for negative values', () {
      expect(
        () => ProportionalValidator.validatePositive(-1.0, 'test'),
        throwsArgumentError,
      );
    });

    test('should validate non-zero values', () {
      expect(
        () => ProportionalValidator.validateNonZero(10.0, 'test'),
        returnsNormally,
      );
    });

    test('should throw error for zero value', () {
      expect(
        () => ProportionalValidator.validateNonZero(0.0, 'test'),
        throwsArgumentError,
      );
    });

    test('should validate screen size', () {
      expect(
        () => ProportionalValidator.validateScreenSize(const Size(800, 600)),
        returnsNormally,
      );
    });

    test('should throw error for invalid screen size', () {
      expect(
        () => ProportionalValidator.validateScreenSize(const Size(0, 600)),
        throwsArgumentError,
      );
      expect(
        () => ProportionalValidator.validateScreenSize(const Size(800, -600)),
        throwsArgumentError,
      );
    });

    test('should validate range', () {
      expect(
        () => ProportionalValidator.validateRange(5.0, 0.0, 10.0, 'test'),
        returnsNormally,
      );
    });

    test('should throw error for value outside range', () {
      expect(
        () => ProportionalValidator.validateRange(15.0, 0.0, 10.0, 'test'),
        throwsArgumentError,
      );
    });
  });

  group('ProportionalSafeValues Tests', () {
    test('should clamp percentage values', () {
      expect(ProportionalSafeValues.safePercentage(0.5), 0.5);
      expect(ProportionalSafeValues.safePercentage(1.5), 1.0);
      expect(ProportionalSafeValues.safePercentage(-0.5), 0.0);
    });

    test('should return safe positive values', () {
      expect(ProportionalSafeValues.safePositive(10.0), 10.0);
      expect(ProportionalSafeValues.safePositive(-10.0), 0.0);
    });

    test('should return safe non-zero values', () {
      expect(ProportionalSafeValues.safeNonZero(10.0), 10.0);
      expect(ProportionalSafeValues.safeNonZero(0.0), 1.0);
      expect(ProportionalSafeValues.safeNonZero(0.0, fallback: 5.0), 5.0);
    });

    test('should clamp range values', () {
      expect(ProportionalSafeValues.safeRange(5.0, 0.0, 10.0), 5.0);
      expect(ProportionalSafeValues.safeRange(15.0, 0.0, 10.0), 10.0);
      expect(ProportionalSafeValues.safeRange(-5.0, 0.0, 10.0), 0.0);
    });

    test('should return safe EdgeInsets', () {
      const insets = EdgeInsets.only(left: 10, right: -5, top: 20, bottom: -10);
      final safeInsets = ProportionalSafeValues.safeEdgeInsets(insets);

      expect(safeInsets.left, 10);
      expect(safeInsets.right, 0);
      expect(safeInsets.top, 20);
      expect(safeInsets.bottom, 0);
    });
  });
}
