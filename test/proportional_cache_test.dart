import 'package:flutter_test/flutter_test.dart';
import 'package:proportional_design/proportional_design.dart';

void main() {
  group('ProportionalCache Tests', () {
    setUp(() {
      ProportionalCache.clear();
      ProportionalCache.enable();
    });

    tearDown(() {
      ProportionalCache.clear();
    });

    test('should cache values', () {
      int callCount = 0;
      final calculator = () {
        callCount++;
        return 100.0;
      };

      final key = 'test_key';
      final value1 = ProportionalCache.getCachedSize(key, calculator);
      final value2 = ProportionalCache.getCachedSize(key, calculator);

      expect(value1, 100.0);
      expect(value2, 100.0);
      expect(callCount, 1); // Calculator should only be called once
    });

    test('should not cache when disabled', () {
      int callCount = 0;
      final calculator = () {
        callCount++;
        return 100.0;
      };

      ProportionalCache.disable();

      final key = 'test_key';
      final value1 = ProportionalCache.getCachedSize(key, calculator);
      final value2 = ProportionalCache.getCachedSize(key, calculator);

      expect(value1, 100.0);
      expect(value2, 100.0);
      expect(callCount, 2); // Calculator should be called twice
    });

    test('should clear cache', () {
      int callCount = 0;
      final calculator = () {
        callCount++;
        return 100.0;
      };

      final key = 'test_key';
      ProportionalCache.getCachedSize(key, calculator);
      ProportionalCache.clear();
      ProportionalCache.getCachedSize(key, calculator);

      expect(callCount, 2); // Calculator should be called twice
    });

    test('should generate unique keys', () {
      final key1 = ProportionalCache.generateKey(100, true, 800);
      final key2 = ProportionalCache.generateKey(100, false, 800);
      final key3 = ProportionalCache.generateKey(100, true, 900);

      expect(key1, isNot(key2));
      expect(key1, isNot(key3));
      expect(key2, isNot(key3));
    });

    test('should provide statistics', () {
      ProportionalCache.getCachedSize('key1', () => 100.0);
      ProportionalCache.getCachedSize('key2', () => 200.0);
      ProportionalCache.getCachedSize('key1', () => 100.0); // Cache hit

      final stats = ProportionalCache.statistics;
      expect(stats['enabled'], true);
      expect(stats['size'], 2);
    });

    test('should respect max cache size', () {
      ProportionalCache.setMaxCacheSize(2);

      ProportionalCache.getCachedSize('key1', () => 100.0);
      ProportionalCache.getCachedSize('key2', () => 200.0);
      ProportionalCache.getCachedSize('key3', () => 300.0);

      expect(ProportionalCache.cacheSize, lessThanOrEqualTo(2));
    });
  });
}
